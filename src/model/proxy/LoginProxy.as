package model.proxy
{

	
	import model.services.loginservice.LoginService;
	import model.services.userservice.TuserService;
	import model.valueObjects.LoginVO;
	import model.valueObjects.T_user;
	
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * @author Francois Dubois
	 * Prüft ob ein User in der Datenbank existiert
	 * */
	public class LoginProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "loginProxy";
		
		public static const SUCCESS: String = "login_success";
		public static const FAILED: String = "login_failed";
		
		private var loginService:LoginService = new LoginService;
		private var loginVO:LoginVO;
		
		private var pullUser:CallResponder = new CallResponder;
		
		public function LoginProxy () 
		{
			super(NAME, data);		
		}
		
		/**
		 * wird ausgeführt wenn ein User vorhanden ist
		 * */
		protected function UserDataResponseHandler(event:ResultEvent):void {
			var user:T_user = event.result as T_user;
			sendNotification(LoginProxy.SUCCESS,user);
	
		}
		
		/**
		 * prüft und benachrichtig ob ein Benutzer existiert
		 * */
		protected function LoginResponseHandler(event:ResultEvent): void {
			if(event.result as Boolean) {
		
				pullUser.token = loginService.getUserByUsername(loginVO.Username);
				pullUser.addEventListener(ResultEvent.RESULT,UserDataResponseHandler);
				
			} else {
				sendNotification(LoginProxy.FAILED);
			}
		}
		
		public function checkUserData(loginVO:LoginVO):void {
			this.loginVO = loginVO;
			var checkUser:CallResponder = new CallResponder;

			checkUser.addEventListener(ResultEvent.RESULT,LoginResponseHandler);
			checkUser.token = loginService.checkUserCredentials(loginVO);

		}
				
	}
	
}