package editor.struct 
{
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Matrix4x4 
	{
		public var Xx : Number;
		public var Xy : Number;
		public var Xz : Number;
		public var Xw : Number;
		
		public var Yx : Number;
		public var Yy : Number;
		public var Yz : Number;
		public var Yw : Number;
		
		
		public var Zx : Number;
		public var Zy : Number;
		public var Zz : Number;
		public var Zw : Number;
		
		
		public var Wx : Number;
		public var Wy : Number;
		public var Wz : Number;
		public var Ww : Number;
		
		
		public function identity():void
		{
			Xx = 0;
			Xy = 0;
			Xz = 0;
			Xw = 0;
			
			Yx = 0;
			Yy = 0;
			Yz = 0;
			Yw = 0;
			
			
			Zx = 0;
			Zy = 0;
			Zz = 0;
			Zw = 0;
			
			
			Wx = 0;
			Wy = 0;
			Wz = 0;
			Ww = 0;
		}
		public function Matrix4x4() 
		{
			
		}
		
		public static function rotateArbitraryAxis(pOut : Matrix4x4, axis : Vertex3D, theta : Number) : void
		{
			
			axis.normalize();
			var u : Number = axis.x;
			var v : Number = axis.y;
			var w : Number = axis.z;

			pOut.Xx = Math.cos(theta) + (u * u) * (1 - Math.cos(theta));
			pOut.Xy = u * v * (1 - Math.cos(theta)) + w * Math.sin(theta);
			pOut.Xz = u * w * (1 - Math.cos(theta)) - v * Math.sin(theta);
			pOut.Xw = 0;

			pOut.Yx = u * v * (1 - Math.cos(theta)) - w * Math.sin(theta);
			pOut.Yy = Math.cos(theta) + v * v * (1 - Math.cos(theta));
			pOut.Yz = w * v * (1 - Math.cos(theta)) + u * Math.sin(theta);
			pOut.Yw = 0;

			pOut.Zx = u * w * (1 - Math.cos(theta)) + v * Math.sin(theta);
			pOut.Zy = v * w * (1 - Math.cos(theta)) - u * Math.sin(theta);
			pOut.Zz = Math.cos(theta) + w * w * (1 - Math.cos(theta));
			pOut.Zw = 0;

			pOut.Wx = 0;
			pOut.Wy = 0;
			pOut.Wz = 0;
			pOut.Ww = 1;
}

		
	}

}