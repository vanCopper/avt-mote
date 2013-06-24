package editor.struct 
{
	import adobe.utils.CustomActions;
	import flash.geom.Vector3D;
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
		
		
		public var Tx : Number;
		public var Ty : Number;
		public var Tz : Number;
		public var Tw : Number;
		
		
		public function identity():void
		{
			Xx = 1;
			Xy = 0;
			Xz = 0;
			Xw = 0;
			
			Yx = 0;
			Yy = 1;
			Yz = 0;
			Yw = 0;
			
			
			Zx = 0;
			Zy = 0;
			Zz = 1;
			Zw = 0;
			
			
			Tx = 0;
			Ty = 0;
			Tz = 0;
			Tw = 1;
		}
		
		public function Matrix4x4() 
		{
			
		}
		
		private static function MULAddMULAddMULAddMUL( x0 : Number , y0  : Number ,  z0  : Number , w0  : Number ,  nx0  : Number ,  nx1  : Number ,  nx2  : Number ,  nx3  : Number ) : Number
		{
			return x0 * nx0 + y0 * nx1 + z0 * nx2 + w0 * nx3;
		}
		
		public function effectPoint3D(_x : Number , _y : Number  , _z : Number , dest : Vertex3D) : void
		{
			dest.x = (Xx * _x + Xy * _y + Xz * _z) ;
			dest.y = (Yx * _x + Yy * _y + Yz * _z) ;
			dest.z = (Zx * _x + Zy * _y + Zz * _z) ;
		}
		
		public static function contact(m1 : Matrix4x4 ,  m2: Matrix4x4 ) : Matrix4x4
		{
			var swapMatrix3D : Matrix4x4 = new Matrix4x4();
			
			swapMatrix3D.Xx = MULAddMULAddMULAddMUL(m1.Xx, m1.Yx, m1.Zx, m1.Tx,m2.Xx,m2.Xy,m2.Xz,m2.Xw);
			swapMatrix3D.Xy = MULAddMULAddMULAddMUL(m1.Xy, m1.Yy, m1.Zy, m1.Ty,m2.Xx,m2.Xy,m2.Xz,m2.Xw);
			swapMatrix3D.Xz = MULAddMULAddMULAddMUL(m1.Xz, m1.Yz, m1.Zz, m1.Tz,m2.Xx,m2.Xy,m2.Xz,m2.Xw);
			swapMatrix3D.Xw = MULAddMULAddMULAddMUL(m1.Xw, m1.Yw, m1.Zw, m1.Tw,m2.Xx,m2.Xy,m2.Xz,m2.Xw);

			swapMatrix3D.Yx = MULAddMULAddMULAddMUL(m1.Xx, m1.Yx, m1.Zx, m1.Tx,m2.Yx,m2.Yy,m2.Yz,m2.Yw);
			swapMatrix3D.Yy = MULAddMULAddMULAddMUL(m1.Xy, m1.Yy, m1.Zy, m1.Ty,m2.Yx,m2.Yy,m2.Yz,m2.Yw);
			swapMatrix3D.Yz = MULAddMULAddMULAddMUL(m1.Xz, m1.Yz, m1.Zz, m1.Tz,m2.Yx,m2.Yy,m2.Yz,m2.Yw);
			swapMatrix3D.Yw = MULAddMULAddMULAddMUL(m1.Xw, m1.Yw, m1.Zw, m1.Tw,m2.Yx,m2.Yy,m2.Yz,m2.Yw);

			swapMatrix3D.Zx = MULAddMULAddMULAddMUL(m1.Xx, m1.Yx, m1.Zx, m1.Tx,m2.Zx,m2.Zy,m2.Zz,m2.Zw);
			swapMatrix3D.Zy = MULAddMULAddMULAddMUL(m1.Xy, m1.Yy, m1.Zy, m1.Ty,m2.Zx,m2.Zy,m2.Zz,m2.Zw);
			swapMatrix3D.Zz = MULAddMULAddMULAddMUL(m1.Xz, m1.Yz, m1.Zz, m1.Tz,m2.Zx,m2.Zy,m2.Zz,m2.Zw);
			swapMatrix3D.Zw = MULAddMULAddMULAddMUL(m1.Xw, m1.Yw, m1.Zw, m1.Tw,m2.Zx,m2.Zy,m2.Zz,m2.Zw);

			swapMatrix3D.Tx = MULAddMULAddMULAddMUL(m1.Xx, m1.Yx, m1.Zx, m1.Tx,m2.Tx,m2.Ty,m2.Tz,m2.Tw);
			swapMatrix3D.Ty = MULAddMULAddMULAddMUL(m1.Xy, m1.Yy, m1.Zy, m1.Ty,m2.Tx,m2.Ty,m2.Tz,m2.Tw);
			swapMatrix3D.Tz = MULAddMULAddMULAddMUL(m1.Xz, m1.Yz, m1.Zz, m1.Tz,m2.Tx,m2.Ty,m2.Tz,m2.Tw);
			swapMatrix3D.Tw = MULAddMULAddMULAddMUL(m1.Xw, m1.Yw, m1.Zw, m1.Tw,m2.Tx,m2.Ty,m2.Tz,m2.Tw);

			return swapMatrix3D;
			
		}
		public function toString():String
		{
			return "Xx = " + Xx + "\n" + 
			"Xy = " + Xy + "\n" + 
			"Xz = " + Xz + "\n" + 
			"Xw = " + Xw + "\n" + 
			
			"Yx = " + Yx + "\n" + 
			"Yy = " + Yy + "\n" + 
			"Yz = " + Yz + "\n" + 
			"Yw = " + Yw + "\n" + 
			
			
			"Zx = " + Zx + "\n" + 
			"Zy = " + Zy + "\n" + 
			"Zz = " + Zz + "\n" + 
			"Zw = " + Zw + "\n" + 
			
			
			"Tx = " + Tx + "\n" + 
			"Ty = " + Ty + "\n" + 
			"Tz = " + Tz + "\n" + 
			"Tw = " + Tw + "\n" ;
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

			pOut.Tx = 0;
			pOut.Ty = 0;
			pOut.Tz = 0;
			pOut.Tw = 1;
		}
		
		
		public function invert():void
		{
			var a : Vector.<Number> = Vector.<Number>([
				Xx 
				,Xy 
				,Xz 
				,Xw 
				
				,Yx 
				,Yy 
				,Yz 
				,Yw 
				
				
				,Zx 
				,Zy 
				,Zz 
				,Zw 
				
				
				,Tx 
				,Ty 
				,Tz 
				,Tw 
			]);
			
			const n : int = 4;
			var _is : Vector.<int> = new Vector.<int>(4, true);
			var _js : Vector.<int> = new Vector.<int>(4, true);
		
			var i : int;
			var j : int;
			var k : int;
			var l : int;
			var u : int;
			var v : int;
			
			
			var  d : Number;
			var  p : Number;
			
			for (k=0; k <= n-1; k++)
			{ 
				d=0.0;
				for (i=k; i <= n-1; i++)
				for (j=k; j <= n-1; j++)
				{ 
					l= i * n +j; p= Math.abs(a[l]);
					if (p>d) { d=p; _is[k]=i; _js[k]=j;}
				}
				if (d+1.0==1.0)
				{ 
					//free(_is); free(js); printf("err**not inv\n");
					ASSERT(false , "err**not inv");
					return/*(0)*/;
				}
				if (_is[k]!=k)
					for (j = 0; j<= n-1; j++)
					{ 
						u=k* n+j; v=_is[k]*n+j;
						p=a[u]; a[u]=a[v]; a[v]=p;
					}

				if (_js[k]!=k)
					for (i=0; i<=n-1; i++)
					{
						u=i*n+k; v=i*n+_js[k];
						p=a[u]; a[u]=a[v]; a[v]=p;
					}

				l=k*n+k;
				a[l]=1.0/a[l];
				for (j=0; j<=n-1; j++)
					if (j!=k)
					{ u=k*n+j; a[u]=a[u]*a[l];}
					for (i=0; i<=n-1; i++)
						if (i!=k)
							for (j=0; j<=n-1; j++)
								if (j!=k)
								{ 
									u=i*n+j;
									a[u]=a[u]-a[i*n+k]*a[k*n+j];
								}
					for (i=0; i<=n-1; i++)
						if (i!=k)
						{ u=i*n+k; a[u]=-a[u]*a[l];}
			}

			for (k=n-1; k>=0; k--)
			{ 
				if (_js[k]!=k)
				for (j=0; j<=n-1; j++)
				{ 
					u=k*n+j; v=_js[k]*n+j;
					p=a[u]; a[u]=a[v]; a[v]=p;
				}
				if (_is[k]!=k)
					for (i=0; i<=n-1; i++)
					{ 
						u=i*n+k; v=i*n+_is[k];
						p=a[u]; a[u]=a[v]; a[v]=p;
					}
			}
			
			
			Xx = a[0];
			Xy = a[1];
			Xz = a[2];
			Xw = a[3];
				
			Yx = a[4];
			Yy = a[5];
			Yz = a[6];
			Yw = a[7];
				
				
			Zx = a[8];
			Zy = a[9];
			Zz = a[10];
			Zw = a[11];
				
				
			Tx = a[12];
			Ty = a[13];
			Tz = a[14];
			Tw = a[15];
		}

			
			
	}

}