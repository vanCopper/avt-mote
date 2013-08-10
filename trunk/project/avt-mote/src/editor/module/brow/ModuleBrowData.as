package editor.module.brow 
{
	import editor.struct.Plane3D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBrowData 
	{
		public static var s_frameList : Vector.<ModuleBrowFrame> = new Vector.<ModuleBrowFrame>();
		
		public static var centerLX : Number = -10;
		public static var centerLY : Number = 0;
		
		public static var browPlaneL: Plane3D = new Plane3D();

		public static var browVL0 : EdtVertex3D;
		public static var browVL1 : EdtVertex3D;
		public static var browVL2 : EdtVertex3D;
		
		public static var centerRX : Number = 10;
		public static var centerRY : Number = 0;
		
		public static var browPlaneR : Plane3D = new Plane3D();

		public static var browVR0 : EdtVertex3D;
		public static var browVR1 : EdtVertex3D;
		public static var browVR2 : EdtVertex3D;
		
	}

}