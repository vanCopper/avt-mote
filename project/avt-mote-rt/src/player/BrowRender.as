package player 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import player.struct.BodyFrameData;
	import player.struct.HairFrameData;
	import player.struct.Matrix4x4;
	import player.struct.BrowFrameData;
	import player.struct.Plane3D;
	import player.struct.Texture2D;
	import player.struct.Vertex3D;
	import player.util.ByteArrayUtil;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class BrowRender
	{
		private var m_frameList : Vector.<BrowFrameData>;
		private var m_centerLX : Number;
		private var m_centerLY : Number;
		private var m_browPlaneL : Plane3D;
		
		private var m_centerRX : Number;
		private var m_centerRY : Number;
		private var m_browPlaneR : Plane3D;
		
		private var m_curFrameL : int;
		private var m_curFrameR : int;
		public var changeFrame : int;
		
		CONFIG::AVT_CONFIGER {
		public function get totalFrames():uint
		{
			return m_frameList.length;
		}
		
		public function set browL(v:int):void
		{
			m_curFrameL = v;
		}
		public function set browR(v:int):void
		{
			m_curFrameR = v;
		}
		
		
		}
		public function BrowRender() 
		{
			
		}

		public function render(g:Graphics  , bitmapData : BitmapData , _matrix : Matrix4x4) : void
		{
			if (!m_frameList || !m_frameList.length)
				return;
				
			var _frameListLength : int = m_frameList.length;		
			
			if (m_curFrameL < _frameListLength)
				m_frameList[m_curFrameL].render(g, bitmapData, _matrix , true);
				
			if (m_curFrameR < _frameListLength)
				m_frameList[m_curFrameR].render(g, bitmapData,_matrix , false);
		}
		
		
		
		public function decode(ba : ByteArray , endPos : uint , a_bitmapData:BitmapData) : void
		{
			while (ba.position < endPos)
			{
				var _flag : int = ba.readByte();

				if (_flag == 1)
				{
					var _frameListLength : int = ByteArrayUtil.readUnsignedByteOrShort(ba);
					m_frameList = new Vector.<BrowFrameData>(_frameListLength , true);
					
					if (_frameListLength)
					{	
						for (var i : int = 0 ; i < _frameListLength; i++ )
						{
							m_frameList[i] = BrowFrameData.decodeBrowFrameData(ba,a_bitmapData);
						}
					}
					else {
						ba.position = endPos;
						return;
					}
				}
				else if (_flag == 2)
				{
					m_centerLX = ba.readFloat();
					m_centerLY = ba.readFloat();
					m_browPlaneL = Plane3D.decodePlane3D(ba);
					
					m_centerRX = ba.readFloat();
					m_centerRY = ba.readFloat();
					m_browPlaneR = Plane3D.decodePlane3D(ba);
				}
			}
			
			for each (var _mfd : BrowFrameData in m_frameList)
			{	
				_mfd.confitZ(m_browPlaneL , m_centerLX , m_centerLY , m_browPlaneR , m_centerRX , m_centerRY);
				_mfd.genUVData(a_bitmapData);
			}
		}
		

		
	}

}