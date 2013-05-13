package editor.util 
{
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class FilePicker
	{
		protected var m_callback : Function;
		public var m_filename : String;
		
		private static var s_fbOpen : FileReference;
		
		public function FilePicker(callback : Function , filefArray : Array)
		{
			m_callback = callback;
			
			if (!s_fbOpen)
				s_fbOpen = new FileReference();
				
			s_fbOpen.addEventListener(Event.SELECT, onSelect);
			s_fbOpen.browse(filefArray);
			
		}
		
		
	
		private function onSelect(event : Event)
		: void 
		{
			var fb : FileReference = FileReference(event.currentTarget);
			fb.removeEventListener(event.type, arguments.callee);
			
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