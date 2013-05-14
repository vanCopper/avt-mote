package editor.ui 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtVertexInfo 
	{
		public var vertex : EdtVertex3D;
		public var dot : EdtDot;
		public var point : Point;
		
		public function EdtVertexInfo(_vertex : EdtVertex3D = null , _dot : EdtDot = null) 
		{
			dot =  _dot;
			vertex =  _vertex;
			
			if (dot == null )
			{	
				dot = new EdtDot();
			}
		}
		
		public static function getEdtVertexInfo(_ev3d : EdtVertex3D , _vertexArray : Vector.<EdtVertexInfo>):EdtVertexInfo
		{
			for each( var evi : EdtVertexInfo in _vertexArray)
			{
				if (evi.vertex == _ev3d)
					return evi;
			}
			
			return null;
		}
		
	}

}