package controller.tab
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import model.valueObjects.Track;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.messaging.management.Attribute;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import spark.components.List;
	
	/**
	 * @author Francois Dubois
	 * Der TrackingManager lädt, erstellt, setzt und entfernt TrackingPoints 
	 * Außerdem ist der TrackingManager in der Lage rückwirkend für einen bestimmten TrackingPoint 
	 * den TimeCode zu liefern
	 * */
	public class TrackingManager extends EventDispatcher
	{
		
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const ITEM_STATE_CHANGED:String = "itemStateChanged";
		
		private const BTN_INDEX:String = "btnIndex";
		private const START_TIME:String = "startTime";
		private const END_TIME:String = "endTime";
		private var track:XML;
		
		private static var numTracked:int = 0;
		private static var numPerspectives:int = 3;
		
		private var tp_perspective:ArrayList = new ArrayList;
		
		public function TrackingManager() 
		{
		}
		
		/**
		 * Ein Aufruf dieser Methode erstellt eine neue TrackingPointXML
		 * */
		public function createTrackingPointXML(trackingPoints:TrackingPointSet):void {
			track = <trackingPoints></trackingPoints>;
			numTracked = 0;
			var p1:XML = <perspective1></perspective1>;
			var p2:XML = <perspective2></perspective2>;
			var p3:XML = <perspective3></perspective3>;
			
			track.appendChild(p1);
			track.appendChild(p2);
			track.appendChild(p3);
			
			for(var x:int = 0; x < trackingPoints.getTrackingPoints().length; x++) {
				var tp:TrackingPoint = trackingPoints.getTrackingPoints().getItemAt(x) as TrackingPoint;
				
				var trackingPoint:XML = <trackingPoint />;
				trackingPoint.@btnIndex= tp.btnIndex;
				trackingPoint.@startTime= tp.startTime;
				trackingPoint.@endTime= tp.endTime;
				
				if(tp.perspective == "Perspective 1") {
					p1.appendChild(trackingPoint);
				}
				
				if(tp.perspective == "Perspective 2") {
					p2.appendChild(trackingPoint);
				}
				
				if(tp.perspective == "Perspective 3") {
					p3.appendChild(trackingPoint);
				}
				
			}
			
			//Alert.show(trackingPoint.toXMLString();
		}
		
		/**
		 * Ein Aufruf dieser Methode setzt einen TrackingPoint wenn der mark parameter auf true 
		 * gesetzt ist, wenn der Parameter false ist, wird der aktuelle TrackingPoint an definierter Position entfernt
		 * @btnIndex Index des Aktuellen Buttons
		 * @perspective Die Aktuelle Perspektive
		 * @tabListComponent Die TabList Komponente
		 * @mark wenn true setzen, false entfernen
		 * */
		public function markTrack(btnIndex:int, perspective:String, tabListComponent:List, mark:Boolean = true):void {
			var tracks:IList = tabListComponent.dataProvider;
			var track:Track = tracks.getItemAt(btnIndex) as Track;
			
			if(perspective == "Perspective 1") {
				track.tracked1 = mark;
			}
			
			if(perspective == "Perspective 2") {
				track.tracked2 = mark;
			}
			
			if(perspective == "Perspective 3") {
				track.tracked3 = mark;
			}
			
			tracks.removeItemAt(btnIndex);
			tracks.addItemAt(track,btnIndex);
			tabListComponent.dataProvider = tracks;
			this.dispatchEvent(new Event(ITEM_STATE_CHANGED));
		}
		
		/**
		 * Diese Methode prüft ob jeder Track zu jeder Perspektive 
		 * einen TrackingPoint erhalten hat, ist dies nicht der Fall 
		 * liefert diese Methode false
		 * @return boolean
		 * */
		public function trackingComplete(tracks:IList):Boolean {
			
			for(var x:int = 0; x < tracks.length; x++) {
				var track:Track = tracks.getItemAt(x) as Track;
				if(!(track.tracked1)) {
					return false;
				}
				if(!(track.tracked2)) {
					return false;
				}
				if(!(track.tracked3)) {
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Diese Methode leitet den Download der TrackingPoint Datei 
		 * an angegeben Pfad ein
		 * */
		public function loadTrackingPoints(path:String):void {
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			urlLoader.load(new URLRequest(path));
		}
		
		private function onXMLLoaded(event:Event):void {
			var trackFile:XML = initializeXML(event);
			
			tp_perspective.addItem(parseTrackingPoints(trackFile.perspective1));
			tp_perspective.addItem(parseTrackingPoints(trackFile.perspective2));
			tp_perspective.addItem(parseTrackingPoints(trackFile.perspective3));
			
			this.dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		/**
		 * Die Methode erstellt eine XML Objekt um darin
		 * TrackingPoints abzulegen
		 * */
		private function initializeXML(event:Event):XML {
			var trackFile:XML= new XML(event.target.data);
			return trackFile;
		}
		
		/**
		 * Diese Methode parst eine TrackingDatei und binden die Daten 
		 * an ein TrackingPointSet
		 * @return TrackingPointSet
		 * */
		private function parseTrackingPoints(perspective:Object):TrackingPointSet {
			var trackingPoints:TrackingPointSet = new TrackingPointSet;
	
			for(var x:int = 0; x < perspective.*.length(); x++) {
				var trackingPoint:TrackingPoint = new TrackingPoint;
				trackingPoint.startTime = perspective.trackingPoint[x].@startTime;
				trackingPoint.endTime = perspective.trackingPoint[x].@endTime;
				trackingPoint.btnIndex = perspective.trackingPoint[x].@btnIndex;
				trackingPoints.addTrackingPoint(trackingPoint);
			}
			return trackingPoints;
		}
		
		/**
		 * Ein Aufruf dieser Methode liefer den TimeCode des Tracks der, 
		 * dem aktuelle ButtonIndex und der Perspektive entspricht
		 * @return TimeCode - Zeitintervall für einen Track
		 * */
		public function getTimeCode(btnIndex:int, perspectiveIndex:int):TimeCode {
			var timeCode:TimeCode = new TimeCode;
			
			var trackingPoints:TrackingPointSet = tp_perspective.getItemAt(perspectiveIndex) as TrackingPointSet;
			
			var tp:ArrayList = trackingPoints.getTrackingPoints();
			for(var x:int = 0; x < tp.length; x++) {
				var trackingPoint:TrackingPoint = tp.getItemAt(x) as TrackingPoint;

				if(btnIndex == trackingPoint.btnIndex) {
					timeCode.startTime = int(trackingPoint.startTime);
					timeCode.endTime = int(trackingPoint.endTime);
				}			
			}
			return timeCode;
		}
		
		/**
		 * Diese Methode liefert eine TrackingPointXML
		 * @return TrackingPointXML
		 * */
		public function getTrackingPointXML():XML {
			return track;
		}
	}
}
