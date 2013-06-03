package editor.module.eye 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrame 
	{
		
		public function ModuleEyeFrame() 
		{
			
		}
		public function createSprite() : ModuleEyeFrameSprite
		{
			return new ModuleEyeFrameSprite(this);
		}
		
	}

}