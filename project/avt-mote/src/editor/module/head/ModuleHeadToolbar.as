package editor.module.head 
{
	import editor.config.StringPool;
	import editor.ui.SripteWithRect;
	import flash.display.DisplayObject;
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
		public var btnAM : BSSButton;
		
		public var btnEdit : BSSButton;
		public var btnView : BSSButton;
		
		public function ModuleHeadToolbar() 
		{
			var lastBtn : DisplayObject;
			btnImport= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_IMPORT_IMAGE , true);
			btnImport.x = 5;
			btnImport.y = 5 ;
			lastBtn = addChild(btnImport) ;
			
			
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
			
			var _areaArray : Array = [];
			btnEdit= BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_EDIT , true , _areaArray);
			btnEdit.x = 5 + lastBtn.x + lastBtn.width;
			btnEdit.y = 5 ;
			lastBtn = addChild(btnEdit) ;
			btnEdit.statusMode = true;
		
			btnView = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HEAD_VIEW , true, _areaArray);
			btnView.x = 5 + lastBtn.x + lastBtn.width;
			btnView.y = 5 ;
			lastBtn = addChild(btnView) ;
			btnView.statusMode = true;
		}
		
		public function deactivateAll(exceptArr : Array):void
		{
			btnImport.deactivate();
			btnAR.deactivate();
			btnAC.deactivate();
			btnAM.deactivate();
			btnEdit.deactivate();
			btnView.deactivate();
			
			
			btnImport.alpha = 
			btnAR.alpha =
			btnAC.alpha = 
			btnAM.alpha = 
			btnEdit.alpha = 
			btnView.alpha = 
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
			if (btnAR) btnAR.dispose(); btnAR = null;
			if (btnAC) btnAC.dispose(); btnAC = null;
			if (btnAM) btnAM.dispose(); btnAM = null;

			if (btnEdit) btnEdit.dispose(); btnEdit = null;
			if (btnView) btnView.dispose(); btnView = null;
			
			super.dispose();
		}
		
	}

}