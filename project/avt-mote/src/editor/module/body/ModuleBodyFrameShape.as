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
		
		public function refreshInterp(interp : Number ):void
		{
			if (data) {
				if (interp == 0)
				{
					refresh(false , true);
				}
				 else if (interp == 1)
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
							
							g.drawTriangles(__v , data.indices, data.uvData);
							g.endFill();
							
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