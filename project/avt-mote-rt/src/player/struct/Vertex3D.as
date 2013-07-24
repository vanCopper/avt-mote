package player.struct
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Vertex3D 
	{
		public var x : Number;
		public var y : Number;
		public var z : Number;
		
		
		public function Vertex3D(_x : Number = 0,_y : Number = 0,_z : Number = 0) 
		{
			x = _x;
			y = _y;
			z = _z;
		}
		
		public function normalize():void
		{
			var _len : Number = Math.sqrt(x * x + y * y + z * z);
			
			if (_len)
			{
				x /= _len;
				y /= _len;
				z /= _len;
			}
			
			
		}
		
		public static function decodeVertex3D(ba:ByteArray):Vertex3D
		{
			var vtx : Vertex3D = new Vertex3D();
			vtx.decode(ba);
			return vtx;
		}
		
		public function decode(ba:ByteArray):void
		{
			x = ba.readFloat();
			y = ba.readFloat();
			z = ba.readFloat();
			
		}
	}

}