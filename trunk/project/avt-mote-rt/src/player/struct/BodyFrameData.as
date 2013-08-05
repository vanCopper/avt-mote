package player.struct 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import player.HairRender;
	import player.util.ByteArrayUtil;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class BodyFrameData
	{
		//public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<Point>;
		public var breathChangeIndex : Vector.<int>;
		public var vertexBreathData : Vector.<Point>;
		
		public var vertexPerLine : int;
		public var totalLine : int;
		public var uvData : Vector.<Number>;
		public var indices : Vector.<int>;
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		public var headLine : int = 0;

		
		public var vertices : Vector.<Number>;
		public var verticesDraw : Vector.<Number>;
		public var centerX : Vector.<Number>;

		//public var verticesOff : Vector.<Number>;
		
		public static function decodeBodyFrameData(ba:ByteArray,a_bitmapData:BitmapData):BodyFrameData
		{
			var ret : BodyFrameData = new BodyFrameData();
			ret.decode(ba,a_bitmapData);
			return ret;
		}
		
		public function decode(ba:ByteArray , a_bitmapData:BitmapData):void
		{
			texture = Texture2D.decodeTexture2D(ba);
			
			offsetX =  ba.readFloat();
			offsetY = ba.readFloat();
			
			vertexPerLine = ba.readByte();
			totalLine = ba.readByte();
			
			var _total : int = vertexPerLine * totalLine;
			vertexData = new Vector.<Point>(_total , true);
		
			for (var i : int = 0 ; i < _total ; i++ )
			{
				var _x : Number = ba.readFloat();
				var _y : Number = ba.readFloat();
				
				vertexData[i] = new Point(_x , _y);
			}
				
			var _changeIndex : int = ba.readUnsignedShort();
			breathChangeIndex = new Vector.<int>(_changeIndex , true);
			
			for (i = 0 ; i < _changeIndex ; i++ )	
			{
				breathChangeIndex[i] = ByteArrayUtil.readUnsignedByteOrShort(ba);
			}
			vertexBreathData = new Vector.<Point>(_changeIndex , true);
			for (i = 0 ; i < _changeIndex ; i++ )
			{
				_x = ba.readFloat();
				_y = ba.readFloat();
				vertexBreathData[i] = new Point(_x + offsetX , _y + offsetY);
			}
			
			
			
			headLine = ba.readUnsignedByte();
			
			genUVData(a_bitmapData);
			indices = new Vector.<int>();
			MeshUtil.genIndicesData(indices , vertexPerLine , totalLine);
			
			
			vertices = new Vector.<Number>();
			
			for each (_pt in vertexData)
			{
				_pt.x += offsetX;
				_pt.y += offsetY;
			}
			
			//for each (_pt in vertexBreathData)
			//{
			//	_pt.x += offsetX;
			//	_pt.y += offsetY;
			//}
			
			for each (var _pt : Point in vertexData)
			{
				vertices.push(_pt.x );
				vertices.push(_pt.y );
			}
			
			centerX = new Vector.<Number>(totalLine , true); 
			
			
			var _centerX : Number;
			
			for (var j : int = 0 ; j < totalLine ; j++ )
			{
				_centerX = 0;
				i = j * vertexPerLine;
				var end : int = vertexPerLine + i;
				
				for ( ; i < end ; i++ )
					_centerX += vertexData[i].x;
				
				centerX[j] = _centerX / vertexPerLine;
			}
		}
		
		private function updatePos( interp : Number , yOff : Number , zOff : Number):void 
		{
			var _breathChangeIndexLength : int = breathChangeIndex.length;
			for (var i : int = 0 ; i < _breathChangeIndexLength ; i++)
			{
				var _index : int = breathChangeIndex[i];
				var _index2 : int = _index << 1;
				vertices[_index2] = vertexData[_index].x + (vertexBreathData[i].x - vertexData[_index].x) * interp ;
				vertices[_index2 + 1] = vertexData[_index].y + (vertexBreathData[i].y - vertexData[_index].y) * interp ;
			}
			
			verticesDraw = vertices.slice();
			
			var j : int = 0;
			var j2 : int = vertexPerLine;
			
			var _xOffCur : Number;
			var _yOffCur : Number;
			var _offNew : Number;
			if (headLine && (yOff || zOff))
			{
				var oi : int;
				var end : int;
				var _centerX : Number;
				const _line : int = headLine;
				var _stepX : Number = 0.25 / _line;
				var _stepY : Number = 8 / _line;
				
				for ( oi = 0 ; oi < _line; oi ++  )
				{
					j = oi * vertexPerLine * 2;
					_centerX = centerX[oi];
					
					var rateNumberX : Number = (_line - oi) * _stepX;
					var rateNumberY  : Number = (1 + oi) * _stepY;
					//trace(rateNumber);
					
					for (i = 0 ; i < vertexPerLine ; i++ , j += 2)
					{	
						var _off : Number = vertices[j] - _centerX;
						_xOffCur = yOff * rateNumberX;
						_yOffCur = zOff * _off / rateNumberY;

						if (_off > 0)
							verticesDraw[j] =  _centerX +  _off *  (1 + _xOffCur);
						else
							verticesDraw[j] =  _centerX +  _off *  (1 - _xOffCur);
							
						verticesDraw[j+1] += _yOffCur;
						//trace(_yOffCur)
					}
				}
			}
			
			

		}
		
		public function updateAndRender(g:Graphics , interp : Number  , yOff : Number , zOff : Number):void
		{
			updatePos(interp , yOff  , zOff);
			g.drawTriangles(verticesDraw, indices, uvData);
			
			///g.endFill();
			//g.beginFill(0)
			//for (var i : int = 0; i < verticesDraw.length ; i += 2  )  g.drawRect(verticesDraw[i] - 3 , verticesDraw[i + 1] - 3 , 6 , 6);
		}
				
		
		private function genUVData(a_bitmapData:BitmapData):void
		{
			uvData = new Vector.<Number>();
			for each (var _ev : Point in vertexData)
			{
				uvData.push ((_ev.x /*+ (s_texture.rectW >> 1)*/ + texture.rectX) / a_bitmapData.width);
				uvData.push ((_ev.y /*+ (s_texture.rectH >> 1)*/ + texture.rectY) / a_bitmapData.height);			
			}
			
		}
		
	}

}