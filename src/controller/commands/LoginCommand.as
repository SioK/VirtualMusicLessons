package controller.commands
{

	import flash.utils.Dictionary;
	
	import model.proxy.LoginProxy;
	import model.proxy.VirtualMusicLessonsProxy;
	import model.valueObjects.LoginVO;
	
	import mx.controls.Alert;
	import mx.controls.Tree;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * @author Francois Dubois
	 * Dieser Command löst die Login Prüfung aus
	 * */
	public class LoginCommand extends SimpleCommand
	{
		public static const USERNAME_INVALID_FORMAT:String = "usernameInvalidFormat";
		public static const PASSWORD_INVALID_FORMAT:String = "passwordInvalidFormat";
		
		public static const USERNAME_VALID_FORMAT:String = "usernameValidFormat";
		public static const PASSWORD_VALID_FORMAT:String = "passwordVvalidFormat";
		
		public static const VALIDATION_RESULT:String = "validation_result";
		
		
		
		override public function execute(note: INotification) :void	
		{
			var loginVO:LoginVO = note.getBody() as LoginVO;
			var loginProxy:LoginProxy;
			loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			loginProxy.checkUserData(loginVO);

		}

	}
}