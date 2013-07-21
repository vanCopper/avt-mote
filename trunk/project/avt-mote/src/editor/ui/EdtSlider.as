package editor.ui 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIComponent.BSSSlider;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtSlider extends Sprite
	{
		private var _text : TextField;
		private var m_slider : BSSSlider;
		private var m_min : int;
		
		public var okFunction : Function ;
		public var changeFunction : Function ;
		
		public function get value() : int
		{
			return int(_text.text);
		}
		public function set value(v : int) : void
		{
			_text.text = ""+v;
			m_slider.setThumbValue(0, v);
		}
		
		public function EdtSlider(min : int, max : int , tip : String)
		{
			m_min = min ;
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
			
			m_slider = BSSSlider.createSimpleBSSSlider(true, _btn, 0, 150, min, max);
			m_slider.x  = 10;
			m_slider.y = 10;
			addChild(m_slider);
			
			m_slider.dragFunction = onChange;
			
			var lastX : int = m_slider.x + m_slider.width + 5;
			
			if (tip)
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
				_text.text = tip;
			}
			
			_text = new TextField();
			_text.width = 30;
			_text.height = 20;
			_text.background = true;
			_text.border = true;
			_text.x = lastX;
			_text.y = 5;
			_text.mouseEnabled = false;
			
			
			addChild(_text);
			
			reset();
			
			
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
		
		private function onChange(_slider : BSSSlider):void
		{
			_text.text = "" + int(_slider.getThumbValue(0));
			if (changeFunction != null)
			{
				changeFunction(value);
			}
		}
		public function reset():void
		{
			m_slider.setThumbValue(0 , m_min);
			_text.text = "" + int(m_min);
		}
		
		public function dispose():void
		{
			GraphicsUtil.removeAllChildrenWithDispose(this);
			
			okFunction = null;
			changeFunction = null;
			
			_text = null;
			m_slider = null;
		}
		
	}

}