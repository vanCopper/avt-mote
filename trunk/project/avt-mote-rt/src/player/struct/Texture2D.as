package player.struct 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author blueshell
	 */
	public class Texture2D
	{
		public var rectX : int;
		public var rectY : int;
		public var rectW : int;
		public var rectH : int;
		private var  uvtData :  Vector.<Number>;
		
		public static function decodeTexture2D(ba:ByteArray):Texture2D
		{
			var tx : Texture2D = new Texture2D();
			tx.decode(ba);
			return tx;
		}
		
		public function decode(ba:ByteArray):void
		{
			rectX = ba.readShort();
			rectY = ba.readShort();
			rectW = ba.readShort();
			rectH = ba.readShort();
		}
		
		
		public function disposeUV(): void {
			uvtData = null;
		}
		
		public function genUV(a_bitmapData:BitmapData): Vector.<Number> {
			
			if (!uvtData /*&& bitmapData*/)
			{
				var startX : Number;
				var endX : Number;
				
				if (rectW < 0)
				{
					startX = (rectX + rectW) / a_bitmapData.width; //TODO
					endX = (rectX) / a_bitmapData.width;
				} else 
				{
					startX = (rectX) / a_bitmapData.width;
					endX = (rectX + rectW) / a_bitmapData.width;
				}
				
				var startY : Number =  (rectY) / a_bitmapData.height;
				var endY : Number =  (rectY + rectH) / a_bitmapData.height;
				
				uvtData =  Vector.<Number>([startX, startY,
											endX, startY, 
											startX, endY,
											endX, endY]);
			}
			
			return uvtData;
			
			
		}
		
		public function dispose() : void
		{
			uvtData = null;
		}
	}

}