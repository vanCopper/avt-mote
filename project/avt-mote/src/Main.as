package 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.module.head.ModuleHead;
	import editor.ModuleBar;
	import editor.Toolbar;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			
			var obj : Object = { };
			obj[MouseEvent.MOUSE_WHEEL] = CALLBACK.AS3_ON_STAGE_MOUSE_WHEEL;
			obj[MouseEvent.MOUSE_DOWN] = CALLBACK.AS3_ON_STAGE_MOUSE_DOWN;
			obj[MouseEvent.MOUSE_UP] = CALLBACK.AS3_ON_STAGE_MOUSE_UP;
			obj[MouseEvent.MOUSE_MOVE] = CALLBACK.AS3_ON_STAGE_MOUSE_MOVE;
			 

			 CallbackCenter.init(stage , obj);
			
		}
		
	}
	
}