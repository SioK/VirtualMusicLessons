package views.mediators
{
	import controller.commands.OpenTabCommand;
	import controller.tab.TabManager;
	import controller.tab.TrackingManager;
	import controller.tab.TrackingPoint;
	import controller.tab.TrackingPointSet;
	import controller.videoplayer.PlayTimeManager;
	
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import model.proxy.FileProxy;
	import model.proxy.GenreProxy;
	import model.proxy.InstrumentProxy;
	import model.proxy.LessonProxy;
	import model.valueObjects.LessonVO;
	import model.valueObjects.T_genre;
	import model.valueObjects.T_instrument;
	import model.valueObjects.T_lesson;
	import model.valueObjects.Tab;
	
	import mx.charts.CategoryAxis;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.errors.ItemPendingError;
	import mx.controls.Alert;
	import mx.olap.aggregators.MinAggregator;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.components.ApplicationView;
	import views.mediators.formHandler.UploadLessonFormHandler;
	
	
	/**
	 * @author Francois Dubois
	 * Diese Klasse ist die Schnittstelle für alle GUI-Komponenten
	 * der UploadLessonView und verwaltet diesen auch
	 * */
	public class UploadLessonMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = 'UploadLessonMediator';
		
		private var app:VirtualMusicLessonsMediator;
		private var formHandler:UploadLessonFormHandler; 
		
		private var trackingManager:TrackingManager = new TrackingManager;
		private var playTimeManager:PlayTimeManager;
		
		private var trackingPoints:TrackingPointSet = new TrackingPointSet;
		private var videoFilter:FileFilter = new FileFilter("VIDEO","*.flv;");
		private var tabFilter:FileFilter = new FileFilter("TAB", "*.tab");
		
		private var video1:FileReference = new FileReference;
		private var video2:FileReference = new FileReference;
		private var video3:FileReference = new FileReference;
		private var tab:FileReference = new FileReference;
		
		private var currentUploadLesson_id:int;
		
		
		
		private var fileReferenceContainer:Object = new Object;
		
		
		public function UploadLessonMediator(viewComponent:ApplicationView)
		{
			super(NAME, viewComponent);
			
			viewComponent.addEventListener(ApplicationView.UPDATEVIEW , onCreation);
			viewComponent.addEventListener(ApplicationView.PULLINSTRUMENTS , pullInstruments);
			viewComponent.addEventListener(ApplicationView.PULLGENRES, pullGenres);
			viewComponent.addEventListener(ApplicationView.UPLOAD_VIDEO1 , browseVideo1);
			viewComponent.addEventListener(ApplicationView.UPLOAD_VIDEO2 , browseVideo2);
			viewComponent.addEventListener(ApplicationView.UPLOAD_VIDEO3 , browseVideo3);
			viewComponent.addEventListener(ApplicationView.UPLOAD_TAB , browseTab);
			viewComponent.addEventListener(ApplicationView.UPLOAD_LESSON , uploadLessonFiles);
			viewComponent.addEventListener(ApplicationView.SET_TRACKING_SEGMENT, setTrackingSegment);
			viewComponent.addEventListener(ApplicationView.REMOVE_TRACKING_SEGMENT, removeTrackingSegment);
			viewComponent.addEventListener(ApplicationView.CHANGE_PREVIEW_PERSPECTIVE, changePreviewPerspective);
			viewComponent.addEventListener(ApplicationView.UPLOAD_TRACKING_POINTS, uploadTrackingPoints);
			viewComponent.addEventListener(ApplicationView.TAB_CONTAINER_CHANGED, tabContainerChanged);
			viewComponent.addEventListener(ApplicationView.SET_START_TIME, setStartTime);
			viewComponent.addEventListener(ApplicationView.SET_END_TIME, setEndTime);
			viewComponent.addEventListener(ApplicationView.CURRENT_PREVIEW_PLAYER_TIME, updateTimeCode);
			viewComponent.addEventListener(ApplicationView.CANCEL_TRACKING, cancelTracking);
			
		}
		
		private function onCreation(event:Event):void
		{
			this.playTimeManager = new PlayTimeManager(applicationView.previewPlayer);
			this.formHandler = new UploadLessonFormHandler(this.applicationView);
			this.app = facade.retrieveMediator(VirtualMusicLessonsMediator.NAME) as VirtualMusicLessonsMediator;
			trackingManager.addEventListener(TrackingManager.ITEM_STATE_CHANGED, updateTabItem);
			facade.sendNotification(ApplicationFacade.PULL_LESSON_PLAN_ITEMS, app.getHoldedUserData().P_User_ID);
			
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				
				InstrumentProxy.PULL_INSTRUMENTS_SUCCESS,
				GenreProxy.PULL_GENRES_SUCCESS,
				LessonProxy.UPLOAD_SUCCESS,
				LessonProxy.UPDATE_SUCCESS,
				OpenTabCommand.TAB_COMPLETE,
				FileProxy.UPLOAD_VIDEO1_SUCCESS,
				FileProxy.UPLOAD_VIDEO2_SUCCESS,
				FileProxy.UPLOAD_VIDEO3_SUCCESS,
				FileProxy.UPLOAD_TAB_SUCCESS,
				FileProxy.UPLOAD_THUMBNAIL_SUCCESS,
				FileProxy.FILE_UPLOADS_COMPLETE,
				FileProxy.UPLOAD_TRACK_SUCCESS
				
			];
		}
		
		override public function handleNotification( note: INotification ):void 
		{
			switch ( note.getName() ) 
			{
				case InstrumentProxy.PULL_INSTRUMENTS_SUCCESS:
					addInstruments(note);
					break;
				case GenreProxy.PULL_GENRES_SUCCESS:
					addGenres(note);
					break;
				case LessonProxy.UPLOAD_SUCCESS:
					loadTrackingData(note);
					break;
				case LessonProxy.UPDATE_SUCCESS:
					lessonUpdated(note);
					break;
				case OpenTabCommand.TAB_COMPLETE:
					tabComplete(note);
					break;
				case FileProxy.UPLOAD_VIDEO1_SUCCESS:
					bindVideo1ToLesson(note);
					break;
				case FileProxy.UPLOAD_VIDEO2_SUCCESS:
					bindVideo2ToLesson(note);
					break;
				case FileProxy.UPLOAD_VIDEO3_SUCCESS:
					bindVideo3ToLesson(note);
					break;
				case FileProxy.UPLOAD_TAB_SUCCESS:
					bindTabToLesson(note);
					break;
				case FileProxy.UPLOAD_THUMBNAIL_SUCCESS:
					bindThumbToLesson(note);
					break;
				case FileProxy.FILE_UPLOADS_COMPLETE:
					finalizeUpload(note);
					break;
				case FileProxy.UPLOAD_TRACK_SUCCESS:
					trackingPointsLoaded(note);
					break;
				default:
			}
		}
		
		/**
		 * wenn der Tab Navigator auf die UploadLessonView umschaltet
		 * wird die TrackingForm für Nutzereingaben deaktiviert
		 * */
		public function tabContainerChanged(event:Event):void {
			if(applicationView.tabNavigator.selectedIndex == 2 && !formHandler.isUploading()) {
				formHandler.freezeTrackingForm();
			}
		}
		
		///////////////////////// META INFORMATIONS //////////////////////////////////////
		
		/**
		 * diese Methode ruft die Instrumente von der Datenbank ab
		 * */
		public function pullInstruments(event:Event):void {
			var validator:UploadLessonFormHandler = new UploadLessonFormHandler(this.applicationView);
			facade.sendNotification(ApplicationFacade.PULL_ALL_INSTRUMENTS);
		}
		
		/**
		 * diese Methode ruft die Genres von der Datenbank ab
		 * */
		public function pullGenres(event:Event):void {
			facade.sendNotification(ApplicationFacade.PULL_ALL_GENRES);
		}
		
		/**
		 * die Methode wird aufgerufen, wenn die Instrumente erfolgreich von
		 * der Datenbank abgerufen worden sind und befüllt die Instrumenten- Dropdown List 
		 * */
		public function addInstruments(note: INotification):void {
			var instruments:IList = note.getBody() as IList;
			applicationView.instrument_dropDown.dataProvider = instruments;
		}
		
		/**
		 * die Methode wird aufgerufen, wenn die Genres erfolgreich von
		 * der Datenbank abgerufen worden sind und befüllt die Genre- Dropdown List 
		 * */
		public function addGenres(note: INotification):void {
			var genres:IList = note.getBody() as IList;
			applicationView.genre_dropDown.dataProvider = genres;
		}
		
		///////////////////////// SET FILEREFERENCES //////////////////////////////////////
		
		/**
		 * wird ausgeführt wenn der SelectFile Button für das erste Video betätigt wird
		 * */
		public function browseVideo1(event:Event):void {
			video1.addEventListener(Event.SELECT, printVideo1Name);
			video1.browse([videoFilter]);
			
		}
		
		/**
		 * wird ausgeführt wenn der SelectFile Button für das zweite Video betätigt wird
		 * */
		public function browseVideo2(event:Event):void {
			video2.addEventListener(Event.SELECT, printVideo2Name);
			video2.browse([videoFilter]);
			
		}
		
		/**
		 * wird ausgeführt wenn der SelectFile Button für das dritte Video betätigt wird
		 * */
		public function browseVideo3(event:Event):void {
			video3.addEventListener(Event.SELECT, printVideo3Name);
			video3.browse([videoFilter]);
			
		}
		
		/**
		 * wird ausgeführt wenn der SelectFile Button für den Tab betätigt wird
		 * */
		public function browseTab(event:Event):void {
			tab.addEventListener(Event.SELECT, preloadTab);
			tab.browse([tabFilter]);
		}
		
		
		public function printVideo1Name(even:Event):void {
			applicationView.input_videoName1.text = video1.name;
		}
		
		public function printVideo2Name(even:Event):void {
			applicationView.input_videoName2.text = video2.name;
		}
		
		public function printVideo3Name(even:Event):void {
			applicationView.input_videoName3.text = video3.name;
		}
		
		public function preloadTab(even:Event):void {
			tab.addEventListener(Event.COMPLETE, loaded);
			tab.load();
		}
		

		/** 
		 * wird aufgerufen um zu Prüfen ob der Tab
		 * ein korrekte Format besitzt
		 * */
		public function loaded(event:Event):void {
			var tabManager:TabManager = new TabManager;
			if(tabManager.isTabValid(event)) {
				applicationView.input_tabReference.text = tab.name;
			} else {
				applicationView.input_tabReference.text = "";
			}
		}
		
		///////////////////////// SENDING LESSON FILES //////////////////////////////////////
		
		/**
		 * Diese Methode baut einen Container aus allen FileReference Objekten während des Lesson Uploads
		 * */
		public function createFileReferenceContainer():Object {
			fileReferenceContainer["Video1"] = video1;
			fileReferenceContainer["Video2"] = video2;
			fileReferenceContainer["Video3"] = video3;
			fileReferenceContainer["Tab"] = tab;
			return fileReferenceContainer;
		}
		
		
		/**
		 * wird ausgeführt wenn der Lesson Upload Vorgang eingeleitet wird
		 * */
		public function uploadLessonFiles(event:Event):void {
			applicationView.lessonVO.Instrument = (applicationView.instrument_dropDown.selectedItem as T_instrument).Instrument;
			applicationView.lessonVO.Genre =  (applicationView.genre_dropDown.selectedItem as T_genre).Genre;
			if(formHandler.hasLessonFormValidFields()) {
				facade.sendNotification(ApplicationFacade.UPLOAD_FILES, createFileReferenceContainer());
			}
			
		}
		
		/**
		 * wird ausgeführt wenn die FileUploads abeschlossen sind,
		 * leitet das erstellen der Lesson auf der Datenbank ein
		 * desweiteren wird die TrackingForm für Eingaben aktiviert 
		 * */
		public function finalizeUpload(note:INotification):void {
			
			var lesson:LessonVO = applicationView.lessonVO;
			lesson.Uploader = app.getHoldedUserData().Username;
			lesson.P_Lesson_ID = 0;
			
			formHandler.freezeLessonUploadForm();
			formHandler.activateTrackingForm();
			formHandler.setUploadState(true);
			
			facade.sendNotification(ApplicationFacade.PUSH_LESSON, lesson);
		}
		
		///////////////////////// BINDING UPLOADED FILEINFORMATIONS TO LESSON OBJECT ///////////////////////// 
		
		
		public function bindVideo1ToLesson(note: INotification):void {
			var path:String = note.getBody() as String;
			applicationView.lessonVO.Video1_Path =  path + (fileReferenceContainer["Video1"] as FileReference).name;
		}
		
		public function bindVideo2ToLesson(note: INotification):void {
			var path:String = note.getBody() as String;
			applicationView.lessonVO.Video2_Path =  path + (fileReferenceContainer["Video2"] as FileReference).name;
		}
		
		public function bindVideo3ToLesson(note: INotification):void {
			var path:String = note.getBody() as String;
			applicationView.lessonVO.Video3_Path =  path + (fileReferenceContainer["Video3"] as FileReference).name;
		}
		
		public function bindTabToLesson(note: INotification):void {
			var path:String = note.getBody() as String;
			applicationView.lessonVO.Tab_Path = path + (fileReferenceContainer["Tab"] as FileReference).name;
		}
		
		public function bindThumbToLesson(note: INotification):void {
			var path:String = note.getBody() as String;
			applicationView.lessonVO.Thumbnail =  path + (fileReferenceContainer["Video1"] as FileReference).name.replace(".flv",".jpg");
		}
		
		///////////////////////// TRACKING SECTION //////////////////////////////////////
		
		/**
		 * lädt die Daten für den Tracking Vorgang
		 * */
		public function loadTrackingData(note: INotification):void {
			var lesson:LessonVO = note.getBody() as LessonVO;
			applicationView.lessonVO = lesson;
			fillPreviewPerspectives(lesson);
			loadTabPreview(lesson);
		}
		
		/**
		 * befüllt die previewPerspective Liste mit den Perspektiven der Lesson die
		 * als letzten erstellt wurde
		 * */
		private function fillPreviewPerspectives(lesson:T_lesson):void {
			var perspectives:IList = new ArrayCollection;
			
			if(lesson.Video1_Path != "") {
				perspectives.addItem({Perspective:'Perspective 1',Path:lesson.Video1_Path});
			}
			
			if(lesson.Video2_Path != "") {
				perspectives.addItem({Perspective:'Perspective 2',Path:lesson.Video2_Path});
			}
			
			if(lesson.Video3_Path != "") {
				perspectives.addItem({Perspective:'Perspective 3',Path:lesson.Video3_Path});
			}
			
			applicationView.previewPerspectiveSelection.dataProvider = perspectives;
			applicationView.previewPerspectiveSelection.selectedIndex = 0;
			applicationView.previewPlayer.source = applicationView.previewPerspectiveSelection.selectedItem.Path;
			
		}
		
		/**
		 * leitet das Befüllen der TabPreviewBar ein
		 * */
		public function loadTabPreview(lesson:T_lesson):void {
			facade.sendNotification(ApplicationFacade.OPEN_TAB, lesson.Tab_Path);
		}
		
		/**
		 * wird aufgerufen wenn die Tabs erfolgreich geladen wurden
		 * und Befüllt die TabPreviewBar mit den Tracks
		 * */
		public function tabComplete(note:INotification):void {
			var tab:Tab = note.getBody() as Tab;
			var tracks:IList = tab.getTracks();
			if(applicationView.tabNavigator.selectedIndex == 2) {
				applicationView.tabListPreview.dataProvider = new ArrayList;
				applicationView.tabListPreview.dataProvider = tracks;
			}
		}
		
		/**
		 * wird ausgelöst wenn sich die Perspektive ändert
		 * */
		public function changePreviewPerspective(event:Event):void {
			applicationView.previewPlayer.source = applicationView.previewPerspectiveSelection.selectedItem.Path;
		}
		
		/**
		 * setzt ein TrackingPoint auf einen Track und markiert diesen 
		 * */
		public function setTrackingSegment(event:Event):void {
			
			var startTime:int = PlayTimeManager.minutesToSeconds(int(applicationView.min_start.text)) + int(applicationView.sec_start.text);
			var endTime:int = PlayTimeManager.minutesToSeconds(int(applicationView.min_end.text)) + int(applicationView.sec_end.text);
			
			if(formHandler.isTimeCodeValid(startTime, endTime) && applicationView.tabListPreview.selectedIndex != -1) {
				var trackingPoint:TrackingPoint = new TrackingPoint;
				
				trackingPoint.perspective = applicationView.previewPerspectiveSelection.selectedItem.Perspective;
				trackingPoint.btnIndex = applicationView.tabListPreview.selectedIndex;	
				
				trackingPoint.startTime = startTime + "";
				trackingPoint.endTime = endTime + "";
				
				trackingPoints.addTrackingPoint(trackingPoint);
				trackingManager.markTrack(trackingPoint.btnIndex, trackingPoint.perspective, applicationView.tabListPreview);
			}
		}
		
		/**
		 * entfernt einen TrackingPoint von einem Track und entfernt auch die Markierung
		 * */ 
		public function removeTrackingSegment(event:Event):void {
			var trackingPoint:TrackingPoint = new TrackingPoint;
			
			trackingPoint.perspective = applicationView.previewPerspectiveSelection.selectedItem.Perspective;
			trackingPoint.btnIndex = applicationView.tabListPreview.selectedIndex;	
			
			trackingPoints.removeTrackingPoint(trackingPoint);
			trackingManager.markTrack(trackingPoint.btnIndex, trackingPoint.perspective, applicationView.tabListPreview, false);
		}
		
		public function updateTabItem(event:Event):void {
			if(trackingManager.trackingComplete(applicationView.tabListPreview.dataProvider)) {
				applicationView.uploadTrackingPoints_btn.enabled = true;
			} else {
				applicationView.uploadTrackingPoints_btn.enabled = false;
			}
		}
		
		
		/**
		 * ein Aufruf dieser Methode leiten den Upload der TrackingPoints ein
		 * */
		public function uploadTrackingPoints(event:Event):void {
			
			trackingManager.createTrackingPointXML(trackingPoints);
			
			// RESET FILEREFERENCES AND DATA OBJECTS
			video1 = new FileReference;
			video2 = new FileReference;
			video3 = new FileReference;
			tab = new FileReference;
			trackingPoints = new TrackingPointSet;
			
			var trackingContainer:Object = new Object;
			trackingContainer["name"] = "trackingPoints_" + applicationView.lessonVO.Lesson + "_" + applicationView.lessonVO.P_Lesson_ID;
			trackingContainer["data"] = trackingManager.getTrackingPointXML();
			facade.sendNotification(ApplicationView.UPLOAD_TRACKING_POINTS, trackingContainer);
		}
		
		/**
		 * beendet den Uploadvorgang der Lesson ohne TrackingPoints anzufügen
		 * */
		public function cancelTracking(event:Event):void {

			video1 = new FileReference;
			video2 = new FileReference;
			video3 = new FileReference;
			tab = new FileReference;
			trackingPoints = new TrackingPointSet;
			
			var lesson:LessonVO = applicationView.lessonVO;
			facade.sendNotification(ApplicationFacade.UPDATE_LESSON, lesson);
			formHandler.freezeTrackingForm();
			formHandler.resetLessonUploadForm();
		}
		
		/**
		 * wird aufgerufen wenn die TrackingPoints erfolgreich hochgeladen wurden
		 * und aktualisiert die Lesson auf der Datenbank
		 * */
		public function trackingPointsLoaded(note:INotification):void {
			
			var track_path:String = note.getBody() as String;
			var lesson:LessonVO = applicationView.lessonVO;
			lesson.Track_Path = track_path;
			facade.sendNotification(ApplicationFacade.UPDATE_LESSON, lesson);
		}
		
		/**
		 * setzt den Status der Lesson auf aktualisiert und
		 * resetet die UploadLessonForm
		 * */
		public function lessonUpdated(note:INotification):void {
			formHandler.freezeTrackingForm();
			formHandler.resetLessonUploadForm();
		}
		
		/**
		 * ein Aufruf dieser Methode aktualisiert die aktuelle Zeit des VideoPlayers
		 * */
		public function updateTimeCode(event:Event):void {
			playTimeManager.updateCurrentTime(applicationView.previewPlayer.currentTime);
		}
		
		/**
		 * setzt die Startzeit für einen TrackingPoint
		 * */
		public function setStartTime(event:Event):void {
			applicationView.sec_start.text = playTimeManager.getSeconds() + "";
			applicationView.min_start.text = playTimeManager.getMinutes() + "";
		}
		
		/**
		 * setzt die Endzeit für einen TrackingPoint
		 * */ 
		public function setEndTime(event:Event):void {
			applicationView.sec_end.text = playTimeManager.getSeconds() + "";
			applicationView.min_end.text = playTimeManager.getMinutes() + "";
		}
		
		protected function get applicationView(): ApplicationView
		{
			return viewComponent as ApplicationView;
		}
	}
}