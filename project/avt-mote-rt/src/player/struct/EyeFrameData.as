package player.struct 
{
	import flash.utils.ByteArray;
	import player.util.ByteArrayUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EyeFrameData 
	{
		
		public var eyeMaskData : Vector.<Vertex3D>;
		public var eyeWhite : Texture2D;
		
		
		public var eyeBall : Texture2D;
		public var eyeBallX : Number;
		public var eyeBallY : Number;
		public var eyeBallRawX : Number;
		public var eyeBallRawY : Number;
		
		public var eyeLip : Texture2D;
		public var eyeLipX : Number;
		public var eyeLipY : Number;
		
		public var eyeVertex3D :  Vector.<Vertex3D>;
		public var eyeVertex3DUV :  Vector.<Number>;
		private var eyeBallStart : int;
		public var vertexLength : int;
		
		public function EyeFrameData() 
		{
			
		}
		
		public function dispose():void
		{
			eyeMaskData = null;
		}
		public static function decodeEyeFrameData(ba:ByteArray):EyeFrameData
		{
			var ret : EyeFrameData = new EyeFrameData();
			ret.decode(ba);
			return ret;
		}
		
		public function decode(ba:ByteArray):void
		{
			var _flag : int = ba.readByte();
			
			if (_flag & 1)	{
				eyeWhite = Texture2D.decodeVertex3D(ba);
				vertexLength+=8;
			}
			if (_flag & 2)	{ 
				eyeBallRawX = eyeBallX = ba.readFloat();
				eyeBallRawY = eyeBallY = ba.readFloat();
				eyeBall = Texture2D.decodeVertex3D(ba);
				vertexLength += 8;
				
			}
			if (_flag & 4) 	{
				eyeLipX = ba.readFloat();
				eyeLipY = ba.readFloat();
				
				eyeLip = Texture2D.decodeVertex3D(ba);
			}
			
			if (_flag & 8)
			{
				var _eyeMaskData_length : int = ByteArrayUtil.readUnsignedByteOrShort(ba);
				eyeMaskData = new Vector.<Vertex3D>(_eyeMaskData_length , true);
				for (var i : int = 0 ; i < _eyeMaskData_length ; i++ )	
				{
					var _v : Vertex3D = new Vertex3D();
					_v.x = ba.readFloat();
					_v.y = ba.readFloat();
					eyeMaskData[i] = _v;
				}
			}
		}
		
		public function updateEyeBallVertex3D(m:Matrix4x4 , p:Plane3D  , _scale : Number  , _xOff : Number  , _yOff : Number ):void
		{
			var v : Vector.<Vertex3D>;
			v = genEyeBallVertex3D();
			if (v)
			{
				for (var i : int = 0 ; i < v.length ; i++ )
				{	
					eyeVertex3D[eyeBallStart + i] = v[i];
					dealVertex3D(eyeVertex3D[eyeBallStart + i] , _scale , p , m , _xOff , _yOff);
				}
			}
		}
		
		public function init(m:Matrix4x4 , p:Plane3D  , _scale : Number  , _xOff : Number  , _yOff : Number ):void
		{
			if (!eyeVertex3D)
			{
				eyeVertex3D = new Vector.<Vertex3D>();
				var v : Vector.<Vertex3D>;
				v = genEyeWhiteVertex3D();
				var v3d : Vertex3D;
				if (v) 
				{	
					for each ( v3d in v)	
						eyeVertex3D.push(v3d);
				}
				v = genEyeBallVertex3D();
				if (v) 
				{	
					eyeBallStart = eyeVertex3D.length;
					for each ( v3d in v)	
						eyeVertex3D.push(v3d);
				}
				
				v = genEyeLipVertex3D();
				if (v) 
				{	
					for each ( v3d in v)	
						eyeVertex3D.push(v3d);
				}
				
				if (eyeVertex3D.length)
				{
					eyeVertex3DUV = new Vector.<Number>();
					var uv : Vector.<Number>;
					if (eyeWhite) 
					{	
						uv =  eyeWhite.genUV();
						for each (var n : Number in uv)
							eyeVertex3DUV.push(n);
						eyeBall.disposeUV();
					}
					
					if (eyeBall) 
					{	
						uv =  eyeBall.genUV();
						for each (n in uv)
							eyeVertex3DUV.push(n);
						eyeBall.disposeUV();
					}
					
					if (eyeLip) 
					{	
						//uv =  
						eyeLip.genUV();
						//for each (n in uv)
						//	eyeVertex3DUV.push(n);
					}
				}
				
				
				v = eyeMaskData;
				if (v)  
					for each ( v3d in v) eyeVertex3D.push(v3d);
					
				dealVertex3DArray(eyeVertex3D , _scale , p , m , _xOff , _yOff);
			}
		}
		
		public static function dealVertex3D( vtx : Vertex3D , _scale : Number , plane : Plane3D , md : Matrix4x4 , _xOff : Number  , _yOff : Number ) : void
		{
			vtx.x *= _scale;
			vtx.y *= _scale;
			vtx.x += _xOff;
			vtx.y += _yOff;
			
			vtx.z = plane.confitZ(vtx.x , vtx.y)
			
			md.effectPoint3D(vtx.x, vtx.y , vtx.z , vtx);
		}
		private function dealVertex3DArray( v : Vector.<Vertex3D> , _scale : Number , plane : Plane3D , md : Matrix4x4 , _xOff : Number  , _yOff : Number ) : void
		{
			for each(var vtx : Vertex3D in v )
			{
				dealVertex3D(vtx , _scale , plane , md , _xOff , _yOff);
				
			}
		}
		
		
		private function genEyeWhiteVertex3D():Vector.<Vertex3D>
		{
			if (!eyeWhite)
				return null;
				
			var t : Texture2D = eyeWhite;
			
			if (t.rectW < 0)
				return Vector.<Vertex3D>([
					new Vertex3D(-t.rectW , 0, 0)
					,new Vertex3D(0 , 0, 0)
					,new Vertex3D(-t.rectW , t.rectH, 0)
					,new Vertex3D(0 , 0 + t.rectH, 0)
			]);
			else 
			return Vector.<Vertex3D>([
				new Vertex3D(0 , 0, 0)
				,new Vertex3D(+ t.rectW , 0, 0)
				,new Vertex3D(0 , t.rectH, 0)
				,new Vertex3D(+ t.rectW , 0 + t.rectH, 0)
			]);
		}
		
		private function genEyeBallVertex3D():Vector.<Vertex3D>
		{
			if (!eyeBall)
				return null;
				
			var t : Texture2D = eyeBall;
			
			if (t.rectW < 0)
			return Vector.<Vertex3D>([
				 new Vertex3D(eyeBallX -t.rectW , eyeBallY + 0, 0)
				,new Vertex3D(eyeBallX  , eyeBallY + 0, 0)
				,new Vertex3D(eyeBallX -t.rectW , 0 + eyeBallY + t.rectH, 0)
				,new Vertex3D(eyeBallX , eyeBallY + 0 + t.rectH, 0)
			]);
			else
			return Vector.<Vertex3D>([
				 new Vertex3D(eyeBallX  , eyeBallY + 0, 0)
				,new Vertex3D(eyeBallX + t.rectW , eyeBallY + 0, 0)
				,new Vertex3D(eyeBallX , 0 + eyeBallY + t.rectH, 0)
				,new Vertex3D(eyeBallX + t.rectW , eyeBallY + 0 + t.rectH, 0)
			]);
		}
		private function genEyeLipVertex3D():Vector.<Vertex3D>
		{
			if (!eyeLip)
				return null;
				
			var t : Texture2D = eyeLip;
			if (t.rectW < 0)
			return Vector.<Vertex3D>([
				new Vertex3D(eyeLipX -t.rectW , eyeLipY + 0, 0)
				,new Vertex3D(eyeLipX , eyeLipY + 0, 0)
				,new Vertex3D(eyeLipX -t.rectW , 0 + eyeLipY + t.rectH, 0)
				,new Vertex3D(eyeLipX , eyeLipY + 0+ t.rectH, 0)
			]);
			else
			return Vector.<Vertex3D>([
				new Vertex3D(eyeLipX + 0 , eyeLipY + 0, 0)
				,new Vertex3D(eyeLipX + 0 + t.rectW , eyeLipY + 0, 0)
				,new Vertex3D(eyeLipX + 0 , 0 + eyeLipY + t.rectH, 0)
				,new Vertex3D(eyeLipX + 0 + t.rectW , eyeLipY + 0+ t.rectH, 0)
			]);
		}
		
		
		
		
		
		
		
		
		
		
	}

}