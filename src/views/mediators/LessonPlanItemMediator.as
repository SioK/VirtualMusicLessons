package views.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.components.LessonPlanItem;

	

	/**
	 * @author Francois Dubois
	 * Diese Klasse ist die Schnittstelle für alle GUI-Komponenten
	 * des LessonPlanItems und verwaltet diesen auch
	 * */
	public class LessonPlanItemMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'LessonPlanItemMediator';
		
		
		public function LessonPlanItemMediator( viewComponent:LessonPlanItem ) 
		{
			super(NAME, viewComponent);
			viewComponent.addEventListener(LessonPlanItem.PLAY_LESSON_PLAN , playLesson);
			viewComponent.addEventListener(MouseEvent.MOUSE_UP , updateLessonPlanItem);
			viewComponent.addEventListener(LessonPlanItem.REMOVE_LESSON_PLAN_ITEM , removeLessonPlanItem);
		}
		
		/**
		 * leitet das Abspielen der Lesson ein
		 * */
		public function playLesson(event:Event):void {

			facade.sendNotification(LessonPlanItem.PLAY_LESSON_PLAN, lessonPlanItem.getLessonData());
		}
		
		/**
		 * wird aufgerufen wenn die aktuelle Position 
		 * LessonPlanItems aktualisieren soll
		 * */
		public function updateLessonPlanItem(event:MouseEvent):void {
			
			facade.sendNotification(ApplicationFacade.UPDATE_LESSON_PLAN_ITEM, lessonPlanItem);
		}
		
		/**
		 * wird aufgerufen um ein LessonPlanItem zu entfernen
		 * */
		public function removeLessonPlanItem(event:Event):void {
			facade.sendNotification(ApplicationFacade.REMOVE_LESSON_PLAN_ITEM, lessonPlanItem);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
			
			];
		}
		
		override public function handleNotification( note: INotification ):void 
		{
			switch ( note.getName() ) 
			{
			}
		}
		/**
		 * gibt die View Komponente die von der Klasse LessonPlanItemMediator 
		 * verwaltet wird zurück
		 * */
		protected function get lessonPlanItem(): LessonPlanItem
		{
			return viewComponent as LessonPlanItem;
		}
	}
}