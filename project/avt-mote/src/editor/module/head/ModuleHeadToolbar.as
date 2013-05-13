package editor.module.head 
{
	import editor.config.StringPool;
	import editor.ui.SripteWithRect;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleHeadToolbar extends SripteWithRect
	{
		
		public var btnImport : BSSButton;
		public var btnAR : BSSButton;
		public var btnAC : BSSButton;
		
		public function ModuleHeadToolbar() 
		{

			btnImport= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_IMPORT_IMAGE , true);
			btnImport.x = 5;
			btnImport.y = 5 ;
			addChild(btnImport) ;
			
			
			btnAR= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_ADD_ROTOR , true);
			btnAR.x = 5 + btnImport.x + btnImport.width;
			btnAR.y = 5 ;
			addChild(btnAR) ;
			
			
			btnAC= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_ADD_CIRCLE , true);
			btnAC.x = 5 + btnAR.x + btnAR.width;
			btnAC.y = 5 ;
			addChild(btnAC) ;
			
			
		}
		
		public override function dispose()
		: void 
		{
			
			btnImport.dispose() ; btnImport = null;

			
			super.dispose();
		}
		
	}

}