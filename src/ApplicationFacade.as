package
{
	import controller.ApplicationStartupCommand;
	import controller.commands.CreateLessonPlanItemCommand;
	import controller.commands.LoginCommand;
	import controller.commands.OpenTabCommand;
	import controller.commands.PullGenresCommand;
	import controller.commands.PullInstrumentsCommand;
	import controller.commands.PullLessonCommand;
	import controller.commands.PullLessonPlanItemsCommand;
	import controller.commands.PullLessonsCommand;
	import controller.commands.PushLessonCommand;
	import controller.commands.RegisterCommand;
	import controller.commands.RemoveLessonPlanItemCommand;
	import controller.commands.UpdateLessonCommand;
	import controller.commands.UpdateLessonPlanItemCommand;
	import controller.commands.UploadFilesCommand;
	import controller.commands.UploadTrackingPointsCommand;
	
	import mx.logging.Log;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * @author Francois Dubois
	 * */
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const APP_STARTUP:String = "app_startUp";
		
		public static const LOGIN:String = "login";
		public static const REGISTER:String = "register";
		public static const PUSH_LESSON:String = "pushLesson";
		public static const PULL_LESSONS:String = "pullLessons";
		public static const PULL_LESSON:String = "pullLesson";
		public static const OPEN_TAB:String = "openTab";
		public static const UPLOAD_TRACKING_POINTS:String = "uploadTrackingPoints";
		public static const CREATE_LESSON_PLAN_ITEM:String = "addLessonPlanItem";
		public static const UPDATE_LESSON_PLAN_ITEM:String = "updateLessonPlanItem";
		public static const REMOVE_LESSON_PLAN_ITEM:String = "removeLessonPlanItem";
		public static const PULL_LESSON_PLAN_ITEMS:String = "pullLessonPlanItems";
		public static const PULL_ALL_INSTRUMENTS:String = "pullAllInstruments";
		public static const PULL_ALL_GENRES:String = "pullAllGenres";
		public static const UPLOAD_FILES:String = "uploadFile";
		public static const UPDATE_LESSON:String = "updateLesson";
		
		public static function getInstance(): ApplicationFacade {
			if(instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController() : void 
		{
			super.initializeController();
			// register commands			
			registerCommand( APP_STARTUP, ApplicationStartupCommand );
			// own commands
			registerCommand( LOGIN , LoginCommand );
			registerCommand( REGISTER , RegisterCommand );
			registerCommand( PUSH_LESSON , PushLessonCommand );
			registerCommand( PULL_LESSONS , PullLessonsCommand );
			registerCommand( PULL_LESSON, PullLessonCommand );
			registerCommand( CREATE_LESSON_PLAN_ITEM, CreateLessonPlanItemCommand );
			registerCommand( UPDATE_LESSON_PLAN_ITEM, UpdateLessonPlanItemCommand );
			registerCommand( PULL_LESSON_PLAN_ITEMS, PullLessonPlanItemsCommand );
			registerCommand( REMOVE_LESSON_PLAN_ITEM, RemoveLessonPlanItemCommand );
			registerCommand( PULL_ALL_GENRES, PullGenresCommand );
			registerCommand( PULL_ALL_INSTRUMENTS , PullInstrumentsCommand );
			registerCommand( UPLOAD_TRACKING_POINTS , UploadTrackingPointsCommand );
			registerCommand( OPEN_TAB, OpenTabCommand );
			registerCommand( UPLOAD_FILES, UploadFilesCommand );
			registerCommand( UPDATE_LESSON, UpdateLessonCommand );
			
		}
		
		public function startup(app: VirtualMusicLessons):void
		{
			this.sendNotification( ApplicationFacade.APP_STARTUP, app );
		}
	}
}