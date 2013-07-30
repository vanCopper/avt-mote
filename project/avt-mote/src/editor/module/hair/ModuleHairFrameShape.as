package editor.module.hair 
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
	public class ModuleHairFrameShape extends Sprite 
	{
		public var data : ModuleHairFrame;
		
		public function ModuleHairFrameShape(_data : ModuleHairFrame) 
		{
			data = _data;
		}
		
		public function dsipose():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
		public function refresh():void
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
						g.drawTriangles(data.vertices , data.indices, data.uvData);
						g.endFill();
					}
				}
				
				
			} else {
				graphics.clear();
			}
		}
	}

}