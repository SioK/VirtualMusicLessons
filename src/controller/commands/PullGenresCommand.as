package controller.commands
{
	import model.proxy.GenreProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Bei Aufruf dieses Commands werden alle Genres aus der Datenbank geladen
	 * */
	public class PullGenresCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void {
			
			var user_id:int = note.getBody() as int;
			( facade.retrieveProxy(GenreProxy.NAME) as GenreProxy ).getAllGenres();
		}
	}
}