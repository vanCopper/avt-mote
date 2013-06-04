package editor.module.eye 
{
	import editor.config.StringPool;
	import editor.Library;
	import editor.module.ModuleBase;
	import editor.struct.Texture2D;
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtVertex3D;
	import editor.ui.SpriteWH;
	import editor.ui.SripteWithRect;
	import editor.util.ImageListPicker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIComponent.BSSCheckBox;
	import UISuit.UIComponent.BSSDropDownMenu;
	
	import UISuit.UIComponent.BSSDropDownMenuScrollable;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEye extends ModuleBase 
	{
		private var m_tb : ModuleEyeToolbar;
		private var m_eqm : ModuleEyeEQMgr;
		private var m_quadrant2 : EdtQuadrant;
		private var m_eyeContainer : ModuleEyeFrameSprite;
		
		
		
		private var m_efl : ModuleEyeFrameLib;
		
		private var m_eyeChoose : Sprite;
		private var m_nameTF : TextField;
		private var m_eyeWhiteDDM : BSSDropDownMenuScrollable;
		private var m_eyeBallDDM : BSSDropDownMenuScrollable;
		private var m_eyeLipDDM : BSSDropDownMenuScrollable;
		private var m_eyeMaskBtn : BSSButton;
		private var m_eyeMaskAddUI : EdtAddUI;
		private var m_eyeMaskEdit: BSSCheckBox;
		
		private var m_hoverTexture2DBitmap : Texture2DBitmap;
		private var m_hoverTextureSprite : Sprite;
		
		
		public override function dispose():void
		{
			if (m_eyeContainer)
			{
				m_eyeContainer.eyeBall.removeEventListener(MouseEvent.MOUSE_DOWN , onMouse);
				m_eyeContainer.eyeLip.removeEventListener(MouseEvent.MOUSE_DOWN , onMouse);
				m_eyeContainer.eyeBall.removeEventListener(MouseEvent.MOUSE_UP , onMouse);
				m_eyeContainer.eyeLip.removeEventListener(MouseEvent.MOUSE_UP , onMouse);
				m_eyeContainer.dispose();
				m_eyeContainer = null;
			}
			super.dispose();
		}
		
		private function onMouse(e:MouseEvent):void 
		{
			var t2b : Texture2DBitmap =
					Texture2DBitmap(e.currentTarget);
					
			if (e.type == MouseEvent.MOUSE_DOWN)
			{
				if (t2b == m_eyeContainer.eyeLip)
				{
					if (!m_eyeContainer.eyeLip.isTransArea())
					{
						t2b.startDrag();
						m_eyeContainer.eyeBall.mouseEnabled = false;
					}
					else if (!m_eyeContainer.eyeBall.isTransArea())
						t2b = m_eyeContainer.eyeBall;
				}
				
				
				if (t2b == m_eyeContainer.eyeBall)
				{
					t2b.startDrag();
					m_eyeContainer.eyeLip.mouseEnabled = false;
				}
			}
			else {
				
				
				t2b.stopDrag();
				
				if (t2b == m_eyeContainer.eyeBall)
				{
					m_eyeContainer.data.eyeBallX = t2b.x;
					m_eyeContainer.data.eyeBallY = t2b.y;
					
				} else if (t2b == m_eyeContainer.eyeLip)
				{
					m_eyeContainer.data.eyeLipX = t2b.x;
					m_eyeContainer.data.eyeLipY = t2b.y;
					
				} 
				
				m_eyeContainer.refresh();
				currentEditMEFS.refresh();
				currentEditMEFS.fitPos(84 , 84 , 8 , 8);
				
				m_eyeContainer.eyeBall.mouseEnabled =
				m_eyeContainer.eyeLip.mouseEnabled = true;
				
			}
		}
		
		public function ModuleEye(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_EYE);
			
			m_tb = new ModuleEyeToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			
			m_eqm = new ModuleEyeEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			
			m_eyeContainer = new ModuleEyeFrameSprite(null);
			
			
			
			/*
			m_bmp = new Bitmap();
			m_bmpShape = new Shape();
			
			m_bmpCnt.addChild(m_bmp);
			m_bmpCnt.addChild(m_bmpShape);
			*/
			
			m_quadrant2.indicate = m_eyeContainer;
			
			m_quadrant2.fullScreen = (true);
			m_quadrant2.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant2;
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_tb.btnImport.releaseFunction = onOpen;
			
			m_efl  = new ModuleEyeFrameLib();
			m_content.addChild(m_efl);
			m_efl.x = 650;
			m_efl.y = 240;
			m_efl.visible = false;
			m_efl.clickFuntion = onClick;
			
			m_eyeChoose = new Sprite();
			m_nameTF = new TextField(); m_nameTF.width = 180; m_nameTF.text = "CURRENT:";
			m_eyeWhiteDDM = BSSDropDownMenuScrollable.createSimpleBSSDropDownMenuScrollable(150 , 20 , "EYE-WHITE",false);
			m_eyeBallDDM = BSSDropDownMenuScrollable.createSimpleBSSDropDownMenuScrollable(150 , 20 , "EYE-BALL",false);
			m_eyeLipDDM = BSSDropDownMenuScrollable.createSimpleBSSDropDownMenuScrollable(150 , 20 , "EYE-LIP", false);
			
			m_eyeMaskBtn = BSSButton.createSimpleBSSButton(100 , 20 , "add mask");
			var sp : SripteWithRect = new SripteWithRect();
			sp.addChild(m_eyeMaskBtn);
			
			m_eyeMaskBtn.x = m_eyeMaskBtn.y = 5;
			
			
			var _indiMask : TextField = new TextField(); 
			_indiMask.text = "show mask"; 
			_indiMask.height = 12;
			_indiMask.x = m_eyeMaskBtn.width + m_eyeMaskBtn.x + 20;
			_indiMask.y =  m_eyeMaskBtn.y;
			_indiMask.width = _indiMask.textWidth+5;
			_indiMask.mouseEnabled = false;
			sp.addChild(_indiMask);
			
			_indiMask.height = 20;
			
			
			m_eyeMaskEdit = BSSCheckBox.createSimpleBSSCheckBox(16);
			m_eyeMaskEdit.x = _indiMask.textWidth + _indiMask.x + 10;
			m_eyeMaskEdit.y = _indiMask.y + 2.5;
			
			m_eyeMaskEdit.selectFunction = onSelectCB;
			m_eyeMaskEdit.selected = true;
			
			sp.addChild(m_eyeMaskEdit);
			
			m_eyeMaskBtn.releaseFunction = onMaskAdd;
			m_eyeMaskAddUI = new EdtAddUI(8 , 20);
			m_eyeMaskAddUI.changeFunction = onMaskAddChanged;
			m_eyeMaskAddUI.okFunction = onMaskAddOK;
			m_eyeMaskAddUI.visible = false;
			
			m_eyeWhiteDDM.setMaxHeight(400);
			m_eyeBallDDM.setMaxHeight(400);
			m_eyeLipDDM.setMaxHeight(400);
			
			
			m_eyeChoose.addChild(m_nameTF);
			m_eyeChoose.addChild(m_eyeMaskAddUI);
			m_eyeChoose.addChild(sp);
			
			m_eyeChoose.addChild(m_eyeLipDDM).y = 90;
			m_eyeChoose.addChild(m_eyeBallDDM).y = 60;
			m_eyeChoose.addChild(m_eyeWhiteDDM).y = 30;
			sp.y = 120;

			m_eyeMaskAddUI.y = 154;
			
			m_content.addChild(m_eyeChoose);
			m_eyeChoose.x = 650;
			m_eyeChoose.y = 50;
			m_eyeChoose.alpha = 0.5;
			m_eyeChoose.mouseChildren = false;
			
			m_eyeWhiteDDM.hoverFunction = onHover;
			m_eyeBallDDM.hoverFunction = onHover;
			m_eyeLipDDM.hoverFunction = onHover;
			
			m_eyeWhiteDDM.selectFunction = onPressEW;
			m_eyeBallDDM.selectFunction = onPressEB;
			m_eyeLipDDM.selectFunction = onPressEL;
			
			m_hoverTexture2DBitmap = new Texture2DBitmap(null);
			m_hoverTextureSprite = new Sprite;
			m_content.addChild(m_hoverTextureSprite);
			m_hoverTextureSprite.addChild(m_hoverTexture2DBitmap);
			m_hoverTexture2DBitmap.x = 5;
			m_hoverTexture2DBitmap.y = 5;
			m_hoverTextureSprite.visible = false;
			
			
			m_eyeContainer.eyeBall.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
			m_eyeContainer.eyeLip.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
			m_eyeContainer.eyeBall.addEventListener(MouseEvent.MOUSE_UP , onMouse);
			m_eyeContainer.eyeLip.addEventListener(MouseEvent.MOUSE_UP , onMouse);
			
		}
		
		private function onMaskClear(btn : BSSButton):void
		{
			btn.text = "add mask";
			btn.releaseFunction = onMaskClear;
			m_eyeMaskBtn.releaseFunction = onMaskAdd;
			m_eyeMaskAddUI.visible = false;
			if (m_eyeContainer.data && m_eyeContainer.data.eyeMaskData)
				m_eyeContainer.data.eyeMaskData.length = 0;
			m_eyeContainer.clearMask();
			m_quadrant2.setVertex(null);
			if (currentEditMEFS) 
				currentEditMEFS.clearMask();
		}
		private function onMaskAdd(btn : BSSButton):void
		{
			btn.text = "cln mask";
			btn.releaseFunction = onMaskClear;
			m_eyeMaskAddUI.visible = true;
			onMaskAddChanged(m_eyeMaskAddUI.value);
		}
		
		private function onMaskAddChanged(v:int):void
		{
			m_eyeContainer.data.eyeMaskData.length = 0;
			m_quadrant2.setVertex(null);
			m_eqm.useSelector = false;
			m_eqm.useVtxEditor = false;
			m_eqm.changeFunction = null;
			
			var _t : Texture2D = m_eyeContainer.data.eyeWhite;
			
			if (!_t)
				 _t = m_eyeContainer.data.eyeBall;
			if (!_t)
				 _t = m_eyeContainer.data.eyeLip;	 
			
			var _centerX : Number = _t ? (_t.rectX + _t.rectW / 2): 50;
			var _centerY : Number = _t ? (_t.rectY + _t.rectH / 2): 50;
			
			var lenR : Number = Math.abs(_t ? _t.rectW / 2 : 50);
			
			m_eyeContainer.data.eyeMaskData.push(new EdtVertex3D(_centerX , _centerY , 0));
			
			var _step : Number = Math.PI * 2 / v;
			
			for (var i : int = 0 ; i < v ; i++ )
			{
				var rn : Number = i * _step;
				
				m_eyeContainer.data.eyeMaskData.push(new EdtVertex3D(
					_centerX + Math.cos(rn) * lenR ,
					_centerY + Math.sin(rn) * lenR * 0.6 ,
					0));
			}
			m_eyeContainer.data.eyeMaskData.push(m_eyeContainer.data.eyeMaskData[1]);
			
			m_eyeContainer.renderMask(true);
			
		}
		private function onMaskAddOK(v:int):void
		{
			m_eyeMaskAddUI.visible = false;
			onMaskAddChanged(v);
			//m_eyeContainer.clearMask();
			
			var _vertexArray : Vector.<EdtVertex3D> = m_eyeContainer.data.eyeMaskData;
			
			var p : int = 1;
			for each (var _v3d : EdtVertex3D in m_eyeContainer.data.eyeMaskData)
			{
				_v3d.priority = p++;
			}
			
			
			var idx : int = 2;
			
			while (idx < _vertexArray.length)
			{
				EdtVertex3D.connect2PT(_vertexArray[0] , _vertexArray[idx - 1]);
				EdtVertex3D.connect2PT(_vertexArray[0] , _vertexArray[idx]);
				EdtVertex3D.connect2PT(_vertexArray[idx] , _vertexArray[idx - 1]);
				idx++;
			}
			
			
			m_quadrant2.setVertex(_vertexArray);
			m_eqm.useSelector = true;
			m_eqm.useVtxEditor = true;
			
			
			m_eqm.changeFunction = onChangeMask;
			if (currentEditMEFS) currentEditMEFS.renderMask(false);
		}
		
		private function onChangeMask():void
		{
			m_eyeContainer.renderMask(false);
			if (currentEditMEFS) currentEditMEFS.renderMask(false);
		}
		
		
		private function onHover(_DDM : BSSDropDownMenu):void
		{
			m_hoverTextureSprite.y = int(m_hoverTextureSprite.parent.mouseY / 15 - 1) * 15 ;
			
			if (_DDM.getHoverId() <= 0)
				m_hoverTextureSprite.visible = false;
			else {
				m_hoverTextureSprite.visible = true;
				
				m_hoverTexture2DBitmap.texture2D = Library.getS().getTexture2D(_DDM.getHoverString());
				
				m_hoverTextureSprite.graphics.clear();
				m_hoverTextureSprite.graphics.lineStyle(1 , 0x9999FF);
				m_hoverTextureSprite.graphics.beginFill(0xFFFFFF , 0.5);
				m_hoverTextureSprite.graphics.drawRect(0, 0, m_hoverTexture2DBitmap.width+10, m_hoverTexture2DBitmap.height+10);
				m_hoverTextureSprite.x = _DDM.parent.x - m_hoverTexture2DBitmap.width - 15;
				
			}
		}
		
		private function onPressEW(_DDM : BSSDropDownMenu):void
		{
			if (_DDM.selectedId == 0)
			{		if (m_eyeContainer.data) m_eyeContainer.data.eyeWhite = null;}
			else {
				m_eyeContainer.data.eyeWhite = Library.getS().getTexture2D(_DDM.getSelectedString());
			}
			m_eyeContainer.refresh();
			if (currentEditMEFS) {
				currentEditMEFS.refresh();
				currentEditMEFS.fitPos(84 , 84 , 8 , 8);
			}
			
			m_hoverTextureSprite.visible = false;
		}
		private function onPressEB(_DDM : BSSDropDownMenu):void
		{
			if (_DDM.selectedId == 0)
			{	if (m_eyeContainer.data) m_eyeContainer.data.eyeBall = null;}
			else {
				m_eyeContainer.data.eyeBall = Library.getS().getTexture2D(_DDM.getSelectedString());
			}
			m_eyeContainer.refresh();
			if (currentEditMEFS) {
				currentEditMEFS.refresh();
				currentEditMEFS.fitPos(84 , 84 , 8 , 8);
			}
			
			m_hoverTextureSprite.visible = false;
		}
		private function onPressEL(_DDM : BSSDropDownMenu):void
		{
			if (_DDM.selectedId == 0)
			{		if (m_eyeContainer.data) 	m_eyeContainer.data.eyeLip = null;}
			else {
				m_eyeContainer.data.eyeLip = Library.getS().getTexture2D(_DDM.getSelectedString());
			}
			m_eyeContainer.refresh();
			if (currentEditMEFS) {
				currentEditMEFS.refresh();
				currentEditMEFS.fitPos(84 , 84 , 8 , 8);
			}
			
			m_hoverTextureSprite.visible = false;
		}
		
		private var currentEditMEFS : ModuleEyeFrameSprite;
		private function onSelectCB(cb : BSSCheckBox) : void {
			if (m_eyeContainer)
			{
				m_eyeContainer.maskMode = !cb.selected;
			}
		}
		
		private function onClick(__item : Sprite , mefs : ModuleEyeFrameSprite , _name : String ):void 
		{
			m_nameTF.text = "CURRENT: "+_name;
			
			currentEditMEFS = mefs;
			m_eyeContainer.data = currentEditMEFS ? currentEditMEFS.data : null;
			m_eyeContainer.refresh();
			
			if (m_eyeContainer.data)
			{
				m_eyeChoose.alpha = 1;
				m_eyeChoose.mouseChildren = true;
			
				if (m_eyeContainer.data.eyeWhite)
					m_eyeWhiteDDM.setSelectedString(m_eyeContainer.data.eyeWhite.name);
				else
					m_eyeWhiteDDM.selectedId = (0);
					
				if (m_eyeContainer.data.eyeBall)
					m_eyeBallDDM.setSelectedString(m_eyeContainer.data.eyeBall.name);
				else
					m_eyeBallDDM.selectedId = (0);
					
				if (m_eyeContainer.data.eyeLip)
					m_eyeLipDDM.setSelectedString(m_eyeContainer.data.eyeLip.name);
				else
					m_eyeLipDDM.selectedId = (0);
					
					
				if (m_eyeContainer.data.eyeMaskData.length)
				{
					m_quadrant2.setVertex(m_eyeContainer.data.eyeMaskData);
					
					m_eqm.useSelector = true;
					m_eqm.useVtxEditor = true;
					m_eqm.resetSelect();
					
					m_eqm.changeFunction = onChangeMask;
					m_eyeContainer.renderMask(false);
					
			
					m_eyeMaskBtn.text = "cln mask";
					m_eyeMaskBtn.releaseFunction = onMaskClear;
					
				}
				else
				{
					m_quadrant2.setVertex(null);
					m_eqm.useSelector = false;
					m_eqm.useVtxEditor = false;
					m_eqm.resetSelect();
					
					m_eqm.changeFunction = null;
					m_eyeContainer.clearMask();
					
					m_eyeMaskBtn.text = "add mask";
					m_eyeMaskBtn.releaseFunction = onMaskAdd;
				}
				
			
			}
			else
			{
				m_eyeChoose.alpha = 0.5;
				m_eyeChoose.mouseChildren = false;
				m_eyeWhiteDDM.selectedId = (0);
				m_eyeBallDDM.selectedId = (0);
				m_eyeLipDDM.selectedId = (0);
				
				m_quadrant2.setVertex(null);
				m_eqm.useSelector = false;
				m_eqm.useVtxEditor = false;
				m_eqm.resetSelect();
					
				m_eqm.changeFunction = null;
				m_eyeContainer.clearMask();
				
			}
				
				
		}
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [new FileFilter("image list(*.imglist)" , "*.imglist") , new FileFilter("image (*.png)" , "*.png")]);
		}
		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , _filename , "EYE");
			Library.getS().addTexture(_texture);
			Library.getS().addTexture(new Texture2D(bitmapData , _filename+"#FLIP" , "EYE" , _texture.rectX + _texture.rectW , _texture.rectY , -_texture.rectW , _texture.rectH));
			//m_tb.deactivateAll([m_tb.btnAR]);
			
			m_efl.visible = true;
			
			var _ret : Vector.<Texture2D> = Library.getS().getList("EYE");
			
			for each(var _t : Texture2D in _ret)
			{
				var _type : String = _t.name;
				if (m_eyeLipDDM.getItemIndex(_type) == -1)
				{
					m_eyeLipDDM.addItem(_type);
					m_eyeBallDDM.addItem(_type);
					m_eyeWhiteDDM.addItem(_type);
					
				}
				
			}
			//m_eyeLipDDM.setSelectedString
			
			//m_eyeChoose.addChild(m_eyeBallDDM).y = 60;
			//m_eyeChoose.addChild(m_eyeWhiteDDM).y = 30;
			
		}
		
		public override function activate() : void
		{
			if (m_eqm.parent)
				m_eqm.activate();
			
			super.activate();
		}
		
		public override function deactivate() : void
		{
			
			m_eqm.deactivate();
			
			super.deactivate();
		}
		
		public override function onNew():void
		{
			m_tb.deactivateAll([m_tb.btnImport]);
			onClick(null, null, "");
			m_efl.onNew();
			m_efl.visible = false;
			onMaskClear(m_eyeMaskBtn);
			
			
			m_eyeWhiteDDM.clearAllItem();
			m_eyeBallDDM.clearAllItem();
			m_eyeLipDDM.clearAllItem();
			
			deactivate();
		}
		
		
	}

}