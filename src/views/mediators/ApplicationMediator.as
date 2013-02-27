package views.mediators
{
	
	import controller.search.filter.DifficultyFilter;
	import controller.search.filter.GenreFilter;
	import controller.search.filter.IFilter;
	import controller.search.filter.InstrumentFilter;
	import controller.search.filter.SearchFilter;
	import controller.tab.TrackingManager;
	
	import flash.events.Event;
	
	import model.proxy.FileProxy;
	import model.proxy.GenreProxy;
	import model.proxy.InstrumentProxy;
	import model.proxy.LessonProxy;
	import model.valueObjects.LessonVO;
	import model.valueObjects.T_lesson;
	
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
	 * Bei der ApplicationMediator Klasse handelt es sich um die Schnittstelle
	 * zu den GUI Komponenten die zu jeder Zeit in der Anwendung erreichbar sind
	 * */
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ApplicationMediator';
		

		private var app: VirtualMusicLessonsMediator;
		
		private var searchFilter:SearchFilter = new SearchFilter();;
		
		private var dif_filter:DifficultyFilter;
		private var genre_filter:GenreFilter;
		private var instrument_filter:InstrumentFilter;

	
		public function ApplicationMediator( viewComponent:ApplicationView ) 
		{
			super(NAME, viewComponent);

			viewComponent.addEventListener(ApplicationView.UPDATEVIEW , onCreation);
			viewComponent.addEventListener(ApplicationView.LOADCATEGORIES , fillCategory);
			viewComponent.addEventListener(ApplicationView.LOADDETAILS , fillDetails);
			viewComponent.addEventListener(ApplicationView.FILTER , filter);
			viewComponent.addEventListener(ApplicationView.SEARCH, search);
			viewComponent.addEventListener(ApplicationView.LOGOUT, logout);
		}
		
		/**
		 * Bei der Erstellung des ApplicationMediators wird der aktuell eingeloggte 
		 * Benutzer angezeigt, zudem werden die Filter für die Suchmaske geladen
		 * */
		public function onCreation(event:Event):void {
			
			facade.sendNotification(ApplicationFacade.PULL_LESSONS);
			this.app = facade.retrieveMediator(VirtualMusicLessonsMediator.NAME) as VirtualMusicLessonsMediator;
			applicationView.loginInfo.text = "Welcome, " + app.getHoldedUserData().Username + " [" + app.getHoldedUserData().Mail + "]";
			
			dif_filter = new DifficultyFilter("Difficulty");
			genre_filter = new GenreFilter("Genre");
			instrument_filter = new InstrumentFilter("Instrument");
			
			genre_filter.loadDetails();
			dif_filter.loadDetails();
			instrument_filter.loadDetails();
			
			searchFilter.addFilter(dif_filter);
			searchFilter.addFilter(genre_filter);
			searchFilter.addFilter(instrument_filter);
			
		}	
			
		override public function listNotificationInterests():Array 
		{
			return [
				LessonProxy.UPLOAD_SUCCESS,
				LessonProxy.PULL_LESSONS_SUCCESS,
				LessonProxy.UPDATE_SUCCESS,
			];
		}
		
		override public function handleNotification( note: INotification ):void 
		{
			switch ( note.getName() ) 
			{
				case LessonProxy.UPLOAD_SUCCESS:
					updateLessons();
					break;
				case LessonProxy.UPDATE_SUCCESS:
					updateLessons();
					break;
				case LessonProxy.PULL_LESSONS_SUCCESS: 
					fillLessonList(note);
					break;
				default:
			}
		}
		
	
		// LESSON LIST 
		
		/**
		 * ruft alle Lessons des aktuell eingeloggten Benutzers ab
		 * */
		public function updateLessons(): void{
			applicationView.lessonVO = new LessonVO;
			applicationView.lessonVO.Uploader = app.getHoldedUserData().Username;
			facade.sendNotification(ApplicationFacade.PULL_LESSONS);
		}
		
		/**
		 * befüllt die VideoListe mit allen vorhanden Lessons
		 * */
		public function fillLessonList(note: INotification):void {
			var lessons:IList = note.getBody() as IList;
			applicationView.videoList.dataProvider = lessons;
			searchFilter.dataList = applicationView.videoList.dataProvider;
			(applicationView.videoList.dataProvider as ArrayCollection).refresh();
		}
		
		
		// SEARCH MASK
		
		/**
		 * Ein Aufruf dieser Methode bewirkt das Befüllen der Kategorie DropdownListe
		 * */
		public function fillCategory(event:Event):void {
			applicationView.category.dataProvider = searchFilter.getAllFilter();
			applicationView.details.dataProvider = null;
		}
		
		/**
		 * Ein Aufruf dieser Methode bewirk das Befüllen der Details DropdownListe 
		 * */
		public function fillDetails(event:Event):void {
			
			var filter:IFilter = applicationView.category.selectedItem as IFilter;		
			searchFilter.activateFilter(filter);
			applicationView.details.dataProvider = filter.detailList;
		}
		
		/**
		 * wird diese Methode aufgerufen werden die LessonItems in der Videoliste 
		 * gefiltert
		 * */
		public function filter(event:Event):void {
			var filteredList:IList = searchFilter.filterList(applicationView.details.selectedItem);
			applicationView.videoList.dataProvider = filteredList;
			(applicationView.videoList.dataProvider as ArrayCollection).refresh();
			
		}
		
		/**
		 *Diese Methode führt die Echtzeit- Textsuche aus
		 * */
		public function search(event:Event):void {
			if(applicationView.lessons_search_input.text == "") {
				applicationView.category.dataProvider = null;
				applicationView.details.dataProvider = null;
			}
			var searchResult:IList = new ArrayList
			searchResult = searchFilter.textSearch(applicationView.lessons_search_input.text);
			applicationView.videoList.dataProvider = searchResult;
			(applicationView.videoList.dataProvider as ArrayCollection).refresh();	
			
		}
		
		/**
		 * Wird diese Methode aufgerufen Starten die Komplette Anwendung neu
		 * und das Einloggen muss erneut Erfolgen
		 * */
		public function logout(event:Event):void {
			(app.getViewComponent() as VirtualMusicLessons).logout();
		}
		
		/**
		 * liefert die ViewComponente die durch den Mediator verwaltet wird
		 * */
		protected function get applicationView(): ApplicationView
		{
			return viewComponent as ApplicationView;
		}
		
	}
}