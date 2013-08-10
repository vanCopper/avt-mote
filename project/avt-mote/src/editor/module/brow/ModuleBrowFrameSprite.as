package editor.module.brow 
{
	import editor.struct.Texture2DBitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBrowFrameSprite extends Sprite 
	{
		public var data : ModuleBrowFrame;
		public var view : Texture2DBitmap;
		
		public function ModuleBrowFrameSprite(_data : ModuleBrowFrame) 
		{
			data = _data;
			view = new Texture2DBitmap(null);
			addChild(view);
		}
		
		
		public function fitPos(w:Number , h:Number , minX : Number = 0 , minY : Number = 0):void
		{
			if (width && height)
			{
				scaleY = scaleX = 1;
				
				width = Math.min(w, width);
				height = Math.min(h, height);
				
				scaleY = scaleX = Math.min(scaleX , scaleY);
				
				var rect : Rectangle = this.getRect(this);
				
				x = minX + w / 2 - (rect.right + rect.left)*scaleX / 2;
				y = minY + h / 2 - (rect.bottom + rect.top)*scaleY / 2;
				
				
			}
		}
		
		public function dsipose():void
		{
			view.texture2D = null;
			if (parent)
				parent.removeChild(this);
		}
		
		public function refresh():void
		{
			if (data) {
				view.texture2D = data.texture;
			} else {
				view.texture2D = null;
			}
		}
	}

}