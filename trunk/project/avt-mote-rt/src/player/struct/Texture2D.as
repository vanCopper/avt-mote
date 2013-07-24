package player.struct 
{
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
		
		public static function decodeVertex3D(ba:ByteArray):Texture2D
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
		
		public function genUV(): Vector.<Number> {
			
			if (!uvtData /*&& bitmapData*/)
			{
				var startX : Number;
				var endX : Number;
				
				if (rectW < 0)
				{
					startX = (rectX + rectW) / 512; //TODO
					endX = (rectX) / 512;
				} else 
				{
					startX = (rectX) / 512;
					endX = (rectX + rectW) / 512;
				}
				
				var startY : Number =  (rectY) / 1024;
				var endY : Number =  (rectY + rectH) / 1024;
				
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