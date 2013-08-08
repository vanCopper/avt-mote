package player 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import player.struct.BodyFrameData;
	import player.struct.HairFrameData;
	import player.struct.Matrix4x4;
	import player.struct.MouthFrameData;
	import player.struct.Plane3D;
	import player.struct.Texture2D;
	import player.struct.Vertex3D;
	import player.util.ByteArrayUtil;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class MouthRender
	{
		private var m_frameList : Vector.<MouthFrameData>;
		private var m_centerX : Number;
		private var m_centerY : Number;
		private var m_mouthPlane : Plane3D;
		
		private var m_curFrame : int;
		public var changeFrame : int;
		
		public function MouthRender() 
		{
			
		}

		public function render(g:Graphics  , bitmapData : BitmapData , _matrix : Matrix4x4) : void
		{
			var _frameListLength : int = m_frameList.length;
			if (changeFrame)
			{
				changeFrame--;
				
				
				if (changeFrame == 0)
					m_curFrame = 0;
				else if (changeFrame >= 10 && changeFrame < 17)
					m_curFrame = 0;
				else {
					if (changeFrame & 1)
					{
						if (m_curFrame == 2)
							m_curFrame = 3;
						else 
							m_curFrame = Math.random() < 0.2 ? 4 : 2;
					}
					
				}
			}
						
			
			if (m_curFrame < _frameListLength)
				m_frameList[m_curFrame].render(g, bitmapData,_matrix);
		}
		
		
		
		public function decode(ba : ByteArray , endPos : uint , a_bitmapData:BitmapData) : void
		{
			while (ba.position < endPos)
			{
				var _flag : int = ba.readByte();

				if (_flag == 1)
				{
					var _frameListLength : int = ByteArrayUtil.readUnsignedByteOrShort(ba);
					m_frameList = new Vector.<MouthFrameData>(_frameListLength , true);
					for (var i : int = 0 ; i < _frameListLength; i++ )
					{
						m_frameList[i] = MouthFrameData.decodeMouthFrameData(ba,a_bitmapData);
					}
				}
				else if (_flag == 2)
				{
					m_centerX = ba.readFloat();
					m_centerY = ba.readFloat();
					m_mouthPlane = Plane3D.decodePlane3D(ba);
					
				}
			}
			
			for each (var _mfd : MouthFrameData in m_frameList)
			{	
				_mfd.confitZ(m_mouthPlane , m_centerX , m_centerY);
				_mfd.genUVData(a_bitmapData);
			}
		}
		

		
	}

}