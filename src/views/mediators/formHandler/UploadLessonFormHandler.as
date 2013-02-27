package views.mediators.formHandler
{
	import controller.videoplayer.PlayTimeManager;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.ValidationResultEvent;
	import mx.olap.aggregators.MinAggregator;
	import mx.validators.StringValidator;
	
	import views.components.ApplicationView;

	/**
	 * @author Francois Dubois
	 * Diese Klasse verhindert fehlerhafte Prozesse oder Eingaben
	 * auf der UploadLessonView
	 * */
	public class UploadLessonFormHandler
	{
		private var applicationView:ApplicationView;
		private var vResult:ValidationResultEvent;
		
		private var uploading:Boolean;
		
		public function UploadLessonFormHandler(applicationView:ApplicationView)
		{
			this.applicationView = applicationView;
		}
		
		/**
		 * setzt den aktuellen Status der UploadLessonView auf Upload 
		 * im Gange
		 * */
		public function setUploadState(uploading:Boolean):void {
			this.uploading = uploading;
		}
		
		/**
		 * gibt Auskunft darüber ob ein Upload derzeit im Gange ist
		 * @return boolean, bei true ist Upload im Gange
		 * */
		public function isUploading():Boolean {
			return uploading;
		}
		
		/**
		 * Prüft ob die hochzuladende Lesson überall
		 * korrekte Eingaben besitzt 
		 * */
		public function hasLessonFormValidFields():Boolean {
			var isValid:Boolean = true;
			vResult = applicationView.lessonNameValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.artistValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.songValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.descriptionValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.tabReferenceValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.videoName1Validator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.videoName2Validator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.videoName3Validator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.instrumentValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			vResult = applicationView.genreValidator.validate();
			if(vResult.type == ValidationResultEvent.INVALID) {
				isValid = false;
			}
			return isValid;
		}
		
		/**
		 * Deaktiviert Eingabemöglichkeiten in der LessonUploadForm 
		 * */
		public function freezeLessonUploadForm():void {
			applicationView.input_lessonName.editable = false;
			applicationView.input_artist.editable = false;
			applicationView.input_song.editable = false;
			applicationView.input_description.editable = false;
			applicationView.btn_open_vid1.enabled = false;
			applicationView.btn_open_vid2.enabled = false;
			applicationView.btn_open_vid3.enabled = false;
			applicationView.uploadLesson_btn.enabled = false;
			applicationView.btn_open_tab.enabled = false;
			applicationView.instrument_dropDown.enabled = false;
			applicationView.genre_dropDown.enabled = false;

			
		}
		
		/**
		 * Deaktiviert Eingabemöglichkeiten in der TrackingForm 
		 * */
		public function freezeTrackingForm():void {
			applicationView.uploadTrackingPoints_btn.enabled = false;
			applicationView.previewPerspectiveSelection.enabled = false;
			applicationView.setTrackingPoint.enabled = false;
			applicationView.removeTrackingPoint.enabled = false;
			applicationView.cancel_btn.enabled = false;
			applicationView.tabListPreview.dataProvider = new ArrayList;
			applicationView.previewPlayer.source = "";
		}
		
		/**
		 * aktiviert die Trackingform für Eingaben
		 * */
		public function activateTrackingForm():void {
			applicationView.previewPerspectiveSelection.enabled = true;
			applicationView.setTrackingPoint.enabled = true;
			applicationView.removeTrackingPoint.enabled = true;
			applicationView.cancel_btn.enabled = true;
		}
		
		/**
		 * setzt die UploadLessonForm zurück
		 * */
		public function resetLessonUploadForm():void {
			applicationView.input_lessonName.editable = true;
			applicationView.input_artist.editable = true;
			applicationView.input_song.editable = true;
			applicationView.input_description.editable = true;
			applicationView.btn_open_vid1.enabled = true;
			applicationView.btn_open_vid2.enabled = true;
			applicationView.btn_open_vid3.enabled = true;
			applicationView.uploadLesson_btn.enabled = true;
			applicationView.btn_open_tab.enabled = true;
			applicationView.instrument_dropDown.enabled = true;
			applicationView.genre_dropDown.enabled = true;
			
			applicationView.uploadVideosNavigator.selectedIndex = 0;
			
			applicationView.input_lessonName.text = "";
			applicationView.input_artist.text = "";
			applicationView.input_song.text = "";
			applicationView.input_description.text = "";
			applicationView.input_tabReference.text = "";
			applicationView.input_videoName1.text = "";
			applicationView.input_videoName2.text = "";
			applicationView.input_videoName3.text = "";
			
			applicationView.input_artist.errorString = "";
			applicationView.input_lessonName.errorString = "";
			applicationView.input_artist.errorString = "";
			applicationView.input_song.errorString = "";
			applicationView.input_description.errorString = "";
			applicationView.input_tabReference.errorString = "";
			applicationView.input_videoName1.errorString = "";
			applicationView.input_videoName2.errorString = "";
			applicationView.input_videoName3.errorString = "";

		}
		
		/**
		 * prüft ob der eingegebene TimeCode korrekt ist
		 * */
		public function isTimeCodeValid(startTime:int, endTime:int):Boolean {
			
			if(startTime > endTime) {
				Alert.show("Invalid TimeCode");
				return false;
			}
				
			return true;
		
		}
		
	}
	

}