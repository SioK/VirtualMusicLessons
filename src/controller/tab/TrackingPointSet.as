package controller.tab
{
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	/**
	 * @author Francois Dubois
	 * Bei einem TrackingPointSet handelt es sich um einen Array von TrackingPoints
	 * es ist jedoch nicht möglich das es zwei TrackingPoints gibt bei denn sowohl
	 * der ButtonIndex als auch die Perspektiven Identisch sind
	 * */
	public class TrackingPointSet
	{
		private var trackingPoints:ArrayList = new ArrayList;
		
		public function TrackingPointSet()
		{
		}
		
		/**
		 * fügt einen TrackingPoint hinzu
		 * ist dieser TrackingPoint bereits vorhanden,
		 * damit ist gemeint, das es bereits einen TrackingPoint mit dem
		 * aktuelle ButtonIndex und der aktuelle Perspektive gibt
		 * wird dieser nicht gesetzt
		 * */
		public function addTrackingPoint(item:TrackingPoint):void {
			if(!itemExists(item)) {
				trackingPoints.addItem(item);
			}
	
		}
		
		/**
		 * entfernt das übergebene Element aus dem TrackingPointSet
		 * */
		public function removeTrackingPoint(item:TrackingPoint):void {
			if(trackingPoints.length > 0) {
				for(var x:int = 0; x < trackingPoints.length; x++) {
					if((trackingPoints.getItemAt(x).btnIndex == item.btnIndex) 
						&& (trackingPoints.getItemAt(x).perspective == item.perspective)) {
						trackingPoints.removeItemAt(x);
					}
				}
			}
		}
			
		/**
		 * prüft ob ein Item bereits vorhanden ist wenn ja liefert
		 * diese Methode false
		 * @return boolean
		 * */
		private function itemExists(item:TrackingPoint):Boolean {
			if(trackingPoints.length > 0) {
				for(var x:int = 0; x < trackingPoints.length; x++) {
					if((trackingPoints.getItemAt(x).btnIndex == item.btnIndex) 
						&& (trackingPoints.getItemAt(x).perspective == item.perspective)) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * liefert die TrackingPoints 
		 * @return TrackingPoints - ArrayList
		 * */
		public function getTrackingPoints():ArrayList
		{
			return trackingPoints;
		}
	}

}