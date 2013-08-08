package editor.util 
{
	import editor.struct.Plane3D;
	import editor.struct.Vertex3D;
	/**
	 * ...
	 * @author blueshell
	 */
	public class ZFitter
	{
		
		public static function fitZ3Point(v : Vertex3D , _v : Vector.<Vertex3D>):void
		{
			var arr : Array = [];
			for each (var headV : Vertex3D in _v)
			{
				var _x : Number = headV.x - v.x;
				var _y : Number = headV.y - v.y;
				
				arr.push( { len2:(_x * _x + _y * _y) , vtx : headV } );
			}
			
			arr.sort(sortOnVLength);  
			
			var _p : Plane3D = new Plane3D();
			 _p.gen3Point(arr[0].vtx , arr[1].vtx , arr[2].vtx );
			
			/* trace(
				"nearest3 pt" + arr[0].vtx
				+ arr[1].vtx
				+ arr[2].vtx
			 );*/
			 
			v.z = _p.confitZ(v.x, v.y);
			
			if (Math.abs(v.z - arr[0].vtx.z) / Math.abs(arr[0].vtx.z - arr[1].vtx.z) > 3)
			{
				 trace("regenZ");
				 _p.gen3Point(arr[0].vtx , arr[1].vtx , arr[3].vtx );
				 v.z = _p.confitZ(v.x, v.y);
			}
			
			if (Math.abs(v.z - arr[0].vtx.z) / Math.abs(arr[0].vtx.z - arr[1].vtx.z) > 3)
			{
				trace("regenZ2");
				
				var dt0 : Number = Math.sqrt((v.x - arr[0].vtx.x) * (v.x - arr[0].vtx.x) + (v.y - arr[0].vtx.y) * (v.y - arr[0].vtx.y));
				var dt1 : Number = Math.sqrt((v.x - arr[1].vtx.x) * (v.x - arr[1].vtx.x) + (v.y - arr[1].vtx.y) * (v.y - arr[1].vtx.y));
				var dt2 : Number = Math.sqrt((v.x - arr[2].vtx.x) * (v.x - arr[2].vtx.x) + (v.y - arr[2].vtx.y) * (v.y - arr[2].vtx.y));
			
				var _total : Number = dt0 + dt1 + dt2;
				
				v.z = (arr[0].vtx.z *  (_total - dt0) +  arr[1].vtx.z *  (_total - dt1) +  arr[2].vtx.z *  (_total - dt2)) / (_total * 2);
			}
			
			//trace("confitZ" + v);
		}
		
		private static function sortOnVLength(a:Object, b:Object):Number {  
			if (a.len2 > b.len2)
				return 1;
			else if (a.len2 < b.len2)
				return -1;
			else
				return 0;
		}
	}

}