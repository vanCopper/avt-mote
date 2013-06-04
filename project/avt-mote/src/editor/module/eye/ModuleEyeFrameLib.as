package editor.module.eye 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIComponent.BSSDropDownMenu;
	import UISuit.UIComponent.BSSItemListScrollBar;
	import UISuit.UIComponent.BSSScrollBar;
	import UISuit.UIController.BSSPanel;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrameLib  extends Sprite
	{
		
		private var m_btnAdd : BSSButton;
		private var m_btnClone : BSSButton;
		private var m_btnDelete : BSSButton;
		private var m_btnFlip : BSSButton;
		
		public var item : BSSItemListScrollBar;
		public var clickFuntion : Function;
		
		public function ModuleEyeFrameLib() 
		{
			
			const W : int = 220;
			const H : int = 400;
			const S : int = 5;
			
			
			var _p : BSSPanel =
			BSSPanel.createSimpleBSSPanel(W , H , 
			  BSSPanel.ENABLE_TITLE|BSSPanel.ENABLE_MOVE
			);
			
			addChild(_p);
			_p.closeFunction = function( caller : BSSPanel )
			: void {
				visible = false;	
			}
			
			_p.titleText = "Eye Frame Library";
			
			m_btnAdd = BSSButton.createSimpleBSSButton(100 , 20 , "add");
			m_btnClone = BSSButton.createSimpleBSSButton(100 , 20 , "clone");
			m_btnDelete = BSSButton.createSimpleBSSButton(100 , 20 , "delete");
			m_btnFlip = BSSButton.createSimpleBSSButton(100 , 20 , "flip");
						
			m_btnAdd.x = S; m_btnClone.x = m_btnAdd.x + m_btnAdd.width + S; m_btnDelete.x = m_btnClone.x + m_btnClone.width + S; m_btnFlip.x = m_btnDelete.x +m_btnDelete.width + S;
			m_btnAdd.y = m_btnClone.y =  m_btnDelete.y = m_btnFlip.y = 20 + S;
			
			_p.addChild(m_btnAdd);
			_p.addChild(m_btnClone);
			_p.addChild(m_btnDelete);
			_p.addChild(m_btnFlip);
			
			var _sb : BSSScrollBar = BSSScrollBar.createSimpleBSSScrollBar(10, false);
			_sb.x = W - 10 - S - S;
			item = new BSSItemListScrollBar(_sb);
			item.x = S;
			item.y = m_btnAdd.y + S + 20;
			item.height = H - item.y - S;
			item.width = _sb.x - S;
			
			var _itemBg : Shape = new Shape();
			_itemBg.graphics.beginFill(0xFFFFFF , 0.75);
			_itemBg.graphics.lineStyle(1, 0);
			_itemBg.graphics.drawRect(0, 0, item.width, item.height);
			_itemBg.x = item.x;
			_itemBg.y = item.y;
			
			_p.addChild(_itemBg);
			_p.addChild(item);
			
			m_btnAdd.releaseFunction = onAdd;
			m_btnDelete.releaseFunction = onDelete;
			m_btnClone.releaseFunction = onClone;
			m_btnFlip.releaseFunction = onFlip;
			
			m_btnClone.deactivate(); m_btnClone.alpha = 0.5;
			m_btnDelete.deactivate(); m_btnDelete.alpha = 0.5;
			m_btnFlip.deactivate(); m_btnFlip.alpha = 0.5;
		}
		
		private function onFlip(btn:BSSButton):void
		{
			if (m_currentItemContainer) 
			{
				var _oldData : ModuleEyeFrame = (m_currentItemContainer.getChildAt(0) as ModuleEyeFrameSprite).data;
				addTexture(_oldData.flipData() , (m_currentItemContainer.getChildAt(1) as TextField).text+"#FLIP" , true);
			}
		}
		
		private function onClone(btn:BSSButton):void
		{
			if (m_currentItemContainer) 
			{
				var _oldData : ModuleEyeFrame = (m_currentItemContainer.getChildAt(0) as ModuleEyeFrameSprite).data;
				addTexture(_oldData.cloneData() , (m_currentItemContainer.getChildAt(1) as TextField).text+"#COPY" , true);
			}
		}
		
		
		
		private function onDelete(btn:BSSButton):void
		{
			if (m_currentItemContainer)
			{
				if (clickFuntion != null)
					clickFuntion(null , null , null);
				
				item.removeItem(m_currentItemContainer);
				
				m_currentItemContainer = null;
				
				m_btnClone.deactivate(); m_btnClone.alpha = 0.5;
				m_btnDelete.deactivate(); m_btnDelete.alpha = 0.5;
				m_btnFlip.deactivate(); m_btnFlip.alpha = 0.5;
			}
			
		}
		
		private function onAdd(btn:BSSButton):void 
		{
			addTexture(new ModuleEyeFrame());
		}
		
		private var m_frameList : Vector.<ModuleEyeFrame> = new Vector.<ModuleEyeFrame>();
		public function addTexture(_t : ModuleEyeFrame , a_name : String = null , clickAtAdd : Boolean = false ) : void
		{
			m_frameList.push(_t);
			
			var __item : ItemContainer = new ItemContainer;
			__item.clickFuntion = onClick;
			
			var __frame : ModuleEyeFrameSprite = _t.createSprite();
			__frame.refresh();
			__frame.fitPos(84 , 84 , 8 , 8);
			
			__item.addChild(__frame);
			
			//__frame.width = Math.min(100, __frame.width);
			
			//if (__frame.width < 100)
			//	__frame.x += (100 - __frame.width) >> 1;
			
			var indi : TextField = new TextField();
			indi.text = a_name ? a_name : "Frame" + (m_frameList.length - 1);
			indi.x = 105;
			indi.width = 90;
			indi.height = 24;
			indi.type = TextFieldType.INPUT;
			__item.addChild(indi);
			
			item.addItem(__item);
			
			if (clickAtAdd)
				onClick(__item);
			
		}
		private var m_currentItemContainer : ItemContainer;
		//private var m_currentItemContainerFilter : Array = [new GlowFilter(0xFFFFFF00)];
		
		private function onClick(__item:ItemContainer):void 
		{
			if (m_currentItemContainer)
			{
				m_currentItemContainer.setNormal();
				m_currentItemContainer = null;
			}
			
			m_currentItemContainer = __item;
			if (m_currentItemContainer)
				m_currentItemContainer.setClick();
			
			m_btnClone.activate(); m_btnClone.alpha = 1;
			m_btnDelete.activate(); m_btnDelete.alpha = 1;
			m_btnFlip.activate(); m_btnFlip.alpha = 1;
			
			
			
			if (clickFuntion != null)
				clickFuntion(__item , __item.getChildAt(0) as ModuleEyeFrameSprite , (__item.getChildAt(1) as TextField).text);
			
			
			
		}
		public function onNew():void
		{
			m_frameList = new Vector.<ModuleEyeFrame>();
		}

		
		public function dispose():void
		{
			GraphicsUtil.removeAllChildrenWithDispose(this);

			if (parent)
				parent.removeChild(this);
			m_currentItemContainer = null;	
		}
		
	}

}
import flash.display.Sprite;
import flash.events.MouseEvent;

class ItemContainer extends Sprite {
	
	public var clickFuntion : Function;
	public function ItemContainer()
	{
		addEventListener(MouseEvent.CLICK , onClick);
		setNormal();
		
		buttonMode = true;
	}
	public function setNormal():void
	{
		graphics.clear();
		graphics.lineStyle(1, 0x0000FF, 0.25);
		graphics.beginFill(0xAAAAFF, 0.25);
		graphics.drawRect(5, 5, 95, 95);
	}
	
	public function setClick():void
	{
		graphics.clear();
		graphics.lineStyle(1, 0xFF8000, 0.5);
		graphics.beginFill(0xFFFF00, 0.25);
		graphics.drawRect(5, 5, 95, 95);
	}
	
	private function onClick(e:MouseEvent):void 
	{
		if (clickFuntion != null)
			clickFuntion(this);
	}
	
	
	public function dispose():void
	{
		removeEventListener(MouseEvent.CLICK , onClick);
	}
	
}
