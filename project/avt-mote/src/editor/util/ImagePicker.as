package editor.util 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class ImagePicker
	{
		
		protected var m_callback : Function;
		public var m_filename : String;
		
		public function ImagePicker(callback : Function ,filefArray : Array  , multiFile : Boolean) 
		{
			m_callback = callback;
			new FilePicker(onBA , filefArray , multiFile);
		}
		private function onBA(_filename : String , ba : ByteArray):void
		{
			m_filename = _filename;
			
			var ldr : Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete );
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onComplete );
			ldr.loadBytes(ba);
		}
		
		
		private function onComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE , onComplete );
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR , onComplete );
			
			if (e.type == IOErrorEvent.IO_ERROR)
			{
				trace(e);
				return;
			}
			
			var ldi : LoaderInfo = (e.currentTarget) as LoaderInfo;
			
			if (m_callback != null)
			{	
				m_callback(	m_filename , Bitmap(ldi.content).bitmapData);
				m_callback = null;
			}
		}
	}
	

}