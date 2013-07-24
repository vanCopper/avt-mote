package player.struct 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Plane3D 
	{
		public var a : Number;
		public var b : Number;
		public var c : Number;
		public var d : Number;
		
		public function Plane3D() 
		{
			
		}
		
		public function reset():void
		{
			a = b = c = d = 0;
		}
		public function confitZ(x:Number,y:Number) : Number
		{
			if (c == 0)
				return 0;
			else {
				return (x * a + y * b + d) / -c;
			}
		}
		
		public static function decodePlane3D(ba:ByteArray):Plane3D
		{
			var ret : Plane3D = new Plane3D();
			ret.decode(ba);
			return ret;
		}
		
		public function decode(ba:ByteArray):void
		{
			a = ba.readFloat();
			b = ba.readFloat();
			c = ba.readFloat();
			d = ba.readFloat();
			
		}
		
	}

}