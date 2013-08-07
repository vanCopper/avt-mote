package 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
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
		
		public function MainAir()
		{
			Config.isAirVersion = true;
			super();			
		}
		
	}
	
}