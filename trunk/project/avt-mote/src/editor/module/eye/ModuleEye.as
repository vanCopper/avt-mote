package editor.module.eye 
{
	import editor.config.StringPool;
	import editor.Library;
	import editor.module.ModuleBase;
	import editor.struct.Texture2D;
	import editor.struct.Texture2DBitmap;
	import editor.ui.EdtQuadrant;
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
			m_efl.y = 180;
			m_efl.visible = false;
			m_efl.clickFuntion = onClick;
			
			m_eyeChoose = new Sprite();
			m_nameTF = new TextField(); m_nameTF.width = 180; m_nameTF.text = "CURRENT:";
			m_eyeWhiteDDM = BSSDropDownMenuScrollable.createSimpleBSSDropDownMenuScrollable(150 , 20 , "EYE-WHITE",false);
			m_eyeBallDDM = BSSDropDownMenuScrollable.createSimpleBSSDropDownMenuScrollable(150 , 20 , "EYE-BALL",false);
			m_eyeLipDDM = BSSDropDownMenuScrollable.createSimpleBSSDropDownMenuScrollable(150 , 20 , "EYE-LIP",false);
			m_eyeWhiteDDM.setMaxHeight(400);
			m_eyeBallDDM.setMaxHeight(400);
			m_eyeLipDDM.setMaxHeight(400);
			
			
			m_eyeChoose.addChild(m_nameTF);
			m_eyeChoose.addChild(m_eyeLipDDM).y = 90;
			m_eyeChoose.addChild(m_eyeBallDDM).y = 60;
			m_eyeChoose.addChild(m_eyeWhiteDDM).y = 30;
			
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
			}
			else
			{
				m_eyeChoose.alpha = 0.5;
				m_eyeChoose.mouseChildren = false;
				m_eyeWhiteDDM.selectedId = (0);
				m_eyeBallDDM.selectedId = (0);
				m_eyeLipDDM.selectedId = (0);
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
		
	}

}