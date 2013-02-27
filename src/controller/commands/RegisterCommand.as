package controller.commands
{
	import model.proxy.RegisterProxy;
	import model.valueObjects.RegisterVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * @author Francois Dubois
	 * Wird dieser Command mit Nutzerdaten aufgerufen wird dieser Nutzer im System registriert
	 * */
	public class RegisterCommand extends SimpleCommand
	{
		
		override public function execute(note: INotification) :void	
		{
			
			var registerVO:RegisterVO = note.getBody() as RegisterVO;
			var registerProxy:RegisterProxy;
			registerProxy = facade.retrieveProxy(RegisterProxy.NAME) as RegisterProxy;
			registerProxy.register(registerVO);
		}
	}
}