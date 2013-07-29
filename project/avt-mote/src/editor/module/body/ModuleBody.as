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
	import editor.ui.SpriteWH;
	import editor.ui.SripteWithRect;
	import editor.util.ByteArrayUtil;
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
		
		private var m_hairContainer : ModuleBodyFrameSprite;
		
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
				
			if (m_hairContainer)
			{
				//m_hairContainer.dispose();
				m_hairContainer = null;
			}
			
			super.dispose();
		}
		
		public function ModuleBody(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_BODY);
			
			m_tb = new ModuleBodyToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			m_quadrant2._xQ = -100;
			m_quadrant2._yQ = -100;
			
			
			m_eqm = new ModuleBodyEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			
			m_hairContainer = new ModuleBodyFrameSprite(null);
			m_quadrant2.indicate = m_hairContainer;
			
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
				
			}
			else if (p == 1)
			{
				
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
		private function enablePage(p:int):void
		{
			for (var i : int = 0 ; i < 5; i++ )
			{
				if (p != i)
					disablePage(i);
			}
			
			if (p == 0)
			{
				
			}
			else if (p == 1)
			{
				
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
		
		
		private function onSetMesh(_data:ModuleBodyFrame):void 
		{
			m_quadrant2.setVertex(_data.vertexData);
		}
		
		private function onClickToEdit(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{
			
			m_hairContainer.data = mefs.data;
			m_hairContainer.refresh();
		}
		private function onClickToLocate(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{

		}
		
		private function onClickToZAdj(__item : Sprite , mefs : ModuleBodyFrameSprite , _name : String ):void 
		{
			
		}
		
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [ , new FileFilter("image (*.png)" , "*.png") , new FileFilter("image list(*.imglist)" , "*.imglist")]);
		}

		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , _filename , _filename , "BODY");
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
		
			m_hairContainer.data = null;
			m_hairContainer.refresh();
			
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
			
			
			
			
			{	
				
				baData.writeByte(1);
				ByteArrayUtil.writeUnsignedByteOrShort(baData , ModuleBodyData.s_frameList.length);
				for each (var _mhf : ModuleBodyFrame in ModuleBodyData.s_frameList)
				{
					_mhf.encode(baData);
				}
			}
			
			__rootBA.writeByte(0x23);
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
				var ModuleEyeXML : XML = <ModuleBody/>;
				__root.appendChild(
					ModuleEyeXML
				);
			}
		}
		
		
	}

}