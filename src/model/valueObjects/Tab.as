package model.valueObjects
{
	import mx.collections.ArrayList;
	import mx.collections.IList;

	/**
	 * @author Francois Dubois
	 * Die Klasse repräsentiert einen Tab
	 * */
	public class Tab
	{
		private var tracks:IList = new ArrayList;
		public function Tab()
		{
		}
		
		public function addTrack(track:Track):void {
			tracks.addItem(track);
		}
		
		public function getTracks():IList {
			return tracks;
		}
	}
}