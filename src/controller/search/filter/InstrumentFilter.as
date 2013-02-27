package controller.search.filter
{
	import model.services.tinstrumentservice.TinstrumentService;
	import model.valueObjects.T_instrument;
	import model.valueObjects.T_lesson;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;

	/**
	 * @author Francois Dubois
	 * Dieser Filter filtert nach Instrumenten
	 * */
	public class InstrumentFilter implements IFilter
	{
		
		private var details:IList;
		
		private var name:String = new String;
		
		private var getAllInstrumentsResp:CallResponder = new CallResponder;
		private var instrumentService:TinstrumentService = new TinstrumentService
		
		public function InstrumentFilter(category:String) 
		{
			this.name = category;
		}
		
		/**
		 * leitet den download der Instrumente vom Server ein
		 * @dispatch ResultEvent
		 * */
		public function loadDetails():void {
			getAllInstrumentsResp.addEventListener(ResultEvent.RESULT,detailsHandler);
			getAllInstrumentsResp.token = instrumentService.getAllT_instrument();
			instrumentService.commit();
		}
		
		/**
		 * wenn der download der Instrumente vom Server abgeschlossen ist,
		 * wird diese Methode ausgeführt und die 
		 * detailList wird mit den geladenen Instrumenten befüllt
		 * */
		public function detailsHandler(event:ResultEvent):void {
			this.details = getAllInstrumentsResp.lastResult;
		}
		
		/**
		 * Wrapper für DetailsList wandelt Genre Objekte in Strings um
		 * @return details - IList
		 * */
		public function get detailList():IList {
			var stringList:IList = new ArrayList;
			for(var x:int = 0; x < details.length; x++) {
				stringList.addItem((details.getItemAt(x) as T_instrument).Instrument);
			}
			return stringList;
		}
		
		/**
		 * Filtert die Lessons nach Instrument
		 * @return result - IList
		 * */
		public function filterList(detail:String, data:IList):IList {
			var list:IList = new ArrayList;
			for(var x:int = 0; x < data.length; x++) {
				if((data.getItemAt(x) as T_lesson).Instrument == detail) {
					list.addItem(data.getItemAt(x));
				}
			}
			return list
		}
		
		/**
		 * @return name des Filters
		 * */
		public function get category():String {
			return name;
		}
	}
}