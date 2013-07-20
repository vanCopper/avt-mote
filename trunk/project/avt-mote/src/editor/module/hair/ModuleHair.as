package editor.module.hair 
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
	public class ModuleHair extends ModuleBase 
	{
		private var m_tb : ModuleHairToolbar;
		private var m_eqm : ModuleHairEQMgr;
		private var m_quadrant2 : EdtQuadrant;
		private var m_efl : ModuleHairFrameLib;
		
		private var m_meshEditor : ModuleHairMeshEditor;
		private var m_hairLocate : ModuleHairLocate;
		
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
			m_tb.btnAF.releaseFunction = onAddFrame;
			m_tb.btnLocate.releaseFunction = onEditLocate;
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
				
			}
			else if (p == 3)
			{
				
			}
			else if (p == 4)
			{
			
			}
			
		}
		
		private function onAddFrame(btn : BSSButton):void
		{
			disablePage(1);
			m_meshEditor.visible = true;
			m_efl.clickFuntion = onClickToEdit;
			m_eqm.visible = true;
			
		}
		private function onSetMesh(_data:ModuleHairFrame):void 
		{
			m_quadrant2.setVertex(_data.vertexData);
		}
		private function onClickToEdit(__item : Sprite , mefs : ModuleHairFrameSprite , _name : String ):void 
		{
			
			
			m_hairContainer.data = mefs.data;
			m_hairContainer.refresh();
			
			//m_quadrant2.setVertex
			
			m_meshEditor.setCurrentData(m_hairContainer.data);
			
		}
		
		private function onEditBlink(btn : BSSButton):void
		{
			
		}
		
		private function onEditMove(btn : BSSButton):void
		{
			 

		}
		
		private function onEditLocate(btn : BSSButton):void
		{
			 disablePage(0);
			 m_hairLocate.visible = true;
			 m_hairLocate.activate();
		}
		
		
		private function onEditView(btn : BSSButton):void
		{
			
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
			
			disablePage(0);
			disablePage(1);
			disablePage(2);
			disablePage(3);
			disablePage(4);
			
			super.deactivate();
		}
		
		public override function onNew():void
		{
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_efl.onNew();
			m_efl.visible = false;
		
			m_hairContainer.data = null;
			m_hairContainer.refresh();
			
			onAddFrame(null);
			deactivate();
			
			m_quadrant2.setVertex(null);
		}
		
	
		public override function onOpenXML(__root : XML):void
		{
			/*
			var eyeXML : XMLList = __root.ModuleEye;
			
			for each (var item : XML in eyeXML.elements())
			{
				//trace(item.toXMLString());
				if (item.name() == "ModuleEyeFrames")
				{
					m_moduleEyeFrameList = new Vector.<XML>
					for each (var itemModuleEyeFrame : XML in item.ModuleEyeFrame )
					{	
						m_moduleEyeFrameList.push(itemModuleEyeFrame);
						
						
						//m_efl.visible = true;
					}
					
					if (m_moduleEyeFrameList.length) {
						var mef : ModuleEyeFrame = new ModuleEyeFrame();
						mef.fromXMLString(m_moduleEyeFrameList.shift(), onModuleEyeFrameInited);
					}	
				}
				else if (item.name() == "ModuleEyeBlink")
				{
					m_moduleEyeBlinkEditor.fromXMLString(item);
				}
				else if (item.name() == "ModuleEyeMoveArea")
				{
					m_moduleEyeMA.fromXMLString(item);
				}
				else if (item.name() == "ModuleEyeLocate")
				{
					m_moduleEyeLocate.fromXMLString(item);
				}
				
				
			}
						
			//m_tb.deactivateAll([m_tb.btnImport]);
			*/
		}
		
		public override function onSave(__root : XML):void
		{
			/*
			if (ModuleEyeData.s_frameList && ModuleEyeData.s_frameList.length)
			{
				var str : String = "<ModuleEye>";
					str += "<ModuleEyeFrames>";
					for each (var _mef : ModuleEyeFrame in ModuleEyeData.s_frameList)
					{
						str += _mef.toXMLString();
					}
					str += "</ModuleEyeFrames>";
					
					str += m_moduleEyeBlinkEditor.toXMLString();
					str += m_moduleEyeMA.toXMLString();
					str += m_moduleEyeLocate.toXMLString();
					
					
				
				str += "</ModuleEye>";
				
				__root.appendChild(
					new XML(str)
				);
			}
			else
			{
				var ModuleEyeXML : XML = <ModuleEye/>;
				__root.appendChild(
					ModuleEyeXML
				);
			}*/
		}
		
		
	}

}