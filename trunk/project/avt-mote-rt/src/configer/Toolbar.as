package configer
{
	import flash.display.Sprite;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author blueshell
	 */
	public class Toolbar extends Sprite//WithRect
	{
		
		public var btnNew : BSSButton;
		public var btnOpen : BSSButton;
		public var btnSave : BSSButton;
		public var btnSaveAs : BSSButton;
		public var btnCopy : BSSButton;
		public var btnExport : BSSButton;
		public var btnSnap : BSSButton;
		
		public function Toolbar() 
		{
			
			btnNew= BSSButton.createSimpleBSSButton(20, 20, StringPool.NEW , true);
			btnNew.x = 5;
			btnNew.y = 5 ;
			addChild(btnNew) ;
			
			btnOpen = BSSButton.createSimpleBSSButton(20, 20, StringPool.OPEN , true);
			btnOpen.x = btnNew.x + btnNew.width + 5;
			btnOpen.y = 5 ;
			addChild(btnOpen) ;
			var _lastBtn : BSSButton = btnOpen;
			
			{
				btnSave =  BSSButton.createSimpleBSSButton(20, 20, StringPool.SAVE , true);
				btnSave.x = _lastBtn.x + _lastBtn.width + 5;
				btnSave.y = 5 ;
				addChild(btnSave) ;
				_lastBtn = btnSave;
			}
			
			
			
			btnSaveAs = BSSButton.createSimpleBSSButton(20, 20, StringPool.SAVE_AS , true);
			btnSaveAs.x = _lastBtn.x + _lastBtn.width + 5;
			btnSaveAs.y = 5 ;
			addChild(btnSaveAs) ;
			_lastBtn = btnSaveAs;
			
			
			btnExport =  BSSButton.createSimpleBSSButton(20, 20, StringPool.EXPORT , true);
			btnExport.x = _lastBtn.x + _lastBtn.width + 5;
			btnExport.y = 5 ;
			addChild(btnExport) ;
			_lastBtn = btnExport;
			
			
			btnSnap =  BSSButton.createSimpleBSSButton(20, 20, StringPool.SNAP , true);
			btnSnap.x = _lastBtn.x + _lastBtn.width + 5;
			btnSnap.y = 5 ;
			addChild(btnSnap) ;
			_lastBtn = btnSnap;
			
			
		//	btnCopy =  BSSButton.createSimpleBSSButton(20, 20, StringPool.COPY , true);
		///	btnCopy.x = btnExport.x + btnExport.width + 5;
		//	btnCopy.y = 5 ;
		//	addChild(btnCopy) ;
			
			
			
		}
		
		public function dispose()
		: void 
		{
			
			btnNew.dispose() ; btnNew = null;
			btnOpen.dispose() ; btnOpen = null;
			btnSave.dispose() ; btnSave = null;
			btnExport.dispose() ; btnExport = null;
			btnCopy.dispose() ; btnCopy = null;
			
		}
		
		
	}

}