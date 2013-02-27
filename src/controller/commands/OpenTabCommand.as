package controller.commands
{
	import controller.tab.TabManager;
	
	import flash.events.Event;
	import flash.net.FileReference;
	
	import model.valueObjects.Tab;
	
	import mx.collections.IList;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Francois Dubois
	 * Dieser Command löst das öffnen eines Tabs aus
	 * */
	public class OpenTabCommand extends SimpleCommand
	{
		public static const TAB_COMPLETE:String = "tabComplete";
		
		private var tabManager:TabManager;
		
		
		override public function execute(note: INotification) :void	
		{
			var tab_Path:String = note.getBody() as String;
			tabManager = new TabManager;
			tabManager.addEventListener(TabManager.TAB_COMPLETE, tabComplete);
			tabManager.loadTab(tab_Path);
			

		}
		
		/**
		 * Wenn der Tab vollständig geladen wurde wird der Tab geparst 
		 * und per Notification an das Framework gesendet
		 * */
		private function tabComplete(event:Event):void {
			var tab:Tab = tabManager.getTab();
			facade.sendNotification(TAB_COMPLETE, tab);
		}
		
	}
}