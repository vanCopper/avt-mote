package player 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import player.struct.Matrix4x4;
	import player.struct.Vertex3D;
	import player.util.ByteArrayUtil;
	
	/**
	 * ...
	 * @author blueshell
	 */
	public class AVTMPlayer extends Sprite
	{
		private var m_bitmapData : BitmapData;
		private var m_head : HeadRender;
		private var m_eye : EyeRender;
		
		private var m_headShape : Shape;
		private var m_eyeSprite : Sprite;
		
		public function AVTMPlayer() 
		{
			m_bitmapData = new TestDataBD();
			///addChild(new Bitmap(m_bitmapData));
			m_head = new HeadRender();
			m_eye = new EyeRender();
			
			var ba : ByteArray = new TestDataBA();
			//var filehead : String = ;
			if (ba.readMultiByte(4 , "UTF-8") == "AMXB")
			{
				while (ba.bytesAvailable) {
					var flag : int = ba.readByte();
					var length : uint = ByteArrayUtil.readUnsignedShortOrInt(ba);
					var pos : int = ba.position;
					if (flag == 0x21)
					{
						m_head.decode(ba , pos + length);
					}
					else if (flag == 0x22)
					{
						m_eye.decode(ba , pos + length);
					}
					
					if (ba.position != pos + length)
					{
						trace("error pos");
						ba.position == pos + length;
					};
				}
				
				
			}
			
			m_headShape = new Shape();
			addChild(m_headShape);
			m_eyeSprite = new Sprite();
			addChild(m_eyeSprite);
		}
		public function blinkEye():void
		{
			m_eye.curLag = 1;
		}
		
		public function render(_m : Matrix4x4):void
		{
			m_head.render(m_headShape.graphics  , m_bitmapData , _m );
			m_eye.render(m_eyeSprite , m_bitmapData , _m );
		}
		
		public function getMatrix(xValue : Number, yValue : Number, zValue: Number) : Matrix4x4
		{
			if (m_head)
				return m_head.getMatrix(xValue, yValue, zValue);
			
			return null;
		}
		
	}

}