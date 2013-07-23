package editor.module.eye 
{
	import editor.Library;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleEyeBlinkPlayer  extends Sprite
	{
		public var maxLag : int = 120;
		public var minLag : int = 60;
		private var curFrame : int;
		private var curLag : int;
		private var curFrameSpL : ModuleEyeFrameSprite;
		private var curFrameSpR : ModuleEyeFrameSprite;
		
		public function get leftAnime(): Vector.<ModuleEyeFrame>
		{
			return ModuleEyeData.s_leftAnime;
		}
		
		public function get rightAnime(): Vector.<ModuleEyeFrame>
		{
			return ModuleEyeData.s_rightAnime;
		}
		
		public function ModuleEyeBlinkPlayer() 
		{
			curFrameSpL = new ModuleEyeFrameSprite(null);
			curFrameSpR = new ModuleEyeFrameSprite(null);
			addChild(curFrameSpL);
			addChild(curFrameSpR);
			
			curFrameSpL.x = -100;
			curFrameSpR.x = 50;
			
		}
		
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
		}
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
		}
		
		
		private function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME , onUpdate);
			
			if (curFrameSpL)
			{
				curFrameSpL.dispose();
				curFrameSpL = null;
			}
			
			if (curFrameSpR)
			{
				curFrameSpR.dispose();
				curFrameSpR = null;
			}
		}
		private function onUpdate(e:Event):void 
		{
			if (leftAnime.length == 0)
				return;
			
			if (curLag > 0)
			{
				curLag--;
				return;
			}
			
			if (curFrame == leftAnime.length / 2)
				curFrame++;//闭眼有2帧
					
			if (curFrame >= leftAnime.length)
			{
				curLag = (Math.random() * (maxLag - minLag)) + minLag;
				curFrame = 0;
			} else 
			{
				
				
				curFrameSpL.data = (leftAnime[curFrame]);
				if (curFrameSpL.data)curFrameSpL.renderMask(false);
				curFrameSpL.refresh();
				
				curFrameSpR.data = (rightAnime[curFrame]);
				if (curFrameSpR.data)curFrameSpR.renderMask(false);
				curFrameSpR.refresh();
				
				curFrame++;
			}
		}
		
		public function reset():void
		{
			curFrame = 0;
			curLag = 60;
		}
	}

}