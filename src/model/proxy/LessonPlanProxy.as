package model.proxy
{
	
	import model.services.tlessonplanitemservice.TlessonplanitemService;
	import model.valueObjects.T_lesson;
	import model.valueObjects.T_lesson_plan_item;
	import model.valueObjects.T_user;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import views.components.LessonPlanItem;

	/**
	 * @author Francois Dubois
	 * Die Klasse LessonPlanProxy ist für die De- /Serialisierung 
	 * von LessonPlanItems verantwortlich
	 * */
	public class LessonPlanProxy extends Proxy implements IProxy
	{
		
		public static const NAME: String = "lessonPlanProxy";
		
		public static const PULL_LESSON_PLAN_ITEMS_SUCCESS: String = "pullLessonPlanItemsSuccess";
		public static const CREATE_LESSON_PLAN_ITEM_SUCCESS: String = "createLessonPlanItemSuccess";
		public static const UPDATE_LESSON_PLAN_ITEMS_SUCCESS: String = "updateLessonPlanItemsSuccess";
		public static const REMOVE_LESSON_PLAN_ITEM_SUCCESS: String = "removeLessonPlanItemSuccess";
		
		private var entityLessonPlanItem:T_lesson_plan_item;
		
		private var userID:int;

		private var pullLessonPlanItemsResp:CallResponder = new CallResponder;
		private var createLessonItemResp:CallResponder = new CallResponder;
		private var updateLessonItemResp:CallResponder = new CallResponder;
		private var removeLessonItemResp:CallResponder = new CallResponder;
		
		private var lessonPlanItemService:TlessonplanitemService = new TlessonplanitemService;
		
		public function LessonPlanProxy () 
		{
			super(NAME, data);		
		}
		
		/**
		 * wird aufgerufen wenn ein LessonPlanItem erfolgreich aus
		 * der Datenbank geladen wurden
		 * */
		private function pullLessonPlanItemHandler(event:ResultEvent):void {
			
			var lessonPlanItems:IList = pullLessonPlanItemsResp.lastResult;
			sendNotification(LessonPlanProxy.PULL_LESSON_PLAN_ITEMS_SUCCESS,lessonPlanItems);
		}
		
		/**
		 * wird aufgerufen wenn ein LessonPlanItem erfolgreich von
		 * der Datenbank erstellt wurde
		 * */
		private function createResponseHandler(event:ResultEvent):void {
	
			var lessonPlanItemID:int = createLessonItemResp.lastResult;
			sendNotification(LessonPlanProxy.CREATE_LESSON_PLAN_ITEM_SUCCESS, lessonPlanItemID);
		}
		
		/**
		 * wird aufgerufen wenn ein LessonPlanItem erfolgreich von
		 * der Datenbank gelöscht wurde
		 * */
		private function removeLessonPlanItemHandler(event:ResultEvent):void {

			sendNotification(LessonPlanProxy.REMOVE_LESSON_PLAN_ITEM_SUCCESS);
		}
		
		/**
		 * wird aufgerufen wenn ein LessonPlanItem erfolgreich in
		 * der Datenbank aktualisiert wurde
		 * */
		private function updateLessonPlanItemHandler(event:ResultEvent):void {
			
			sendNotification(LessonPlanProxy.UPDATE_LESSON_PLAN_ITEMS_SUCCESS);
		}
		
		/**
		 * ruft alle LessonPlanItems von der Datenbank ab
		 * */
		public function getAllLessonPlanItems():void {
			
    		pullLessonPlanItemsResp.addEventListener(ResultEvent.RESULT,pullLessonPlanItemHandler);
			pullLessonPlanItemsResp.token = lessonPlanItemService.getAllT_lesson_plan_item();
			lessonPlanItemService.commit();
	
		}
		
		/**
		 * ruft speziell die LessonPlanItems aus der Datenbank ab,
		 * die einem bestimmten User zugewiesen sind
		 * @param User ID
		 * */
		public function getLessonPlanItemsByID(user_id:int):void {

			this.userID = user_id;
			pullLessonPlanItemsResp.addEventListener(ResultEvent.RESULT,pullLessonPlanItemHandler);
			pullLessonPlanItemsResp.token = lessonPlanItemService.getAllT_lesson_plan_itemByID(userID);
			lessonPlanItemService.commit();
			
		}
		
		/**
		 * entfernt ein LessonPlanItem
		 * */
		public function removeLessonPlanItemByID(lessonID:int):void {
			
			removeLessonItemResp.addEventListener(ResultEvent.RESULT, removeLessonPlanItemHandler);
			removeLessonItemResp.token = lessonPlanItemService.deleteT_lesson_plan_item(lessonID);
			lessonPlanItemService.commit();
		}
		
		/**
		 * aktualisiert ein LessonPlanItem
		 * */
		public function updateLessonPlanItem(lessonPlanItem:T_lesson_plan_item):void  {
			
			updateLessonItemResp.addEventListener(ResultEvent.RESULT, updateLessonPlanItemHandler);
			updateLessonItemResp.token = lessonPlanItemService.updateT_lesson_plan_item(lessonPlanItem)
			lessonPlanItemService.commit();
		}
		
		/**
		 * erstellt ein LessonPlanItem
		 * */
		public function createLessonPlanItem(lessonPlanItem:T_lesson_plan_item):void {
				
			createLessonItemResp.addEventListener(ResultEvent.RESULT, createResponseHandler);
			createLessonItemResp.token = lessonPlanItemService.createT_lesson_plan_item(lessonPlanItem);	
			lessonPlanItemService.commit();
		}
		
	}
}