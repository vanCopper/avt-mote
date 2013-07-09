package editor.struct 
{
	
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
		public function fromXMLString(s:String):void
		{
			var arr : Array = s.split(":")
			a = Number(arr[0]);
			b = Number(arr[1]);
			c = Number(arr[2]);
			d = Number(arr[3]);
		}
		
		public function toXMLString():String
		{
			return a + ":" + b + ":" + c + ":" + d;
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
		
		public function gen3Point(p0 : Vertex3D , p1 : Vertex3D , p2 : Vertex3D) : void
		{
			var v1 : Vertex3D = new Vertex3D(p1.x - p0.x , p1.y - p0.y , p1.z - p0.z );
			var v2 : Vertex3D = new Vertex3D(p2.x - p0.x , p2.y - p0.y , p2.z - p0.z );
			
			//import flash.geom.Vector3D;
			//var _v1 : Vector3D = new Vector3D(p1.x - p0.x , p1.y - p0.y , p1.z - p0.z );
			//var _v2 : Vector3D = new Vector3D(p2.x - p0.x , p2.y - p0.y , p2.z - p0.z );
			//var _cross : Vector3D = _v1.crossProduct(_v2);
			
			
			var cross : Vertex3D = new Vertex3D((v1.y * v2.z - v1.z * v2.y), (v1.z * v2.x - v1.x * v2.z), (v1.x * v2.y - v1.y * v2.x));
			
			
			
		
			a = cross.x;
			b = cross.y;
			c = cross.z;
			d = -(cross.x * p0.x + cross.y * p0.y + cross.z * p0.z);
			
			//trace(p0.x * a + p0.y * b + p0.z * c + d);
			//trace(p1.x * a + p1.y * b + p1.z * c + d);
			//trace(p2.x * a + p2.y * b + p2.z * c + d);
			
			
			//return,[a,b,c,d]
		}
		
	}

}