package editor.util 
{
	import editor.config.Config;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ...
	 */
	public class FilePickerAir
	{
		protected var m_callback : Function;
		public var m_filename : String;
				
		private var m_loadFile:File;
		
		public function openFile(callback : Function , filefArray : Array , multiFile : Boolean) : void
		{
			m_callback = callback;
			
			var file:File = new File();
			m_loadFile = file;
			if (!multiFile)
			{
				file.addEventListener(Event.SELECT, onLoaded);
				file.browseForOpen("open", filefArray);
			}
			else
			{
				file.addEventListener(FileListEvent.SELECT_MULTIPLE, onSelectMultipleHandler);
				file.browseForOpenMultiple("open", filefArray);
			}
			
			
			
			
			
		}
		
		private function onSelectMultipleHandler(e:FileListEvent) : void {
			e.currentTarget.removeEventListener(FileListEvent.SELECT_MULTIPLE, onSelectMultipleHandler);

			for (var i:Number = 0; i < e.files.length; i++)
			{  
				loadAFile(e.files[i] , i == e.files.length - 1 ? 0 : e.files.length - 1 - i);
			}  
			m_callback = null;
			m_loadFile = null;
			
			//trace(m_loadFile.name);
		}

		private function loadAFile(_loadFile : File, len : int = 0) : void
		{
			try{
				var data:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(_loadFile, FileMode.READ);
				stream.position = 0;
				stream.readBytes(data, 0, stream.bytesAvailable);
				stream.close();
				data.position = 0;
				
				//Config.lastFileName = s_loadFile.name.replace(".amxmlb" , ".amxmla");
				
				var nativePath : String = _loadFile.nativePath;
				var fileName : String = _loadFile.nativePath;
				if (nativePath.indexOf(TextureLoader.s_imgPath) == 0)
					fileName = nativePath.substr(TextureLoader.s_imgPath.length);
				
				if (nativePath.lastIndexOf('\\') != -1)
				{
					nativePath = nativePath.substring(0 , nativePath.lastIndexOf('\\')) + "\\";
				} 
				else if (nativePath.lastIndexOf('/') != -1)
				{
					nativePath = nativePath.substring(0 , nativePath.lastIndexOf('/')) + "/";
				}
				FilePicker.s_lastOpen = nativePath;
				
				m_filename = fileName;
				if (m_callback != null)
				{	
					if (m_callback.length == 2)
						m_callback(m_filename , data);
					else if (m_callback.length == 3)
						m_callback(m_filename , data , len);
				}	
			}catch (e:Error) {
				
			}
		}
		
		private function onLoaded(e:Event):void {
			
			e.currentTarget.removeEventListener(Event.SELECT, onLoaded);
			loadAFile(m_loadFile);
				
			m_callback = null;
			m_loadFile = null;
			
		}
		
		
	}

}