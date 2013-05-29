package editor.struct 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Texture2D 
	{
		public var rectX : Number;
		public var rectY : Number;
		public var rectW : Number;
		public var rectH : Number;
		
		public var bitmapData : BitmapData;
		public function Texture2D(a_bitmapData : BitmapData
			,a_rectX : Number = NaN
			,a_rectY : Number = NaN
			,a_rectW : Number = NaN
			,a_rectH : Number = NaN
		
		)
		{
			bitmapData = a_bitmapData;
			if (isNaN(a_rectX) || isNaN(a_rectY) || isNaN(a_rectW) || isNaN(a_rectH) )
			{
				rectX = rectY = 0;
				rectW = bitmapData.width;
				rectH = bitmapData.height;
			}
		}
		public function dispose() : void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
		}
		
	}

}