package controller.commands
{
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import model.proxy.FileProxy;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Wird dieser Command mit einem FileRefrenceContainer aufgerufen wird der Upload der 
	 * beinhaltenden Dateien eingeleitet
	 * */
	public class UploadFilesCommand extends SimpleCommand
	{
		
		override public function execute(note: INotification) :void	
		{
			
		
			var fileReferenceContainer:Object = note.getBody() as Object;
			(facade.retrieveProxy(FileProxy.NAME) as FileProxy).sendFiles(fileReferenceContainer);
		}
		
		
	}
}