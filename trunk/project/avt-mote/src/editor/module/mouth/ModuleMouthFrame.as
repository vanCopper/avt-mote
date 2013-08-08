package editor.module.mouth 
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
	public class ModuleMouthFrame 
	{
		public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		public var uvData : Vector.<Number>;
		public static const indices : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
		
		public var offsetX : Number ;
		public var offsetY : Number ;
		
		
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
		
		public function getVerticesMatrixed(md : Matrix4x4):Vector.<Number>
		{
			var __v : Vector.<Number> = new Vector.<Number>();
				
			for each( var ev : EdtVertex3D in vertexData)
			{
				__v.push( md.Xx * ev.x + md.Xy * ev.y + md.Xz * ev.z) ;
				__v.push( md.Yx * ev.x + md.Yy * ev.y + md.Yz * ev.z) ;
				
			}
			return __v;
		}
		
		public function ModuleMouthFrame(_texture : Texture2D) 
		{
			texture = _texture;
			if (texture)
			{	
				name = texture.name;
			}
			
			if (isNaN(offsetX))
			{
				if (texture)
				{
					offsetX = -(Math.abs(texture.rectW) >> 1);
					offsetY = -(Math.abs(texture.rectH) >> 1);
				}
				else
				{
					offsetX = 0;
					offsetY = 0;
				}
			}
		}
		
		public function confitZ():void
		{
			vertexData.length = 0;
			
			vertexData.push(new EdtVertex3D(0, 0));
			vertexData.push(new EdtVertex3D(Math.abs(texture.rectW), 0));
			vertexData.push(new EdtVertex3D(0, Math.abs(texture.rectH)));
			vertexData.push(new EdtVertex3D(Math.abs(texture.rectW), Math.abs(texture.rectH)));
			
			for each( var ev : EdtVertex3D in vertexData)
			{
				ev.x += offsetX + ModuleMouthData.centerX;
				ev.y += offsetY + ModuleMouthData.centerY;
				
				ev.z = ModuleMouthData.mouthPlane.confitZ(ev.x , ev.y);
			}
		}
		
		public function dispose():void 
		{
			name = null;
			texture = null;
		}
		
		public function createSprite() : ModuleMouthFrameSprite
		{
			return new ModuleMouthFrameSprite(this);
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
			
			var str : String = "<ModuleMouthFrame>";
			str += "<name>";
				str += name;
			str += "</name>";
			
			if (texture) str += texture.toXMLString();
			
			/*
			str += "<vertexPerLine>";
			str += "" + vertexPerLine;
			str += "</vertexPerLine>";
			
			str += "<vertexData>";
				var first : Boolean = true;
				for each (var _v : Vertex3D in vertexData)	
				{
					if (first)
					{
						str += _v.to2DXMLString();
						first = false;
					}
					else
						str += "," + _v.to2DXMLString();
				}
			str += "</vertexData>";
			str += "<vertexDataZ>";
				first = true;
				for (var vi : int = 0 ; vi < vertexPerLine ; vi++ )	
				{
					if (first)
					{
						str += vertexData[vi].z;
						first = false;
					}
					else
						str += "," + vertexData[vi].z;
				}
			str += "</vertexDataZ>";
			*/
			str += "<offsetX>" + offsetX + "</offsetX>";
			str += "<offsetY>" + offsetY + "</offsetY>";
		
			
			
			str += "</ModuleMouthFrame>";
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
			
			vertexData.length = 0;
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