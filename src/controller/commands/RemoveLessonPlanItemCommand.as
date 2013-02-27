package controller.commands
{	
	import model.proxy.LessonPlanProxy;
	import model.valueObjects.T_lesson_plan_item;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import views.components.LessonPlanItem;
	
	/**
	 * @author Francois Dubois
	 * Ein Aufruf dieses Command bewirkt das Löschen des übergebenen LessonPlanItems
	 * */
	public class RemoveLessonPlanItemCommand extends SimpleCommand
	{
		public static const REMOVE_LESSON_PLAN_ITEM:String = "removeLessonPlanItem";
		
		override public function execute(note: INotification) :void	
		{
			var lessonPlanItem:LessonPlanItem = note.getBody() as LessonPlanItem;
			var id:int = lessonPlanItem.getLessonPlanItemID();
			( facade.retrieveProxy(LessonPlanProxy.NAME) as LessonPlanProxy ).removeLessonPlanItemByID(id);
		}
	}
}