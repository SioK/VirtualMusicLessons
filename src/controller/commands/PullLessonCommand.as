package controller.commands
{
	import model.proxy.LessonProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Bei aufrufen dieses Commands wird eine Lesson aus der Datenbank geladen die 
	 * der übergebenen LESSON_ID entspricht
	 * */
	public class PullLessonCommand extends SimpleCommand
	{
		override public function execute(note: INotification) :void	{
			
			var lessonID:int = note.getBody() as int;
			( facade.retrieveProxy(LessonProxy.NAME) as LessonProxy ).getLesson(lessonID);
		}
	}
}