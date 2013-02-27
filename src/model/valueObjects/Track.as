package model.valueObjects
{
	import mx.collections.ArrayList;
	import mx.controls.Text;

	/**
	 * @author Francois Dubois
	 * Diese Klasse repräsentiert einen Track
	 * */
	public class Track
	{
		public var trackID:int = 0;
		public var title:String = "";
		public var tuning:String = "";
		public var content:String = "";
		public var lines:Array = new Array;
		public var tracked1:Boolean = false;
		public var tracked2:Boolean = false;
		public var tracked3:Boolean = false;
		
	}
}