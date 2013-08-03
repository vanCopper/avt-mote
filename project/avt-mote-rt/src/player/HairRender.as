package player 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
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
	public class HairRender
	{
		private var m_frameList : Vector.<HairFrameData>;
		private var m_matrix : Matrix4x4;
		private var m_changed : Boolean = true;
		private var m_underHairlength : int;
		
		public static var DAMP : Number = 0.35;
		public static var WIND : Number = 0;
		
		public function HairRender() 
		{
			
		}

		public function render(g:Graphics  , bitmapData : BitmapData , md : Matrix4x4 , underHead : Boolean):void
		{
			if (!m_changed && md)
			{
				m_changed = !md.isEqual(m_matrix);
			}
			
			if (m_changed)
			{
				m_matrix = md;
				m_changed = false;
			
				for each (var _hfd : HairFrameData in m_frameList)
					_hfd.updateFirstPoint(md);
			}
			
			if (underHead)
			{
				var i : int;
				g.clear();
				g.beginBitmapFill(bitmapData,null,false,true);
				for (i = 0 ; i < m_underHairlength; i++ )
				{
					m_frameList[i].updateAndRender(g);
					
				}
				g.endFill();
			}
			else {
				g.clear();
				g.beginBitmapFill(bitmapData,null,false,true);
				var _frameListLength : int = m_frameList.length;
				for (i = m_underHairlength ; i < _frameListLength; i++ )
				{
					m_frameList[i].updateAndRender(g);
				}
				g.endFill();
			}
		}
		
		
		
		public function decode(ba : ByteArray , endPos : uint ,a_bitmapData:BitmapData) : void
		{
			while (ba.position < endPos)
			{
				var _flag : int = ba.readByte();

				if (_flag == 1)
				{
					var _frameListLength : int = ByteArrayUtil.readUnsignedByteOrShort(ba);
					m_frameList = new Vector.<HairFrameData>(_frameListLength , true);
					for (var i : int = 0 ; i < _frameListLength; i++ )
					{
						m_frameList[i] = HairFrameData.decodeHairFrameData(ba,a_bitmapData);
					}
					
					m_frameList.sort(sortZ);
					
					for ( i = 0 ; i < _frameListLength; i++ )
					{
						//trace(i , m_frameList[i].avgZ);
						if (m_frameList[i].avgZ < 0)
						{
							m_underHairlength = i + 1;
						}
					}
				}
			}
		}
		
		
		private function sortZ(a:*, b:*):Number
		{
			var az : Number = a.avgZ;
			var bz : Number = b.avgZ;
			
			if (az > bz)
				return 1;
			else if (az < bz)
				return -1;
			else
				return 0;
				
		}
		
	}

}