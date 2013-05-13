package   UISuit.UIComponent   {  
	import  flash.events.* ; 	
	import  flash.text.* ; 	
	import  flash.display.* ; 	
	/**
	 * ...
	 * @author blueshell
	 */
	public class BSSItemListScrollBar extends BSSItemList
	{
		private var m_scrollBar : BSSScrollBar;
		private var m_scrollBarYOffset : int;
		public var alwaysShowScrollBar : Boolean;
		public var edgeSize : int;

		public function BSSItemListScrollBar(_scrollBar : BSSScrollBar , _scrollBarYOffset  : int = 0) 
		{
			m_scrollBar = _scrollBar;
			m_scrollBarYOffset = _scrollBarYOffset;
			if (m_scrollBar)
			{	
				addChild(m_scrollBar);
				m_scrollBar.changeFunction = onScrollBarChange;
				m_scrollBar.visible = (false);
			}
			
			addEventListener(FocusEvent.FOCUS_IN, setWheelFocus ); 
			addEventListener(FocusEvent.FOCUS_OUT, resetWheelFocus );
		}
		
		private  function setWheelFocus  (e : FocusEvent ) : void {BSSScrollBar.BSSScrollBar_setWheelFocusBSSScrollBar(m_scrollBar) ; }
        private  function resetWheelFocus (e : FocusEvent ) : void {BSSScrollBar.BSSScrollBar_resetWheelFocusBSSScrollBar(m_scrollBar);}
		
		override public function dispose()	: void 
		{
			removeEventListener(FocusEvent.FOCUS_IN, setWheelFocus ); 
			removeEventListener(FocusEvent.FOCUS_OUT, resetWheelFocus );
			
			super.dispose();
			
			CONFIG::DEBUG {
				trace("BSSItemListScrollBar dispose");
			}
			
			
			if (m_scrollBar)
			{
				m_scrollBar.dispose();
				m_scrollBar = null;
			}
		}
		
		static private function onScrollBarChange( bsssb : BSSScrollBar )
		: void
		{
			var _this : BSSItemListScrollBar  = (BSSItemListScrollBar)(bsssb.parent);
			_this.m_itemContainer.y = -(bsssb.getContentData());
		}
		public var heightMode : Boolean = true;
		
		override public function freshItem()
		: void
		{
			super.freshItem();
			
			if (m_scrollBar)
			{	
				var yBack : int =  m_itemContainer.y;
				if (heightMode)
				{
					var dsp : DisplayObject = m_itemContainer.getChildAt(m_itemContainer.numChildren - 1);
					m_scrollBar.setContentHeight(0 , dsp.y + dsp.height + 1);

					m_itemContainer.y = (m_scrollBar.height >= dsp.y + dsp.height + 1) ? 0 :  yBack;
				}
				else
					m_scrollBar.setContentHeight(0 , m_itemContainer.height);
				
				
				if (m_scrollBar.getIsActive())
				{	
					m_scrollBar.visible = (true);
				}
				
				
			}
		}
		
		override public function addItem(item : DisplayObject )
		: void
		{
			super.addItem(item);
			if (m_scrollBar)
			{	
				//var m : DisplayObject = m_itemContainer.mask;
				//m_itemContainer.mask = null;
				//trace(m_itemContainer.height);
				//
				if (heightMode)
				{
					var dsp : DisplayObject = m_itemContainer.getChildAt(m_itemContainer.numChildren - 1);
					m_scrollBar.setContentHeight(0 , dsp.y + dsp.height + 1);
				}
				else
					m_scrollBar.setContentHeight(0 , m_itemContainer.height);
				//m_itemContainer.mask = m;
				
				if (m_scrollBar.getIsActive())
				{	
					m_scrollBar.visible = (true);
				}
				
			}
		}

		override public function clearAllItem(_disposeItem : Boolean = false)
		: void 
		{
			super.clearAllItem(_disposeItem);
			if (m_scrollBar)
			{	
				m_scrollBar.setContentHeight(0 , 0);
				if (!alwaysShowScrollBar)
					m_scrollBar.visible = (false);
			}
		}

		override public function set height(h : Number)
		: void 
		{
			//var heightOff : Number =  h - height ;
			super.height = h;
			if (m_scrollBar)
				m_scrollBar.height = h + m_scrollBarYOffset;

			m_scrollBar.visible = (m_scrollBar.getIsActive());
		}
	}

}