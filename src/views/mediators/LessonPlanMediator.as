package views.mediators
{
	import flash.events.Event;
	
	import model.proxy.LessonPlanProxy;
	import model.proxy.LessonProxy;
	import model.valueObjects.T_lesson;
	import model.valueObjects.T_lesson_plan_item;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.events.DragEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.components.ApplicationView;
	import views.components.LessonPlanItem;

	/**
	 * @author Francois Dubois
	 * Diese Klasse ist die Schnittstelle für alle GUI-Komponenten
	 * des LessonPlans und verwaltet diesen auch
	 * */
	public class LessonPlanMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = 'LessonPlanMediator';
		
		private var app:VirtualMusicLessonsMediator;
		private var lessonPlanItems:IList;
		private var lessonPlanItemCount:int = 0;
		private var lessonPlanItem:LessonPlanItem = new LessonPlanItem;
		
		public function LessonPlanMediator(viewComponent:ApplicationView)
		{
			super(NAME, viewComponent);
			
			viewComponent.addEventListener(ApplicationView.UPDATEVIEW , onCreation);
			viewComponent.addEventListener(DragEvent.DRAG_DROP, createLessonPlanItem);
			
		}
		
		private function onCreation(event:Event):void
		{
			this.app = facade.retrieveMediator(VirtualMusicLessonsMediator.NAME) as VirtualMusicLessonsMediator;
			facade.sendNotification(ApplicationFacade.PULL_LESSON_PLAN_ITEMS, app.getHoldedUserData().P_User_ID);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				
				LessonPlanProxy.PULL_LESSON_PLAN_ITEMS_SUCCESS,
				LessonProxy.PULL_LESSON_SUCCESS,
				LessonPlanProxy.CREATE_LESSON_PLAN_ITEM_SUCCESS
				
			];
		}
		
		override public function handleNotification( note: INotification ):void 
		{
			switch ( note.getName() ) 
			{
				case LessonPlanProxy.PULL_LESSON_PLAN_ITEMS_SUCCESS:
					pullLessonPlanItems(note);
					break;
				case LessonProxy.PULL_LESSON_SUCCESS:
					lessonPlanItemAdapter(note);
					break;
				case LessonPlanProxy.CREATE_LESSON_PLAN_ITEM_SUCCESS:
					addCreatedLessonPlanItem(note);
					break;
				default:
			}
		}
		
		// LESSON PLAN FUNCTIONS
		
		/**
		 * Diese Methode erstellt eine LessonPlanItem
		 * */
		private function createLessonPlanItem(event:DragEvent):void {
			
			var items:* = event.dragSource.dataForFormat("itemsByIndex");
			var lesson:T_lesson = items[0] as T_lesson;
			
			
			lessonPlanItem.setLessonData(lesson);
			
			lessonPlanItem.x = event.localX - (lessonPlanItem.width / 2);
			lessonPlanItem.y = event.localY - (lessonPlanItem.height / 2);
			lessonPlanItem.setLessonPlanDisplayIndex(applicationView.lessonPlan.numElements + 1);
			
			facade.sendNotification(ApplicationFacade.CREATE_LESSON_PLAN_ITEM, lessonPlanItem);
		}
		

		/**
		 * Diese Methode fügt eine gerade erstellte Lesson dem LessonPlan hinzu
		 * */
		private function addCreatedLessonPlanItem(note:INotification):void {
			var id:int = note.getBody() as int;
			addLessonPlanItem(id, lessonPlanItem.getLessonData(), lessonPlanItem.x, lessonPlanItem.y, lessonPlanItem.getLessonPlanDisplayIndex());
		}
		
		/**
		 * Diese Methode fügt eine Lesson dem LessonPlan hinzu
		 * */
		private function addLessonPlanItem(lessonPlanID:int, lesson:T_lesson, x:int, y:int, displayIndex:int):void {
			var item:LessonPlanItem = new LessonPlanItem; 
			
			item.setLessonData(lesson);
			item.setLessonPlanItemID(lessonPlanID);
			item.setLessonPlanDisplayIndex(displayIndex);
			item.x = x;
			item.y = y;
			applicationView.lessonPlan.addElement(item);
		}
		
		/**
		 * Die Methode ruft alle LessonPlanItems ab die zu dem eingeloggten Benutzer gehören
		 * */
		private function pullLessonPlanItems(note: INotification):void {
			lessonPlanItems = note.getBody() as IList;
			facade.sendNotification(ApplicationFacade.PULL_LESSON, (lessonPlanItems[0] as T_lesson_plan_item).lesson_id );
		}
		
		/**
		 * Jede abgerufene Lesson wird dem LessonPlan hinzugefügt
		 * */
		private function lessonPlanItemAdapter(note: INotification):void {
			var lessonPlanItem:T_lesson_plan_item = (lessonPlanItems[lessonPlanItemCount] as T_lesson_plan_item);
			var lesson:T_lesson = note.getBody() as T_lesson;
			
			addLessonPlanItem(lessonPlanItem.t_lesson_plan_item_id, lesson, lessonPlanItem.x_position, lessonPlanItem.y_position, lessonPlanItem.display_index);
			
			if(lessonPlanItemCount < lessonPlanItems.length) {
				lessonPlanItemCount++;
				facade.sendNotification(ApplicationFacade.PULL_LESSON, (lessonPlanItems[lessonPlanItemCount] as T_lesson_plan_item).lesson_id );
			}
			
		}
		
		/**
		 * gibt die View Komponente die von der Klasse LessonPlanMediator 
		 * verwaltet wird zurück
		 * */
		protected function get applicationView(): ApplicationView
		{
			return viewComponent as ApplicationView;
		}
	}
}