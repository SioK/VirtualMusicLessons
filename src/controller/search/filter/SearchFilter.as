package controller.search.filter
{
	
	import model.valueObjects.T_lesson;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.List;

	
	/**
	 * @author Francois
	 * Bei dem SearchFilter handelt es sich um einen Container für Filter
	 * Er verwaltet und für die Filter aus zudem besitzt er eine Echtzeit Textsuche
	 * Es sind nur Filter vom Typ IFilter zulässig
	 * */
	public class SearchFilter
	{
		
		private var data:IList = new ArrayList;
		
		private var currentFilter:IFilter;
		private var filters:IList = new ArrayList;
		private var text:String = new String;
		
		public function SearchFilter()
		{
		}
		
		/**
		 * daten die gefiltert werden sollen - IList
		 * */
		public function set dataList(data:IList):void {
			this.data = data;
		}
		
		/**
		 * befüllt den SearchFilter mit Filtermodulen
		 * */
		public function addFilter(filter:IFilter):void {
			filters.addItem(filter);
		}
		
		/**
		 * aktiviert den übergebenen Filter
		 * */
		public function activateFilter(filter:IFilter):void {
			for(var x:int = 0; x < filters.length; x++) {
				if((filters.getItemAt(x) as IFilter).category == filter.category) {
					currentFilter = filters.getItemAt(x) as IFilter;
				}
			}
		}
		
		/**
		 * liefert alle Filter die von der SearchFilter Klasse verwaltet werden
		 * @return filters - IList
		 * */
		public function getAllFilter():IList {
			return filters;
		}
		
		/**
		 * befüllt die aktuelle detailsList
		 * @return details - IFilter
		 * */
		public function filterList(detail:String):IList {
			return currentFilter.filterList(detail,textSearch(this.text));
		}
		
		/**
		 * ein Aufruf dieser Methode löst die Textsuche aus
		 * @return result - IList
		 * */
		public function textSearch(text:String):IList {
			this.text = text;
			var list:IList = new ArrayList;
			for(var x:int = 0; x < data.length; x++) {
				if((data.getItemAt(x) as T_lesson).Lesson.substring(0, text.length).toLowerCase() == text.toLowerCase() ) {
					list.addItem(data.getItemAt(x));
				}
			}
			return list;
		}
	}
}