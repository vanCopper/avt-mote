package 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.Config;
	import editor.Library;
	import editor.module.head.ModuleHead;
	import editor.ModuleBar;
	import editor.Toolbar;
	import editor.util.FilePicker;
	import editor.util.FilePickerAir;
	import editor.util.TextureLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIController.BSSPanel;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class MainAir extends Main
	{
		
		public override function initAirFunc():void
		{
			FilePickerAir;
			m_tb.btnSaveAs.releaseFunction = onSaveAsAir;
			m_tb.btnSave.releaseFunction = onSave;
			m_tb.btnOpen.releaseFunction = onOpenAir;
			
			
		}
		
		private function onSaveAsAir(btn:BSSButton):void 
		{			
			var file:File = new File();
			file.addEventListener(Event.SELECT, onSaveAir);
			file.browseForSave("save");
			m_loadFile = file;
		}
		
		private var m_textureAtlasPanel : BSSPanel;
		private var m_textureAtlas : TextureAtlas;
		private var m_dataBack : XML;
		
		public function getMergedBA(_xml : XML , _navtivePath : String) : ByteArray
		{
			var lastFileNameFull_bak : String = Config.lastFileNameFull;
			var _dataBack : XML = getXMLData();
			
			if (_navtivePath.lastIndexOf('\\') != -1)
			{
				_navtivePath = _navtivePath.substring(0 , _navtivePath.lastIndexOf('\\')) + "\\";
			} 
			else if (_navtivePath.lastIndexOf('/') != -1)
			{
				_navtivePath = _navtivePath.substring(0 , _navtivePath.lastIndexOf('/')) + "/";
			}
			TextureLoader.s_imgPath = _navtivePath;
			
			TextureLoader.s_fakeLoaderMode = true;
			newDoc();
			m_mb.onOpenXML(_xml);
			
			var ba : ByteArray = getAmxmlbByteArray();
			
			TextureLoader.s_fakeLoaderMode = false;
			_navtivePath = Config.lastFileNameFull;
			if (_navtivePath.lastIndexOf('\\') != -1)
			{
				_navtivePath = _navtivePath.substring(0 , _navtivePath.lastIndexOf('\\')) + "\\";
			} 
			else if (_navtivePath.lastIndexOf('/') != -1)
			{
				_navtivePath = _navtivePath.substring(0 , _navtivePath.lastIndexOf('/')) + "/";
			}
			TextureLoader.s_imgPath = _navtivePath;
			
			newDoc();
			m_mb.onOpenXML(_dataBack);
			
			return ba;
			
		}
		
		override public function onExport(btn:BSSButton):void 
		{
			var _dataBack : XML = getXMLData();
			
			if (!m_textureAtlasPanel) {
				m_textureAtlasPanel =
				BSSPanel.createSimpleBSSPanel(720 , 570 , 
				  BSSPanel.ENABLE_TITLE|BSSPanel.ENABLE_MOVE|BSSPanel.ENABLE_CLOSE
				);
				
				m_textureAtlasPanel.titleText = "texture atlas";
				
				m_textureAtlasPanel.closeFunction = function( caller : BSSPanel )
				: void {
					if (m_textureAtlasPanel.parent)
					{	
						m_textureAtlasPanel.parent.removeChild(m_textureAtlasPanel);
						m_textureAtlas.onNew();
					}
				}
				
				m_textureAtlas = new TextureAtlas();
				m_textureAtlasPanel.addChild(m_textureAtlas).y = 20;
				m_textureAtlasPanel.x = 10;
				m_textureAtlasPanel.y = 10;
			}
			
			addChild(m_textureAtlasPanel);
			
			m_textureAtlas.onNew();
			var _ba : ByteArray = new ByteArray();
			_ba.writeUTFBytes(_dataBack.toXMLString());
			_ba.position = 0;
			TextureAtlas.s_loadFile_name = Config.lastFileName;
			TextureAtlas.s_loadFile_nativePath = Config.lastFileNameFull;
			TextureAtlas.onDeal(_ba);
			//saveAmxmlb();
			
		}
		
		private function saveToFile(_file:File):void
		{
			
			Config.lastFileName = _file.name;
			Config.lastFileNameFull = _file.nativePath;
			
			
			var stream:FileStream = new FileStream();
			stream.open(_file, FileMode.WRITE);
			stream.position = 0;
				
			var nativePath : String = _file.nativePath;
			if (nativePath.lastIndexOf('\\') != -1)
			{
				nativePath = nativePath.substring(0 , nativePath.lastIndexOf('\\')) + "\\";
			} 
			else if (nativePath.lastIndexOf('/') != -1)
			{
				nativePath = nativePath.substring(0 , nativePath.lastIndexOf('/')) + "/";
			}
			
			TextureLoader.s_imgPath = nativePath;
			
			
			var data:ByteArray = new ByteArray();
			var _data : XML = getXMLData();
			data.writeUTFBytes(_data.toXMLString());
			stream.writeBytes(data);
			stream.close();
		}
		
		private function onSaveAir(e:Event):void {
			
			e.currentTarget.removeEventListener(Event.SELECT, onSaveAir);
			try{
				
				if (m_loadFile.nativePath.indexOf(".amxmla") == -1)
				{	
					m_loadFile.nativePath += ".amxmla";
				}
				saveToFile(m_loadFile);
				
			}catch (e:Error) {
				
			}
			
			m_loadFile = null;
			
		}
		
		private var m_loadFile:File;
		private function onOpenAir(btn:BSSButton):void 
		{
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, onLoaded);
			file.browseForOpen("open", inputFilterArray);
			m_loadFile = file;
		}
		
		
		private function onLoaded(e:Event):void {
			
			e.currentTarget.removeEventListener(Event.SELECT, onLoaded);
			
			try{
				var data:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(m_loadFile, FileMode.READ);
				stream.position = 0;
				stream.readBytes(data, 0, stream.bytesAvailable);
				stream.close();
				data.position = 0;
				
				//Config.lastFileName = s_loadFile.name.replace(".amxmlb" , ".amxmla");
				
				var nativePath : String = m_loadFile.nativePath;
				Config.lastFileNameFull = nativePath;
				if (nativePath.lastIndexOf('\\') != -1)
				{
					nativePath = nativePath.substring(0 , nativePath.lastIndexOf('\\')) + "\\";
				} 
				else if (nativePath.lastIndexOf('/') != -1)
				{
					nativePath = nativePath.substring(0 , nativePath.lastIndexOf('/')) + "/";
				}
				
				TextureLoader.s_imgPath = nativePath;
				onOpenBA(m_loadFile.name , data);
				
				//trace(nativePath);

				
				//new ImageByteLoader().load([data], __imageLoaded);
			}catch (e:Error) {
				
				//JOptionPane.showMessageDialog("读取图形文件出错", e+"", null, pane);
			}
			
			m_loadFile = null;
			
		}
		
		private function onSave(btn:BSSButton):void 
		{
			if (Config.lastFileNameFull)
				try {
					
					var file:File = new File(Config.lastFileNameFull);
					saveToFile(file);
					
				} catch (e:Error)
				{
					
				}
			else {
				onSaveAsAir(btn);
			}
		}
		public static var ins : MainAir;
		public function MainAir()
		{
			ins = this;
			Config.isAirVersion = true;
			super();			
		}
		
	}
	
}