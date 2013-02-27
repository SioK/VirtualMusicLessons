package model.proxy
{
	import model.services.tgenreservice.TgenreService;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.rpc.CallResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * @author
	 * Die GenreProxy Klasse ist für die De- / Serialisierung der Genres verantwortlich
	 * */
	public class GenreProxy extends Proxy implements IProxy
	{
		
		public static const NAME: String = "genreProxy";
		
		
		public static const PULL_GENRES_SUCCESS: String = "pullGenresSuccess";
		
		private var getAllGenresResp:CallResponder = new CallResponder;
		private var genreService:TgenreService = new TgenreService;
		
		public function GenreProxy()
		{
			super(NAME, data);	
		}
		
		/**
		 * ruft alle Genres von der Datenbank ab
		 * */
		public function getAllGenres():void {
			
			getAllGenresResp.addEventListener(ResultEvent.RESULT,pullGenreHandler);
			getAllGenresResp.token = genreService.getAllT_genre()
			genreService.commit();
		}
		
		/**
		 * Benachrichtigt wenn die Genres erfolgreich aus der Datenbank 
		 * geladen wurden
		 * */
		private function pullGenreHandler(event:ResultEvent):void {
			var genres:IList = getAllGenresResp.lastResult;
			sendNotification(GenreProxy.PULL_GENRES_SUCCESS,genres);
		}
	}
}