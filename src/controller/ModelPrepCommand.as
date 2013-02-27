package controller
{
	import model.proxy.FileProxy;
	import model.proxy.GenreProxy;
	import model.proxy.InstrumentProxy;
	import model.proxy.LessonPlanProxy;
	import model.proxy.LessonProxy;
	import model.proxy.LoginProxy;
	import model.proxy.RegisterProxy;
	import model.proxy.VirtualMusicLessonsProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import views.mediators.LessonPlanItemMediator;


	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	
		{			
			facade.registerProxy( new VirtualMusicLessonsProxy() );	
			
			// register the needed proxies
			facade.registerProxy( new LoginProxy() );		
			facade.registerProxy( new RegisterProxy() );
			facade.registerProxy( new LessonProxy() );
			facade.registerProxy( new LessonPlanProxy() );
			facade.registerProxy( new GenreProxy() );
			facade.registerProxy( new InstrumentProxy() );
			facade.registerProxy( new FileProxy() );
			
		}
	}
}