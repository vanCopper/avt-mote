package editor.module 
{
	import editor.config.StringPool;
	import editor.ui.SpriteWH;
	import editor.ui.SripteWithRect;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleBase
	{
		private var m_btn : BSSButton;
		protected var m_container : DisplayObjectContainer;
		protected var m_content : SpriteWH;
		public function getButtonDsp() : BSSButton
		{
			return m_btn;
		}
		
		public function activate() : void
		{
			if (m_content && m_container)
				m_container.addChild(m_content);
		}
		public function deactivate() : void
		{
			if (m_content && m_content.parent)
				m_content.parent.removeChild(m_content);
		}
		private static var s_areaArray : Array = [];
		public function ModuleBase(_container: DisplayObjectContainer , name : String) 
		{
			m_container = _container;
			m_btn = BSSButton.createSimpleBSSButton(20, 20, name , true, s_areaArray);
			m_btn.statusMode = true;
			m_content = new SpriteWH();
			
			var tf :TextField = new TextField();
			m_content.addChild(tf);
			
			tf.x = tf.y = 5;
			tf.width = 200;
			tf.mouseEnabled = false;
			tf.text = StringPool.MODULE + " [" + name + "]"
		}
		
		public function dispose() : void
		{
			if (m_btn)
			{
				m_btn.dispose();
				m_btn = null;
			}
		}
		public function onNew():void
		{
			
		}
		
		public function onSave(__root : XML):void
		{
			
		}
		public function onOpenXML(__root : XML):void
		{
			
		}
	}

}