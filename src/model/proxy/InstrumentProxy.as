package model.proxy
{
	import model.services.tinstrumentservice.TinstrumentService;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * @author
	 * Die Instrumentroxy Klasse ist für die De- / Serialisierung der Instrumente verantwortlich
	 * */
	public class InstrumentProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "instrumentProxy";
		
		public static const PULL_INSTRUMENTS_SUCCESS: String = "pullInstrumentsSuccess";
		
		private var getAllInstrumentResp:CallResponder = new CallResponder;
		private var instrumentService:TinstrumentService = new TinstrumentService;
		
		public function InstrumentProxy()
		{
			super(NAME, data);	
		}
		
		
		/**
		 * ruft alle Instrumente von der Datenbank ab
		 * */
		public function getAllInstruments():void {

			getAllInstrumentResp.addEventListener(ResultEvent.RESULT,pullInstrumentHandler);
			getAllInstrumentResp.token = instrumentService.getAllT_instrument();
			instrumentService.commit();
		}
		
		/**
		 * Benachrichtigt wenn die Instrumente erfolgreich aus der Datenbank 
		 * geladen wurden
		 * */
		private function pullInstrumentHandler(event:ResultEvent):void {
			var instruments:IList = getAllInstrumentResp.lastResult;
			sendNotification(InstrumentProxy.PULL_INSTRUMENTS_SUCCESS,instruments);
		}
	}
}