package editor.module.head 
{
	import editor.ui.EdtRotationAxis;
	import flash.display.Sprite;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleHead3DBrowser extends Sprite
	{
		public var m_viewer : ModuleHead3DView;
		public var m_controler : EdtRotationAxis;
		public function ModuleHead3DBrowser() 
		{
			m_viewer = new ModuleHead3DView();
			m_controler = new EdtRotationAxis();
			
			addChild(m_viewer);
			addChild(m_controler);
			
			m_controler.x = m_controler.y = 400;
		}
		
		public function activate() : void
		{
			m_controler.rotation = ModuleHeadData.s_rotorR * 180 / Math.PI;
		}
		
		public function dispose() : void 
		{
			if (m_viewer)
			{
				m_viewer = null;
			}
			
			if (m_controler)
			{
				m_controler.dispose();
				m_controler = null;
			}
			
			GraphicsUtil.removeAllChildren(this);
		}
	}

}