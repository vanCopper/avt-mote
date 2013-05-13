package editor.ui 
{
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtVertexInfo 
	{
		public var vertex : EdtVertex3D;
		public var dot : EdtDot;
		
		public function EdtVertexInfo(_vertex : EdtVertex3D = null , _dot : EdtDot = null) 
		{
			dot =  _dot;
			vertex =  _vertex;
			
			if (dot == null )
			{	
				dot = new EdtDot();
			}
		}
		
	}

}