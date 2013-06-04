package editor.module.eye 
{
	import editor.struct.Texture2DBitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrameSprite extends Sprite 
	{
		public var data : ModuleEyeFrame;
		
		public var eyeWhite : Texture2DBitmap;
		public var eyeBall : Texture2DBitmap;
		public var eyeWBContainer : Sprite;
		public var eyeWBMask : Shape;
		public var eyeLip : Texture2DBitmap;
		
		public function ModuleEyeFrameSprite(_data : ModuleEyeFrame) 
		{
			data = _data;
			
			eyeWBContainer = new Sprite();
			eyeWhite = new Texture2DBitmap(null);
			eyeBall = new Texture2DBitmap(null);
			eyeWBMask = new Shape;
			eyeLip = new Texture2DBitmap(null);
			
			
			eyeWBContainer.addChild(eyeWhite);
			eyeWBContainer.addChild(eyeBall);
			
			addChild(eyeWBContainer);
			addChild(eyeWBMask);
			addChild(eyeLip);
			
			
		}
		
		public function fitPos(w:Number , h:Number):void
		{
			if (width && height)
			{
				width = Math.min(w, width);
				
				scaleY = scaleX;
				var rect : Rectangle = this.getRect(this);
				
				x = w / 2 - (rect.right + rect.left) / 2;
				y = h / 2 - (rect.bottom + rect.top) / 2;
				
				
			}
		}
		
		public function refresh():void
		{
			if (data) {
				if (eyeWhite){ eyeWhite.texture2D = data.eyeWhite ; }
				if (eyeBall) { 
					eyeBall.texture2D = data.eyeBall ; 
					eyeBall.x = data.eyeBallX;
					eyeBall.y = data.eyeBallY;
					
				}
				if (eyeLip)  {
					eyeLip.texture2D = data.eyeLip ; 
					eyeLip.x = data.eyeLipX;
					eyeLip.y = data.eyeLipY;
				}
			}
			
		}
		
		public function dispose():void 
		{
			if (eyeWhite) { eyeWhite.dispose(); eyeWhite = null; }
			if (eyeBall) { eyeBall.dispose(); eyeBall = null; }
			if (eyeLip) { eyeLip.dispose(); eyeLip = null; }
			

		}
		
		
	}

}