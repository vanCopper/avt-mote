package editor.ui 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantIndicate extends Sprite
	{
		
		public function EdtQuadrantIndicate() 
		{
			
		}
		private var m_moveIndicate : EdtMoveIndicate;
		
		
		public function set moveIndicate(dsp : EdtMoveIndicate) : void
		{
			m_moveIndicate = dsp;
			addChild(dsp);
		}
		
		private var m_selectorIndicate : EdtSelector;
		public function set selectorIndicate(dsp : EdtSelector) : void
		{
			m_selectorIndicate = dsp;
			addChild(dsp);
		}
		
		public function dispose():void
		{
			m_moveIndicate = null;
			m_selectorIndicate = null;
			GraphicsUtil.removeAllChildrenWithDispose(this);
			
			if (parent)
				parent.removeChild(this);
		}
		
		public static const VIEW_CONTROL : int = 1;
		public static const SELECT_POINT : int = 2;
		public static const NONE : int = -1;
		
		public function set mode(_v : int) : void
		{
			if (m_moveIndicate)
				m_moveIndicate.visible = _v == VIEW_CONTROL;
			if (m_selectorIndicate)
				m_selectorIndicate.visible = _v == SELECT_POINT;	
		}
		
		
		
		
	}

}