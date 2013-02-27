package controller.commands
{

	import model.proxy.InstrumentProxy;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Wenn der Command aufgerufen wird werden alle Instrumente aus der Datenbank geladen
	 * */
	public class PullInstrumentsCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void {
			
			(facade.retrieveProxy(InstrumentProxy.NAME) as InstrumentProxy).getAllInstruments();
		
		}
	}
}