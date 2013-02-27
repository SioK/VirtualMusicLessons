package views.mediators
{
	import model.proxy.LoginProxy;
	import model.proxy.VirtualMusicLessonsProxy;
	import model.valueObjects.T_user;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;


	/**
	 * @author Francois Dubois
	 * */
	public class VirtualMusicLessonsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "VirtualMusicLessonsMediator";
		
		private var _appProxy: VirtualMusicLessonsProxy;
		
		private var userData:T_user = null;
		
		public function VirtualMusicLessonsMediator( viewComponent:VirtualMusicLessons ) 
		{
		
			super(NAME, viewComponent);

			// local reference to the proxies
			_appProxy = facade.retrieveProxy(VirtualMusicLessonsProxy.NAME) as VirtualMusicLessonsProxy;
			
		}
		
		/**
		 * List all notifications this Mediator is interested in.
		 * 
		 * @return Array the list of Nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			
			return [ 	
				LoginProxy.SUCCESS
			];
		}
		
		
		override public function handleNotification( note:INotification ):void 
		{
			switch (note.getName()) 
			{
				case LoginProxy.SUCCESS:
					changeToApplicationView(note);
					break;		
				default:
					
			}
		}	
		
		private function changeToApplicationView(note:INotification): void {
			this.userData = note.getBody() as T_user;
			app.currentState = "ApplicationState";
		}
		
		public function getHoldedUserData():T_user {
			return this.userData;
		}
		
		protected function get app():VirtualMusicLessons
		{
			return viewComponent as VirtualMusicLessons;
		}

		
	}
}