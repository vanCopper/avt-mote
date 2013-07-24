package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import player.AVTMPlayer;
	
	/**
	 * ...
	 * @author blueshell
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var _player : AVTMPlayer = new AVTMPlayer();
			addChild(_player);
			
			_player.x = 300;
			_player.y = 300;
			
		}
		
	}
	
}