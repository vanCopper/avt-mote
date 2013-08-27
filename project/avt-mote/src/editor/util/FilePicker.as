package editor.util 
{
	import editor.config.Config;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ...
	 */
	public class FilePicker
	{
		protected var m_callback : Function;
		public var m_filename : String;
		private var m_fileList : Array;
		
		private var m_filePickerAir : Object;
		
		private static var s_fbOpen : FileReferenceList;
		private static var s_fr  : FileReference;
		
		public static var s_lastOpen : String = "";
		
		public static function getShortName(s:String):String
		{
			if (s.lastIndexOf('\\') != -1)
			{
				s = s.substring(s.lastIndexOf('\\') + 1 );
			} 
			else if (s.lastIndexOf('/') != -1)
			{
				s = s.substring(s.lastIndexOf('/')  + 1);
			}
			return s;
		}
		
		
		private function airOpenCallBack(_filename : String , ba : ByteArray , len : int):void
		{
			m_filename = _filename;
			if (m_callback != null)
			{	
				if (m_callback.length == 2)
					m_callback(m_filename , ba);
				else if (m_callback.length == 3)
					m_callback(m_filename , ba , len);
			}
			if (len == 0)
				m_callback = null;
		}
		
		public function FilePicker(callback : Function , filefArray : Array , multiFile : Boolean)
		{
			m_callback = callback;
			
			if (Config.isAirVersion)
			{
				var _filePickerAir:Class = getDefinitionByName("editor.util.FilePickerAir") as Class;
				if (_filePickerAir)
					m_filePickerAir = new _filePickerAir();
					
				if (m_filePickerAir)
					m_filePickerAir.openFile(airOpenCallBack , filefArray , multiFile);
			}
			else {
				
				if (multiFile)
				{
					if (!s_fbOpen)
					{	
						s_fbOpen = new FileReferenceList();
						
					}
					s_fbOpen.addEventListener(Event.SELECT, onSelect);
					s_fbOpen.addEventListener(Event.CANCEL, onCancel);
					s_fbOpen.browse(filefArray);
				}
				else
				{
					if (!s_fr)
					{	
						s_fr = new FileReference();
					}
					s_fr.addEventListener(Event.SELECT, onSelect);
					s_fr.addEventListener(Event.CANCEL, onCancel);
					s_fr.browse(filefArray);
				}
				
			}
			
			
		}
		
		private function onCancel(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.SELECT, onSelect);
			e.currentTarget.removeEventListener(Event.CANCEL, onCancel);
		}
		
		private function loadAFile():void
		{
			
			if (m_fileList && m_fileList.length)
			{
				s_fr = m_fileList.shift() as FileReference;
				if (m_fileList.length == 0)
					m_fileList = null;
					
				m_filename = s_fr.name;
				s_fr.addEventListener(Event.COMPLETE , onSelectLoad);
				s_fr.load();
			
				
			}
			
		}
	
		private function onSelect(event : Event)
		: void 
		{
			
			
			event.currentTarget.removeEventListener(Event.SELECT, onSelect);
			event.currentTarget.removeEventListener(Event.CANCEL, onCancel);
			
			
			var fb : FileReferenceList = (event.currentTarget) as FileReferenceList;
			if (fb)
			{	
				m_fileList = fb.fileList;
				loadAFile();
			}
			else
			{
				var fr : FileReference = (event.currentTarget) as FileReference;
				m_fileList = null;
				
				m_filename = s_fr.name;
				s_fr.addEventListener(Event.COMPLETE , onSelectLoad);
				s_fr.load();
			}
		}
	
		
		private function onSelectLoad(event : Event)
		: void 
		{
			
			//DBG_TRACE("onSelectLoad ");
			var fb : FileReference = FileReference(event.currentTarget);
			fb.removeEventListener(event.type, arguments.callee);
			
			var ba : ByteArray = fb.data;
			
			if (m_callback != null)
			{	
				if (m_callback.length == 2)
					m_callback(m_filename , ba);
				else if (m_callback.length == 3)
					m_callback(m_filename , ba , m_fileList ? m_fileList.length : 0);
			}
			if (!m_fileList)
				m_callback = null;
				
			loadAFile();
			
			
		
		}
		
	}

}