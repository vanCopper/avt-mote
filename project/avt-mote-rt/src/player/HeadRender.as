package player 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import player.struct.Matrix4x4;
	import player.struct.Texture2D;
	import player.struct.Vertex3D;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class HeadRender
	{
		private var m_rotorX : Number;
		private var m_rotorY : Number;
		private var m_rotorR : Number;
		
		private var m_approximationMode : Boolean = true;
		private var m_absRX : Number;
		private var m_absRY : Number;
		private var m_absRZ : Number;
		private var m_xRotor : Vertex3D;
		private var m_yRotor : Vertex3D;
		private var m_zRotor : Vertex3D;
		private var m_texture:Texture2D;
		private var m_pointPerLine : uint;
		private var m_totalLine : uint;
		
		private var m_vertexData : Vector.<Vertex3D>;
		private var m_uvData : Vector.<Number> ;
		private var m_indices : Vector.<int>;
		private var m_changed : Boolean;
		private var m_vertices : Vector.<Number>;
		private var m_matrix : Matrix4x4;
		
		public function HeadRender() 
		{
			
		}
		
		public function render(g:Graphics  , bitmapData : BitmapData , _matrix : Matrix4x4):void
		{
			
			
			if (!m_vertices)
			{
				m_vertices = new Vector.<Number>();
				m_changed = true;
			}
			
			if (!m_changed && _matrix)
			{
				m_changed = !_matrix.isEqual(m_matrix);
			}
			
			if (m_changed)
			{
				g.clear();
				g.beginBitmapFill(bitmapData, null, false, true);
			
				m_matrix = _matrix;
				m_changed = false;
				var ii : int = 0;
				
				if (m_matrix)
				{
					for ( var i : int = 0; i <  m_vertexData.length ; i++ )
					{
						var ev : Vertex3D = m_vertexData[i];
						m_vertices[ii++] = (m_matrix.Xx * ev.x + m_matrix.Xy * ev.y + m_matrix.Xz * ev.z) ;
						m_vertices[ii++] = (m_matrix.Yx * ev.x + m_matrix.Yy * ev.y + m_matrix.Yz * ev.z) ;
				
					}
				} else {
					for ( i = 0; i <  m_vertexData.length ; i++ )
					{
						ev = m_vertexData[i];
						m_vertices[ii++] =  ev.x ;
						m_vertices[ii++] =  ev.y ;
					}
				}
				g.drawTriangles(m_vertices , m_indices, m_uvData  );
			} 
			//else
			//	trace("skip a head render")
			
			
		}
		
		public function getMatrix(xValue : Number, yValue : Number, zValue: Number) : Matrix4x4
		{
			var md : Matrix4x4;
			var mX : Matrix4x4 = new Matrix4x4();
			var mY : Matrix4x4 = new Matrix4x4();
			var mZ : Matrix4x4 = new Matrix4x4();
			var mXY : Matrix4x4;
			
			var v : Vertex3D = new Vertex3D();
			var vX : Vertex3D = new Vertex3D();
			var vY : Vertex3D = new Vertex3D();
			var vZ : Vertex3D = new Vertex3D();
				
			if (m_approximationMode)
			{
				v = new Vertex3D();
				v.y = Math.sin(m_rotorR);
				v.x = Math.cos(m_rotorR);
				
				vX.x = v.x;
				vX.y = v.y;
			
				Matrix4x4.rotateArbitraryAxis(mX ,  vX  , xValue);
				
				mX.effectPoint3D(v.y , -v.x , 0 , vY);
				Matrix4x4.rotateArbitraryAxis(mY , vY  , yValue);
				
				mXY = Matrix4x4.contact(mX , mY); 
				mXY.effectPoint3D(0 , 0 , 1 ,vZ);
				Matrix4x4.rotateArbitraryAxis(mZ , vZ  , -zValue);
				
				
				md = Matrix4x4.contact(mXY , mZ);
			}
			else {
				vX = m_yRotor;
				Matrix4x4.rotateArbitraryAxis(mX , vX  , xValue);
				
				mX.effectPoint3D(m_xRotor.x , m_xRotor.y , m_xRotor.z , vY);
				Matrix4x4.rotateArbitraryAxis(mY , vY  , yValue);
				mXY = Matrix4x4.contact(mX , mY); 
				
				mXY.effectPoint3D(m_zRotor.x , m_zRotor.y ,m_zRotor.z , vZ);
				Matrix4x4.rotateArbitraryAxis(mZ , vZ  , zValue);
				md = Matrix4x4.contact(mXY , mZ);
				
			}
			
			return md;
		}
		
		public function decode(ba : ByteArray , endPos : uint) : void
		{
			while (ba.position < endPos)
			{
				var _flag : int = ba.readByte();
				
				if (_flag == 1)
				{
					m_rotorX = ba.readFloat();
					m_rotorY = ba.readFloat();
					m_rotorR = ba.readFloat();
				}
				else if (_flag == 2)
				{
					m_approximationMode = false;
					m_absRX = ba.readFloat();
					m_absRY = ba.readFloat();
					m_absRZ = ba.readFloat();
				
					m_xRotor = Vertex3D.decodeVertex3D(ba);
					m_yRotor = Vertex3D.decodeVertex3D(ba);
					m_zRotor = Vertex3D.decodeVertex3D(ba);
				}
				else if (_flag == 3)
				{
					m_texture = Texture2D.decodeTexture2D(ba);
				}
				else if (_flag == 4)
				{
					m_pointPerLine = ba.readUnsignedShort();
					m_totalLine = ba.readUnsignedShort();
					
					var _total : int = m_pointPerLine * m_totalLine;
					var _vertexData : Vector.<Vertex3D> = new Vector.<Vertex3D>(_total , true);
					for (var i : int = 0 ; i < _total ; i++ )
					{
						_vertexData[i] = (Vertex3D.decodeVertex3D(ba));
					}
					
					
					m_vertexData = new Vector.<Vertex3D>();
					m_uvData = new Vector.<Number>();
					m_indices = new Vector.<int>();
					
					for each (var _ev : Vertex3D in _vertexData)
					{
						var _evR : Vertex3D = new Vertex3D();
						_evR.x = _ev.x - m_rotorX;
						_evR.y = _ev.y - m_rotorY;
						_evR.z = _ev.z;
						
						m_vertexData.push(_evR);
					}
					
					var _halfW : int = (m_texture.rectW >> 1);
					var _halfH : int = (m_texture.rectH >> 1);
					
					
					for each (_ev in _vertexData)
					{
						m_uvData.push ((_ev.x + _halfW + m_texture.rectX) / 512);
						m_uvData.push ((_ev.y + _halfH + m_texture.rectY) / 1024); //temp TODO
					}
					
					MeshUtil.genIndicesData(m_indices , m_pointPerLine , m_totalLine );
				}	
			}
		}
	}

}