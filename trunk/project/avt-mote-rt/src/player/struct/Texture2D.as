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
			rectH = ba.readShort();
			rectW = ba.readShort();
		}
	}

}