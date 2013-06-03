package editor.module.eye 
{
	import editor.config.StringPool;
	import editor.ui.SripteWithRect;
	import flash.display.DisplayObject;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleEyeToolbar extends SripteWithRect
	{
		
		public var btnImport : BSSButton;
		/*
		public var btnAR : BSSButton;
		public var btnAC : BSSButton;
		public var btnAM : BSSButton;
		
		public var btnEdit : BSSButton;
		public var btnView : BSSButton;
		*/
		public function ModuleEyeToolbar() 
		{
			var lastBtn : DisplayObject;
			btnImport= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_EYE_IMPORT_IMAGE , true);
			btnImport.x = 5;
			btnImport.y = 5 ;
			lastBtn = addChild(btnImport) ;
			
			/*
			btnAR= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_ADD_ROTOR , true);
			btnAR.x = 5 + lastBtn.x + lastBtn.width;
			btnAR.y = 5 ;
			lastBtn = addChild(btnAR) ;
			
			
			btnAC= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_ADD_CIRCLE , true);
			btnAC.x = 5 + lastBtn.x + lastBtn.width;
			btnAC.y = 5 ;
			lastBtn = addChild(btnAC) ;
			
			btnAM= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_ADD_MERIDIAN , true);
			btnAM.x = 5 + lastBtn.x + lastBtn.width;
			btnAM.y = 5 ;
			lastBtn = addChild(btnAM) ;
			
			btnEdit= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_EDIT , true);
			btnEdit.x = 5 + lastBtn.x + lastBtn.width;
			btnEdit.y = 5 ;
			lastBtn = addChild(btnEdit) ;
		
			btnView = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_VIEW , true);
			btnView.x = 5 + lastBtn.x + lastBtn.width;
			btnView.y = 5 ;
			lastBtn = addChild(btnView) ;
			*/
		}
		
		public function deactivateAll(exceptArr : Array):void
		{
			btnImport.deactivate();
			
			
			btnImport.alpha = 
			0.5;
			
			for each (var btn : BSSButton in exceptArr)
			{
				btn.activate();
				btn.alpha = 1;
			}
		}
		
		public override function dispose()
		: void 
		{
			
			if (btnImport) btnImport.dispose(); btnImport = null;
			
			super.dispose();
		}
		
	}

}