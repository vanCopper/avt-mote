package editor.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSCheckBox;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class TextCheckBox extends Sprite
	{
		private var _text : TextField;
		private var m_cb : BSSCheckBox;
		
		public var changeFunction : Function ;
		
		public function get selected() : Boolean
		{
			return m_cb.selected ;
		}
		public function set selected(v : Boolean) : void
		{
			m_cb.selected = v;
		}
		
		public function get text() : String
		{
			return _text.text;
		}
		public function set text(v : String) : void
		{
			_text.text = v;
		}
		
		public function TextCheckBox() 
		{
			m_cb = BSSCheckBox.createSimpleBSSCheckBox(16);
			m_cb.x = m_cb.y = 2;
			_text = new TextField();
			_text.width = 200;
			_text.height = 20;
			//_text.background = true;
			//_text.border = true;
			_text.x = 20;
			_text.y = 0;
			_text.mouseEnabled = false;
			
			m_cb.selectFunction = function (__cb : BSSCheckBox) : void
			{
				if (changeFunction != null)
					changeFunction(__cb.parent);
			}
			
			addChild(_text);
			addChild(m_cb);
			
		}
		
	}

}