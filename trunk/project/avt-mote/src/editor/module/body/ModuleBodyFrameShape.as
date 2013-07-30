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
	public class ModuleBodyFrameShape extends Shape 
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
		
		public function refresh(breath : Boolean):void
		{
			if (data) {
				graphics.clear();
				
				if (data.uvData && data.indices )
				{
					var g : Graphics = graphics;
					if (data.texture && data.texture.bitmapData)
					{
						g.clear();
						g.beginBitmapFill(data.texture.bitmapData,null,false,true);
						g.drawTriangles(breath ? data.verticesBreath : data.vertices , data.indices, data.uvData);
						g.endFill();
					}
				}
				
				
			} else {
				graphics.clear();
			}
		}
	}

}