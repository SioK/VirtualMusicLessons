package controller.commands
{
	import model.proxy.LessonProxy;
	import model.valueObjects.LessonVO;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Bei Aufruf diese Command wird die übergeben Lesson aktualisiert
	 * */
	public class UpdateLessonCommand extends SimpleCommand
	{
		override public function execute(note: INotification) :void	{
			
			var lesson:LessonVO = note.getBody() as LessonVO;
			( facade.retrieveProxy(LessonProxy.NAME) as LessonProxy ).updateLesson(lesson);
		}
	}
}