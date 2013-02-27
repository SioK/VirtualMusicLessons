package model.proxy
{
	import model.services.tlessonservice.TlessonService;
	import model.valueObjects.LessonVO;
	import model.valueObjects.T_lesson;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import spark.components.List;

	/**
	 * @author Francois Dubois
	 * Die Klasse LessonProxy ist für die De- /Serialisierung 
	 * von LessonItems verantwortlich
	 * */
	public class LessonProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "lessonProxy";
		
		public static const UPLOAD_SUCCESS: String = "upload_success";
		public static const UPDATE_SUCCESS: String = "update_success";
		public static const PULL_LESSONS_SUCCESS: String = "pull_lessons_success";
		public static const PULL_LESSON_SUCCESS: String = "pull_lesson_success";
		public static const FAILED: String = "upload_failed";
		
		private var lessonService:TlessonService = new TlessonService
		private var uploadLessonResp:CallResponder = new CallResponder;
		private var pullLessonsResp:CallResponder = new CallResponder;
		private var pullLessonResp:CallResponder = new CallResponder;
		private var updateLessonResp:CallResponder = new CallResponder;

		
		public function LessonProxy () 
		{
			super(NAME, data);		
		}
		
		/**
		 * wird aufgerufen wenn eine Lesson erfolgreich in der Datenbank 
		 * aktualisiert wurde
		 * */
		private function updateResponseHandler(event:ResultEvent):void {
			sendNotification(UPDATE_SUCCESS);
		}
		
		/**
		 * wird aufgerufen wenn eine Lesson erfolgreich in der Datenbank 
		 * erstellt wurde
		 * */
		private function uploadResponseHandler(event:ResultEvent):void {
			sendNotification(LessonProxy.UPLOAD_SUCCESS, data);
		}
		
		
		/**
		 * wird aufgerufen wenn alle Lessons erfolgreich aus der Datenbank 
		 * geladen wurden
		 * */
		private function pullLessonsHandler(event:ResultEvent):void {
			
			var lessons:IList = pullLessonsResp.lastResult;
			sendNotification(LessonProxy.PULL_LESSONS_SUCCESS,lessons);
		}
		
		/**
		 * wird aufgerufen wenn eine Lesson erfolgreich aus der Datenbank 
		 * geladen wurde
		 * */
		public function pullLessonHandler(event:ResultEvent):void {

			var lesson:T_lesson = pullLessonResp.lastResult;
			sendNotification(LessonProxy.PULL_LESSON_SUCCESS, lesson);
		}
	
		/**
		 * Ein Aufruf dieser Methode erstellt die übergeben Lesson
		 * in der Datenbank
		 * */
		public function createLesson(lessonVO:LessonVO):void {
			uploadLessonResp.addEventListener(ResultEvent.RESULT,uploadResponseHandler);
			uploadLessonResp.token = lessonService.createT_lesson(lessonVO as T_lesson);
			data = lessonVO;
			lessonService.commit();
		}
		
		/**
		 * Ein Aufruf dieser Methode aktualisiert die übergeben Lesson
		 * in der Datenbank
		 * */
		public function updateLesson(lessonVO:LessonVO):void {
			updateLessonResp.addEventListener(ResultEvent.RESULT, updateResponseHandler);
			updateLessonResp.token = lessonService.updateT_lesson(lessonVO as T_lesson);
			lessonService.commit();
			updateLessonResp.dispatchEvent(new ResultEvent(ResultEvent.RESULT));
			
		}
		
		/**
		 * ruft alle Lessons aus der Datenbank ab die einem Bestimmten
		 * User zugeordnet sind
		 * @param User ID
		 * */
		public function getLesson(lessonID:int):void {
			pullLessonResp.addEventListener(ResultEvent.RESULT, pullLessonHandler);
			pullLessonResp.token = lessonService.getT_lessonByID(lessonID);
		}
		
		/**
		 * ruft alle Lesson von der Datenbank ab
		 * */
		public function getLessons():void{
			
			pullLessonsResp.addEventListener(ResultEvent.RESULT,pullLessonsHandler);
			pullLessonsResp.token = lessonService.getAllT_lesson();
			

		}
	}
}