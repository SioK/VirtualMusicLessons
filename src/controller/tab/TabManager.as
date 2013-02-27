package controller.tab
{
	import com.adobe.serializers.xml.XMLDecoder;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	
	import model.valueObjects.Tab;
	import model.valueObjects.Track;
	
	import mx.controls.Alert;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	/**
	 * @author Francois Dubois
	 * Der TabManager lädt, parst und prüft den Tab 
	 * */
	public class TabManager extends EventDispatcher
	{
		public static const TAB_COMPLETE:String = "tabComplete";
		
		private var tab:Tab = new Tab;
		
		public function TabManager()
		{
		}
		
		/**
		 * Ein Aufruf dieser Methode lädt den Tab an angegebenem Pfad
		 * */
		public function loadTab(path:String):void {
			
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			urlLoader.load(new URLRequest(path));
			
		}
		
		/**
		 * Diese Methode wird aufgerufen wenn der Tab vollständig geladen wurde
		 * und parst den Tab 
		 * @dispatch TAB_COMPLETE Event
		 * */
		private function onXMLLoaded(event:Event):void {
			var tabFile:Object = initializeXML(event);
			tab = new Tab;
			for(var x:int = 0; x < tabFile.tab.track.length; x++) {
				var track:Track = new Track;
				track.title = tabFile.tab.track[x].title;
				track.tuning = tabFile.tab.track[x].tuning;
				var content:String = tabFile.tab.track[x].content;
				var whitespace:RegExp = /(\t|\n|\s{2,})/g;  
				content = content.replace(whitespace, "");
				content = content.substr(2, content.length - 4);
				track.lines = content.split("||||");
				for(var k:int = 0; k < track.lines.length; k++) {
					track.content += "||" + track.lines[k] + "||";
					track.content += "\n";
					
				}
				
				tab.addTrack(track);
			}
			this.dispatchEvent(new Event(TAB_COMPLETE))
		}
		
		/**
		 * Ein Aufruf dieser Methode prüft den Tab auf ein gültiges Format
		 * @return boolean
		 * */
		public function isTabValid(event:Event):Boolean {
			var tabFile:Object = initializeXML(event);
			for(var x:int = 0; x < tabFile.tab.track.length; x++) {
				if(!isTrackContentValid(tabFile.tab.track[x].content)) {
					Alert.show("Tab Format is Invalid");
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * Ein Aufruf dieser Methode Serialisiert die XML / Tab Datei
		 * @ return serialisiertes Objekt
		 * */
		private function initializeXML(event:Event):Object {
			var xmlDoc:XMLDocument = new XMLDocument(event.target.data);
			xmlDoc.ignoreWhite = true;
			var simpleXMLDecoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
			var tabFile:Object = simpleXMLDecoder.decodeXML(xmlDoc);
			return tabFile;
		}
		
		/**
		 * Ein Aufruf dieser Methode prüft einen Track auf seine Gültigkeit
		 * */
		public function isTrackContentValid(trackContent:String):Boolean {
			var lines:Array = new Array();
			var measures:Array = new Array();
			var checkLines:int = 0;
			var initCheck:int = 0;
			
			var measureChecks:Array = new Array();
			var whitespace:RegExp = /(\t|\n|\s{2,})/g;  
			
			trackContent = trackContent.replace(whitespace, "");
			trackContent = trackContent.substr(2, trackContent.length - 4);
			
			lines = trackContent.split("||||");
			if(lines.length > 1) {
				for(var j:int; j < lines.length; j++) {
					var lengthLines:int = (lines[j] as String).length;
					checkLines = (lines[0] as String).length;
					if(lengthLines != checkLines) {
						return false;
					}
					for(var i:int=0; i<lines.length; i++) {
						measures = (lines[i] as String).split("|");
						for(var t:int = 0; t < measures.length; t++) {
							if(initCheck == 0) {
								measureChecks[t] = (measures[t] as String).length;
							} else {
								if((measures[t] as String).length != measureChecks[t]) {
									return false;
								}
							}
						}
						initCheck = 1;
					}
				}
			} else {
				return false;
			}
			
			return true;
		}
		
		/**
		 * @return liefert den Tab
		 * */
		public function getTab():Tab {
			return tab;
		}
		
	}
}