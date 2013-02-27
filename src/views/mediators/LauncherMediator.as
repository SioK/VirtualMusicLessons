package views.mediators
{
	
	
	import controller.commands.LoginCommand;
	
	import flash.events.Event;
	
	import model.proxy.InstrumentProxy;
	import model.proxy.LoginProxy;
	import model.proxy.RegisterProxy;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.components.LauncherView;
	import views.mediators.formHandler.LauncherFormHandler;
	
	
	/**
	 * @author Francois Dubois
	 * Diese Klasse ist die Schnittstelle für alle GUI-Komponenten
	 * der LauncherView und verwaltet diese auch
	 * */
	public class LauncherMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'LauncherMediator';
		
		private var formHandler:LauncherFormHandler;
		
		public function LauncherMediator( viewComponent:LauncherView ) 
		{
			super(NAME, viewComponent);
			viewComponent.addEventListener(LauncherView.VIEW_CREATION_COMPLETE, onCreationComplete);
			viewComponent.addEventListener(LauncherView.LOGINPRESSED , clickedLoginButton);
			viewComponent.addEventListener(LauncherView.REGISTERPRESSED , clickedRegisterButton);
			viewComponent.addEventListener(LauncherView.PULLINSTRUMENTS, pullInstruments);
			
		}
		
		/**
		 * Wird bei der Erstellung vom LauncherMediator aufgerufen
		 * und "meldet den LauncherFormHandler an"
		 * */
		public function onCreationComplete(event:Event):void {
			this.formHandler = new LauncherFormHandler(this.launcherView);
		}
		
		/**
		 * wird aufgerufen wenn der Login Button gedrückt wird
		 * und führt den Loginvorgang aus
		 * */
		protected function clickedLoginButton(event:Event):void
		{
			if(formHandler.isLoginValid()) {
				sendNotification(ApplicationFacade.LOGIN, launcherView.loginVO);					
			}
		}
		
		
		/**
		 * wird aufgerufen wenn der Register Button gedrückt wird
		 * und führt den Registrierungsvorgang aus
		 * */
		protected function clickedRegisterButton(event:Event):void
		{
			if(formHandler.isRegistrationValid()) {
				sendNotification(ApplicationFacade.REGISTER, launcherView.registerVO);				
			}
		}
		
		/**
		 * ein Aufruf dieser Methode lädt die Instrumente
		 * */
		private function pullInstruments(event:Event):void {
			sendNotification(ApplicationFacade.PULL_ALL_INSTRUMENTS);
		}
		
		/**
		 * ein Aufruf dieser Methode fügt die Instrument der 
		 * Registrierungs DropdownList hinzu
		 * */
		private function addInstruments(note: INotification):void {
			var instruments:IList = note.getBody() as IList;
			launcherView.register_instrument_dropdown.dataProvider = instruments;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ 
				RegisterProxy.SUCCESS,
				LoginProxy.FAILED,
				LoginCommand.USERNAME_INVALID_FORMAT,
				LoginCommand.PASSWORD_INVALID_FORMAT,
				LoginCommand.USERNAME_VALID_FORMAT,
				LoginCommand.PASSWORD_VALID_FORMAT,
				InstrumentProxy.PULL_INSTRUMENTS_SUCCESS
			];
		}
		
		override public function handleNotification( note: INotification ):void 
		{
			switch ( note.getName() ) 
			{
				
				case RegisterProxy.SUCCESS: 
					formHandler.resetRegistrationForm();
					break;
				case LoginProxy.FAILED:
					Alert.show("User not found");
					break;
				case LoginCommand.USERNAME_INVALID_FORMAT:
					launcherView.error_message_username.text = "Invalid Format ";
					break;
				case LoginCommand.PASSWORD_INVALID_FORMAT:
					launcherView.error_message_password.text = "Invalid Format ";
					break;
				case LoginCommand.USERNAME_VALID_FORMAT:
					launcherView.error_message_username.text = "";
					break;
				case LoginCommand.PASSWORD_VALID_FORMAT:
					launcherView.error_message_password.text = "";
					break;
				case InstrumentProxy.PULL_INSTRUMENTS_SUCCESS:
					addInstruments(note);
					break;
				default:
					
					
			}
		}
		
		protected function login(param0:Object):void {
			launcherView.login_username_label.text = param0 as String;
		}
		
		/**
		 * gibt die View Komponente die von der Klasse LauncherMediator 
		 * verwaltet wird zurück
		 * */
		protected function get launcherView(): LauncherView
		{
			return viewComponent as LauncherView;
		}
	}
}