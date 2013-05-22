package editor.module.head 
{
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
		public static var s_texture : BitmapData;
		
		public static var s_pointPerLine : int;
		public static var s_totalLine : int;
		
		public static var s_uvData : Vector.<Number> ;
		public static var s_indices : Vector.<int>;
		
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
				s_uvData.push ((_ev.x + (s_texture.width >> 1)) / s_texture.width);
				s_uvData.push ((_ev.y + (s_texture.height >> 1)) / s_texture.height);
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
			g.clear();
			g.beginBitmapFill(s_texture);
			g.drawTriangles(vertices , s_indices, s_uvData);
			g.endFill();
		}
	}

}