package editor.module.eye 
{
	import editor.Library;
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
		public function flipData():ModuleEyeFrame
		{
			var n : ModuleEyeFrame = new ModuleEyeFrame();
			n.eyeWhite = eyeWhite ? Library.getS().getTexture2DFlip(eyeWhite.name) : null;
			n.eyeBall = eyeBall ? Library.getS().getTexture2DFlip(eyeBall.name) : null;
			n.eyeLip = eyeLip ? Library.getS().getTexture2DFlip(eyeLip.name) : null;
			
			
			n.eyeBallX = eyeBallX;
			n.eyeBallY = eyeBallY;
			n.eyeLipX = eyeLipX;
			n.eyeLipY = eyeLipY;
			return n;
		}
		
		public function cloneData():ModuleEyeFrame
		{
			var n : ModuleEyeFrame = new ModuleEyeFrame();
			n.eyeWhite = eyeWhite;
			n.eyeBall = eyeBall;
			n.eyeLip = eyeLip;
			
			
			n.eyeBallX = eyeBallX;
			n.eyeBallY = eyeBallY;
			n.eyeLipX = eyeLipX;
			n.eyeLipY = eyeLipY;
			return n;
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