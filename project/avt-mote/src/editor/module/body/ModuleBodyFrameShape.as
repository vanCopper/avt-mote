package editor.module.body 
{
	import editor.struct.Texture2DBitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBodyFrameShape extends Sprite 
	{
		public var data : ModuleBodyFrame;
		
		public function ModuleBodyFrameShape(_data : ModuleBodyFrame) 
		{
			data = _data;
		}
		
		public function dsipose():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
		public function refreshInterp(interp : Number , xValue : Number, yValue : Number, zValue: Number):void
		{
			if (data) {
				if (interp == 0 && xValue == 0 && yValue == 0 && zValue == 0)
				{
					refresh(false , true);
				}
				 else if (interp == 1 && xValue == 0 && yValue == 0 && zValue == 0)
				{
					refresh(true , true);
				}
				else
				{
					graphics.clear();
				
					if (data.uvData && data.indices )
					{
						var g : Graphics = graphics;
						if (data.texture && data.texture.bitmapData)
						{
							g.clear();
							g.beginBitmapFill(data.texture.bitmapData, null, false, true);
							
							var __v : Vector.<Number> = new Vector.<Number>();
							var _vertices : Vector.<Number> = data.vertices;
							var _verticesBreath : Vector.<Number> = data.verticesBreath;
							
							
							for ( var i : int = 0;  i < _vertices.length; i++ )
							{
								__v.push(_vertices[i] + (_verticesBreath[i] - _vertices[i]) * interp);
							}
							
							
							
							var verticesDraw  : Vector.<Number> = __v.slice();
			
							var j : int = 0;
							var j2 : int = data.vertexPerLine;
							
							var _xOffCur : Number;
							var _yOffCur : Number;
							var _offNew : Number;
							var yOff : Number = xValue;
							var zOff : Number = zValue;
							
							
							if (yOff || zOff)
							{
								var oi : int;
								var end : int;
								var _centerX : Number;
								const _line : int = data.headLine;
								var _stepX : Number = 0.25 / _line;
								var _stepY : Number = 8 / _line;
								data.genCenterX();
								for ( oi = 0 ; oi < _line; oi ++  )
								{
									j = oi * data.vertexPerLine * 2;
									_centerX = data.centerX[oi];
									
									var rateNumberX : Number = (_line - oi) * _stepX;
									var rateNumberY  : Number = (1 + oi) * _stepY;
									//trace(rateNumber);
									
									for (i = 0 ; i < data.vertexPerLine ; i++ , j += 2)
									{	
										var _off : Number = __v[j] - _centerX;
										_xOffCur = yOff * rateNumberX;
										_yOffCur = zOff * _off / rateNumberY;
										//trace(_yOffCur , zOff , _off , rateNumberY)
										
										if (_off > 0)
											verticesDraw[j] =  _centerX +  _off *  (1 + _xOffCur);
										else
											verticesDraw[j] =  _centerX +  _off *  (1 - _xOffCur);
											
										verticesDraw[j+1] += _yOffCur;
										
									}
								}
							}
							
							g.drawTriangles(verticesDraw , data.indices, data.uvData);
							g.endFill();
							
							//g.beginFill(0)
							//for ( i  = 0; i < verticesDraw.length ; i += 2  )  g.drawRect(verticesDraw[i] - 3 , verticesDraw[i + 1] - 3 , 6 , 6);
							//g.endFill();
		
						}
					}
				}
				
			} else {
				graphics.clear();
			}
			
		}
		
		public function refresh(breath : Boolean , useOffset : Boolean ):void
		{
			if (data) {
				graphics.clear();
				
				if (data.uvData && data.indices )
				{
					var g : Graphics = graphics;
					if (data.texture && data.texture.bitmapData)
					{
						g.clear();
						g.beginBitmapFill(data.texture.bitmapData, null, false, true);
						
						if (!useOffset)
						{
							var __x : Number = data.offsetX;
							var __y : Number = data.offsetY;
							
							data.offsetX = 0;
							data.offsetY = 0;
							
						}
						
						g.drawTriangles(breath ? data.verticesBreath : data.vertices , data.indices, data.uvData);
						g.endFill();
						
						if (!useOffset)
						{
							data.offsetX = __x;
							data.offsetY = __y;
							
						}
					}
				}
				
				
			} else {
				graphics.clear();
			}
		}
	}

}