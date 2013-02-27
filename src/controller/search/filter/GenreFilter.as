package controller.search.filter
{
	import model.proxy.GenreProxy;
	import model.services.tgenreservice.TgenreService;
	import model.valueObjects.T_genre;
	import model.valueObjects.T_lesson;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * @author Francois Dubois
	 * Dieser Filter filtert die Lessons nach Genres
	 * */
	public class GenreFilter implements IFilter
	{
		
		private var details:IList;
		
		private var name:String = new String;
		
		private var getAllGenresResp:CallResponder = new CallResponder;
		private var genreService:TgenreService = new TgenreService
			
		public function GenreFilter(category:String) 
		{
			this.name = category;
		}
		
		/**
		 * leitet den download der Genres vom Server ein
		 * @dispatch ResultEvent
		 * */
		public function loadDetails():void {
			getAllGenresResp.addEventListener(ResultEvent.RESULT,detailsHandler);
			getAllGenresResp.token = genreService.getAllT_genre();
			genreService.commit();
		}
		
		/**
		 * wenn der download der Genres vom Server abgeschlossen ist,
		 * wird diese Methode ausgeführt und die 
		 * DetailList wird mit den geladenen Genres befüllt
		 * */
		public function detailsHandler(event:ResultEvent):void {
			this.details = getAllGenresResp.lastResult;
		}
		
		/**
		 * wrapper für DetailsList wandelt Genre Objekte in Strings um
		 * @return details - IList
		 * */
		public function get detailList():IList {
			var stringList:IList = new ArrayList;
			for(var x:int = 0; x < details.length; x++) {
				stringList.addItem((details.getItemAt(x) as T_genre).Genre);
			}
			return stringList;
		}
		
		/**
		 * filtert die Lessons nach Genre
		 * @return result - IList
		 * */
		public function filterList(detail:String, data:IList):IList {
			var list:IList = new ArrayList;
			for(var x:int = 0; x < data.length; x++) {
				if((data.getItemAt(x) as T_lesson).Genre == detail) {
					list.addItem(data.getItemAt(x));
				}
				
			}
			return list;
		}
		
		/**
		 * @return name des Filters
		 * */
		public function get category():String {
			return name;
		}

	}
}