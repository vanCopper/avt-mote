package player 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import player.struct.Matrix4x4;
	import player.struct.Vertex3D;
	
	/**
	 * ...
	 * @author blueshell
	 */
	public class AVTMPlayer extends Sprite
	{
		private var m_bitmapData : BitmapData;
		private var m_head : HeadRender;
		
		
		public function AVTMPlayer() 
		{
			m_bitmapData = new TestDataBD();
			///addChild(new Bitmap(m_bitmapData));
			m_head = new HeadRender();
			var ba : ByteArray = new TestDataBA();
			//var filehead : String = ;
			if (ba.readMultiByte(4 , "UTF-8") == "AMXB")
			{
				var flag : int = ba.readByte();
				var length : uint = ba.readUnsignedShort();
				if (length == 0xFFFF)
					length = ba.readUnsignedInt();
				var pos : int = ba.position;
				if (flag == 0x21)
				{
					m_head.decode(ba , pos + length);
				}
				
				if (ba.position != pos + length)
				{
					trace("error pos");
					ba.position == pos + length;
				};
				
			}
			
		}
		
		public function render(_m : Matrix4x4):void
		{
			graphics.clear();
			graphics.beginBitmapFill(m_bitmapData,null,false,true);
			m_head.render(graphics , _m );
		}
		
		public function getMatrix(xValue : Number, yValue : Number, zValue: Number) : Matrix4x4
		{
			if (m_head)
				return m_head.getMatrix(xValue, yValue, zValue);
			
			return null;
		}
		
	}

}