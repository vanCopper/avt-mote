package editor.module.hair 
{
	import editor.config.StringPool;
	import editor.Library;
	import editor.module.head.ModuleHead3DView;
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
	public class ModuleHair extends ModuleBase 
	{
		private var m_tb : ModuleHairToolbar;
		private var m_eqm : ModuleHairEQMgr;
		private var m_quadrant2 : EdtQuadrant;
		private var m_quadrant1 : EdtQuadrant;
		private var m_quadrant0 : EdtQuadrant;
		private var m_quadrant3 : EdtQuadrant;
		
		private var m_efl : ModuleHairFrameLib;
		
		private var m_meshEditor : ModuleHairMeshEditor;
		private var m_hairLocate : ModuleHairLocate;
		private var m_hairZAdj : ModuleHairZAdjust;
		private var m_hairProperty : ModuleHairProperty;
		private var m_hairView : ModuleHairView;
		
		private var m_hairContainer : ModuleHairFrameSprite;
		
		public override function dispose():void
		{
			if (m_tb)
			{
				m_tb.dispose();
				m_tb = null;
			}
			
			if (m_eqm)
			{
				m_eqm.dispose();
				m_eqm = null;
			}
			
			if (m_quadrant2)
			{
				m_quadrant2.dispose();
				m_quadrant2 = null;
			}
				
			if (m_quadrant0)
			{
				m_quadrant0.dispose();
				m_quadrant0 = null;
			}
			if (m_quadrant1)
			{
				m_quadrant1.dispose();
				m_quadrant1 = null;
			}
			if (m_quadrant3)
			{
				m_quadrant3.dispose();
				m_quadrant3 = null;
			}
			super.dispose();
		}
		
		public function ModuleHair(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_HAIR);
			
			m_tb = new ModuleHairToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			m_quadrant2._xQ = -100;
			m_quadrant2._yQ = -100;
			
			
			m_eqm = new ModuleHairEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			
			m_hairContainer = new ModuleHairFrameSprite(null);
			m_quadrant2.indicate = m_hairContainer;
			
			m_quadrant2.fullScreen = (true);
			m_quadrant2.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant2;
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_tb.btnImport.releaseFunction = onOpen;
			m_tb.btnAF.releaseFunction = function (btn : BSSButton):void { enablePage(0);}
			m_tb.btnLocate.releaseFunction = function (btn : BSSButton):void { enablePage(1);}
			m_tb.btnZAdj.releaseFunction = function (btn : BSSButton):void { enablePage(2); }
			m_tb.btnProperty.releaseFunction = function (btn : BSSButton):void { enablePage(3); }
			m_tb.btnView.releaseFunction = function (btn : BSSButton):void { enablePage(4); }
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_efl  = new ModuleHairFrameLib();
			m_efl.x = 650;
			m_efl.y = 240;
			m_efl.visible = false;
			m_efl.clickFuntion = null;
			
			
			m_content.addChild(m_efl);
			
			m_meshEditor = new ModuleHairMeshEditor();
			m_content.addChild(m_meshEditor);
			m_meshEditor.visible = false;
			m_meshEditor.okFunction = onSetMesh;
			
			
			m_hairLocate = new ModuleHairLocate();
			m_content.addChild(m_hairLocate);
			m_hairLocate.visible = false;
			
			
			m_hairZAdj = new ModuleHairZAdjust();
			m_content.addChild(m_hairZAdj);
			m_hairZAdj.visible = false;
			
			
			m_hairProperty = new ModuleHairProperty();
			m_content.addChild(m_hairProperty);
			m_hairProperty.visible = false;
			
			
			m_hairView = new ModuleHairView();
			m_content.addChild(m_hairView);
			m_hairView.visible = false;
		}
		
		
		private function init4Quadrant():void
		{
			if (!m_quadrant1)
			{	
				m_quadrant1 = new EdtQuadrant(1);
				//m_3dView = new ModuleHead3DView();
				//m_3dView.scaleEnabled = false;
				//m_quadrant1.indicate = m_3dView;
			}
			if (!m_quadrant0)
				m_quadrant0 = new EdtQuadrant(0);	
			if (!m_quadrant3)
				m_quadrant3 = new EdtQuadrant(3);	
				
			
			m_eqm.setQuadrant(m_quadrant0 , m_quadrant1 , m_quadrant2 , m_quadrant3);
			
			m_quadrant2.fullScreen = false;
		}
		
		private function disablePage(p:int):void
		{
			if (p == 0)
			{
				m_meshEditor.visible = false;
				m_efl.clickFuntion = null;
				m_eqm.visible = false;
				m_efl.clickFuntion = null;
			}
			else if (p == 1)
			{
				m_hairLocate.deactivate();
				m_hairLocate.visible = false;
				m_efl.clickFuntion = null;
			}
			else if (p == 2)
			{
				m_eqm.visible = false;
				m_eqm.remainQuadrant(m_quadrant2);
				m_eqm.curEdtQuadrant = m_quadrant2;
				m_quadrant2.indicate = null;
				m_hairZAdj.visible = false;
			}
			else if (p == 3)
			{
				m_hairProperty.visible = false;
				m_efl.clickFuntion = null;
				m_hairProperty.deactivate();
			}
			else if (p == 4)
			{
				m_hairView.visible = false;
				m_efl.clickFuntion = null;
				m_hairView.deactivate();
			}
			
		}
		private function enablePage(p:int):void
		{
			for (var i : int = 0 ; i < 5; i++ )
			{
				if (p != i)
					disablePage(i);
			}
			
			if (p == 0)
			{
				m_meshEditor.visible = true;
				m_efl.clickFuntion = onClickToEdit;
				m_eqm.visible = true;
				m_quadrant2.indicate = m_hairContainer;
				m_quadrant2.setVertex(null);
				m_eqm.changeFunction = null;
			}
			else if (p == 1)
			{
				 m_hairLocate.visible = true;
				 m_hairLocate.activate();
				 m_efl.clickFuntion = onClickToLocate;
			}
			else if (p == 2)
			{
				init4Quadrant();
			 
				m_efl.clickFuntion = null;
				m_eqm.visible = true;
				m_quadrant2.indicate = null;
				m_hairZAdj.visible = true;
				m_efl.clickFuntion = onClickToZAdj;
				m_eqm.setVertex(null);
				m_eqm.changeFunction = onZAdjChange;
			}
			else if (p == 3)
			{
				m_hairProperty.visible = true;
				m_efl.clickFuntion = onHairProperty;
				m_hairProperty.activate();
			}
			else if (p == 4)
			{
				m_hairView.visible = true;
				m_efl.clickFuntion = null;
				m_hairView.activate();
			}
		}
		
		
		private function onSetMesh(_data:ModuleHairFrame):void 
		{
			m_quadrant2.setVertex(_data.vertexData);
		}
		
		private function onClickToEdit(__item : Sprite , mefs : ModuleHairFrameSprite , _name : String ):void 
		{
			
			m_hairContainer.data = mefs.data;
			m_hairContainer.refresh();
			m_meshEditor.setCurrentData(m_hairContainer.data);
			
		}
		private function onClickToLocate(__item : Sprite , mefs : ModuleHairFrameSprite , _name : String ):void 
		{
			m_hairLocate.setCurrentData(mefs.data);
		}
		
		private function onClickToZAdj(__item : Sprite , mefs : ModuleHairFrameSprite , _name : String ):void 
		{
			m_hairZAdj.setCurrentData(mefs.data);
			m_eqm.setVertex(m_hairZAdj.getVertex());
		}
		private function onZAdjChange():void 
		{
			m_hairZAdj.onSetNewZ();
			m_eqm.setVertex(m_hairZAdj.getVertex());
		}
		private function onHairProperty(__item : Sprite , mefs : ModuleHairFrameSprite , _name : String ):void 
		{
			m_hairProperty.setCurrentData(mefs.data);
			m_hairProperty.refresh();
		}
		
		
		
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [new FileFilter("image list(*.imglist)" , "*.imglist") , new FileFilter("image (*.png)" , "*.png")]);
		}

		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , _filename , "HAIR");
			Library.getS().addTexture(_texture);
			
			m_efl.visible = true;
			m_tb.activateAll(null);
			m_efl.addTexture(new ModuleHairFrame(_texture) ,  _texture.name);
			
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
			
			enablePage( -1);
			
			super.deactivate();
		}
		
		public override function onNew():void
		{
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_efl.onNew();
			m_efl.visible = false;
		
			m_hairContainer.data = null;
			m_hairContainer.refresh();
			
			enablePage(-1);
			deactivate();
			
			m_quadrant2.setVertex(null);
			
			m_moduleHairFrameList = null;
		}
		private var m_moduleHairFrameList : Vector.<XML>;
	
		private function onModuleHairFrameInited(_mef : ModuleHairFrame):void
		{
			
			m_efl.addTexture(_mef , _mef.name);
			m_efl.visible = true;
			m_tb.activateAll(null);
			
			if (m_moduleHairFrameList.length) {
				var mef : ModuleHairFrame = new ModuleHairFrame(null);
				mef.fromXMLString(m_moduleHairFrameList.shift(), onModuleHairFrameInited);
			}
			else {
				m_moduleHairFrameList = null;
			}
		}
		
		public override function onOpenXML(__root : XML):void
		{
			
			var eyeXML : XMLList = __root.ModuleHair;
			
			for each (var item : XML in eyeXML.elements())
			{
				//trace(item.toXMLString());
				if (item.name() == "ModuleHairFrames")
				{
					m_moduleHairFrameList = new Vector.<XML>
					for each (var itemModuleEyeFrame : XML in item.ModuleHairFrame )
					{	
						m_moduleHairFrameList.push(itemModuleEyeFrame);
					}
					
					if (m_moduleHairFrameList.length) {
						var mef : ModuleHairFrame = new ModuleHairFrame(null);
						mef.fromXMLString(m_moduleHairFrameList.shift(), onModuleHairFrameInited);
					}	
				}
				
			}
		}
		
		public override function onSave(__root : XML):void
		{
			
			if (ModuleHairData.s_frameList && ModuleHairData.s_frameList.length)
			{
				var str : String = "<ModuleHair>";
					str += "<ModuleHairFrames>";
					for each (var _mef : ModuleHairFrame in ModuleHairData.s_frameList)
					{
						str += _mef.toXMLString();
					}
					str += "</ModuleHairFrames>";
					
					//str += m_moduleEyeBlinkEditor.toXMLString();
					//str += m_moduleEyeMA.toXMLString();
					//str += m_moduleEyeLocate.toXMLString();
					
				str += "</ModuleHair>";
				
				__root.appendChild(
					new XML(str)
				);
			}
			else
			{
				var ModuleEyeXML : XML = <ModuleHair/>;
				__root.appendChild(
					ModuleEyeXML
				);
			}
		}
		
		
	}

}