package editor.util 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class ImageListPicker
	{
		
		protected var m_callback : Function;
		public var m_filename : String;
		private var m_loadArray : Array;
		public function ImageListPicker(callback : Function ,filefArray : Array) 
		{
			m_callback = callback;
			new FilePicker(onBA , filefArray);
		}
		
		private function loadImg(str :String) : void
		{
			var ldr : Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete );
			var url : String = TextureLoader.s_imgPath +  m_filename;
			ldr.load(new URLRequest(url));
			
			//trace(url , TextureLoader.s_imgPath +  m_filename);
		}
		
		private function onBA(_filename : String , ba : ByteArray):void
		{
			m_filename = _filename;
			
			
			if (m_filename.indexOf(".png") != -1)
			{
				var ldr : Loader = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete );
				ldr.loadBytes(ba);
			}
			else {
				var _info : String = String(ba);
				while(_info.indexOf('\r') != -1)
					_info = _info.replace('\r' , "");
				m_loadArray = _info.split("\n");
				if (m_loadArray[m_loadArray.length - 1] == "")
					m_loadArray.pop();
				//trace(m_loadArray);
				
				
				m_filename = m_loadArray.shift();
				loadImg(m_filename);
			}
			
			
			
			//var ldr : Loader = new Loader();
			//ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete );
			//ldr.loadBytes(ba);
		}
		
		
		private function onComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE , onComplete );
			var ldi : LoaderInfo = (e.currentTarget) as LoaderInfo;
			
			if (m_callback != null)
			{	
				m_callback(	m_filename , Bitmap(ldi.content).bitmapData);
			}	
			
			if (!m_loadArray)
			{
				m_callback = null;
				return;
			}
			
			
			if (m_loadArray.length == 0)	
			{	
				m_loadArray = null;
				m_callback = null;
			}	
			else {
				
				m_filename = m_loadArray.shift();
				
				loadImg(m_filename);
			}
			
		}
	}
	

}