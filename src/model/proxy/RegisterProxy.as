package model.proxy
{

	import model.services.registerservice.RegisterService;
	import model.services.userservice.TuserService;
	import model.valueObjects.RegisterVO;
	import model.valueObjects.T_user;
	
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	

	/**
	 * @author Francois Dubois
	 * Diese Klasse ist für die Registrierung von Usern verantwortlich
	 * */
	public class RegisterProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "registerProxy";
		
		public static const SUCCESS: String  = "register_success";
		public static const FAILED: String = "registe_failed";
		
		private var registerUser:CallResponder = new CallResponder;
		
		public function RegisterProxy (data:Object = null) 
		{
			super(NAME, data);		
		}
		
		/**
		 * wird aufgerufen wenn ein User erfolgreich registriert wurde
		 * */
		public function registerResponseHandler(event:ResultEvent):void {
			sendNotification(RegisterProxy.SUCCESS);
		}
		

		
		/**
		 * Ein Aufruf dieser Methode registriert einen neuen User
		 * */
		public function register(registerVO:RegisterVO):void {
			
			var registerService:RegisterService = new RegisterService;
			registerUser.addEventListener(ResultEvent.RESULT,registerResponseHandler);
			registerUser.token = registerService.registerUser(registerVO);

		}
	}
}