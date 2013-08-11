package editor.module.brow
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
	public class ModuleBrow extends ModuleBase 
	{
		private var m_tb : ModuleBrowToolbar;
		private var m_eqm : ModuleBrowEQMgr;
		private var m_quadrant2 : EdtQuadrant;
		private var m_quadrant1 : EdtQuadrant;
		private var m_quadrant0 : EdtQuadrant;
		private var m_quadrant3 : EdtQuadrant;
		
		private var m_efl : ModuleBrowFrameLib;
		
		//private var m_meshEditor : ModuleBrowMeshEditor;
		private var m_browLocate : ModuleBrowLocate;
		//private var m_browZAdj : ModuleBrowZAdjust;
		private var m_lastVertexArray : Vector.<EdtVertex3D>;
		
		private var m_browContainer : ModuleBrowFrameSprite;
		private var m_browView : ModuleBrowView;
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
		
		public function ModuleBrow(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_BROW);
			
			m_tb = new ModuleBrowToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			//m_quadrant2._xQ = -100;
			//m_quadrant2._yQ = -100;
			
			
			m_eqm = new ModuleBrowEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			m_eqm.visible = false;
			
			m_browContainer = new ModuleBrowFrameSprite(null);
			m_quadrant2.indicate = m_browContainer;
			
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
			
			m_efl  = new ModuleBrowFrameLib();
			m_efl.x = 650;
			m_efl.y = 240;
			m_efl.visible = false;
			m_efl.clickFuntion = null;
			
			
			m_content.addChild(m_efl);
			
			m_browContainer.view.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
			m_browContainer.view.addEventListener(MouseEvent.MOUSE_UP , onMouse);
			
			
			
			
			m_browLocate = new ModuleBrowLocate();
			m_content.addChild(m_browLocate);
			m_browLocate.visible = false;
			
			
			
			//m_browZAdj = new ModuleBrowZAdjust();
			//m_content.addChild(m_browZAdj);
			//m_browZAdj.visible = false;
			
			/*
			m_hairProperty = new ModuleBrowProperty();
			m_content.addChild(m_hairProperty);
			m_hairProperty.visible = false;
			*/
			
			m_browView = new ModuleBrowView();
			m_content.addChild(m_browView);
			m_browView.visible = false;
			
		}
		
		private function onMouse(e:MouseEvent):void 
		{
		
			if (m_browContainer.data)
			{
				if (e.type == MouseEvent.MOUSE_DOWN)
				{
					m_browContainer.view.startDrag();
				}
				else {
					
					m_browContainer.view.stopDrag();
					//trace(m_browContainer.data.offsetX , m_browContainer.data.offsetY)
					
					///if (m_browContainer.data.name.indexOf("#FLIP") != -1)
					//{
						m_browContainer.data.offsetX = m_browContainer.view.x;
						m_browContainer.data.offsetY = m_browContainer.view.y;
					//}
					
					
					//trace("A" + m_browContainer.data.offsetX , m_browContainer.data.offsetY)
					
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
				m_browContainer.mouseEnabled = false;
				
			}
			else if (p == 1)
			{
				m_browLocate.deactivate();
				m_browLocate.visible = false;
				m_efl.clickFuntion = null;
			}
			else if (p == 2)
			{
				m_eqm.visible = false;
				m_eqm.remainQuadrant(m_quadrant2);
				m_eqm.curEdtQuadrant = m_quadrant2;
				m_quadrant2.indicate = null;
				m_eqm.useSelector = false;
				//m_browZAdj.visible = false;
			}
			/*else if (p == 3)
			{
				m_hairProperty.visible = false;
				m_efl.clickFuntion = null;
				m_hairProperty.deactivate();
			}*/
			else if (p == 3)
			{
				m_browView.visible = false;
				m_efl.clickFuntion = null;
				m_browView.deactivate();
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
				m_quadrant2.indicate = m_browContainer;
				m_quadrant2.setVertex(null);
				m_eqm.changeFunction = null;
				m_browContainer.mouseEnabled = true;
				m_eqm.useSelector = false;
			}
			else if (p == 1)
			{
				 m_browLocate.visible = true;
				 m_browLocate.activate();
				 m_efl.clickFuntion = onClickToLocate;
			}
			else if (p == 2)
			{
				init4Quadrant();
			 
				m_efl.clickFuntion = null;
				m_eqm.visible = true;
				m_quadrant2.indicate = null;
				//m_browZAdj.visible = true;
				m_efl.clickFuntion = null;
				m_eqm.useSelector = true;
				
				
				m_eqm.changeFunction = onZAdjChange;
				
				setZVertex();
			}
			else if (p == 3)
			{
				m_browView.visible = true;
				m_efl.clickFuntion = changeMouth;
				m_browView.activate();
			}
		}
		private function setZVertexConnect():void
		{
			if (ModuleBrowData.browVL0)
			{
				ModuleBrowData.browVL0.priority = 1;
				ModuleBrowData.browVL1.priority = 2;
				ModuleBrowData.browVL2.priority = 3;
				
				EdtVertex3D.connect2PT(ModuleBrowData.browVL0 , ModuleBrowData.browVL1);
				EdtVertex3D.connect2PT(ModuleBrowData.browVL1 , ModuleBrowData.browVL2);
				EdtVertex3D.connect2PT(ModuleBrowData.browVL0 , ModuleBrowData.browVL2);
				
				///////////////////////////////////

				ModuleBrowData.browVR0.priority = 4;
				ModuleBrowData.browVR1.priority = 5;
				ModuleBrowData.browVR2.priority = 6;
				
				EdtVertex3D.connect2PT(ModuleBrowData.browVR0 , ModuleBrowData.browVR1);
				EdtVertex3D.connect2PT(ModuleBrowData.browVR1 , ModuleBrowData.browVR2);
				EdtVertex3D.connect2PT(ModuleBrowData.browVR0 , ModuleBrowData.browVR2);
			}
		}
		
		private function setZVertex():void
		{
			if (!ModuleBrowData.browVL0)
			{
				ModuleBrowData.browVL0 = new EdtVertex3D(ModuleBrowData.centerLX, ModuleBrowData.centerLY + 10, 0);
				ModuleBrowData.browVL1 = new EdtVertex3D(ModuleBrowData.centerLX - 15 , ModuleBrowData.centerLY - 10, 0);
				ModuleBrowData.browVL2 = new EdtVertex3D(ModuleBrowData.centerLX + 15 , ModuleBrowData.centerLY - 10, 0);
				
				///////////////////////////////////
				ModuleBrowData.browVR0 = new EdtVertex3D(ModuleBrowData.centerRX, ModuleBrowData.centerRY + 10, 0);
				ModuleBrowData.browVR1 = new EdtVertex3D(ModuleBrowData.centerRX - 15 , ModuleBrowData.centerRY - 10, 0);
				ModuleBrowData.browVR2 = new EdtVertex3D(ModuleBrowData.centerRX + 15 , ModuleBrowData.centerRY - 10, 0);
				
				
				
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
			
			ret.push(ModuleBrowData.browVL0);
			ret.push(ModuleBrowData.browVL1);
			ret.push(ModuleBrowData.browVL2);
			
			ret.push(ModuleBrowData.browVR0);
			ret.push(ModuleBrowData.browVR1);
			ret.push(ModuleBrowData.browVR2);
			
			
			ModuleBrowData.browVL0.scale = 
			ModuleBrowData.browVL1.scale = 
			ModuleBrowData.browVL2.scale = 
			
			ModuleBrowData.browVR0.scale = 
			ModuleBrowData.browVR1.scale = 
			ModuleBrowData.browVR2.scale = 
			1.5;
			
			m_lastVertexArray = ret;
			
			m_eqm.setVertex(ret);
		}
		
		
		private function onClickToEdit(__item : Sprite , mefs : ModuleBrowFrameSprite , _name : String ):void 
		{
			
			m_browContainer.data = mefs.data;
			m_browContainer.refresh();
			m_browContainer.view.x = mefs.data.offsetX;
			m_browContainer.view.y = mefs.data.offsetY;
			
			//m_meshEditor.setCurrentData(m_browContainer.data);
			
		}
		private function onClickToLocate(__item : Sprite , mefs : ModuleBrowFrameSprite , _name : String ):void 
		{
			m_browLocate.setCurrentData(mefs.data);
		}
		private function changeMouth(__item : Sprite , mefs : ModuleBrowFrameSprite , _name : String ):void 
		{
			m_browView.setCurrentData(mefs.data);
		}
		private function onClickToZAdj(__item : Sprite , mefs : ModuleBrowFrameSprite , _name : String ):void 
		{
			//m_browZAdj.setCurrentData(mefs.data);
			//m_eqm.setVertex(m_browZAdj.getVertex());
		}
		private function onZAdjChange():void 
		{
			if (m_lastVertexArray)
			{
				ModuleBrowData.browVL0 = m_lastVertexArray[m_lastVertexArray.length - 6].cloneEdtVertex3D();
				ModuleBrowData.browVL1 = m_lastVertexArray[m_lastVertexArray.length - 5].cloneEdtVertex3D();
				ModuleBrowData.browVL2 = m_lastVertexArray[m_lastVertexArray.length - 4].cloneEdtVertex3D();
				
				ModuleBrowData.browVR0 = m_lastVertexArray[m_lastVertexArray.length - 3].cloneEdtVertex3D();
				ModuleBrowData.browVR1 = m_lastVertexArray[m_lastVertexArray.length - 2].cloneEdtVertex3D();
				ModuleBrowData.browVR2 = m_lastVertexArray[m_lastVertexArray.length - 1].cloneEdtVertex3D();
				
				//trace(ModuleBrowData.browV0);
				ModuleBrowData.browPlaneL.gen3Point(ModuleBrowData.browVL0, ModuleBrowData.browVL1, ModuleBrowData.browVL2);
				ModuleBrowData.browPlaneR.gen3Point(ModuleBrowData.browVR0, ModuleBrowData.browVR1, ModuleBrowData.browVR2);
				setZVertex();
				setZVertexConnect();
			}
			
		
		}
		
		
		
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [new FileFilter("image list(*.imglist)" , "*.imglist") , new FileFilter("image (*.png)" , "*.png")]);
		}

		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , FilePicker.getShortName(_filename) , _filename , "BROW");
			Library.getS().addTexture(_texture);
			var _textureFilp : Texture2D = new Texture2D(bitmapData , FilePicker.getShortName(_filename) + "#FLIP" , _filename  , "BROW" , _texture.rectX + _texture.rectW , _texture.rectY , -_texture.rectW , _texture.rectH);
			Library.getS().addTexture(_textureFilp);

			m_efl.visible = true;
			m_tb.activateAll(null);
			m_efl.addTexture(new ModuleBrowFrame(_texture) ,  _texture.name);
			m_efl.addTexture(new ModuleBrowFrame(_textureFilp) ,  _textureFilp.name);
			
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
		
			m_browContainer.data = null;
			m_browContainer.refresh();
			
			enablePage(-1);
			deactivate();
			
			m_quadrant2.setVertex(null);
			
			m_ModuleBrowFrameList = null;
		}
		private var m_ModuleBrowFrameList : Vector.<XML>;
	
		private function onModuleBrowFrameInited(_mef : ModuleBrowFrame):void
		{
			
			m_efl.addTexture(_mef , _mef.name);
			var _rawName : String = _mef.name.replace("#FLIP" , "");
			var mbf : ModuleBrowFrame = ModuleBrowFrameLib.getSingleton().getModuleBrowFrameData(_rawName);

			
			var _textureFilp : Texture2D = new Texture2D(mbf.texture.bitmapData , _rawName + "#FLIP" , mbf.texture.filename  , "BROW" , mbf.texture.rectX + mbf.texture.rectW , mbf.texture.rectY , -mbf.texture.rectW , mbf.texture.rectH);
			Library.getS().addTexture(_textureFilp);
			m_efl.addTexture(new ModuleBrowFrame(_textureFilp) ,  _textureFilp.name);
			
			/////////////////////////////////////////////////////////
			
			
			m_efl.visible = true;
			m_tb.activateAll(null);
			
			if (m_ModuleBrowFrameList.length) {
				var mef : ModuleBrowFrame = new ModuleBrowFrame(null);
				mef.fromXMLString(m_ModuleBrowFrameList.shift(), onModuleBrowFrameInited);
			}
			else {
				m_ModuleBrowFrameList = null;
			}
		}
		
		public override function onOpenXML(__root : XML):void
		{
			
			var eyeXML : XMLList = __root.ModuleBrow;
			
			for each (var item : XML in eyeXML.elements())
			{
				//trace(item.toXMLString());
				if (item.name() == "ModuleBrowFrames")
				{
					m_ModuleBrowFrameList = new Vector.<XML>
					for each (var itemModuleEyeFrame : XML in item.ModuleBrowFrame )
					{	
						m_ModuleBrowFrameList.push(itemModuleEyeFrame);
					}
					
					if (m_ModuleBrowFrameList.length) {
						var mef : ModuleBrowFrame = new ModuleBrowFrame(null);
						mef.fromXMLString(m_ModuleBrowFrameList.shift(), onModuleBrowFrameInited);
					}	
				}
				else if (item.name() == "ModuleBrowLocate")
				{
					ModuleBrowData.centerLX = Number(item.centerLX.text());
					ModuleBrowData.centerLY = Number(item.centerLY.text());
					ModuleBrowData.browPlaneL.fromXMLString(item.mouthPlaneL.text());
					if (item.mouthVL0 != undefined && item.mouthVL0.text())
					{	ModuleBrowData.browVL0 = new EdtVertex3D();  ModuleBrowData.browVL0.fromXMLString(item.mouthVL0.text());}
					if (item.mouthVL1 != undefined && item.mouthVL1.text())
					{	ModuleBrowData.browVL1 = new EdtVertex3D();  ModuleBrowData.browVL1.fromXMLString(item.mouthVL1.text());}
					if (item.mouthVL2 != undefined && item.mouthVL2.text())
					{	ModuleBrowData.browVL2 = new EdtVertex3D();  ModuleBrowData.browVL2.fromXMLString(item.mouthVL2.text()); }
					
					
					ModuleBrowData.centerRX = Number(item.centerRX.text());
					ModuleBrowData.centerRY = Number(item.centerRY.text());
					ModuleBrowData.browPlaneR.fromXMLString(item.mouthPlaneR.text());
					if (item.mouthVR0 != undefined && item.mouthVR0.text())
					{	ModuleBrowData.browVR0 = new EdtVertex3D();  ModuleBrowData.browVR0.fromXMLString(item.mouthVR0.text());}
					if (item.mouthVR1 != undefined && item.mouthVR1.text())
					{	ModuleBrowData.browVR1 = new EdtVertex3D();  ModuleBrowData.browVR1.fromXMLString(item.mouthVR1.text());}
					if (item.mouthVR2 != undefined && item.mouthVR2.text())
					{	ModuleBrowData.browVR2 = new EdtVertex3D();  ModuleBrowData.browVR2.fromXMLString(item.mouthVR2.text()); }
					
					
					
					if (ModuleBrowData.browVL0 && ModuleBrowData.browVL1 && ModuleBrowData.browVL2)
					{
						ModuleBrowData.browVL0.priority = 1;
						ModuleBrowData.browVL1.priority = 2;
						ModuleBrowData.browVL2.priority = 3;
						
						EdtVertex3D.connect2PT(ModuleBrowData.browVL0 , ModuleBrowData.browVL1);
						EdtVertex3D.connect2PT(ModuleBrowData.browVL1 , ModuleBrowData.browVL2);
						EdtVertex3D.connect2PT(ModuleBrowData.browVL0 , ModuleBrowData.browVL2);
					}
					else
					{
						ModuleBrowData.browVL0 =
						ModuleBrowData.browVL1 = 
						ModuleBrowData.browVL2 = null;
				
					}
					
					
					if (ModuleBrowData.browVR0 && ModuleBrowData.browVR1 && ModuleBrowData.browVR2)
					{
						ModuleBrowData.browVR0.priority = 4;
						ModuleBrowData.browVR1.priority = 5;
						ModuleBrowData.browVR2.priority = 6;
						
						EdtVertex3D.connect2PT(ModuleBrowData.browVR0 , ModuleBrowData.browVR1);
						EdtVertex3D.connect2PT(ModuleBrowData.browVR1 , ModuleBrowData.browVR2);
						EdtVertex3D.connect2PT(ModuleBrowData.browVR0 , ModuleBrowData.browVR2);
					}
					else
					{
						ModuleBrowData.browVR0 =
						ModuleBrowData.browVR1 = 
						ModuleBrowData.browVR2 = null;
				
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
				ByteArrayUtil.writeUnsignedByteOrShort(baData , ModuleBrowData.s_frameList.length / 2);
				for each (var _mhf : ModuleBrowFrame in ModuleBrowData.s_frameList)
				{
					if (_mhf.name.indexOf("#FLIP") == -1)
						_mhf.encode(baData);
				}
			}
			{	
				
				baData.writeByte(2);
				baData.writeFloat(ModuleBrowData.centerLX);
				baData.writeFloat(ModuleBrowData.centerLY);
				ModuleBrowData.browPlaneL.encode(baData);
				
				baData.writeFloat(ModuleBrowData.centerRX);
				baData.writeFloat(ModuleBrowData.centerRY);
				ModuleBrowData.browPlaneR.encode(baData);
			}
			
			
			__rootBA.writeByte(0x26);
			ByteArrayUtil.writeUnsignedShortOrInt(__rootBA , baData.length);
			__rootBA.writeBytes(baData);
			
			
		}
		
		public override function onSave(__root : XML):void
		{
			
			if (ModuleBrowData.s_frameList && ModuleBrowData.s_frameList.length)
			{
				var str : String = "<ModuleBrow>";
					str += "<ModuleBrowFrames>";
					for each (var _mef : ModuleBrowFrame in ModuleBrowData.s_frameList)
					{
						if (_mef.name.indexOf("#FLIP") == -1)
							str += _mef.toXMLString();
					}
					str += "</ModuleBrowFrames>";
					
					str += "<ModuleBrowLocate>";
						str += "<centerLX>" + ModuleBrowData.centerLX + "</centerLX>";
						str += "<centerLY>" + ModuleBrowData.centerLY + "</centerLY>";
						if (ModuleBrowData.browVL0) str += "<mouthVL0>" + ModuleBrowData.browVL0.toXMLString() + "</mouthVL0>";
						if (ModuleBrowData.browVL1) str += "<mouthVL1>" + ModuleBrowData.browVL1.toXMLString() + "</mouthVL1>";
						if (ModuleBrowData.browVL2) str += "<mouthVL2>" + ModuleBrowData.browVL2.toXMLString() + "</mouthVL2>";
						
						str += "<mouthPlaneL>" + ModuleBrowData.browPlaneL.toXMLString() + "</mouthPlaneL>";
						
						str += "<centerRX>" + ModuleBrowData.centerRX + "</centerRX>";
						str += "<centerRY>" + ModuleBrowData.centerRY + "</centerRY>";
						if (ModuleBrowData.browVR0) str += "<mouthVR0>" + ModuleBrowData.browVR0.toXMLString() + "</mouthVR0>";
						if (ModuleBrowData.browVR1) str += "<mouthVR1>" + ModuleBrowData.browVR1.toXMLString() + "</mouthVR1>";
						if (ModuleBrowData.browVR2) str += "<mouthVR2>" + ModuleBrowData.browVR2.toXMLString() + "</mouthVR2>";
						str += "<mouthPlaneR>" + ModuleBrowData.browPlaneR.toXMLString() + "</mouthPlaneR>";
					str += "</ModuleBrowLocate>";
					
				str += "</ModuleBrow>";
				
				__root.appendChild(
					new XML(str)
				);
			}
			else
			{
				var ModuleEyeXML : XML = <ModuleBrow/>;
				__root.appendChild(
					ModuleEyeXML
				);
			}
		}
		
		
	}

}