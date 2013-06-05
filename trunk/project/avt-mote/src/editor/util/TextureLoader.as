package editor.util 
{
	import editor.Library;
	import editor.struct.Texture2D;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class TextureLoader 
	{
		public static var s_imgPath : String = "../../demo/";
		private var m_callback : Function;
		private var m_filename : String;
		private var m_xml : XML;
		private var m_filp : Boolean;
		
		public function TextureLoader(xml : XML , a_callback : Function , filp : Boolean) 
		{
			m_filp = filp;
			m_callback = a_callback;
			if (xml.name() == "Texture2D")
			{
				m_xml = xml;
				m_filename = xml.name.text();
			
				var _textureLoaded : Texture2D = Library.getS().getTexture2D(m_filename);
				if (_textureLoaded && _textureLoaded.bitmapData)
				{
					if (m_callback != null)
					{	
						m_callback(	m_filename , _textureLoaded );
						m_callback = null;
					}
					return;
				}
				
				var ldr : Loader = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete );
				ldr.load(new URLRequest(s_imgPath + m_filename.replace("#FLIP" , "")));
			}
			else
			{
				ASSERT(false , "error head");
			}
		}
		
		public function dispose():void
		{
			m_callback = null;
			m_filename = null;
			m_xml = null;
		}
		
		private function onComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE , onComplete );
			var ldi : LoaderInfo = (e.currentTarget) as LoaderInfo;
			
			var _texture : Texture2D = new Texture2D(Bitmap(ldi.content).bitmapData , m_filename.replace("#FLIP" , "") , m_xml.type.text()
			, Number(m_xml.rectX.text())
			, Number(m_xml.rectY.text())
			, Number(m_xml.rectW.text())
			, Number(m_xml.rectH.text())
			);
			Library.getS().addTexture(_texture);
			if (m_filp)
				Library.getS().addTexture(new Texture2D(Bitmap(ldi.content).bitmapData , (m_filename.replace("#FLIP" , "") +"#FLIP") ,  m_xml.type.text() , _texture.rectX + _texture.rectW , _texture.rectY , -_texture.rectW , _texture.rectH));
			
			_texture = Library.getS().getTexture2D(m_filename);//prevent load 2 tiwce
			if (m_callback != null)
			{	
				m_callback(	m_filename , _texture);
				m_callback = null;
			}
			
			dispose();
		}
		
	}

}