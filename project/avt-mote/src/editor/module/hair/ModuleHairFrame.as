package editor.module.hair 
{
	import editor.struct.Texture2D;
	import editor.ui.EdtVertex3D;
	import editor.ui.EdtVertexInfo;
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
				__v.push(ev.x);
				__v.push(ev.y);
			}
			return __v;
		}
		
		public function ModuleHairFrame(_texture : Texture2D) 
		{
			texture = _texture;
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
	}

}