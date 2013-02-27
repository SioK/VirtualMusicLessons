package model.proxy
{
	
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * @author Francois Dubois
	 * */
	public class VirtualMusicLessonsProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = 'VirtualMusicLessonsProxy';
		
		public function VirtualMusicLessonsProxy (data:Object = null) 
		{
			super(NAME, data);		
		}
		
	}
}