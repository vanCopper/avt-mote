package editor.module.eye 
{
	import editor.struct.Texture2D;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrame 
	{
		
		public var eyeWhite : Texture2D;
		
		
		public var eyeBall : Texture2D;
		public var eyeBallX : Number;
		public var eyeBallY : Number;
		
		
		public var eyeLip : Texture2D;
		public var eyeLipX : Number;
		public var eyeLipY : Number;
		
		public function ModuleEyeFrame() 
		{
			
		}
		public function createSprite() : ModuleEyeFrameSprite
		{
			return new ModuleEyeFrameSprite(this);
		}
		public function dispose():void 
		{
			eyeWhite = null;
			eyeBall = null;
			eyeLip = null;
		}
	}

}