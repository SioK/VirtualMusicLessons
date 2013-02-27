package controller.search.filter
{
	import model.valueObjects.T_lesson;
	
	import mx.collections.IList;

	/**
	 * @author Francois Dubois
	 * Das IFilter Interface definiert die Spezifikationen für den SearchFilter
	 * */
	public interface IFilter
	{
		
		function loadDetails():void;
		function get detailList():IList;
		function filterList(detail:String, data:IList):IList;
		function get category():String;
	}
}