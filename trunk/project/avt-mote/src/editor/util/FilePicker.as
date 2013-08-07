package editor.util 
{
	import editor.config.Config;
	import flash.events.Event;
	import flash.net.FileReference;
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
		
		private var m_filePickerAir : Object;
		
		private static var s_fbOpen : FileReference;
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
		
		
		private function airOpenCallBack(_filename : String , ba : ByteArray ):void
		{
			m_filename = _filename;
			if (m_callback != null)
				m_callback(m_filename , ba);
			m_callback = null;
		}
		
		public function FilePicker(callback : Function , filefArray : Array)
		{
			m_callback = callback;
			
			if (Config.isAirVersion)
			{
				var _filePickerAir:Class = getDefinitionByName("editor.util.FilePickerAir") as Class;
				if (_filePickerAir)
					m_filePickerAir = new _filePickerAir();
					
				if (m_filePickerAir)
					m_filePickerAir.openFile(airOpenCallBack , filefArray);
			}
			else {
				if (!s_fbOpen)
					s_fbOpen = new FileReference();
				
				s_fbOpen.addEventListener(Event.SELECT, onSelect);
				s_fbOpen.addEventListener(Event.CANCEL, onCancel);
				s_fbOpen.browse(filefArray);
			}
			
			
		}
		
		private function onCancel(e:Event):void 
		{
			s_fbOpen.removeEventListener(Event.SELECT, onSelect);
			s_fbOpen.removeEventListener(Event.CANCEL, onCancel);
		}
		
		
	
		private function onSelect(event : Event)
		: void 
		{
			var fb : FileReference = FileReference(event.currentTarget);
			s_fbOpen.removeEventListener(Event.SELECT, onSelect);
			s_fbOpen.removeEventListener(Event.CANCEL, onCancel);
			
			
			m_filename = fb.name;
			
			fb.addEventListener(Event.COMPLETE , onSelectLoad);
			fb.load();
		}
	
		
		private function onSelectLoad(event : Event)
		: void 
		{
			
			//DBG_TRACE("onSelectLoad ");
			var fb : FileReference = FileReference(event.currentTarget);
			fb.removeEventListener(event.type, arguments.callee);
			
			var ba : ByteArray = fb.data;
			
			if (m_callback != null)
				m_callback(m_filename , ba);
			m_callback = null;
		
		}
		
	}

}