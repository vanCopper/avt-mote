package player 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import player.struct.BodyFrameData;
	import player.struct.HairFrameData;
	import player.struct.Matrix4x4;
	import player.struct.Texture2D;
	import player.struct.Vertex3D;
	import player.util.ByteArrayUtil;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class BodyRender
	{
		private var m_frameList : Vector.<BodyFrameData>;
		public static var breath : Number = 0;
		public static var breathOff : Number = 0.02;
		
		public function BodyRender() 
		{
			
		}

		public function render(g:Graphics  , bitmapData : BitmapData , yOff : Number , zOff : Number ) : void
		{
			breath += breathOff;
			if (breath >= 1)
			{
				breath = 1;
				breathOff = -Math.abs(breathOff);
			}
			else if (breath <= 0)
			{
				breath = 0;
				breathOff = Math.abs(breathOff);
			}
			
			g.clear();
			g.beginBitmapFill(bitmapData, null, false, true);
			//g.drawRect(0, 0, 200, 200);
			
			var _frameListLength : int = m_frameList.length;
			for (var i : int = 0 ; i < _frameListLength; i++ )
			{
				m_frameList[i].updateAndRender(g,breath , yOff , zOff);
			}
			g.endFill();
		}
		
		
		
		public function decode(ba : ByteArray , endPos : uint) : void
		{
			while (ba.position < endPos)
			{
				var _flag : int = ba.readByte();

				if (_flag == 1)
				{
					var _frameListLength : int = ByteArrayUtil.readUnsignedByteOrShort(ba);
					m_frameList = new Vector.<BodyFrameData>(_frameListLength , true);
					for (var i : int = 0 ; i < _frameListLength; i++ )
					{
						m_frameList[i] = BodyFrameData.decodeBodyFrameData(ba);
					}
				}
			}
		}
		

		
	}

}