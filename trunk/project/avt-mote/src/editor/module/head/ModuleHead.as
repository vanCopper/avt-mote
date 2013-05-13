package editor.module.head 
{
	import editor.config.StringPool;
	import editor.module.ModuleBase;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleHead extends ModuleBase
	{	
		
		private var m_tb : ModuleHeadToolbar;
		
		public function ModuleHead(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_HEAD);
			
			m_tb = new ModuleHeadToolbar();
			m_content.addChild(m_tb).y = 25;
			
		}
		
		public override function activate() : void
		{
			super.activate();
		}
		
		public override function deactivate() : void
		{
			super.deactivate();
		}
		public override function dispose() : void
		{
			if (m_tb)
			{
				m_tb.dispose();
				m_tb = null;
			}
			
			super.dispose();
		}
	}

}