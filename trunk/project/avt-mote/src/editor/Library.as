package editor 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.struct.Texture2D;
	import editor.struct.Texture2DBitmap;
	import editor.ui.SpriteWH;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
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
	public class Library extends Sprite
	{
		private static var s_s : Library;
		public static function getS()
		: Library {
			return s_s;
		}
		private var m_filter : BSSDropDownMenu
		public var item : BSSItemListScrollBar;
		public function Library() 
		{
			
			const W : int = 220;
			const H : int = 400;
			const S : int = 5;
			
			
			var _p : BSSPanel =
			BSSPanel.createSimpleBSSPanel(W , H , 
			  BSSPanel.ENABLE_TITLE|BSSPanel.ENABLE_MOVE|BSSPanel.ENABLE_CLOSE
			);
			
			addChild(_p);
			_p.closeFunction = function( caller : BSSPanel )
			: void {
				visible = false;	
			}
			CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_KEY_DOWN , onKeyDown);
			
			_p.titleText = "Library";
			
			
			
			
			
			
			m_filter = BSSDropDownMenu.createSimpleBSSDropDownMenu(W - S - S, 20 , "ALL" , false);
			
			m_filter.x = S;
			m_filter.y = 20 + S;
			
			var _sb : BSSScrollBar = BSSScrollBar.createSimpleBSSScrollBar(10, false);
			_sb.x = W - 10 - S - S;
			item = new BSSItemListScrollBar(_sb);
			item.x = S;
			item.y = m_filter.y + S + 20;
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
			
			_p.addChild(m_filter);
			
			this.visible = false;
			s_s = this;
		}
		
		public function getList(_type : String) : Vector.<Texture2D>
		{
			var _ret : Vector.<Texture2D> = new Vector.<Texture2D>();
			
			for each(var _t : Texture2D in m_textureList)
			{
				if (_type == _t.type)
					_ret.push(_t);
			}
			
			return _ret;
		}
		private var m_textureList : Vector.<Texture2D> = new Vector.<Texture2D>();
		public function addTexture(_t : Texture2D , test : Boolean = true) : void
		{
			if (test) {
				if (getTexture2D(_t.name , _t.filename , _t.type ))
					return;
			}
			
			
			m_textureList.push(_t);
			
			if (_t.type)
			{
				if (m_filter.getItemIndex(_t.type) == -1)
					m_filter.addItem(_t.type);
			}
			var __item : Sprite = new Sprite;
			var _Texture2DBitmap : Texture2DBitmap = new Texture2DBitmap(_t) 
			_Texture2DBitmap.width = Math.min(100, _Texture2DBitmap.width);
			_Texture2DBitmap.scaleY = _Texture2DBitmap.scaleX;
			
			if (_Texture2DBitmap.width < 100)
				_Texture2DBitmap.x += (100 - _Texture2DBitmap.width) >> 1;
			
			var indi : TextField = new TextField();
			indi.text = _t.name;
			indi.x = 105;
			indi.width = 90;
			indi.height = 24;
			
			var indi2 : TextField = new TextField();
			indi2.text = _t.type;
			indi2.x = indi.x;
			indi2.y = 26;
			indi2.mouseEnabled = false;
			indi2.width = indi.width ;
			
			__item.addChild(_Texture2DBitmap);
			__item.addChild(indi);
			__item.addChild(indi2);
			
			item.addItem(__item);
			
		}
		public function getTexture2DFlip(_name : String):Texture2D
		{
			
			_name += "#FLIP";
			
			_name = _name.replace("#FLIP#FLIP" , "");
			
			for each(var _t : Texture2D in m_textureList)
			{
				if (_name == _t.name)
					return _t;
			}
			
			return null;
		}
		
		public function getTexture2DXML(_xml : XML) :Texture2D
		{
			if (_xml.name.text())
				return getTexture2D(_xml.name.text()
				, _xml.filename ? null : _xml.filename.text()
				, _xml.type.text() , _xml
				);
			else
				return null;
		}
		
		
		public function getTexture2D(_name : String , _filename : String , _type : String , refXML : XML = null):Texture2D
		{
			for each(var _t : Texture2D in m_textureList)
			{
				if (_name == _t.name && _type == _t.type)
				{	
					return _t;
				}
				
			}
			
			if (_filename && refXML)
			for each( _t in m_textureList)
			{
				if (_filename == _t.filename)
				{	
					var _texture : Texture2D = new Texture2D(_t.bitmapData , _name , _filename , _type
						, Number(refXML.rectX.text())
						, Number(refXML.rectY.text())
						, Number(refXML.rectW.text())
						, Number(refXML.rectH.text())
						);
						Library.getS().addTexture(_texture , false);
					return _texture;
				}
			}
			
			return null;
		}
		
		public function onNew():void
		{
			m_textureList = new Vector.<Texture2D>();
			
		}
		private function onKeyDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : KeyboardEvent = args as KeyboardEvent;
			
			if (me.ctrlKey && me.keyCode == 76) //+
			{
				this.visible = true;	
			}
			
			return CallbackCenter.EVENT_OK;
		}
		
		public function dispose():void
		{
			GraphicsUtil.removeAllChildrenWithDispose(this);
			CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_KEY_DOWN , onKeyDown);

			if (parent)
				parent.removeChild(this);
				
			s_s = null;
		}
	}

}