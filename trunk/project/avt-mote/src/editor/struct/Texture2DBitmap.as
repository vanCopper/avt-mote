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
		public var texture2D : Texture2D;
		public function Texture2DBitmap(a_texture2D : Texture2D) 
		{
			texture2D = a_texture2D;
			var bd : BitmapData = new BitmapData(a_texture2D.rectW , a_texture2D.rectH);
			bd.copyPixels(
			a_texture2D.bitmapData , 
			new Rectangle(a_texture2D.rectX , a_texture2D.rectY , a_texture2D.rectW , a_texture2D.rectH),
			new Point(0,0)
			);
			super(bd);
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