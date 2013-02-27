package views.mediators
{
	import controller.commands.OpenTabCommand;
	import controller.tab.TimeCode;
	import controller.tab.TrackingManager;
	import controller.videoplayer.PlayTimeManager;
	
	import flash.events.Event;
	
	import model.valueObjects.T_lesson;
	import model.valueObjects.Tab;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.components.ApplicationView;
	import views.components.LessonPlanItem;

	/**
	 * @author Francois Dubois
	 * Diese Klasse ist die Schnittstelle für alle GUI-Komponenten
	 * des LessonViewers und verwaltet diesen auch
	 * */
	public class LessonViewerMediator extends Mediator implements IMediator
	{

		public static const NAME:String = 'LessonViewerMediator';
		
		private var currentLesson:T_lesson;
		private var trackingManager:TrackingManager;
		private var tab:Tab;
		
		public function LessonViewerMediator(viewComponent:ApplicationView)
		{
			super(NAME, viewComponent);
			
			viewComponent.addEventListener(ApplicationView.PLAY_LESSON_LIST , lessonList_play);
			viewComponent.addEventListener(ApplicationView.SET_PLAY_INTERVALL, setPlayIntervall);
			viewComponent.addEventListener(ApplicationView.CHANGE_PERSPECTIVE, changePerspective);
			viewComponent.addEventListener(ApplicationView.TAB_CONTAINER_CHANGED, tabContainerChanged);
			
		}
		
		/**
		 * Wenn der Tab Navigator der Anwendung die LessonView ausgewählt hat wird 
		 * diese Methode aktive und füllt die LessonView mit Tracks, startet
		 * das Video und füllt die Perspektiven Liste
		 * */
		public function tabContainerChanged(event:Event):void {
			if(applicationView.tabNavigator.selectedIndex == 1) {
				
				fillPerspectives(currentLesson);	
				loadTab(currentLesson);
				play(currentLesson);
			}
			
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				LessonPlanItem.PLAY_LESSON_PLAN,
				OpenTabCommand.TAB_COMPLETE
			];
		}
		
		override public function handleNotification( note: INotification ):void 
		{
			switch ( note.getName() ) 
			{
				case LessonPlanItem.PLAY_LESSON_PLAN:
					lessonPlan_play(note);
					break;
				case OpenTabCommand.TAB_COMPLETE: 
					tabComplete(note);
					break;
				default:
			}
		}
		
		// VIDEO PLAYER FUNCTIONS
		
		/**
		 * Wird ausgeführt wenn ein Video über die Lesson Liste gestartet wird
		 * */
		private function lessonList_play(event:Event):void {
			currentLesson = applicationView.videoList.selectedItem as T_lesson;
			if(applicationView.tabNavigator.selectedIndex == 1) {
				fillPerspectives(currentLesson);	
				loadTab(currentLesson);
				play(currentLesson);
			} else {
				applicationView.tabNavigator.selectedIndex = 1;	
			}
		}
		
		/**
		 * Wird ausgeführt wenn ein Video über den LessonPlan gestartet wird
		 * */
		private function lessonPlan_play(note:INotification):void {
			currentLesson = note.getBody() as T_lesson;
			applicationView.tabNavigator.selectedIndex = 1;
		}
		
		/**
		 * Diese Methode navigiert zur LessonView und startet das Video
		 * */
		private function play(lesson: T_lesson):void {
			applicationView.currentViewableLesson = currentLesson;
			applicationView.dif_bar_small.setDifficulty(currentLesson.Difficulty);
			applicationView.tabNavigator.selectedIndex = 1;
			applicationView.perspectives.selectedIndex = 0;

		}
		
		/**
		 * Ein Aufruf dieser Methode setzt das PlayIntervall
		 * */
		public function setPlayIntervall(event:Event):void {
			//use tracking xml here
			trackingManager = new TrackingManager;
			trackingManager.addEventListener(TrackingManager.LOAD_COMPLETE, handleTrackingMap);
			trackingManager.loadTrackingPoints(currentLesson.Track_Path);		
		}
		
		/**
		 * wird aufgerufen wenn das Laden der TrackingPoints über setPlayIntervall() abgeschlossen ist
		 * */
		public function handleTrackingMap(event:Event):void {
			var timeCode:TimeCode = trackingManager.getTimeCode(applicationView.tabList.selectedIndex, applicationView.perspectives.selectedIndex);
			var ptm:PlayTimeManager = new PlayTimeManager(applicationView.videoPlayer);
			applicationView.videoPlayer.stop();
			ptm.setTimeIntervall(timeCode);
		}
		
		// PERSPECTIVES
		
		/**
		 * Diese Methode befüllt die Perspektiven Liste mit den Video der aktuellen
		 * der aktuelle Lesson
		 * */
		private function fillPerspectives(lesson:T_lesson):void {
			var perspectives:IList = new ArrayList();
			if(lesson.Video1_Path != "") {
				perspectives.addItem(lesson.Video1_Path);	
			} 
			
			if(lesson.Video2_Path != "") {
				perspectives.addItem(lesson.Video2_Path);
			}
			
			if(lesson.Video3_Path != "") {
				perspectives.addItem(lesson.Video3_Path);
			}		
			applicationView.perspectives.dataProvider = perspectives;
		}
		
		/**
		 * wird ausgeführt um eine andere Perspektive zu starten
		 * */
		private function changePerspective(event:Event):void {
			applicationView.videoPlayer.source = applicationView.perspectives.selectedItem;
		}
		
		//TAB 
		
		/**
		 * Diese Methode leitet das befüllen der TabBar ein 
		 * */
		private function loadTab(lesson:T_lesson):void {
			facade.sendNotification(ApplicationFacade.OPEN_TAB, lesson.Tab_Path);
		}
		
		/**
		 * Die Methode wird aufgerufen wenn die Tabs komplett geladen wurden 
		 * und befüllt die TabBar mit den Tracks 
		 * */
		private function tabComplete(note: INotification):void {
			tab = note.getBody() as Tab;
			var tracks:IList = tab.getTracks();
			if(applicationView.tabNavigator.selectedIndex == 1) {
				applicationView.tabList.dataProvider = tracks;
				(applicationView.tabList as ArrayCollection).refresh();
			}
		}
		
		/**
		 * gibt die View Komponente die von der Klasse LessonViewerMediator 
		 * verwaltet wird zurück
		 * */
		protected function get applicationView(): ApplicationView
		{
			return viewComponent as ApplicationView;
		}
	}
}