package controller.commands
{
	import model.proxy.LessonProxy;
	import model.valueObjects.LessonVO;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * @author Francois Dubois
	 * Bei Aufruf dieses Command wird die übergebene Lessons persistiert
	 * */
	public class PushLessonCommand extends SimpleCommand
	{
		override public function execute(note: INotification) :void	
		{
			
			var lessonVO:LessonVO = note.getBody() as LessonVO;
			var lessonProxy:LessonProxy;
			lessonProxy = facade.retrieveProxy(LessonProxy.NAME) as LessonProxy;
			lessonProxy.createLesson(lessonVO);
		}
	}
}