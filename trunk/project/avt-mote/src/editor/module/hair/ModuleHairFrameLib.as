package editor.module.hair 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
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
	public class ModuleHairFrameLib  extends Sprite
	{
		
		public var item : BSSItemListScrollBar;
		public var clickFuntion : Function;
		
		public function ModuleHairFrameLib() 
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
			
			_p.titleText = "Hair Frame Library";
			
			
			
			var _sb : BSSScrollBar = BSSScrollBar.createSimpleBSSScrollBar(10, false);
			_sb.x = W - 10 - S - S;
			item = new BSSItemListScrollBar(_sb);
			item.x = S;
			item.y = /*m_btnAdd.y*/ S + 20;
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
			
		}
		
		private function deactivateLibButton():void
		{
			
		}
				
		public function clearSelect():void
		{
			if (m_currentItemContainer)
			{
				m_currentItemContainer.setNormal();
				if (clickFuntion != null)
					clickFuntion(null , null , null);
				m_currentItemContainer = null;
			}
		}
		
		
		public function getModuleEyeFrameData(_v : String) : ModuleHairFrame
		{
			for each (var mef : ModuleHairFrame in m_frameList)
			{
				if (mef.name == _v)
					return mef;
			}
			
			return null;
		}
		
	
		private var m_frameList : Vector.<ModuleHairFrame> = ModuleHairData.s_frameList;
		public function addTexture(_t : ModuleHairFrame , a_name : String , clickAtAdd : Boolean = false ) : void
		{
			for each (var _oldData : ModuleHairFrame in m_frameList)
			{
				if (_oldData.texture == _t.texture)
				{
					return;
				}
			}
				
			m_frameList.push(_t);
			
			
			
			var __frame : ModuleHairFrameSprite = _t.createSprite();
			__frame.refresh();
			__frame.fitPos(84 , 84 , 8 , 8);
			
			
			//__frame.width = Math.min(100, __frame.width);
			
			//if (__frame.width < 100)
			//	__frame.x += (100 - __frame.width) >> 1;
			
			var indi : TextField = new TextField();
			indi.text = a_name ? a_name : "Frame" + (m_frameList.length - 1);

			indi.x = 105;
			indi.width = 90;
			indi.height = 24;
			//indi.type = TextFieldType.INPUT;
			
			var __item : ItemContainer = new ItemContainer(__frame , indi);
			__item.clickFuntion = onClick;
			item.addItem(__item);
			
			_t.name = indi.text;
			
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
			

			if (clickFuntion != null)
				clickFuntion(__item , __item.mef , __item.indi.text);
			
			
			
		}
		public function onNew():void
		{
			m_frameList.length = 0;
			if (item) item.clearAllItem(true);
			deactivateLibButton();
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
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import editor.module.hair.*;

class ItemContainer extends Sprite {
	
	public var clickFuntion : Function;
	public var changeFuntion : Function;
	
	public var indi : TextField;
	public var mef : ModuleHairFrameSprite;
	
	
	public function ItemContainer(a_mef : ModuleHairFrameSprite , a_indi : TextField)
	{
		addEventListener(MouseEvent.CLICK , onClick);
		mef = a_mef;
		indi = a_indi;
		
		indi.addEventListener(Event.CHANGE , onChange);
		
		addChild(mef);
		addChild(indi);
		
		
		setNormal();
		
		buttonMode = true;
	}
	
	private function onChange(e:Event):void 
	{
		if (mef.data)
			mef.data.name = indi.text; 

		if (changeFuntion != null )
		{
			changeFuntion();
		}
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
		indi.removeEventListener(Event.CHANGE , onChange);
		
		indi = null;
		mef = null;
		
	}
	
}
