package controller.commands
{
	import model.proxy.LessonProxy;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Bei Auslösen dieses Commands werden alle Lessons aus der Datenbank geladen
	 * */
	public class PullLessonsCommand extends SimpleCommand
	{
		override public function execute(note: INotification):void 
		{
			var lessonProxy:LessonProxy;
			lessonProxy = facade.retrieveProxy(LessonProxy.NAME) as LessonProxy;
			lessonProxy.getLessons();

		}
	}
}