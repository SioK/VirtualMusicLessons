package controller.commands
{
	import model.proxy.LessonPlanProxy;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Bei Aufruf dieses Commands werden alle LessonPlanItems aus der Datenbank geladen,
	 * die einem bestimmten User zugeordnet wurden (USER_ID)
	 * */	
	public class PullLessonPlanItemsCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void {
			var user_id:int = note.getBody() as int;
			( facade.retrieveProxy(LessonPlanProxy.NAME) as LessonPlanProxy ).getLessonPlanItemsByID(user_id);
		}
	}
}