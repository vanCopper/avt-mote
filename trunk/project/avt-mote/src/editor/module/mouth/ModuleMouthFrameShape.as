package editor.module.mouth 
{
	import editor.struct.Matrix4x4;
	import editor.struct.Texture2DBitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleMouthFrameShape extends Sprite 
	{
		public var data : ModuleMouthFrame;
		
		public function ModuleMouthFrameShape(_data : ModuleMouthFrame) 
		{
			data = _data;
		}
		
		public function dsipose():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
		public function refresh(_currentMatrix : Matrix4x4):void
		{
			if (data) {
				graphics.clear();
				
				if (data.uvData )
				{
					var g : Graphics = graphics;
					if (data.texture && data.texture.bitmapData)
					{
						g.clear();
						g.beginBitmapFill(data.texture.bitmapData,null,false,true);
						g.drawTriangles(data.getVerticesMatrixed(_currentMatrix) , ModuleMouthFrame.indices, data.uvData);
						g.endFill();
					}
				}
				
				
			} else {
				graphics.clear();
			}
		}
	}

}