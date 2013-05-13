package editor.config   {  




	import flash.geom.ColorTransform;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;



	/**	
	 * BSS假3D类 之编辑器宏设定 Define
	 * @author blueshell
	 * @version		0.1.1
	 * @date 		22.10.2007
  	 * @MSN blueshell＠live.com
	 * @QQ 87453144
	 */
	public class EdtDEF  { 
		
		//象限的宽
		public static const   QUADRANT_WIDTH   :   int   =   320 ; 
		//象限的高
		public static const   QUADRANT_HEIGHT   :   int   =   320 ; 
		
		//public static const   QUADRANT_X   :   int   =   0 ; 
		//public static const   QUADRANT_Y   :   int   =   40 ; 
		
		public static const   BG_COLOR   :   uint   =   0x999999 ; 
		public static const   GIRD_COLOR   :   uint   =   0xAAAAAA ; 
		
		
		public static const   INFOX   :   int   =   10 ; 
		public static const   INFOY   :   int   =   4 ; 
		
		public static const   POSX   :   int   =   EdtDEF.QUADRANT_WIDTH  - 100 ; 
		public static const   FRESH_TIME   :   int   =   30 ; 
		
		public static const   Z_SCALE   :   int   =   4 ; 
		
		public static const   HOVER_ACCURACY   :   int   =   1 ; 
	//	CONST( HOVER_TIME , uint , 250)
		
		public static const   MAX_CLICK_ACCURACY   :   int   =   30 ; 
		public static const   MIN_CLICK_ACCURACY   :   int   =   2 ; 
		
		public static const   OPERATOR_WIDTH   :   int   =   5 ; 
		public static const   OPERATOR_OPT_OFF   :   int   =   33 ; 
		public static const   OPERATOR_OPT_OFF_WIDTH   :   int   =   EdtDEF.OPERATOR_OPT_OFF +12 ; 
		public static const   OPERATOR_OPT_HALF_HEIGHT   :   int   =   3 ; 
		
		public static const   LINE_SHAPE_DYM_B   :   int   =   0 ; 
		public static const   LINE_SHAPE_B    :   int   =   1 ; 
		public static const   LINE_SHAPE_ALPHA    :   Number   =   0.9 ; 
		

		public static const   MIN_SCALE   :   int   =   4 ; 
		public static const   MAX_SCALE   :   int   =   80 ; 
		
		public static const   MAX_EDT_SCALE   :   int   =   8 ; 
		
	
		public static const   TILE_WIDTH_DIV    :   int  =   3  ; 
		//tile's width and height
		public static const   TILE_WIDTH   :   int   =   (1<< EdtDEF.TILE_WIDTH_DIV )  ; 
		public static const   TILE_WIDTH_MOD    :   int   =   (EdtDEF.TILE_WIDTH -1)  ; 
	} 
} 


