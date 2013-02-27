package controller.videoplayer
{
	import controller.tab.TimeCode;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	import spark.components.VideoPlayer;

	
	/**
	 * @author Francois Dubois
	 * Der PlayTimeManager verwaltet den TimeCode so das ein 
	 * VideoPlayer damit iteragieren kann
	 * */
	public class PlayTimeManager
	{
		private var t:Timer;
		private var videoPlayer:VideoPlayer;
		private var start:Number;
		private var end:Number;
		
		private var minutes:int;
		private var seconds:int;
		
		public function PlayTimeManager(videoPlayerComponent:VideoPlayer)
		{
			this.videoPlayer = videoPlayerComponent;
		}
		
		/**
		 * setzt ein TimeIntervall auf den VideoPlayer
		 * */
		public function setTimeIntervall(timeCode:TimeCode):void {
			this.start = timeCode.startTime;
			this.end = timeCode.endTime;
			videoPlayer.play();
			videoPlayer.seek(start);
			t = new Timer(10);
			t.start();
			t.addEventListener(TimerEvent.TIMER , checkCurrentPlayerTime);
		}
		
		/**
		 * prüft ob das Ende des TimeIntervalls erreicht wurde
		 * wenn dies der Fall ist wird der Player gestoppt
		 * */
		private function checkCurrentPlayerTime(event:TimerEvent):void
		{
			if(videoPlayer.currentTime > end) {
				videoPlayer.stop();
				t.stop();
			}
		}
		
		/**
		 * ein Aufruf dieser Methode ermittelt die aktuelle Zeit 
		 * des VideoPlayers und wandelt diese in Minuten und Sekunden um
		 * */
		public function updateCurrentTime(currentTime:int):void {
			var playerTime:Number = currentTime;
			minutes = playerTime / 60;
			seconds = playerTime % 60;
		}
		
		/**
		 * Diese Methode wandelt Minuten in Sekunden um
		 * */
		public static function minutesToSeconds(minutes:int):int {
			return (minutes * 60);
		}
			
		/**
		 * Nach jedem Aufruf der updateCurrentTime gibt
		 * diese Methode den Minutenanteil der zu diesem Zeitpunkt 
		 * ermittelten VideoPlayer- Zeit
		 * @return Minuten
		 * */
		public function getMinutes():int {
			return minutes;
		}
		
		/**
		 * Nach jedem Aufruf der updateCurrentTime gibt
		 * diese Methode den Sekundenanteil der zu diesem Zeitpunkt 
		 * ermittelten VideoPlayer- Zeit
		 * @return Sekunden
		 * */
		public function getSeconds():int {
			return seconds;
		}
	}
}