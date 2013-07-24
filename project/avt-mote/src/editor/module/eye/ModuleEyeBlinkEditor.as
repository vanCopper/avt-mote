package editor.module.eye 
{
	import editor.ui.EdtAddUI;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleEyeBlinkEditor extends Sprite
	{
		private var m_eyeBlinkAddUI : EdtAddUI;
		private var m_lc : SimpleTL;
		private var m_lo : SimpleTL;
		private var m_rc : SimpleTL;
		private var m_ro : SimpleTL;
		private var m_player : ModuleEyeBlinkPlayer;
		
		

		
		
		
		public function ModuleEyeBlinkEditor() 
		{
			
			var tf : TextField = new  TextField();
			tf.mouseEnabled = false;
			tf.text = "frame length";
			addChild(tf);
			
			m_eyeBlinkAddUI = new EdtAddUI(1, 10);
			m_eyeBlinkAddUI.changeFunction = onBlinkAddChanged;
			m_eyeBlinkAddUI.okFunction = onBlinkAddOK;
			m_eyeBlinkAddUI.y = 25;
			
			
			
			addChild(m_eyeBlinkAddUI);
			
			
			m_lc = new SimpleTL;
			m_lo = new SimpleTL;
			m_rc = new SimpleTL;
			m_ro = new SimpleTL;
			
			var _arr : Array = [m_lc , m_lo , m_rc , m_ro];
			
			for (var i : int = 0 ; i < 4 ; i++ )
			{
				tf = new  TextField();
				tf.mouseEnabled = false;
				tf.text = ["左闭眼","左睁眼","右闭眼","右睁眼"][i];
				_arr[i].y = tf.y = 70 + i * 40;
				addChild(tf);
			}
			
			addChild(m_lc);
			addChild(m_lo);
			addChild(m_rc);
			addChild(m_ro);
			
			m_lc.setLength(m_eyeBlinkAddUI.value);
			m_lo.setLength(m_eyeBlinkAddUI.value);
			m_rc.setLength(m_eyeBlinkAddUI.value);
			m_ro.setLength(m_eyeBlinkAddUI.value);
			
			
			m_lc.x = m_lo.x = m_rc.x = m_ro.x = 80;
			
			m_player = new ModuleEyeBlinkPlayer();
			addChild(m_player);
			m_player.x = 400;
			m_player.y = 300;
			
			m_player.reset();
		}
		
		private function onBlinkAddOK(v:int):void
		{
			
		}
		
		private function onBlinkAddChanged(v:int):void
		{
			m_lc.setLength(v);
			m_lo.setLength(v);
			m_rc.setLength(v);
			m_ro.setLength(v);
			
			m_player.reset();
			
			refreshPlayer();
		}
		
		public function dispose():void
		{
			if (m_eyeBlinkAddUI)
			{
				m_eyeBlinkAddUI.dispose();
				m_eyeBlinkAddUI = null;
			}
		}
		private function refreshPlayer():void
		{
			m_player.leftAnime.length = 0;
			m_player.rightAnime.length = 0;
			
			for each (var _btn : BSSButton in m_lc.btnArray)
			{
				if (_btn.numChildren == 5)
				{
					var _sp : ModuleEyeFrameSprite = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					 m_player.leftAnime.push(_sp.data );
				}
				else
				{
					m_player.leftAnime.push(null );
				}
			}
			for each (_btn in m_lo.btnArray)
			{
				if (_btn.numChildren == 5)
				{
					 _sp = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					 m_player.leftAnime.push(_sp.data );
				}
				else
				{
					m_player.leftAnime.push(null );
				}
			}
			
			for each (_btn in m_rc.btnArray)
			{
				if (_btn.numChildren == 5)
				{
					 _sp = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					 m_player.rightAnime.push(_sp.data );
				}
				else
				{
					m_player.rightAnime.push(null );
				}
			}
			for each (_btn in m_ro.btnArray)
			{
				if (_btn.numChildren == 5)
				{
					 _sp = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					 m_player.rightAnime.push(_sp.data );
				}
				else
				{
					m_player.rightAnime.push(null );
				}
			}
			
			m_player.reset();
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
				_btn.text = _name ? _name : "";
				
				if (mefs && mefs.data)
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
						
						if (_btn == m_lc.btnArray[0])
							ModuleEyeData.s_frameL = mefs.data;
						else if (_btn == m_rc.btnArray[0])
							ModuleEyeData.s_frameR = mefs.data;
						
						
					}
				}
				
				refreshPlayer();
			}
		}
		
		private function genArrayXML(arr : Array):String
		{
			var strVect : Vector.<String> = new Vector.<String>();
			for each (var _btn : BSSButton in arr)
			{
				if (_btn.numChildren == 5)
				{
					var _sp : ModuleEyeFrameSprite = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					if (_sp)
					{	
						if (_sp.data)
							strVect.push(_sp.data.name ? _sp.data.name : "");
						else
							strVect.push("");
					}
					else
					{
						strVect.push("");
					}
				}
				else {
					strVect.push("");
				}
			}
			
			return "<frame>" + strVect.join("</frame><frame>") + "</frame>";
			
		}
		
		
		
		public function fromXMLString(s:XML):void
		{
			m_eyeBlinkAddUI.value = int(s.EyeBlinkLength.text());
			onBlinkAddChanged(m_eyeBlinkAddUI.value);
			
			
			fromArrayXML(s.lc.frame , m_lc);
			fromArrayXML(s.lo.frame , m_lo);
			fromArrayXML(s.rc.frame , m_rc);
			fromArrayXML(s.ro.frame , m_ro);
			
		}
		public function loadFrame(getFunc : Function):void
		{
			for each (var _btn : BSSButton in SimpleTL.s_btnArray)
			{
				if (_btn.numChildren == 5)
				{
					var _sp : ModuleEyeFrameSprite = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					if (_sp)
						_sp.dispose();
				}
				
				if (_btn.numChildren == 4 && _btn.text && getFunc != null)
				{
					var mef : ModuleEyeFrame = getFunc(_btn.text);
					
					if (mef)
					{
						_sp = mef.createSprite();
						_sp.height = 28;
						_sp.scaleX = _sp.scaleY;
						_sp.x = _btn.width - _sp.width;
						_sp.y = 1;
						
						_btn.addChild(_sp);
						
						if (_btn == m_lc.btnArray[0])
							ModuleEyeData.s_frameL = mef;
						else if (_btn == m_rc.btnArray[0])
							ModuleEyeData.s_frameR = mef;
						
					}
				}
			}
			
			
			refreshPlayer();
		}
		
		private function fromArrayXML(xml : XMLList , _lc : SimpleTL):void
		{
			var _i : int;
			for each (var _btn : BSSButton in _lc.btnArray)
			{
				_btn.text = xml[_i].text();
				 _i++;
			}
		}
		
		
		private function genArrayBA(ba:ByteArray , arr : Array) : void
		{
			for each (var _btn : BSSButton in arr)
			{
				if (_btn.numChildren == 5)
				{
					var _sp : ModuleEyeFrameSprite = _btn.getChildAt(4) as  ModuleEyeFrameSprite;
					if (_sp)
					{	
						if (_sp.data)
						{	
							ba.writeByte(ModuleEyeData.getModuleEyeFrameIndex(_sp.data.name));
						}
						else
							ba.writeByte( -1);
					}
					else
					{
						ba.writeByte( -1);
					}
				}
				else {
					ba.writeByte( -1);
				}
			}
			
			
		}
		
		public function encode(ba:ByteArray):void
		{
			ba.writeByte(m_eyeBlinkAddUI.value);
			genArrayBA(ba, m_lc.btnArray);
			genArrayBA(ba, m_lo.btnArray);
			genArrayBA(ba, m_rc.btnArray);
			genArrayBA(ba, m_ro.btnArray);
			
		}
		
		
		public function toXMLString():String
		{
			var str : String = "<ModuleEyeBlink>";
			str += "<EyeBlinkLength>" + m_eyeBlinkAddUI.value + "</EyeBlinkLength>";
			
			str += "<lc>";
				str += genArrayXML(m_lc.btnArray);
			str += "</lc>";
			
			str += "<lo>";
				str += genArrayXML(m_lo.btnArray);
			str += "</lo>";
			
			str += "<rc>";
				str += genArrayXML(m_rc.btnArray);
			str += "</rc>";
			
			str += "<ro>";
				str += genArrayXML(m_ro.btnArray);
			str += "</ro>";
			
			str += "</ModuleEyeBlink>";
			
			return str;
		}
		public function deactivate():void
		{
			m_player.reset();
			m_player.deactivate();
		}
		public function activate():void
		{
			m_player.reset();
			m_player.activate();
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