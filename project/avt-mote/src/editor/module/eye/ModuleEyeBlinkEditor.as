package editor.module.eye 
{
	import editor.ui.EdtAddUI;
	import flash.display.Sprite;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleEyeBlinkEditor extends Sprite
	{
		private var m_eyeBlinkAddUI : EdtAddUI;
		private var m_lc : SimpleTL;
		private var m_lu : SimpleTL;
		private var m_rc : SimpleTL;
		private var m_ru : SimpleTL;
		
		public function ModuleEyeBlinkEditor() 
		{
			
			var tf : TextField = new  TextField();
			tf.mouseEnabled = false;
			tf.text = "frame length";
			addChild(tf);
			
			m_eyeBlinkAddUI = new EdtAddUI(1, 15);
			m_eyeBlinkAddUI.changeFunction = onBlinkAddChanged;
			m_eyeBlinkAddUI.okFunction = onBlinkAddOK;
			m_eyeBlinkAddUI.y = 25;
			
			
			
			addChild(m_eyeBlinkAddUI);
			
			
			m_lc = new SimpleTL;
			m_lu = new SimpleTL;
			m_rc = new SimpleTL;
			m_ru = new SimpleTL;
			
			var _arr : Array = [m_lc , m_lu , m_rc , m_ru];
			
			for (var i : int = 0 ; i < 4 ; i++ )
			{
				tf = new  TextField();
				tf.mouseEnabled = false;
				tf.text = ["左闭眼","左睁眼","右闭眼","右睁眼"][i];
				_arr[i].y = tf.y = 70 + i * 40;
				addChild(tf);
			}
			
			addChild(m_lc);
			addChild(m_lu);
			addChild(m_rc);
			addChild(m_ru);
			
			m_lc.setLength(m_eyeBlinkAddUI.value);
			m_lu.setLength(m_eyeBlinkAddUI.value);
			m_rc.setLength(m_eyeBlinkAddUI.value);
			m_ru.setLength(m_eyeBlinkAddUI.value);
			
			
			m_lc.x = m_lu.x = m_rc.x = m_ru.x = 80;
		}
		
		private function onBlinkAddOK(v:int):void
		{
			
		}
		
		private function onBlinkAddChanged(v:int):void
		{
			m_lc.setLength(v);
			m_lu.setLength(v);
			m_rc.setLength(v);
			m_ru.setLength(v);
		}
		
		public function dispose():void
		{
			if (m_eyeBlinkAddUI)
			{
				m_eyeBlinkAddUI.dispose();
				m_eyeBlinkAddUI = null;
			}
		}
		
		public function setFrame(mefs : ModuleEyeFrameSprite , _name : String):void
		{
			for each (var _btn : BSSButton in SimpleTL.s_btnArray)
			{
				if (_btn.getState() == BSSButton.SBST_PRESS)
				{
					break;
				}
			}
			
			if (_btn.getState() == BSSButton.SBST_PRESS)
			{
				_btn.text = _name;
				
				if (mefs.data)
				{
					if (_btn.numChildren == 5)
					{
						var _sp : ModuleEyeFrameSprite = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
						if (_sp)
							_sp.dispose();
					}
					
					if (_btn.numChildren == 4)
					{
						_sp = mefs.data.createSprite();
						_sp.height = 28;
						_sp.scaleX = _sp.scaleY;
						_sp.x = _btn.width - _sp.width;
						_sp.y = 1;
						
						_btn.addChild(_sp);
					}
				}
				
			}
		}
		
		public function refresh():void
		{
			for each (var _btn : BSSButton in SimpleTL.s_btnArray)
			{
				if (_btn.numChildren == 5)
				{
					var _sp : ModuleEyeFrameSprite = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					if (_sp)
					{	
						_btn.text = _sp.data.name;
						_sp.refresh();
					}
				}
			}
		}
	}

}
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import UISuit.UIComponent.BSSButton;
import UISuit.UIUtils.GraphicsUtil;
import editor.module.eye.*;


class SimpleTL extends Sprite
{
	public var btnArray : Array = [];
	public static var s_btnArray : Array = [];
	
	public function SimpleTL()
	{
		
	}
	public static function createSimpleBSSButton(w : int , h : int ,hitString : String = null, autoWidth : Boolean = true , _areaArray : Array  = null )
	: BSSButton {
		var doc : Sprite = new Sprite();
		var shape : Shape = new Shape();
		//var g : Graphics = spahe.graphics;
		GraphicsUtil.DrawRect( shape.graphics , 0 , 0 , w, h , 0xFFFFFF , 0.7 , 0 ,0 ,0.75  );
		doc.addChild (shape);

		shape = new Shape();
		GraphicsUtil.DrawRect( shape.graphics , 0 , 0 , w, h , 0xFFFFFF , 0.9 , 0 ,0 ,0.9  );
		doc.addChild (shape);

		shape = new Shape();
		GraphicsUtil.DrawRect( shape.graphics , 0 , 0 , w, h , 0x62B0FF , 0.4 ,  0 , 0xFF0000 ,0.8  );
		doc.addChild (shape);

		if (hitString != null)
		{
			var textField : TextField = new TextField();
			
			textField.width = w;
			textField.height = 20;
			textField.y = (h-20) >> 1
			
			var tft : TextFormat = new TextFormat();
			tft.align = TextFormatAlign.LEFT;
			textField.defaultTextFormat = tft;
			
			textField.text = hitString;
			doc.addChild (textField);
			
			
		}
		
		return (new BSSButton (doc , hitString , autoWidth , _areaArray)); 
	}
	public function setLength(v:int):void
	{
		while (btnArray.length < v)
		{
			var btn : BSSButton = createSimpleBSSButton(98, 28, "", false, s_btnArray);
			btn.statusMode = true;
			btn.x = btnArray.length * 100;
			btnArray.push(btn);
			addChild(btn);
		}
		
		while (btnArray.length > v)
		{
			btn = btnArray.pop() as BSSButton;
			if (btn.numChildren == 5)
			{
				var _sp : ModuleEyeFrameSprite = btn.getChildAt(4) as  ModuleEyeFrameSprite;
				if (_sp)
					_sp.dispose();
			}
			btn.dispose();
		}
	}
	
	public function dispose():void
	{
		setLength(0);
		btnArray = null;
	}
	
}