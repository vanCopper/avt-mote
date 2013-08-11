package editor.module.brow 
{
	import editor.Library;
	import editor.struct.Matrix4x4;
	import editor.struct.Texture2D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import editor.ui.EdtVertexInfo;
	import editor.util.TextureLoader;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBrowFrame 
	{
		public var name : String;
		public var texture : Texture2D;
		public var vertexDataL : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		public var vertexDataR : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		public var uvData : Vector.<Number>;
		public static const indices : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
		
		public var _offsetX : Number ;
		public var _offsetY : Number ;
		
		public function get offsetX():Number
		{
			if (name.indexOf("#FLIP") == -1)
				return _offsetX;
			else
			{
				var _rawName : String = name.replace("#FLIP" , "");
				var mbf : ModuleBrowFrame = ModuleBrowFrameLib.getSingleton().getModuleBrowFrameData(_rawName);
				
				return -(Math.abs(texture.rectW) + mbf._offsetX);
			}
		}
		public function get offsetY():Number
		{
			if (name.indexOf("#FLIP") == -1)
				return _offsetY;
			else
			{
				var _rawName : String = name.replace("#FLIP" , "");
				var mbf : ModuleBrowFrame = ModuleBrowFrameLib.getSingleton().getModuleBrowFrameData(_rawName);
				
				return mbf._offsetY;
			}
		}
		
		public function set offsetX(v:Number):void
		{
			if (name.indexOf("#FLIP") == -1)
				_offsetX = v;
			else {
				var _rawName : String = name.replace("#FLIP" , "");
				var mbf : ModuleBrowFrame = ModuleBrowFrameLib.getSingleton().getModuleBrowFrameData(_rawName);
				mbf._offsetX = -(Math.abs(texture.rectW) + v);
			}
			
		}
		
		public function set offsetY(v:Number):void
		{
			if (name.indexOf("#FLIP") == -1)
				_offsetY = v;
			else {
				var _rawName : String = name.replace("#FLIP" , "");
				var mbf : ModuleBrowFrame = ModuleBrowFrameLib.getSingleton().getModuleBrowFrameData(_rawName);
				mbf._offsetY = v;
			}
		}
		
		
		public function genUVData():void
		{
			uvData = new Vector.<Number>();
			
			uvData.push (( texture.rectX) / texture.bitmapData.width);
			uvData.push (( texture.rectY) / texture.bitmapData.height);
			
			uvData.push (( texture.rectX + texture.rectW) / texture.bitmapData.width);
			uvData.push (( texture.rectY) / texture.bitmapData.height);
			
			uvData.push (( texture.rectX) / texture.bitmapData.width);
			uvData.push (( texture.rectY + texture.rectH) / texture.bitmapData.height);
			
			uvData.push (( texture.rectX + texture.rectW) / texture.bitmapData.width);
			uvData.push (( texture.rectY + texture.rectH) / texture.bitmapData.height);
			
		}
		
		public function getVerticesMatrixed(md : Matrix4x4 , _left : Boolean):Vector.<Number>
		{
			var __v : Vector.<Number> = new Vector.<Number>();
				
			for each( var ev : EdtVertex3D in _left ? vertexDataL : vertexDataR)
			{
				__v.push( md.Xx * ev.x + md.Xy * ev.y + md.Xz * ev.z) ;
				__v.push( md.Yx * ev.x + md.Yy * ev.y + md.Yz * ev.z) ;
				
			}
			return __v;
		}
		
		public function ModuleBrowFrame(_texture : Texture2D) 
		{
			texture = _texture;
			if (texture)
			{	
				name = texture.name;
			}
			
			if (isNaN(_offsetX))
			{
				if (texture)
				{
					_offsetX = -(Math.abs(texture.rectW) >> 1);
					_offsetY = -(Math.abs(texture.rectH) >> 1);
				}
				else
				{
					_offsetX = 0;
					_offsetY = 0;
				}
			}
		}
		
		public function confitZ():void
		{
			vertexDataL.length = 0;
			
			vertexDataL.push(new EdtVertex3D(0, 0));
			vertexDataL.push(new EdtVertex3D(Math.abs(texture.rectW), 0));
			vertexDataL.push(new EdtVertex3D(0, Math.abs(texture.rectH)));
			vertexDataL.push(new EdtVertex3D(Math.abs(texture.rectW), Math.abs(texture.rectH)));
			
			vertexDataR.length = 0;
			
			vertexDataR.push(new EdtVertex3D(0, 0));
			vertexDataR.push(new EdtVertex3D(Math.abs(texture.rectW), 0));
			vertexDataR.push(new EdtVertex3D(0, Math.abs(texture.rectH)));
			vertexDataR.push(new EdtVertex3D(Math.abs(texture.rectW), Math.abs(texture.rectH)));
			
			var ev : EdtVertex3D;
			for each( ev in vertexDataL)
			{
				ev.x += offsetX + ModuleBrowData.centerLX;
				ev.y += offsetY + ModuleBrowData.centerLY;
				
				ev.z = ModuleBrowData.browPlaneL.confitZ(ev.x , ev.y);
			}
			
			
			for each( ev in vertexDataR)
			{
				ev.x += -(Math.abs(texture.rectW) + offsetX) + ModuleBrowData.centerRX;
				ev.y += offsetY + ModuleBrowData.centerRY;
				
				ev.z = ModuleBrowData.browPlaneR.confitZ(ev.x , ev.y);
			}
		}
		
		public function dispose():void 
		{
			name = null;
			texture = null;
		}
		
		public function createSprite() : ModuleBrowFrameSprite
		{
			return new ModuleBrowFrameSprite(this);
		}
		
		
		
		public function encode(ba:ByteArray):void
		{
			if (texture) 
				texture.encode(ba);
			else
				new Texture2D(null,null,null,null,0,0,0,0 ).encode(ba);
			
			ba.writeFloat(offsetX);
			ba.writeFloat(offsetY);
			
		}
		
		public function toXMLString():String
		{
			
			var str : String = "<ModuleBrowFrame>";
			str += "<name>";
				str += name;
			str += "</name>";
			
			if (texture) str += texture.toXMLString();
			
			str += "<offsetX>" + offsetX + "</offsetX>";
			str += "<offsetY>" + offsetY + "</offsetY>";
		
			
			
			str += "</ModuleBrowFrame>";
			return str;
		}
		
		public var loadStep : int;
		public var callback :Function;
		
		public function genConnect(pointPerLine:int, totalLine:int, _edtVectorAll:Vector.<EdtVertex3D>):void 
		{
			var ti : int = 0;
			
			ti = 0;
			for each(var __edtP : EdtVertex3D in _edtVectorAll)
			{
				__edtP.priority = ti++;
			}
			
			
			for ( l = 0 ; l < totalLine ;l++ )
			{
				var start : int = l * pointPerLine;
				for ( ti = 1 ; ti < pointPerLine ; ti++ )
				{
					EdtVertex3D.connect2PT(_edtVectorAll[start + ti - 1] , _edtVectorAll[start + ti]);
				}
			}
			
			for ( ti = 0 ; ti < pointPerLine ; ti++ )
			for (var l : int = 1 ; l < totalLine ;l++ )
			{
				EdtVertex3D.connect2PT(_edtVectorAll[(l - 1) * pointPerLine + ti ] , _edtVectorAll[(l) * pointPerLine + ti ]);
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
		private function onTextureLoaded(_name : String , _texture2D : Texture2D):void 
		{
			texture = _texture2D;
			onATextureLoaded();
		}
		
		public function fromXMLString(s:XML , a_callback :Function):void
		{
			
			vertexDataL.length = 0;
			vertexDataR.length = 0;
			
			callback = a_callback;
			if (s)
			{
				name = s.name.text();
				
				var _tname : String;
				_tname = s.Texture2D.name.text();
				if (_tname)
					texture = Library.getS().getTexture2DXML(s.Texture2D[0]);
				if (!texture) {
					if (s.Texture2D != undefined)
					{
						loadStep++;
						new TextureLoader(s.Texture2D[0], onTextureLoaded , false);
					}
				}
				
				offsetX  = int(s.offsetX.text());
				offsetY  = int(s.offsetY.text());
				
			
				
				if (loadStep == 0)
				{
					if (callback != null)
						callback(this);
					callback = null;
				}
				
			}
			
		}
		
		
		
		
		
		
	}

}