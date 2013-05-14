package editor.ui {
	
	import flash.display.Shape;
	import editor.config.*;
	
	/**	
	 * BSS¼Ù3DÀà Ö®±à¼­Æ÷ µã
	 * @author blueshell
	 * @version		0.1.1
	 * @date 		22.10.2007
  	 * @MSN blueshell£Àlive.com
	 * @QQ 87453144
	 */
	public class EdtDot extends Shape {
		private var _selected : Boolean = false;
		private var _id : int ;
		private var _mode : int ;
		
		//var xS : Number ;
		//var yS : Number ;
		
		public function EdtDot() {
			
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(-2, -2, 4, 4);
			this.graphics.endFill();
			
	//		addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
	//		addEventListener(MouseEvent.MOUSE_DOWN, _onMousePress);
	//		addEventListener(MouseEvent.MOUSE_UP, _onMouseRelease);

		}
		
	/*	public function _onMouseRelease(event : MouseEvent) : void {
			_selected  = false;
		}

		public function _onMouseMove(event : MouseEvent) : void {
			trace (_id);
		}

		public function _onMousePress(event : MouseEvent) : void {
			_selected  = true;
			
		}
	*/	
	
		public function get selected () : Boolean {
			return (_selected == 1);
		}
		
		public static const DOT_NORMAL_MODE : int = 0;
		public static const DOT_SELECTED_MODE : int = 1;
	
		public static const DOT_SELECTING_MODE : int = 2;
		public static const DOT_UNSELECTING_MODE : int = 3;
		
		public function get mode() : int { return _mode; }
		public function set mode (s : int) : void {
			
			_mode = s;
		//	trace (_selected);
			if (s == DOT_SELECTED_MODE)
			{	
				this.transform.colorTransform = EdtSET.DOT_SELECTED;
				_selected = true;
			}
			else if (s == DOT_SELECTING_MODE)
				this.transform.colorTransform = EdtSET.DOT_SELECTING;
			else  if (s == DOT_UNSELECTING_MODE)
				this.transform.colorTransform = EdtSET.DOT_UNSELECTING;
			else if (s == DOT_NORMAL_MODE)
			{	
				_selected = false;
				
				this.transform.colorTransform = EdtSET.DOT_NORMAL;
			}
		}
		public function set hide (isHide : Boolean) : void {
			this.visible = !isHide;
		}
		public function get hide () : Boolean {
			return !this.visible;
		}
				
	}
}
