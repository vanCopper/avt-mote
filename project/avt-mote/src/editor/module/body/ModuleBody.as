package editor.module.body 
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
	import editor.ui.EdtVertexInfo;
	import editor.ui.SpriteWH;
	import editor.ui.SripteWithRect;
	import editor.util.ByteArrayUtil;
	import editor.util.FilePicker;
	import editor.util.ImageListPicker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIComponent.BSSCheckBox;
	import UISuit.UIComponent.BSSDropDownMenu;
	
	import UISuit.UIComponent.BSSDropDownMenuScrollable;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBody extends ModuleBase 
	{
		private var m_tb : ModuleBodyToolbar;
		private var m_eqm : ModuleBodyEQMgr;
		
		private var m_quadrant2 : EdtQuadrant;
		private var m_efl : ModuleBodyFrameLib;
		
		private var m_bodyContainer : ModuleBodyFrameSprite;
		private var m_bodyShape : ModuleBodyFrameShape;
		
		private var m_meshEditor : ModuleBodyMeshEditor;
		private var m_meshBreathEditor : ModuleBodyMeshBreathEditor;
		private var m_bodyLocate : ModuleBodyLocate;
		private var m_bodyView : ModuleBodyView;
		
		
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
				
			if (m_bodyContainer)
			{
				//m_hairContainer.dispose();
				m_bodyContainer = null;
			}
			
			super.dispose();
		}
		
		public function ModuleBody(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_BODY);
			
			m_tb = new ModuleBodyToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			m_quadrant2._xQ = -80;
			m_quadrant2._yQ = -80;
			
			
			m_eqm = new ModuleBodyEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			m_eqm.visible = false;
			
			m_bodyContainer = new ModuleBodyFrameSprite(null);
			//m_quadrant2.indicate = m_bodyContainer;
			
			m_bodyShape = new ModuleBodyFrameShape(null);
			
			m_quadrant2.fullScreen = (true);
			m_quadrant2.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant2;
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_tb.btnImport.releaseFunction = onOpen;
			m_tb.btnAF.releaseFunction = function (btn : BSSButton):void { enablePage(0);}
			m_tb.btnBreath.releaseFunction = function (btn : BSSButton):void { enablePage(1); }
			m_tb.btnLocate.releaseFunction = function (btn : BSSButton):void { enablePage(2); }
			m_tb.btnView.releaseFunction = function (btn : BSSButton):void { enablePage(3); }
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_efl  = new ModuleBodyFrameLib();
			m_efl.x = 650;
			m_efl.y = 240;
			m_efl.visible = false;
			m_efl.clickFuntion = null;
			
			
			m_content.addChild(m_efl);
			
			m_meshEditor = new ModuleBodyMeshEditor();
			m_content.addChild(m_meshEditor).visible = false;
			m_meshEditor.okFunction = onSetMesh;
			
			
			m_meshBreathEditor = new ModuleBodyMeshBreathEditor();
			m_content.addChild(m_meshBreathEditor).visible = false;
			m_meshBreathEditor.okFunction = onSetBreathMesh;
			m_meshBreathEditor.getFunction = function(): Vector.<EdtVertexInfo> { if (m_quadrant2) return m_quadrant2._edtVertexArray; return null; }
			m_meshBreathEditor.changeFunction  = refreshShape;
			
			m_bodyLocate  = new  ModuleBodyLocate();
			m_content.addChild(m_bodyLocate).visible = false;
			
			m_bodyView  = new  ModuleBodyView();
			m_content.addChild(m_bodyView).visible = false;
			
		}
		
		/*
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
		}*/
		
		
		private function disablePage(p:int):void
		{
			if (p == 0)
			{
				m_meshEditor.visible = false;
				m_efl.clickFuntion = null;
				m_eqm.visible = false;
				m_efl.clickFuntion = null;
				m_eqm.deactivate();
				m_quadrant2.indicate = null;
			}
			else if (p == 1)
			{
				m_meshBreathEditor.visible = false;
				m_efl.clickFuntion = null;
				m_eqm.visible = false;
				m_eqm.deactivate();
				m_quadrant2.indicate = null;
			}
			else if (p == 2)
			{
				m_bodyLocate.visible = false;
				m_bodyLocate.deactivate();
				m_efl.clickFuntion = null;
			}
			else if (p == 3)
			{
				m_bodyView.visible = false;
				m_bodyView.deactivate();
				m_efl.clickFuntion = null;
			}
			else if (p == 4)
			{
				
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
				m_quadrant2.indicate = m_bodyContainer;
				m_quadrant2.setVertex(null);
				m_eqm.changeFunction = null;
				m_eqm.activate();
			}
			else if (p == 1)
			{
				m_meshBreathEditor.visible = true;
				m_efl.clickFuntion = onClickToEditBreath;
				m_eqm.visible = true;
				m_quadrant2.indicate = m_bodyShape;
				m_quadrant2.setVertex(null);
				m_eqm.changeFunction = refreshShape;
				m_eqm.activate();
			}
			else if (p == 2)
			{
				m_bodyLocate.visible = true;
				m_bodyLocate.activate();
				m_efl.clickFuntion = onClickToLocate;
			}
			else if (p == 3)
			{
				m_bodyView.visible = true;
				m_bodyView.activate();
				m_efl.clickFuntion = onClickToView;
			}
			else if (p == 4)
			{
				
			}
		}
		
		
		
		
		private function onSetMesh(_data:ModuleBodyFrame):void 
		{
			m_quadrant2.setVertex(_data.vertexData);
		}
		
		private function onSetBreathMesh(_data:ModuleBodyFrame):void 
		{
			m_quadrant2.setVertex(_data.vertexBreathData);
		}
		
		private function onClickToEdit(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{
			
			m_bodyContainer.data = mefs.data;
			m_bodyContainer.refresh();
			m_meshEditor.setCurrentData(m_bodyContainer.data);
		}
		private function onClickToLocate(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{
			m_bodyLocate.setCurrentData(mefs.data);
		}
		
		private function refreshShape():void
		{
			m_bodyShape.refresh(true , false);
			m_meshBreathEditor.testReset();
		}
		private function onClickToEditBreath(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{
			
			m_bodyShape.data = mefs.data;
			m_bodyShape.data.genUVData();
			m_bodyShape.data.genIndicesData();
			
			m_bodyShape.refresh(true , false);
			m_meshBreathEditor.setCurrentData(m_bodyShape.data);
			
		}
		private function onClickToView(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{
			
			m_bodyShape.data = mefs.data;
			m_bodyShape.data.genUVData();
			m_bodyShape.data.genIndicesData();
			
			m_bodyView.setCurrentData(m_bodyShape.data);
			
		}
		
		
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [ new FileFilter("image (*.png)" , "*.png") , new FileFilter("image list(*.imglist)" , "*.imglist")] , true);
		}

		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , FilePicker.getShortName(_filename) , _filename , "BODY");
			Library.getS().addTexture(_texture);
			
			m_efl.visible = true;
			m_tb.activateAll(null);
			m_efl.addTexture(new ModuleBodyFrame(_texture) ,  _texture.name);
			
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
		
			m_bodyContainer.data = null;
			m_bodyContainer.refresh();
			
			m_bodyShape.data = null;
			m_bodyShape.refresh(true , false);
			
			enablePage(-1);
			deactivate();
			
			m_quadrant2.setVertex(null);
			
			m_moduleBodyFrameList = null;
		}
		
		private var m_moduleBodyFrameList : Vector.<XML>;
	
		private function onModuleBodyFrameInited(_mef : ModuleBodyFrame):void
		{
			
			m_efl.addTexture(_mef , _mef.name);
			m_efl.visible = true;
			m_tb.activateAll(null);
			
			if (m_moduleBodyFrameList.length) {
				var mef : ModuleBodyFrame = new ModuleBodyFrame(null);
				mef.fromXMLString(m_moduleBodyFrameList.shift(), onModuleBodyFrameInited);
			}
			else {
				m_moduleBodyFrameList = null;
			}
		}
		
		public override function onOpenXML(__root : XML):void
		{
			
			var eyeXML : XMLList = __root.ModuleBody;
			
			for each (var item : XML in eyeXML.elements())
			{
				//trace(item.toXMLString());
				if (item.name() == "ModuleBodyFrames")
				{
					m_moduleBodyFrameList = new Vector.<XML>
					for each (var itemModuleEyeFrame : XML in item.ModuleBodyFrame )
					{	
						m_moduleBodyFrameList.push(itemModuleEyeFrame);
					}
					
					if (m_moduleBodyFrameList.length) {
						var mef : ModuleBodyFrame = new ModuleBodyFrame(null);
						mef.fromXMLString(m_moduleBodyFrameList.shift(), onModuleBodyFrameInited);
					}	
				}
				
			}
		}
		
		
		public override function onExport(__rootBA : ByteArray):void
		{
			var baData : ByteArray = new ByteArray();
			baData.endian = Endian.LITTLE_ENDIAN;
			
			
			
			{	
				
				baData.writeByte(1);
				ByteArrayUtil.writeUnsignedByteOrShort(baData , ModuleBodyData.s_frameList.length);
				for each (var _mhf : ModuleBodyFrame in ModuleBodyData.s_frameList)
				{
					_mhf.encode(baData);
				}
			}
			
			__rootBA.writeByte(0x24);
			ByteArrayUtil.writeUnsignedShortOrInt(__rootBA , baData.length);
			__rootBA.writeBytes(baData);
			
			
		}
		
		public override function onSave(__root : XML):void
		{
			
			if (ModuleBodyData.s_frameList && ModuleBodyData.s_frameList.length)
			{
				var str : String = "<ModuleBody>";
					str += "<ModuleBodyFrames>";
					for each (var _mef : ModuleBodyFrame in ModuleBodyData.s_frameList)
					{
						str += _mef.toXMLString();
					}
					str += "</ModuleBodyFrames>";
					
				str += "</ModuleBody>";
				
				__root.appendChild(
					new XML(str)
				);
			}
			else
			{
				var ModuleBodyXML : XML = <ModuleBody/>;
				__root.appendChild(
					ModuleBodyXML
				);
			}
		}
		
		
	}

}