package editor.module.hair 
{
	import editor.Library;
	import editor.struct.Texture2D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import editor.ui.EdtVertexInfo;
	import editor.util.TextureLoader;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHairFrame 
	{
		public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		public var vertexPerLine : int = 0 ;
		public var uvData : Vector.<Number>;
		public var indices : Vector.<int>;
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		
		
		public var weightReciprocal : Number = 60;
		public var ductility : Number = 0.4;
		public var hardness : Number = 1.0;
		//public var decline : Number = 1.05;
		
		public function genIndicesData():void
		{
			if (!indices && vertexData)
			{
				indices = new Vector.<int>();
				
				for (var h : int = 1 ; h < vertexData.length / vertexPerLine; h++ )
				{
					for (var w : int = 1 ; w < vertexPerLine ; w++ )
					{
						var p0 : int = (h-1) * vertexPerLine + (w - 1)
						var p1 : int = p0 + 1;
						var p2 : int = (h) * vertexPerLine + (w - 1)
						var p3 : int = p2 + 1;
						
						indices.push(p0);
						indices.push(p1);
						indices.push(p2);
						
						indices.push(p2);
						indices.push(p1);
						indices.push(p3);
					}
				}
			}
			
		}
		
		public function genUVData():void
		{
			uvData = new Vector.<Number>();
			for each (var _ev : EdtVertex3D in vertexData)
			{
				uvData.push ((_ev.x /*+ (s_texture.rectW >> 1)*/ + texture.rectX) / texture.bitmapData.width);
				uvData.push ((_ev.y /*+ (s_texture.rectH >> 1)*/ + texture.rectY) / texture.bitmapData.height);
			}
			
			//var g : Graphics;
			//g.drawTriangles
			
			
			
		}
		
		public function get vertices():Vector.<Number>
		{
			var __v : Vector.<Number> = new Vector.<Number>();
				
			for each( var ev : EdtVertex3D in vertexData)
			{
				__v.push(ev.x + offsetX);
				__v.push(ev.y + offsetY);
			}
			return __v;
		}
		
		public function ModuleHairFrame(_texture : Texture2D) 
		{
			texture = _texture;
			if (texture)
				name = texture.name;
		}
		
		public function dispose():void 
		{
			name = null;
			texture = null;
		}
		
		public function createSprite() : ModuleHairFrameSprite
		{
			return new ModuleHairFrameSprite(this);
		}
		
		
		
		
		
		
		public function toXMLString():String
		{
			
			var str : String = "<ModuleHairFrame>";
			str += "<name>";
				str += name;
			str += "</name>";
			
			if (texture) str += texture.toXMLString();
			
			
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
			str += "<offsetX>" + offsetX + "</offsetX>";
			str += "<offsetY>" + offsetY + "</offsetY>";
		
			str += "<weightReciprocal>" + weightReciprocal + "</weightReciprocal>";
			str += "<ductility>" + ductility + "</ductility>";
			str += "<hardness>" + hardness + "</hardness>";
			
			str += "</ModuleHairFrame>";
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
				texture = Library.getS().getTexture2D(_tname);
				if (!texture) {
					if (s.Texture2D != undefined)
					{
						loadStep++;
						new TextureLoader(s.Texture2D[0], onTextureLoaded , false);
					}
				}
				
				vertexPerLine  = int(s.vertexPerLine.text());
				
				var __dataString : String = String(s.vertexData.text());
				if (__dataString)
				{
					var __data : Array = __dataString.split(",");
					for each (var vstr : String in __data )
					{
						var _ev : EdtVertex3D = new EdtVertex3D();
						_ev.from2DXMLString(vstr);
						vertexData.push(_ev);
					}
					genConnect(vertexPerLine , vertexData.length / vertexPerLine , vertexData);
					
					
					__dataString = String(s.vertexDataZ.text());
					__data = __dataString.split(",");
					for (var vi : int = 0 ; vi < vertexPerLine ; vi++ )
					{
						vertexData[vi].z = Number(__data[vi]);
					}
				}
				
				offsetX  = int(s.offsetX.text());
				offsetY  = int(s.offsetY.text());
				
				weightReciprocal  = Number(s.weightReciprocal.text());
				ductility  = Number(s.ductility.text());
				hardness  = Number(s.hardness.text());
				
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