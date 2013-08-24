package player.struct 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import player.HairRender;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class HairFrameData
	{
		//public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<Vertex3D>;
		public var vertexPerLine : int;
		public var totalLine : int;
		public var uvData : Vector.<Number>;
		public var indices : Vector.<int>;
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		
		
		public var weightReciprocal : Number;
		public var ductility : Number;
		public var hardness : Number;
		
		private var m_massVector : Vector.<Vector.<MassPoint>>;
		private var m_avgZ:Number;
		public function get avgZ() : Number { return m_avgZ; }
		
		
		
		
		public static function decodeHairFrameData(ba:ByteArray,a_bitmapData:BitmapData):HairFrameData
		{
			var ret : HairFrameData = new HairFrameData();
			ret.decode(ba,a_bitmapData);
			return ret;
		}
		
		public function decode(ba:ByteArray,a_bitmapData:BitmapData):void
		{
			texture = Texture2D.decodeTexture2D(ba);
			
			
			vertexPerLine = ba.readByte();
			totalLine = ba.readByte();
			
			var _total : int = vertexPerLine * totalLine;
			vertexData = new Vector.<Vertex3D>(_total , true);
			for (var i : int = 0 ; i < _total ; i++ )
			{
				var _x : Number = ba.readFloat();
				var _y : Number = ba.readFloat();
				
				vertexData[i] = new Vertex3D(_x , _y);
			}
				
			for (var vi : int = 0 ; vi < vertexPerLine ; vi++ )	
			{
				vertexData[vi].z = ba.readFloat();
			}
			
			offsetX =  ba.readFloat();
			offsetY = ba.readFloat();
			weightReciprocal = ba.readFloat();
			ductility = ba.readFloat();
			hardness = ba.readFloat();

			genUVData(a_bitmapData);
			indices = new Vector.<int>();
			MeshUtil.genIndicesData(indices , vertexPerLine , totalLine);
			initMass();
				
		}
		
		private function updatePos(_rz : Number):void 
		{
			
			const damp : Number = HairRender.DAMP;
			
			
			var weight_d : Number = weightReciprocal;
			
			const wind : Number = HairRender.WIND;
			//var i : int = 1;
			
			//sinWind += 0.05;
			
			if (m_massVector)
			{
				const windStep : Number = 1 / 4;// (m_massVector[0].length - 1);
				for each (var _hairSpring : Vector.<MassPoint> in m_massVector)
				{
					var _li : int = 0;
					
					for each (var _hmp : MassPoint in _hairSpring)
					{
						if (!_hmp.preMassPoint)
							continue;
						
						//weight_d = m_data.weightReciprocal ; //* pow(decline , i - 1)
						
						var _newOffX : Number = _hmp.pos.x - _hmp.preMassPoint.pos.x;
						var _newOffY : Number = _hmp.pos.y - _hmp.preMassPoint.pos.y;
						
						var _newLength : Number = Math.sqrt(_newOffX * _newOffX + _newOffY * _newOffY);
						var _newRadian : Number = Math.atan2(_newOffY , _newOffX);
						
						var _newOff : Number = - (_newLength -  _hmp.springLength);
						var _newRate : Number = _newOff /_hmp.springLength * ductility;
						
						var _fStringRate : Number = _newRate * weight_d;
						
							
						var fSpring : Point = new Point();
						fSpring.x = Math.cos(_newRadian) * _fStringRate;
						fSpring.y = Math.sin(_newRadian) * _fStringRate;
						
						//trace(hardness);
						
						var fRadian : Point = new Point();
						var _rOff : Number;
						//if (_li == 0)
							_rOff = _rz * 0 + _hmp.radian - _newRadian;
						//else
						//	_rOff = _hmp.radian - _newRadian;
						if (_rOff > Math.PI *2)
							_rOff -= Math.PI * 2;
						else if (_rOff < 0)
							_rOff += Math.PI * 2;
							
						if (_rOff > Math.PI)
							_rOff -= Math.PI * 2;
						
						if (_rOff != 0)
						{
							var _rOffRate : Number = _rOff / (Math.PI * 2) ;
							fRadian.x = Math.cos(_newRadian + Math.PI / 2) * _rOffRate * hardness * weight_d;
							fRadian.y = Math.sin(_newRadian + Math.PI / 2) * _rOffRate * hardness * weight_d;
						}
						
						
						var _newX : Number = _hmp.pos.x + damp * (_hmp.pos.x - _hmp.lastPos.x ) +  fRadian.x +  fSpring.x + wind * (windStep * _li ) * weight_d ; //deltaT^2
						var _newY : Number = _hmp.pos.y + damp * (_hmp.pos.y - _hmp.lastPos.y ) +  fRadian.y +  fSpring.y; //deltaT^2
						_li ++ ;
						
						_hmp.lastPos.x = _hmp.pos.x ;
						_hmp.lastPos.y = _hmp.pos.y ;
						
						_hmp.pos.x = _newX;
						_hmp.pos.y = _newY;
					}
				}
				
			}	
			
			
			
		}
		
		public function updateAndRender(g:Graphics , _rz : Number):void
		{
			updatePos(_rz);
			var __v : Vector.<Number> = new Vector.<Number>();
				
			for (var i : int = 0 ; i < totalLine ; i++ )
			{
				for (var j : int = 0 ; j < vertexPerLine ; j++ )
				{
					__v.push(m_massVector[j][i].pos.x);
					__v.push(m_massVector[j][i].pos.y);
				}
			}
			
			g.drawTriangles(__v, indices, uvData);
		}
				
		public function updateFirstPoint (md : Matrix4x4):void
		{
			var i : int = 0 ;
			for each (var _hairSpring : Vector.<MassPoint> in m_massVector)
			{
				_hairSpring[0].pos.x  = (md.Xx * (vertexData[i].x + offsetX)  + md.Xy * (vertexData[i].y  + offsetY) + md.Xz * vertexData[i].z ) ;
				_hairSpring[0].pos.y  = (md.Yx * (vertexData[i].x + offsetX)  + md.Yy * (vertexData[i].y  + offsetY) + md.Yz * vertexData[i].z ) ;
				
				i++;
			}
			
		}
		
		private function initMass():void
		{
			m_avgZ = 0;
			m_massVector = new Vector.<Vector.<MassPoint>>();
			for (var i : int = 0 ; i < vertexPerLine ; i++ )
			{	
				var _hairSpring : Vector.<MassPoint> = new Vector.<MassPoint>(); 
				m_massVector.push(_hairSpring);
				
				for (var j : int = 0 ; j < totalLine ; j++ )
				{
					var _hmp : MassPoint = new MassPoint();
					var _ev3d : Vertex3D = vertexData[j * vertexPerLine + i];
					_hairSpring.push(_hmp);
					
					_hmp.pos.x = _hmp.lastPos.x = _ev3d.x  + offsetX;
					_hmp.pos.y = _hmp.lastPos.y = _ev3d.y  + offsetY;	
			
					
					
					if (j > 0)
					{	
						_hmp.preMassPoint = _hairSpring[j - 1];
						_hmp.init();
					}	
					else
						m_avgZ += _ev3d.z;
				}
				
				
			}
			
			m_avgZ /= vertexPerLine;
		}
		
		
		private function genUVData(a_bitmapData : BitmapData ):void
		{
			uvData = new Vector.<Number>();
			for each (var _ev : Vertex3D in vertexData)
			{
				uvData.push ((_ev.x /*+ (s_texture.rectW >> 1)*/ + texture.rectX) / a_bitmapData.width);
				uvData.push ((_ev.y /*+ (s_texture.rectH >> 1)*/ + texture.rectY) /  a_bitmapData.height);
			}
			
		}
		
	}

}