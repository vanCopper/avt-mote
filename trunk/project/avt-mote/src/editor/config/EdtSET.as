package editor.config   {  


	import flash.geom.ColorTransform;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;


	
	/**
	 * @author blueshell
	 */
	public class EdtSET {
		public static var gird_color : uint = EdtDEF.GIRD_COLOR  ;
		public static var bg_color : uint = EdtDEF.BG_COLOR  ;
		public static var LINE_SHAPE_DYM_COLOR : uint = 0xFFDDDD;
//		public static var LINE_SHAPE_COLOR  : uint = 0xFF0000;
		
		public static function get gird_color_t () : ColorTransform{ return getGird_Color_Transform(gird_color);}
		public static function get bg_color_t () : ColorTransform{ return getGird_Color_Transform(bg_color);}
		
		public static const HOT_MOVEON : ColorTransform = new ColorTransform ( 0, 0, 0, 0,255,255,0,100);
		public static const HOT_WORKON : ColorTransform = new ColorTransform ( 0, 0, 0, 0,255,0, 0, 120);
		
		public static const DOT_SELECT : ColorTransform = new ColorTransform ( 0, 0, 0, 0,255,255, 0, 255);
		public static const DOT_RELEASE : ColorTransform = new ColorTransform ( 0, 0, 0, 0,255,200, 0, 255);
		public static const DOT_UNSELECT : ColorTransform = new ColorTransform ( 0, 0, 0, 0,255,0, 0, 100);

		public static const  BTN_DEFAULT : GlowFilter = new GlowFilter (0xFFFFCC ,1.0, 8.0,8.0, 1.0);
		public static const  BTN_HOVER : GlowFilter = new GlowFilter (0x4444FF,1.0, 5.0,5.0, 0.6);
		public static const  BTN_SELECTED : GlowFilter = new GlowFilter (0xFF5555,1.0, 5.0,5.0, 0.6);
		public static const  SCROLL_SELECTED : GlowFilter=  new GlowFilter (0x0000FF,1.0, 5.0,5.0, 0.8);

		public static const  FIT_TEXT_FORMAT : TextFormat = new TextFormat( null, 12, 0xFF5555, true);
		public static const  UNFIT_TEXT_FORMAT : TextFormat = new TextFormat( null, 12, 0xAAAAAA, false);
		public static const  FIT_TEXT_FILTER : GlowFilter = new GlowFilter (0xFFFF88 ,1.0, 8.0,8.0, 1.5);
		
		
		private static function getGird_Color_Transform (inColor : uint) : ColorTransform {
			
			return new ColorTransform	( 0, 0, 0, 1,
									 	(inColor & 0xFF0000)>>>16,
										(inColor & 0xFF00)>>>8, 
										(inColor & 0xFF), 0);
		}
		
		public static var addDotOff : int = 10;
		public static var click_accuracy : uint = 8;
		
		public static var HoverTime : uint = 250;
	
		public static var LANGUAGE : int /*= TextTable.EN*/;
	}
}
