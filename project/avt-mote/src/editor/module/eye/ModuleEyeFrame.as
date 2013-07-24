package editor.module.eye 
{
	import editor.Library;
	import editor.struct.Matrix4x4;
	import editor.struct.Plane3D;
	import editor.struct.Texture2D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import editor.util.ByteArrayUtil;
	import editor.util.TextureLoader;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrame 
	{
		public var name : String;
		public var eyeWhite : Texture2D;
		
		
		public var eyeBall : Texture2D;
		public var eyeBallX : Number;
		public var eyeBallY : Number;
		
		
		public var eyeLip : Texture2D;
		public var eyeLipX : Number;
		public var eyeLipY : Number;
		
		
		public var eyeMaskData : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		public var eyeVertex3D :  Vector.<Vertex3D>;
		
		public function ModuleEyeFrame() 
		{
			
			
			
			
		}
		
		
		private function dealEyeVertexL(v : Vector.<Vertex3D>):void
		{
			dealVertex3DArray(v , ModuleEyeData.s_eyeLScale , ModuleEyeData.s_eyeLPlane , ModuleEyeData.s_eyeMatrix , ModuleEyeData.s_eyeLLocateX , ModuleEyeData.s_eyeLLocateY);
		}
		private function dealEyeVertexR(v : Vector.<Vertex3D>):void
		{
			dealVertex3DArray(v , ModuleEyeData.s_eyeRScale , ModuleEyeData.s_eyeRPlane , ModuleEyeData.s_eyeMatrix , ModuleEyeData.s_eyeRLocateX , ModuleEyeData.s_eyeRLocateY);
		}
		
		public static function dealVertex3D( vtx : Vertex3D , sacle : Number , plane : Plane3D , md : Matrix4x4 , _xOff : Number  , _yOff : Number ) : void
		{
				vtx.x *= sacle;
				vtx.y *= sacle;
				vtx.x += _xOff;
				vtx.y += _yOff;
				
				vtx.z = plane.confitZ(vtx.x , vtx.y)
				
				md.effectPoint3D(vtx.x, vtx.y , vtx.z , vtx);
		}
		
		private function dealVertex3DArray( v : Vector.<Vertex3D> , sacle : Number , plane : Plane3D , md : Matrix4x4 , _xOff : Number  , _yOff : Number ) : void
		{
			for each(var vtx : Vertex3D in v )
			{
				dealVertex3D(vtx , sacle  , plane , md  , _xOff   , _yOff );
			}
		}
		
		public function genEyeVertex3D(l : Boolean):void
		{
			eyeVertex3D = new Vector.<Vertex3D>();
			var v : Vector.<Vertex3D>;
			v = genEyeWhiteVertex3D();
			var v3d : Vertex3D;
			for each ( v3d in v)	eyeVertex3D.push(v3d);
			
			v = genEyeBallVertex3D();
			for each ( v3d in v)	eyeVertex3D.push(v3d);
			
			v = genEyeLipVertex3D();
			for each ( v3d in v)	eyeVertex3D.push(v3d);
			
			v = genEyeMaskVertex3D();
			for each ( v3d in v)	eyeVertex3D.push(v3d);
			
			if(l)
				dealEyeVertexL(eyeVertex3D);
			else
				dealEyeVertexR(eyeVertex3D);
		}
		
		private function genEyeMaskVertex3D():Vector.<Vertex3D>
		{
			var v : Vector.<Vertex3D> = new Vector.<Vertex3D>();
			
			for each (var ev :EdtVertex3D in eyeMaskData)
				v.push(ev.cloneVertex3D());
			return v;
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
				,new Vertex3D(0 + t.rectW , 0, 0)
				,new Vertex3D(0 , t.rectH, 0)
				,new Vertex3D(0 + t.rectW , 0 + t.rectH, 0)
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
				 new Vertex3D(eyeBallX , eyeBallY + 0, 0)
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
				 new Vertex3D(eyeLipX , eyeLipY + 0, 0)
				,new Vertex3D(eyeLipX + t.rectW , eyeLipY + 0, 0)
				,new Vertex3D(eyeLipX , 0 + eyeLipY + t.rectH, 0)
				,new Vertex3D(eyeLipX + t.rectW , eyeLipY + 0+ t.rectH, 0)
			]);
		}
		
		public function encode(ba:ByteArray):void
		{
			var _flag : int = 0;
			if (eyeWhite)
				_flag |= 1;
			if (eyeBall)
				_flag |= 2;
			if (eyeLip)
				_flag |= 4;
			if (eyeMaskData.length)
				_flag |= 8;
				
			ba.writeByte(_flag);
				
			if (eyeWhite)	eyeWhite.encode(ba);
			if (eyeBall)	{
				//ba.writeFloat(eyeBallX);
				//ba.writeFloat(eyeBallY);
				eyeBall.encode(ba);
			}
			if (eyeLip) 	{
				ba.writeFloat(eyeLipX);
				ba.writeFloat(eyeLipY);
				
				eyeLip.encode(ba);
			}
			
			if (eyeMaskData.length)
			{
				ByteArrayUtil.writeUnsignedByteOrShort(ba,eyeMaskData.length);
				for each (var _v : Vertex3D in eyeMaskData)	
				{
					ba.writeFloat(_v.x);
					ba.writeFloat(_v.y);
					
					//_v.(ba);
				}
			}
		}
		
		public function toXMLString():String
		{
			
			var str : String = "<ModuleEyeFrame>";
			str += "<name>";
				str += name;
			str += "</name>";
			
			str += "<eyeWhite>";
				if (eyeWhite) str += eyeWhite.toXMLString();
			str += "</eyeWhite>";
			
			str += "<eyeBall>";
				if (eyeBall) str += eyeBall.toXMLString();
				str += "<position>" + eyeBallX +":" + eyeBallY + "</position>";
			str += "</eyeBall>";
			
			
			str += "<eyeLip>";
				if (eyeLip) str += eyeLip.toXMLString();
				str += "<position>" + eyeLipX +":" + eyeLipY + "</position>";
			str += "</eyeLip>";
			
			str += "<eyeMaskData>";
			var first : Boolean = true;
			for each (var _v : Vertex3D in eyeMaskData)	
			{
				if (first)
				{
					str += _v.toXMLString();
					first = false;
				}
				else
					str += "," + _v.toXMLString();
			}
			str += "</eyeMaskData>";
			
			str += "</ModuleEyeFrame>";
			return str;
		}
		public var loadStep : int;
		public var callback :Function;
		
		public function fromXMLString(s:XML , a_callback :Function):void
		{
			eyeMaskData.length = 0;
			callback = a_callback;
			if (s)
			{
				loadStep++;
				name = s.name.text();
				
				var _tname : String;
				_tname = s.eyeWhite.Texture2D.name.text();
				if (_tname)
				eyeWhite = Library.getS().getTexture2DXML(s.eyeWhite.Texture2D[0]);
				if (!eyeWhite)
				{
					if (s.eyeWhite.Texture2D != undefined)
					{
						loadStep++;
						new TextureLoader(s.eyeWhite.Texture2D[0], onTextureLoadedEW , true);
					}
				}

				_tname = s.eyeBall.Texture2D.name.text();
				if (_tname)
				eyeBall = Library.getS().getTexture2DXML(s.eyeBall.Texture2D[0]);
				if (!eyeBall)
				{
					if (s.eyeBall.Texture2D != undefined)
					{	
						loadStep++;
						new TextureLoader(s.eyeBall.Texture2D[0] , onTextureLoadedEB , true);
					}
				}
				var _p :Array;
				_p = String(s.eyeBall.position.text()).split(":");
				eyeBallX = Number(_p[0]);
				eyeBallY = Number(_p[1]);
				
				_tname = s.eyeLip.Texture2D.name.text();
				if (_tname)
				eyeLip = Library.getS().getTexture2DXML(s.eyeLip.Texture2D[0]);
				if (!eyeLip)
				{
					if (s.eyeLip.Texture2D != undefined)
					{
						loadStep++;
						new TextureLoader(s.eyeLip.Texture2D[0] , onTextureLoadedEL , true);
					}
				}
				_p = String(s.eyeLip.position.text()).split(":");
				eyeLipX = Number(_p[0]);
				eyeLipY = Number(_p[1]);
				
				var __dataString : String = String(s.eyeMaskData.text());
				if (__dataString)
				{
					var __data : Array = __dataString.split(",");
					for each (var vstr : String in __data )
					{
						var _ev : EdtVertex3D = new EdtVertex3D();
						_ev.fromXMLString(vstr);
						eyeMaskData.push(_ev);
					}
					genConnect();
				}
				
				loadStep--;
				if (loadStep == 0)
				{
					if (callback != null)
						callback(this);
					callback = null;
				}
				
			}
			
		}
		
		private function onATextureLoaded():void
		{
			loadStep--;
			if (loadStep == 0)
			{
				if (callback != null)
					callback(this);
				callback = null;
			}
		}
		private function onTextureLoadedEW(_name : String , _texture2D : Texture2D):void 
		{
			eyeWhite = _texture2D;
			onATextureLoaded();
		}
		private function onTextureLoadedEB(_name : String , _texture2D : Texture2D):void 
		{
			eyeBall = _texture2D;
			onATextureLoaded();
		}
		private function onTextureLoadedEL(_name : String , _texture2D : Texture2D):void 
		{
			eyeLip = _texture2D;
			onATextureLoaded();
		}
		public function flipData():ModuleEyeFrame
		{
			var n : ModuleEyeFrame = new ModuleEyeFrame();
			n.eyeWhite = eyeWhite ? Library.getS().getTexture2DFlip(eyeWhite.name) : null;
			n.eyeBall = eyeBall ? Library.getS().getTexture2DFlip(eyeBall.name) : null;
			n.eyeLip = eyeLip ? Library.getS().getTexture2DFlip(eyeLip.name) : null;
			
			
			n.eyeBallX = eyeBallX;
			n.eyeBallY = eyeBallY;
			n.eyeLipX = eyeLipX;
			n.eyeLipY = eyeLipY;
			
			n.eyeMaskData = new Vector.<EdtVertex3D>(); 
			
			
			if (eyeWhite)
			{
				for each (var _ev3d : EdtVertex3D in eyeMaskData)
				{	
					var _ev3dC : EdtVertex3D = _ev3d.cloneEdtVertex3D();
					
					_ev3dC.x = Math.abs(eyeWhite.rectW) - _ev3dC.x; 
					
					n.eyeMaskData.push(_ev3dC);
				}
				n.genConnect();
			}
			
			return n;
		}
		
		private function genConnect():void
		{
			var p : int = 1;
			for each (var _v3d : EdtVertex3D in eyeMaskData)
			{
				_v3d.priority = p++;
			}
			
			
			var idx : int = 2;
			while (idx < eyeMaskData.length)
			{
				EdtVertex3D.connect2PT(eyeMaskData[0] , eyeMaskData[idx - 1]);
				EdtVertex3D.connect2PT(eyeMaskData[0] , eyeMaskData[idx]);
				EdtVertex3D.connect2PT(eyeMaskData[idx] , eyeMaskData[idx - 1]);
				idx++;
			}
		}
		
		public function cloneData():ModuleEyeFrame
		{
			var n : ModuleEyeFrame = new ModuleEyeFrame();
			n.eyeWhite = eyeWhite;
			n.eyeBall = eyeBall;
			n.eyeLip = eyeLip;
			
			
			n.eyeBallX = eyeBallX;
			n.eyeBallY = eyeBallY;
			n.eyeLipX = eyeLipX;
			n.eyeLipY = eyeLipY;
			
			n.eyeMaskData = new Vector.<EdtVertex3D>(); 
			for each (var _ev3d : EdtVertex3D in eyeMaskData)
				n.eyeMaskData.push(_ev3d.cloneEdtVertex3D());
			
			n.genConnect();
			
			return n;
		}
		public function createSprite() : ModuleEyeFrameSprite
		{
			return new ModuleEyeFrameSprite(this);
		}
		public function dispose():void 
		{
			eyeWhite = null;
			eyeBall = null;
			eyeLip = null;
			eyeMaskData = null;
			eyeVertex3D = null;
			
			callback = null;
		}
	}

}