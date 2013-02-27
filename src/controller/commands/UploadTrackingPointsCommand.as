package controller.commands
{
	import flash.events.Event;
	import flash.media.Video;
	import flash.net.FileReference;
	
	import model.proxy.FileProxy;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * @author Francois Dubois
	 * Bei Aufruf dieses Commands wird der Upload der TrackingPoints auf
	 * den Server eingeleitet
	 * */
	public class UploadTrackingPointsCommand extends SimpleCommand
	{
		
		override public function execute(note: INotification) :void	
		{
			var trackingContainer:Object = note.getBody() as Object;
			(facade.retrieveProxy(FileProxy.NAME) as FileProxy).uploadTrackingXML(trackingContainer);
		}
		
		
	}
}