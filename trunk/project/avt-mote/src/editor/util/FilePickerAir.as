package editor.util 
{
	import editor.config.Config;
	import flash.events.Event;
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
		
		public function openFile(callback : Function , filefArray : Array) : void
		{
			m_callback = callback;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, onLoaded);
			file.browseForOpen("open", filefArray);
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
				var fileName : String = m_loadFile.nativePath;
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
					m_callback(m_filename , data);
				m_callback = null;
					
			}catch (e:Error) {
				
			}
			
			m_loadFile = null;
			
		}
		
		
	}

}