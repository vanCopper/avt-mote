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
		private var m_hair : HairRender;
		private var m_body : BodyRender;
		
		private var m_hairUnderShape : Shape;
		private var m_bodyShape : Shape;
		private var m_headShape : Shape;
		private var m_eyeSprite : Sprite;
		private var m_hairTopShape : Shape;
		
		
		public function AVTMPlayer() 
		{
			m_bitmapData = new TestDataBD();
			///addChild(new Bitmap(m_bitmapData));
			m_head = new HeadRender();
			m_eye = new EyeRender();
			m_hair = new HairRender();
			m_body = new BodyRender();
			
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
						m_head.decode(ba , pos + length , m_bitmapData);
					}
					else if (flag == 0x22)
					{
						m_eye.decode(ba , pos + length , m_bitmapData);
					}
					else if (flag == 0x23)
					{
						m_hair.decode(ba , pos + length , m_bitmapData);
					}
					else if (flag == 0x24)
					{
						m_body.decode(ba , pos + length , m_bitmapData);
					}
					
					if (ba.position != pos + length)
					{
						trace("error pos");
						ba.position = pos + length;
					};
				}
				
				
			}
			
			m_hairUnderShape = new Shape();
			addChild(m_hairUnderShape);
			
			m_bodyShape = new Shape();
			addChild(m_bodyShape);
			
			m_headShape = new Shape();
			addChild(m_headShape);
			m_eyeSprite = new Sprite();
			addChild(m_eyeSprite);

			m_hairTopShape = new Shape();
			addChild(m_hairTopShape);
		}
		public function blinkEye():void
		{
			m_eye.curLag = 1;
		}
		private var sinWind : Number = 0;
		public function render(_m : Matrix4x4 , xValue : Number, yValue : Number, zValue: Number):void
		{
			if (_m == null)
			{
				_m = new Matrix4x4();
				_m.identity();
			}
			
			sinWind += 0.02;
			HairRender.WIND =  -0.01 * Math.abs(Math.sin(sinWind)) + 0.0002;
			
			m_hair.render(m_hairUnderShape.graphics  , m_bitmapData , _m , true );
			m_body.render(m_bodyShape.graphics  , m_bitmapData , xValue , zValue );
			m_head.render(m_headShape.graphics  , m_bitmapData , _m );
			m_eye.render(m_eyeSprite , m_bitmapData , _m );
			m_hair.render(m_hairTopShape.graphics  , m_bitmapData , _m , false);
		}
		
		public function getMatrix(xValue : Number, yValue : Number, zValue: Number) : Matrix4x4
		{
			if (m_head)
				return m_head.getMatrix(xValue, yValue, zValue);
			
			return null;
		}
		
	}

}