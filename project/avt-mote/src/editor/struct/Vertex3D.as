package editor.struct
{
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Vertex3D 
	{
		public var x : Number;
		public var y : Number;
		public var z : Number;
		
		public function clone() :  Vertex3D
		{
			return new Vertex3D(x , y , z);
		}
		
		
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
		
	}

}