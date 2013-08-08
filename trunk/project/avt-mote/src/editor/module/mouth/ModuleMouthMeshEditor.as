package editor.module.mouth 
{
	import editor.module.body.ModuleMouthFrame;
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
	public class ModuleMouthMeshEditor extends Sprite
	{
		
		private var m_data:ModuleMouthFrame;
		public var okFunction : Function;
		
		public function ModuleMouthMeshEditor() 
		{
			setCurrentData(null);
		}
		
		public function setCurrentData(_data:ModuleMouthFrame):void
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