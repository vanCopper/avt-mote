package editor.module.mouth  
{
	import editor.config.StringPool;
	import editor.ui.SripteWithRect;
	import flash.display.DisplayObject;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleMouthToolbar extends SripteWithRect
	{
		
		public var btnImport : BSSButton;
		public var btnAF : BSSButton;
		public var btnLocate : BSSButton;
		
		
		public var btnZAdj : BSSButton;
		//public var btnProperty : BSSButton;
		public var btnView : BSSButton;
		
		/*
		public var btnView : BSSButton;
		*/
		
		/*public var btnAC : BSSButton;
		public var btnAM : BSSButton;
		
		public var btnEdit : BSSButton;
		public var btnView : BSSButton;
		*/
		
		
		public function ModuleMouthToolbar() 
		{
			var lastBtn : DisplayObject;
			btnImport = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_MOUTH_IMPORT_IMAGE , true);
			btnImport.x = 5;
			btnImport.y = 5 ;
			lastBtn = addChild(btnImport) ;
			
			var _areaArray : Array = [];
			btnAF = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_MOUTH_ADD_FRAME , true , _areaArray);
			btnAF.x = 5 + lastBtn.x + lastBtn.width;
			btnAF.y = 5 ;
			lastBtn = addChild(btnAF) ;
			btnAF.statusMode = true;
			
			btnLocate = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_MOUTH_LOCATE , true, _areaArray);
			btnLocate.x = 5 + lastBtn.x + lastBtn.width;
			btnLocate.y = 5 ;
			lastBtn = addChild(btnLocate) ;
			btnLocate.statusMode = true;
			
			btnZAdj = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_MOUTH_Z_ADJUST , true, _areaArray);
			btnZAdj.x = 5 + lastBtn.x + lastBtn.width;
			btnZAdj.y = 5 ;
			lastBtn = addChild(btnZAdj) ;
			btnZAdj.statusMode = true;
			
			/*
			btnProperty = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_HAIR_PROPERTY , true, _areaArray);
			btnProperty.x = 5 + lastBtn.x + lastBtn.width;
			btnProperty.y = 5 ;
			lastBtn = addChild(btnProperty) ;
			btnProperty.statusMode = true;
			*/
			
			btnView = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_MOUTH_VIEW , true, _areaArray);
			btnView.x = 5 + lastBtn.x + lastBtn.width;
			btnView.y = 5 ;
			lastBtn = addChild(btnView) ;
			btnView.statusMode = true;
			
			/*
			btnBlink = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_EYE_EDIT_BLINK , true, _areaArray);
			btnBlink.x = 5 + lastBtn.x + lastBtn.width;
			btnBlink.y = 5 ;
			lastBtn = addChild(btnBlink) ;
			btnBlink.statusMode = true;
			
			
			btnMove = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_EYE_EDIT_AREA , true, _areaArray);
			btnMove.x = 5 + lastBtn.x + lastBtn.width;
			btnMove.y = 5 ;
			lastBtn = addChild(btnMove) ;
			btnMove.statusMode = true;
			
			
			
			btnView = BSSButton.createSimpleBSSButton(20, 20, StringPool.MODULE_EYE_VIEW , true, _areaArray);
			btnView.x = 5 + lastBtn.x + lastBtn.width;
			btnView.y = 5 ;
			lastBtn = addChild(btnView) ;
			btnView.statusMode = true;
			
			/ *
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
		public function activateAll(exceptArr : Array):void
		{
			var _arr : Array =  [btnImport , btnAF ,btnLocate , btnZAdj   , btnView];
			
			
			for each (var btn : BSSButton in _arr)
			{
				if (!exceptArr || exceptArr.indexOf(btn) == -1)
				{
					btn.activate();
					btn.alpha = 1;
				}
				
			}
		}
		public function deactivateAll(exceptArr : Array):void
		{
			var _arr : Array =  [btnImport , btnAF ,btnLocate, btnZAdj , btnView];
			
			for each (var btn : BSSButton in _arr)
			{
				
				btn.deactivate();
				btn.alpha = 0.5;
								
			}
			
			for each ( btn  in exceptArr)
			{
				btn.activate();
				btn.alpha = 1;
			}
		}
		
		public override function dispose()
		: void 
		{
			
			if (btnImport) btnImport.dispose(); btnImport = null;
			if (btnAF) btnAF.dispose(); btnAF = null;
			if (btnLocate) btnLocate.dispose(); btnLocate = null;
			if (btnZAdj) btnZAdj.dispose(); btnZAdj = null;
			//if (btnProperty) btnProperty.dispose(); btnProperty = null;
			if (btnView) btnView.dispose(); btnView = null;
			
			super.dispose();
		}
		
	}

}