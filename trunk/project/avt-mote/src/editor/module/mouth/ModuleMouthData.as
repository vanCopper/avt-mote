package editor.module.mouth 
{
	import editor.struct.Plane3D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleMouthData 
	{
		public static var s_frameList : Vector.<ModuleMouthFrame> = new Vector.<ModuleMouthFrame>();
		
		public static var centerX : Number = 0;
		public static var centerY : Number = 0;
		
		public static var mouthPlane : Plane3D = new Plane3D();

		public static var mouthV0 : EdtVertex3D;
		public static var mouthV1 : EdtVertex3D;
		public static var mouthV2 : EdtVertex3D;
	}

}