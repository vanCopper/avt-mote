package editor.ui 
{
	import editor.struct.Vertex3D;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtVertex3D extends Vertex3D
	{
		public var priority : int;
		public var conect : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
	//	public var isSelected : Boolean;
		
		public var line0 : EdtVertex3D;
		public var line1 : EdtVertex3D;
		
		public var scale : Number = 1.0;
		
		public function EdtVertex3D(_x : Number = 0,_y : Number = 0,_z : Number = 0) 
		{
			super(_x, _y, _z);
		}
		
		public function cloneEdtVertex3D():EdtVertex3D
		{
			return new EdtVertex3D(x, y, z);
		}
		
		
		
		public static function connect2PT(ev0 : EdtVertex3D , ev1 : EdtVertex3D  ) : void
		{
			ev0.conect.push(ev1);
			ev1.conect.push(ev0);
			
		}
	}

}