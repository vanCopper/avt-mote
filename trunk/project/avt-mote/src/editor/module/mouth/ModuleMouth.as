package editor.module.mouth
{
	import editor.config.StringPool;
	import editor.Library;
	import editor.module.head.ModuleHead3DView;
	import editor.module.head.ModuleHeadData;
	import editor.module.ModuleBase;
	import editor.struct.Texture2D;
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtVertex3D;
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
	public class ModuleMouth extends ModuleBase 
	{
		private var m_tb : ModuleMouthToolbar;
		private var m_eqm : ModuleMouthEQMgr;
		private var m_quadrant2 : EdtQuadrant;
		private var m_quadrant1 : EdtQuadrant;
		private var m_quadrant0 : EdtQuadrant;
		private var m_quadrant3 : EdtQuadrant;
		
		private var m_efl : ModuleMouthFrameLib;
		
		//private var m_meshEditor : ModuleMouthMeshEditor;
		private var m_mouthLocate : ModuleMouthLocate;
		//private var m_mouthZAdj : ModuleMouthZAdjust;
		private var m_lastVertexArray : Vector.<EdtVertex3D>;
		
		private var m_mouthContainer : ModuleMouthFrameSprite;
		private var m_mouthView : ModuleMouthView;
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
		
		public function ModuleMouth(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_MOUTH);
			
			m_tb = new ModuleMouthToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			//m_quadrant2._xQ = -100;
			//m_quadrant2._yQ = -100;
			
			
			m_eqm = new ModuleMouthEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			m_eqm.visible = false;
			
			m_mouthContainer = new ModuleMouthFrameSprite(null);
			m_quadrant2.indicate = m_mouthContainer;
			
			m_quadrant2.fullScreen = (true);
			m_quadrant2.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant2;
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_tb.btnImport.releaseFunction = onOpen;
			m_tb.btnAF.releaseFunction = function (btn : BSSButton):void { enablePage(0);}
			m_tb.btnLocate.releaseFunction = function (btn : BSSButton):void { enablePage(1);}
			m_tb.btnZAdj.releaseFunction = function (btn : BSSButton):void { enablePage(2); }
			m_tb.btnView.releaseFunction = function (btn : BSSButton):void { enablePage(3); }
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_efl  = new ModuleMouthFrameLib();
			m_efl.x = 650;
			m_efl.y = 240;
			m_efl.visible = false;
			m_efl.clickFuntion = null;
			
			
			m_content.addChild(m_efl);
			
			m_mouthContainer.view.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
			m_mouthContainer.view.addEventListener(MouseEvent.MOUSE_UP , onMouse);
			
			
			
			
			m_mouthLocate = new ModuleMouthLocate();
			m_content.addChild(m_mouthLocate);
			m_mouthLocate.visible = false;
			
			
			
			//m_mouthZAdj = new ModuleMouthZAdjust();
			//m_content.addChild(m_mouthZAdj);
			//m_mouthZAdj.visible = false;
			
			/*
			m_hairProperty = new ModuleMouthProperty();
			m_content.addChild(m_hairProperty);
			m_hairProperty.visible = false;
			*/
			
			m_mouthView = new ModuleMouthView();
			m_content.addChild(m_mouthView);
			m_mouthView.visible = false;
			
		}
		
		private function onMouse(e:MouseEvent):void 
		{
		
			if (m_mouthContainer.data)
			{
				if (e.type == MouseEvent.MOUSE_DOWN)
				{
					m_mouthContainer.view.startDrag();
				}
				else {
					
					m_mouthContainer.view.stopDrag();
					//trace(m_mouthContainer.data.offsetX , m_mouthContainer.data.offsetY)
					m_mouthContainer.data.offsetX = m_mouthContainer.view.x;
					m_mouthContainer.data.offsetY = m_mouthContainer.view.y;
					//trace("A" + m_mouthContainer.data.offsetX , m_mouthContainer.data.offsetY)
					
				}
			}
			
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
				//m_meshEditor.visible = false;
				m_efl.clickFuntion = null;
				m_eqm.visible = false;
				m_efl.clickFuntion = null;
				m_mouthContainer.mouseEnabled = false;
				
			}
			else if (p == 1)
			{
				m_mouthLocate.deactivate();
				m_mouthLocate.visible = false;
				m_efl.clickFuntion = null;
			}
			else if (p == 2)
			{
				m_eqm.visible = false;
				m_eqm.remainQuadrant(m_quadrant2);
				m_eqm.curEdtQuadrant = m_quadrant2;
				m_quadrant2.indicate = null;
				m_eqm.useSelector = false;
				//m_mouthZAdj.visible = false;
			}
			/*else if (p == 3)
			{
				m_hairProperty.visible = false;
				m_efl.clickFuntion = null;
				m_hairProperty.deactivate();
			}*/
			else if (p == 3)
			{
				m_mouthView.visible = false;
				m_efl.clickFuntion = null;
				m_mouthView.deactivate();
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
				//m_meshEditor.visible = true;
				m_efl.clickFuntion = onClickToEdit;
				m_eqm.visible = true;
				m_quadrant2.indicate = m_mouthContainer;
				m_quadrant2.setVertex(null);
				m_eqm.changeFunction = null;
				m_mouthContainer.mouseEnabled = true;
				m_eqm.useSelector = false;
			}
			else if (p == 1)
			{
				 m_mouthLocate.visible = true;
				 m_mouthLocate.activate();
				 m_efl.clickFuntion = onClickToLocate;
			}
			else if (p == 2)
			{
				init4Quadrant();
			 
				m_efl.clickFuntion = null;
				m_eqm.visible = true;
				m_quadrant2.indicate = null;
				//m_mouthZAdj.visible = true;
				m_efl.clickFuntion = null;
				m_eqm.useSelector = true;
				
				
				m_eqm.changeFunction = onZAdjChange;
				
				setZVertex();
			}
			else if (p == 3)
			{
				m_mouthView.visible = true;
				m_efl.clickFuntion = changeMouth;
				m_mouthView.activate();
			}
		}
		
		private function setZVertexConnect():void
		{
			if (ModuleMouthData.mouthV0)
			{
				ModuleMouthData.mouthV0.priority = 1;
				ModuleMouthData.mouthV1.priority = 2;
				ModuleMouthData.mouthV2.priority = 3;
				
				EdtVertex3D.connect2PT(ModuleMouthData.mouthV0 , ModuleMouthData.mouthV1);
				EdtVertex3D.connect2PT(ModuleMouthData.mouthV1 , ModuleMouthData.mouthV2);
				EdtVertex3D.connect2PT(ModuleMouthData.mouthV0 , ModuleMouthData.mouthV2);
			}
		}
		
		private function setZVertex():void
		{
			if (!ModuleMouthData.mouthV0)
			{
				ModuleMouthData.mouthV0 = new EdtVertex3D(ModuleMouthData.centerX, ModuleMouthData.centerY + 10, 0);
				ModuleMouthData.mouthV1 = new EdtVertex3D(ModuleMouthData.centerX - 15 , ModuleMouthData.centerY - 10, 0);
				ModuleMouthData.mouthV2 = new EdtVertex3D(ModuleMouthData.centerX + 15 , ModuleMouthData.centerY - 10, 0);
				
				setZVertexConnect();
			}
			
			var ret : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
			if (!ModuleHeadData.s_vertexRelativeData || !ModuleHeadData.s_vertexRelativeData.length)
				ModuleHeadData.genVertexRelativeData();
			
			for each ( var rv : Vertex3D in ModuleHeadData.s_vertexRelativeData )
			{
				var newV : EdtVertex3D = new EdtVertex3D();
				newV.x  = rv.x;
				newV.y  = rv.y;
				newV.z  = rv.z;
				newV.scale = 0.5;
				ret.push(newV);
				
			}
			if (ret.length)
				ModuleHeadData.genConnect(ModuleHeadData.s_pointPerLine , ModuleHeadData.s_totalLine , ret);
			
			ret.push(ModuleMouthData.mouthV0);
			ret.push(ModuleMouthData.mouthV1);
			ret.push(ModuleMouthData.mouthV2);
			
			
			
			ModuleMouthData.mouthV0.scale = 
			ModuleMouthData.mouthV1.scale = 
			ModuleMouthData.mouthV2.scale = 1.5;
			
			m_lastVertexArray = ret;
			
			m_eqm.setVertex(ret);
		}
		
		
		private function onSetMesh(_data:ModuleMouthFrame):void 
		{
			m_quadrant2.setVertex(_data.vertexData);
		}
		
		private function onClickToEdit(__item : Sprite , mefs : ModuleMouthFrameSprite , _name : String ):void 
		{
			
			m_mouthContainer.data = mefs.data;
			m_mouthContainer.refresh();
			m_mouthContainer.view.x = mefs.data.offsetX;
			m_mouthContainer.view.y = mefs.data.offsetY;
			
			//m_meshEditor.setCurrentData(m_mouthContainer.data);
			
		}
		private function onClickToLocate(__item : Sprite , mefs : ModuleMouthFrameSprite , _name : String ):void 
		{
			m_mouthLocate.setCurrentData(mefs.data);
		}
		private function changeMouth(__item : Sprite , mefs : ModuleMouthFrameSprite , _name : String ):void 
		{
			m_mouthView.setCurrentData(mefs.data);
		}
		private function onClickToZAdj(__item : Sprite , mefs : ModuleMouthFrameSprite , _name : String ):void 
		{
			//m_mouthZAdj.setCurrentData(mefs.data);
			//m_eqm.setVertex(m_mouthZAdj.getVertex());
		}
		private function onZAdjChange():void 
		{
			if (m_lastVertexArray)
			{
				ModuleMouthData.mouthV0 = m_lastVertexArray[m_lastVertexArray.length - 3].cloneEdtVertex3D();
				ModuleMouthData.mouthV1 = m_lastVertexArray[m_lastVertexArray.length - 2].cloneEdtVertex3D();
				ModuleMouthData.mouthV2 = m_lastVertexArray[m_lastVertexArray.length - 1].cloneEdtVertex3D();
				
				//trace(ModuleMouthData.mouthV0);
				ModuleMouthData.mouthPlane.gen3Point(ModuleMouthData.mouthV0, ModuleMouthData.mouthV1, ModuleMouthData.mouthV2);
				
				setZVertex();
				setZVertexConnect();
			}
			
		
		}
		
		
		
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [new FileFilter("image list(*.imglist)" , "*.imglist") , new FileFilter("image (*.png)" , "*.png")]);
		}

		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , FilePicker.getShortName(_filename) , _filename , "MOUTH");
			Library.getS().addTexture(_texture);
			
			m_efl.visible = true;
			m_tb.activateAll(null);
			m_efl.addTexture(new ModuleMouthFrame(_texture) ,  _texture.name);
			
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
		
			m_mouthContainer.data = null;
			m_mouthContainer.refresh();
			
			enablePage(-1);
			deactivate();
			
			m_quadrant2.setVertex(null);
			
			m_ModuleMouthFrameList = null;
		}
		private var m_ModuleMouthFrameList : Vector.<XML>;
	
		private function onModuleMouthFrameInited(_mef : ModuleMouthFrame):void
		{
			
			m_efl.addTexture(_mef , _mef.name);
			m_efl.visible = true;
			m_tb.activateAll(null);
			
			if (m_ModuleMouthFrameList.length) {
				var mef : ModuleMouthFrame = new ModuleMouthFrame(null);
				mef.fromXMLString(m_ModuleMouthFrameList.shift(), onModuleMouthFrameInited);
			}
			else {
				m_ModuleMouthFrameList = null;
			}
		}
		
		public override function onOpenXML(__root : XML):void
		{
			
			var eyeXML : XMLList = __root.ModuleMouth;
			
			for each (var item : XML in eyeXML.elements())
			{
				//trace(item.toXMLString());
				if (item.name() == "ModuleMouthFrames")
				{
					m_ModuleMouthFrameList = new Vector.<XML>
					for each (var itemModuleEyeFrame : XML in item.ModuleMouthFrame )
					{	
						m_ModuleMouthFrameList.push(itemModuleEyeFrame);
					}
					
					if (m_ModuleMouthFrameList.length) {
						var mef : ModuleMouthFrame = new ModuleMouthFrame(null);
						mef.fromXMLString(m_ModuleMouthFrameList.shift(), onModuleMouthFrameInited);
					}	
				}
				else if (item.name() == "ModuleMouthLocate")
				{
					ModuleMouthData.centerX = Number(item.centerX.text());
					ModuleMouthData.centerY = Number(item.centerY.text());
					ModuleMouthData.mouthPlane.fromXMLString(item.mouthPlane.text());
					if (item.mouthV0 != undefined && item.mouthV0.text())
					{	ModuleMouthData.mouthV0 = new EdtVertex3D();  ModuleMouthData.mouthV0.fromXMLString(item.mouthV0.text());}
					if (item.mouthV1 != undefined && item.mouthV1.text())
					{	ModuleMouthData.mouthV1 = new EdtVertex3D();  ModuleMouthData.mouthV1.fromXMLString(item.mouthV1.text());}
					if (item.mouthV2 != undefined && item.mouthV2.text())
					{	ModuleMouthData.mouthV2 = new EdtVertex3D();  ModuleMouthData.mouthV2.fromXMLString(item.mouthV2.text()); }
					
					if (ModuleMouthData.mouthV0 && ModuleMouthData.mouthV1 && ModuleMouthData.mouthV2)
					{
						ModuleMouthData.mouthV0.priority = 1;
						ModuleMouthData.mouthV1.priority = 2;
						ModuleMouthData.mouthV2.priority = 3;
						
						EdtVertex3D.connect2PT(ModuleMouthData.mouthV0 , ModuleMouthData.mouthV1);
						EdtVertex3D.connect2PT(ModuleMouthData.mouthV1 , ModuleMouthData.mouthV2);
						EdtVertex3D.connect2PT(ModuleMouthData.mouthV0 , ModuleMouthData.mouthV2);
					}
					else
					{
						ModuleMouthData.mouthV0 =
						ModuleMouthData.mouthV1 = 
						ModuleMouthData.mouthV2 = null;
				
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
				ByteArrayUtil.writeUnsignedByteOrShort(baData , ModuleMouthData.s_frameList.length);
				for each (var _mhf : ModuleMouthFrame in ModuleMouthData.s_frameList)
				{
					_mhf.encode(baData);
				}
			}
			{	
				
				baData.writeByte(2);
				baData.writeFloat(ModuleMouthData.centerX);
				baData.writeFloat(ModuleMouthData.centerY);
				ModuleMouthData.mouthPlane.encode(baData);
			}
			
			
			__rootBA.writeByte(0x25);
			ByteArrayUtil.writeUnsignedShortOrInt(__rootBA , baData.length);
			__rootBA.writeBytes(baData);
			
			
		}
		
		public override function onSave(__root : XML):void
		{
			
			if (ModuleMouthData.s_frameList && ModuleMouthData.s_frameList.length)
			{
				var str : String = "<ModuleMouth>";
					str += "<ModuleMouthFrames>";
					for each (var _mef : ModuleMouthFrame in ModuleMouthData.s_frameList)
					{
						str += _mef.toXMLString();
					}
					str += "</ModuleMouthFrames>";
					
					str += "<ModuleMouthLocate>";
						str += "<centerX>" + ModuleMouthData.centerX + "</centerX>";
						str += "<centerY>" + ModuleMouthData.centerY + "</centerY>";
						if (ModuleMouthData.mouthV0) str += "<mouthV0>" + ModuleMouthData.mouthV0.toXMLString() + "</mouthV0>";
						if (ModuleMouthData.mouthV1) str += "<mouthV1>" + ModuleMouthData.mouthV1.toXMLString() + "</mouthV1>";
						if (ModuleMouthData.mouthV2) str += "<mouthV2>" + ModuleMouthData.mouthV2.toXMLString() + "</mouthV2>";
						
						str += "<mouthPlane>" + ModuleMouthData.mouthPlane.toXMLString() + "</mouthPlane>";
					str += "</ModuleMouthLocate>";
					
				str += "</ModuleMouth>";
				
				__root.appendChild(
					new XML(str)
				);
			}
			else
			{
				var ModuleEyeXML : XML = <ModuleMouth/>;
				__root.appendChild(
					ModuleEyeXML
				);
			}
		}
		
		
	}

}