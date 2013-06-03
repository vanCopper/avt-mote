package editor.struct 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Texture2DBitmap extends Bitmap 
	{
		public var _texture2D : Texture2D;
		public function set texture2D (a_texture2D : Texture2D) : void
		{
			texture2D = null;
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			
			_texture2D = a_texture2D;
			
			var bd : BitmapData = new BitmapData(Math.abs(a_texture2D.rectW) , a_texture2D.rectH);
			
			if (a_texture2D.rectW >= 0)
			{
				bd.copyPixels(
				a_texture2D.bitmapData , 
					new Rectangle(a_texture2D.rectX , a_texture2D.rectY , a_texture2D.rectW , a_texture2D.rectH),
					new Point(0,0)
				);	
			} else {
				bd.lock();
				var hy : int = 0;
				var wx : int = 0;
				
				for (var hi : int = a_texture2D.rectY ; hi < a_texture2D.rectY  +  a_texture2D.rectH ; hi++ , hy++)
				{
					var wi : int = a_texture2D.rectX;
					wx = 0;
					for ( ; wi > a_texture2D.rectX + a_texture2D.rectW ; wi-- , wx++)
					{
						bd.setPixel32(wx , hy , a_texture2D.bitmapData.getPixel32(wi - 1 , hi));
					}
				}
				
				bd.unlock();
				
			}
			
			bitmapData = bd;
		}
		
		public function Texture2DBitmap(a_texture2D : Texture2D) 
		{
			super(null);
			texture2D = a_texture2D;
			
			
			
		}
		
		public function dispose():void
		{
			texture2D = null;
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
		}
	}

}