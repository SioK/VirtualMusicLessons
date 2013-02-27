package views.mediators.formHandler
{
	import mx.controls.Alert;
	import mx.events.ValidationResultEvent;
	
	import views.components.LauncherView;

	/**
	 * @author Francois Dubois
	 * Diese Klasse verhindert fehlerhafte Prozesse oder Eingaben
	 * auf der LauncherView
	 * */
	public class LauncherFormHandler
	{
		
		private var launcherView:LauncherView;
		
		private var vResult:ValidationResultEvent;
		
		public function LauncherFormHandler(launcherView:LauncherView)
		{
			this.launcherView = launcherView;
		}
		
		/**
		 * prüft alle EingabeFelder der Login Form
		 * */
		public function isLoginValid():Boolean {
			
			var isValid:Boolean = true;
			vResult = launcherView.login_usernameValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			
			vResult = launcherView.login_passwortValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			return isValid;
		}
		
		/**
		 * prüft alle EingabeFelder der Register Form
		 * */
		public function isRegistrationValid():Boolean {
			
			
			var isValid:Boolean = true;
			vResult = launcherView.register_usernameValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			
			
			vResult = launcherView.register_passwortValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			
			vResult = launcherView.register_emailValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			
	
			vResult = launcherView.register_instrumentValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			
			return isValid;
		}
		
		/**
		 * setzt die Registrationsform zurück
		 * */
		public function resetRegistrationForm():void {
			launcherView.register_username_input.text = "";
			launcherView.register_mail_input.text = "";
			launcherView.register_password_input.text = "";
			launcherView.register_username_input.errorString = "";
			launcherView.register_mail_input.errorString = "";
			launcherView.register_password_input.errorString = "";
			Alert.show("Registrierung Erfolgreich");
		}
	}
}