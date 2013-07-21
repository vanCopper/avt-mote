package editor.module.head 
{
	import editor.struct.Texture2D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHeadData 
	{
		public static var s_rotorX : Number;
		public static var s_rotorY : Number;
		
		public static var s_rotorR : Number;
		
		
		public static var s_vertexData : Vector.<EdtVertex3D>;
		public static var s_vertexRelativeData : Vector.<Vertex3D>;
		public static var s_texture : Texture2D;
		
		public static var s_pointPerLine : int;
		public static var s_totalLine : int;
		
		public static var s_uvData : Vector.<Number> ;
		public static var s_indices : Vector.<int>;
		
		public static var s_approximationMode : Boolean = true;
		public static var s_xRotor : Vertex3D = new Vertex3D();
		public static var s_yRotor : Vertex3D = new Vertex3D();
		public static var s_zRotor : Vertex3D = new Vertex3D();
		
		public static var s_absRX : Number;
		public static var s_absRY : Number;
		public static var s_absRZ : Number;
		
		
		
		
		public static function clear():void
		{
			s_approximationMode = true;
			s_vertexData = null;
			s_vertexRelativeData = null;
			if (s_texture)
				s_texture.dispose();
			s_texture = null;
		
			s_uvData = null;
			s_indices = null;
		}
		
		
		public static function genConnect(pointPerLine:int, totalLine:int, _edtVectorAll:Vector.<EdtVertex3D>):void 
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
		
		public static function genindicesData():void
		{
			s_indices = new Vector.<int>();
			
			for (var h : int = 1 ; h < s_totalLine ; h++ )
			{
				for (var w : int = 1 ; w < s_pointPerLine ; w++ )
				{
					var p0 : int = (h-1) * s_pointPerLine + (w - 1)
					var p1 : int = p0 + 1;
					var p2 : int = (h) * s_pointPerLine + (w - 1)
					var p3 : int = p2 + 1;
					
					s_indices.push(p0);
					s_indices.push(p1);
					s_indices.push(p2);
					
					s_indices.push(p2);
					s_indices.push(p1);
					s_indices.push(p3);
				}
			}
			
		}
		
		public static function genUVData():void
		{
			s_uvData = new Vector.<Number>();
			for each (var _ev : EdtVertex3D in s_vertexData)
			{
				s_uvData.push ((_ev.x + (s_texture.rectW >> 1) + s_texture.rectX) / s_texture.bitmapData.width);
				s_uvData.push ((_ev.y + (s_texture.rectH >> 1) + s_texture.rectY) / s_texture.bitmapData.height);
			}
			
			//var g : Graphics;
			//g.drawTriangles
			
			
			
		}
		
		public static function genVertexRelativeData():void
		{
			s_vertexRelativeData = new Vector.<Vertex3D>();
			var _evR : Vertex3D;
			for each (var _ev : EdtVertex3D in s_vertexData)
			{
				_evR = new Vertex3D();
				_evR.x = _ev.x - s_rotorX;
				_evR.y = _ev.y - s_rotorY;
				_evR.z = _ev.z;
				
				
				s_vertexRelativeData.push(_evR);
			}
		}
		
		
		
		
		public static function drawTriangles(g : Graphics , vertices:Vector.<Number>) : void
		{
			if (s_texture && s_texture.bitmapData)
			{
				g.clear();
				g.beginBitmapFill(s_texture.bitmapData,null,false,true);
				g.drawTriangles(vertices , s_indices, s_uvData);
				g.endFill();
			}
			
		}
	}

}