package editor.module.hair 
{
	import editor.struct.Texture2D;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHairFrame 
	{
		public var name : String;
		public var texture : Texture2D;
		
		public function ModuleHairFrame() 
		{
			
		}
		
		public function dispose():void 
		{
			name = null;
			texture = null;
		}
	}

}