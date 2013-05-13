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
		}
		
		override public function dispose()	: void 
		{
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
		
		override public function addItem(item : DisplayObject )
		: void
		{
			super.addItem(item);
			if (m_scrollBar)
			{	
				//var m : DisplayObject = m_itemContainer.mask;
				//m_itemContainer.mask = null;
				//trace(m_itemContainer.height);
				m_scrollBar.setContentHeight(0 , m_itemContainer.height + m_offsetY + edgeSize);
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