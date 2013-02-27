package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import views.components.ApplicationView;
	import views.components.LauncherView;
	import views.components.LessonPlanItem;
	import views.mediators.ApplicationMediator;
	import views.mediators.LauncherMediator;
	import views.mediators.LessonPlanItemMediator;
	import views.mediators.VirtualMusicLessonsMediator;
	

	public class ViewPrepCommand extends SimpleCommand
	{
		override public function execute(note: INotification) :void	
		{
			facade.registerMediator( new VirtualMusicLessonsMediator( note.getBody() as VirtualMusicLessons ));
		}	
	}
}