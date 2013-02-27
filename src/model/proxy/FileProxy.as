package model.proxy
{
	
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * @author Francois Dubois
	 * Die FileProxy Klasse verwaltet den Upload von den Videos, Tabs und Tracks
	 * */
	public class FileProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "fileProxy";
		
		// Pfade zu den PHP Service Skripts
		public static const VIDEO_SERVICE_PATH_THUMB: String = "http://localhost/video_upload_thumbnail.php";
		public static const VIDEO_SERVICE_PATH: String = "http://localhost/files/video_upload.php";
		public static const TAB_SERVICE_PATH: String = "http://localhost/files/tab_upload.php";
		public static const TRACK_SERVICE_PATH: String = "http://localhost/files/track_upload.php";
		
		//Pfade zu den Speicherorten der Dateien
		public static const VIDEO_PATH:String = "http://localhost/files/videos/";
		public static const TAB_PATH:String = "http://localhost/files/tabs/";
		public static const TRACK_PATH:String = "http://localhost/files/tracks/";
		public static const THUMBS_PATH:String = "http://localhost/files/thumbnails/";
		
		
		public static const UPLOAD_VIDEO1_SUCCESS:String = "uploadVideo1Success";
		public static const UPLOAD_VIDEO2_SUCCESS:String = "uploadVideo2Success";
		public static const UPLOAD_VIDEO3_SUCCESS:String = "uploadVideo3Success";
		public static const UPLOAD_TAB_SUCCESS:String = "uploadTabSuccess";
		public static const UPLOAD_TRACK_SUCCESS:String = "uploadTrackSuccess";
		public static const UPLOAD_THUMBNAIL_SUCCESS:String = "uploadThumbSuccess";
		
		public static const FILE_UPLOADS_COMPLETE:String = "fileUploadComplete";
		
		
		private var urlLoader:URLLoader = new URLLoader;
		private var fileFilter:FileFilter
		private var ticker:int;
		private var uploadPosition:int;
		
		private var fileList:ArrayList = new ArrayList;
		private var videoThumbRequest:URLRequest = new URLRequest(VIDEO_SERVICE_PATH_THUMB);
		private var videoRequest:URLRequest = new URLRequest(VIDEO_SERVICE_PATH);
		private var tabRequest:URLRequest = new URLRequest(TAB_SERVICE_PATH);
		
		private var trackingContainer:Object = new Object;
		
		public function FileProxy()
		{
			super(NAME, data);	
		}
		
		
		/**
		 * Ein Aufruf dieser Datei leitet den Upload der im FileReferenceContainer
		 * enthaltenen FileReferences ein
		 * */
		public function sendFiles(fileReferenceContainer:Object):void {
			data = fileReferenceContainer;
			upload();
		}
		
		/**
		 * Upload der ersten Datei [Video 1]
		 * */
		private function upload():void {
			(data["Video1"] as FileReference).addEventListener(Event.COMPLETE, upload2);
			(data["Video3"] as FileReference).addEventListener(Event.COMPLETE, video1Complete);
			(data["Video1"] as FileReference).upload(videoThumbRequest);
		}
		
		/**
		 * Upload der zweiten Datei [Video 2]
		 * */
		private function upload2(event:Event):void {
			(data["Video2"] as FileReference).addEventListener(Event.COMPLETE, upload3);
			(data["Video3"] as FileReference).addEventListener(Event.COMPLETE, video2Complete);
			(data["Video2"] as FileReference).upload(videoRequest);
		}
		
		/**
		 * Upload der dritten Datei [Video 3]
		 * */
		private function upload3(event:Event):void {
			(data["Video3"] as FileReference).addEventListener(Event.COMPLETE, upload4);
			(data["Video3"] as FileReference).addEventListener(Event.COMPLETE, video3Complete);
			(data["Video3"] as FileReference).upload(videoRequest);
		}
		
		/**
		 * Upload der vierten Datei [Tab]
		 * */
		private function upload4(event:Event):void {
			(data["Tab"] as FileReference).addEventListener(Event.COMPLETE, tabComplete);
			(data["Tab"] as FileReference).addEventListener(Event.COMPLETE, uploadsComplete);
			(data["Tab"] as FileReference).upload(tabRequest);
		}
		
		/**
		 * wird aufgerufen nachdem der upload der vierten Datei beendet ist
		 * */
		private function uploadsComplete(event:Event):void {
			facade.sendNotification(FILE_UPLOADS_COMPLETE);
		}
		
		/**
		 * Benachrichtigt über Beendigung des Uploads der erste FileReference 
		 * [Video 1]
		 * */
		private function video1Complete(event:Event):void { 
			facade.sendNotification(UPLOAD_VIDEO1_SUCCESS, VIDEO_PATH);
			facade.sendNotification(UPLOAD_THUMBNAIL_SUCCESS, THUMBS_PATH);
		}
		
		/**
		 * Benachrichtigt über Beendigung des Uploads der zweiten FileReference 
		 * [Video 2]
		 * */
		private function video2Complete(event:Event):void {
			facade.sendNotification(UPLOAD_VIDEO2_SUCCESS, VIDEO_PATH);
		}
		
		/**
		 * Benachrichtigt über Beendigung des Uploads der dritten FileReference 
		 * [Video 3]
		 * */
		private function video3Complete(event:Event):void {
			facade.sendNotification(UPLOAD_VIDEO3_SUCCESS, VIDEO_PATH);
		}
		
		/**
		 * Benachrichtigt über Beendigung des Uploads der vierten FileReference 
		 * [Tab]
		 * */
		private function tabComplete(event:Event):void {
			facade.sendNotification(UPLOAD_TAB_SUCCESS, TAB_PATH);
			
		}
		

		/**
		 * leitet den Upload der Tracking XML ein
		 * */
		public function uploadTrackingXML(trackingContainer:Object):void {
			this.trackingContainer = trackingContainer;
				
			var variables:URLVariables = new URLVariables();
			variables.filename = trackingContainer["name"];
			variables.filedata = trackingContainer["data"];
			
			var request:URLRequest = new URLRequest(TRACK_SERVICE_PATH);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			urlLoader = new URLLoader(request);
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			urlLoader.load(request);
		}
		
		/**
		 * Wird aufgerufen wenn der Download der TrackingXML erfolgreich 
		 * abgeschlossen ist
		 * */
		private function xmlLoaded(event:Event):void {
			var track_path:String = TRACK_PATH + trackingContainer["name"] + ".xml";
			urlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
			sendNotification(UPLOAD_TRACK_SUCCESS, track_path);
		}
	
		
	}
}