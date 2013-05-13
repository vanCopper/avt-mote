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
		private var _selected : int = -1;
		private var _id : int ;
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
		public function set mode (s : int) : void {
			_selected = s;
		//	trace (_selected);
			if (_selected == 1)
				this.transform.colorTransform = EdtSET.DOT_SELECT;
			else if (_selected == 0)
				this.transform.colorTransform = EdtSET.DOT_RELEASE;
			else
				this.transform.colorTransform = EdtSET.DOT_UNSELECT;
			
		}
		public function set hide (isHide : Boolean) : void {
			this.visible = !isHide;
		}
		public function get hide () : Boolean {
			return !this.visible;
		}
				
	}
}
