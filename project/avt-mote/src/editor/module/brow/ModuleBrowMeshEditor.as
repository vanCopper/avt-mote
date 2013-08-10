package editor.module.brow 
{
	import editor.module.body.ModuleBrowFrame;
	import editor.module.head.ModuleHeadData;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtSlider;
	import editor.ui.EdtVertex3D;
	import flash.display.Sprite;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBrowMeshEditor extends Sprite
	{
		
		private var m_data:ModuleBrowFrame;
		public var okFunction : Function;
		
		public function ModuleBrowMeshEditor() 
		{
			setCurrentData(null);
		}
		
		public function setCurrentData(_data:ModuleBrowFrame):void
		{
			m_data = _data;
			
			if (m_data)
			{
				
				
			} 
			else {
				
			}
			
		}
		
		
		
	}

}