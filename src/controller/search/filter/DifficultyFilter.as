package controller.search.filter
{
	import model.valueObjects.T_lesson;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * @author Francois Dubois
	 * Dieser Filter filtert die Lessons nach Schwierigkeitsstufe
	 * */
	public class DifficultyFilter implements IFilter 
	{
		
		private var details:IList = new ArrayList;
		
		private var name:String = new String;
		
		public function DifficultyFilter(category:String)
		{
			this.name = category;
		}
		
		/**
		 * füllt die DetailsList mit Schwierigkeitsstufen
		 * */
		public function loadDetails():void {
			
			var detailList:IList = new ArrayList;
			detailList.addItem("1");
			detailList.addItem("2");
			detailList.addItem("3");
			detailList.addItem("4");
			detailList.addItem("5");
			
			this.details = detailList;
		}
		
		/**
		 * liefert die Details des Filters
		 * @return details - IList
		 * */
		public function get detailList():IList {
			return details;
		}
		
		/**
		 * filtert die Lessons nach Schwierigkeitsgrad
		 * @return result - IList
		 * */
		public function filterList(detail:String, data:IList):IList {
			var list:IList = new ArrayList;
			for(var x:int = 0; x < data.length; x++) {
				if((data.getItemAt(x) as T_lesson).Difficulty == int(detail)) {
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