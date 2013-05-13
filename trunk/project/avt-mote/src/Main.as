package 
{
	import editor.module.head.ModuleHead;
	import editor.ModuleBar;
	import editor.Toolbar;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Blueshell
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
			var tb : Toolbar = new Toolbar();
			addChild(tb);
			
			var mb : ModuleBar = new ModuleBar();
			addChild(mb).x = tb.x + tb.width + 10;
			
			var _mContainer : Sprite = new Sprite();
			_mContainer.graphics.lineStyle(1,0,0.55);
			_mContainer.graphics.moveTo(0, 0);
			_mContainer.graphics.lineTo(800, 0);
			
			
			mb.addModule(new ModuleHead(_mContainer));
			
			
			addChild(_mContainer).y = mb.y + mb.height + 5;
			
		}
		
	}
	
}