package editor.module.eye 
{
	import editor.struct.Plane3D;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeData 
	{
		public static var s_frameList : Vector.<ModuleEyeFrame> = new Vector.<ModuleEyeFrame>();
		
		public static var s_eaL:Number;
		public static var s_ebL:Number;
		public static var s_erL:Number;
		public static var s_eCenterLX:Number;
		public static var s_eCenterLY:Number;
		
		public static var s_eaR:Number;
		public static var s_ebR:Number;
		public static var s_erR:Number;
		public static var s_eCenterRX:Number;
		public static var s_eCenterRY:Number;		
		
		public static var s_frameL : ModuleEyeFrame;
		public static var s_frameR : ModuleEyeFrame;
		
		public static var s_eyeLPlane : Plane3D = new Plane3D();
		public static var s_eyeRPlane : Plane3D = new Plane3D();
		
		
		public static function reset():void
		{
			s_frameL = null;
			s_frameR = null;
			s_frameList.length = 0;
			
			
			s_eyeLPlane.reset();
			s_eyeRPlane.reset();
		}
		
	}

}