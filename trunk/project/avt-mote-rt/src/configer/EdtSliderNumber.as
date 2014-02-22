package configer
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIComponent.BSSSlider;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtSliderNumber extends Sprite
	{
		private var _text : TextField;
		private var _tip:String;
		private var _value:Number;
		private var m_slider : BSSSlider;
		private var m_min : Number;
		private var m_max : Number;
		
		public var okFunction : Function ;
		public var changeFunction : Function ;
		public var intVer : Boolean = false;
		
		public function get tip() : String
		{
			return _tip;
		}
		
		public function get value() : Number
		{
			return _value;
			//if (intVer)
			//	return int(_text.text);
			//else
			//	return Number(_text.text);
		}
		private function setThumbValue(v : Number): void
		{
			if (v < m_min)
				m_slider.setThumbValue(0, m_min);
			else if (v > m_max)
				m_slider.setThumbValue(0, m_max);
			else
				m_slider.setThumbValue(0, v);
		}
		public function set value(v : Number) : void
		{
			if (intVer)
			{
				_value = int(v);
				_text.text = ""+int(v);
				setThumbValue(int(v));

			}
			else {
				_value = v;
				_text.text = ""+v;
				setThumbValue(v);
			}
			
		}
		
		public function EdtSliderNumber(min : Number, max : Number , a_tip : String)
		{
			_tip = a_tip;
			m_min = min ;
			m_max = max;
			var _btn:BSSButton;
			
			var shape : Shape;
			
			
			var g : Graphics;
			var btnCtar : Sprite = new Sprite();
			
			shape = new Shape();
			g = shape.graphics;
			g.lineStyle(1, 0xFFFF00 , 0.25);
			g.beginFill(0xFF9999 , 0.7 )
			g.moveTo( 0, 0);
			g.lineTo( -5, 10);
			g.lineTo( +5, 10);
			g.lineTo( 0, 0);
			btnCtar.addChild(shape);
			
			shape = new Shape();
			g = shape.graphics;
			g.lineStyle(1, 0xFFFF00 , 0.50);
			g.beginFill(0xFF6666 , 0.9 )
			g.moveTo( 0, 0);
			g.lineTo( -5, 10);
			g.lineTo( +5, 10);
			g.lineTo( 0, 0);
			btnCtar.addChild(shape);
			
			
			shape = new Shape();
			g = shape.graphics;
			g.lineStyle(1, 0x4444FF , 0.90);
			g.beginFill(0xDDDDFF , 0.9 )
			g.moveTo( 0, 0);
			g.lineTo( -5, 10);
			g.lineTo( +5, 10);
			g.lineTo( 0, 0);
			btnCtar.addChild(shape);
			
			
			_btn = new BSSButton(btnCtar);
			
			m_slider = BSSSlider.createSimpleBSSSlider(true, _btn, 0, 200, min, max);
			m_slider.x  = 10;
			m_slider.y = 10;
			addChild(m_slider);
			
			m_slider.dragFunction = onChange;
			m_slider.changeFunction = onChangeDone;
			var lastX : int = m_slider.x + m_slider.width + 5;
			
			if (a_tip)
			{
				_text = new TextField();
				_text.width = 200;
				_text.height = 20;
				_text.background = false;
				_text.border = false;
				_text.x = 0;
				_text.y = -10;
				_text.mouseEnabled = false;
				addChild(_text);
				_text.text = a_tip;
			}
			
			_text = new TextField();
			_text.width = 50;
			_text.height = 20;
			_text.background = true;
			_text.border = true;
			_text.x = lastX;
			_text.y = 5;
			_text.type = "input";
			_text.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			//_text.mouseEnabled = false;
			
			
			addChild(_text);
			
			reset();
			
			
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
		
			if ( e.keyCode == Keyboard.ENTER ) {
				var v : Number = Number(_text.text);
				if (isNaN(v))
					_text.text = "" + _value;
				else
				{	
					value = v;
					if (changeFunction != null)
					{
						if (changeFunction.length == 2)
							changeFunction(this , value);
						else
							changeFunction(value);
					}
				}
			}
		}
		
		public function deactivate():void
		{
			m_slider.deactivate();
			alpha = 0.5;
			
		}
		public function activate():void
		{
			m_slider.activate();
			alpha = 1;
		}
		
		private function onChangeDone(_slider : BSSSlider):void
		{
			if (intVer) {
				m_slider.setThumbValue(0, _value ,true);
			}
		}
		private function onChange(_slider : BSSSlider):void
		{
			if (intVer)
				_value = int(_slider.getThumbValue(0));
			else
				_value = Number(_slider.getThumbValue(0));
				
			_text.text = "" + _value;
			
			
			
			if (changeFunction != null)
			{
				if (changeFunction.length == 2)
					changeFunction(this , value);
				else
					changeFunction(value);
			}
		}
		public function reset():void
		{
			m_slider.setThumbValue(0 , m_min);
			if (intVer)
				_text.text = "" + int(m_min);
			else
				_text.text = "" + Number(m_min);
		}
		
		public function dispose():void
		{
			GraphicsUtil.removeAllChildrenWithDispose(this);
			
			okFunction = null;
			changeFunction = null;
			
			_text.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_text = null;
			m_slider = null;
		}
		
	}

}