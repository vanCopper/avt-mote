package editor.module.brow 
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
	public class ModuleBrowFrameShape extends Sprite 
	{
		public var data : ModuleBrowFrame;
		
		public function ModuleBrowFrameShape(_data : ModuleBrowFrame) 
		{
			data = _data;
		}
		
		public function dsipose():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
		public function refresh(_currentMatrix : Matrix4x4 , _left : Boolean):void
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
						g.drawTriangles(data.getVerticesMatrixed(_currentMatrix ,_left) , ModuleBrowFrame.indices, data.uvData);
						g.endFill();
					}
				}
				
				
			} else {
				graphics.clear();
			}
		}
	}

}