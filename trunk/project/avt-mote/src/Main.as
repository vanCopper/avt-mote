package 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.Library;
	import editor.module.head.ModuleHead;
	import editor.ModuleBar;
	import editor.Toolbar;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Main extends Sprite 
	{
		private var m_mb : ModuleBar;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//import editor.ui.EdtRotationAxis;
			///var _dtRotationAxis : EdtRotationAxis = new EdtRotationAxis();
			//addChild(_dtRotationAxis);
			//_dtRotationAxis.x = _dtRotationAxis.y = 500;
			//return;
			
			// entry point
			var tb : Toolbar = new Toolbar();
			addChild(tb);
			
			m_mb = new ModuleBar();
			addChild(m_mb).x = tb.x + tb.width + 10;
			
			var _mContainer : Sprite = new Sprite();
			_mContainer.graphics.lineStyle(1,0,0.55);
			_mContainer.graphics.moveTo(0, 0);
			_mContainer.graphics.lineTo(800, 0);
			
			
			m_mb.addModule(new ModuleHead(_mContainer));
			
			
			addChild(_mContainer).y = m_mb.y + m_mb.height + 5;
			
			var obj : Object = { };
			obj[MouseEvent.MOUSE_WHEEL] = CALLBACK.AS3_ON_STAGE_MOUSE_WHEEL;
			obj[MouseEvent.MOUSE_DOWN] = CALLBACK.AS3_ON_STAGE_MOUSE_DOWN;
			obj[MouseEvent.MOUSE_UP] = CALLBACK.AS3_ON_STAGE_MOUSE_UP;
			obj[MouseEvent.MOUSE_MOVE] = CALLBACK.AS3_ON_STAGE_MOUSE_MOVE;
			obj[KeyboardEvent.KEY_DOWN] = CALLBACK.AS3_ON_STAGE_KEY_DOWN;
			obj[KeyboardEvent.KEY_UP] = CALLBACK.AS3_ON_STAGE_KEY_UP;

			 CallbackCenter.init(stage , obj);
			
			
			tb.btnNew.releaseFunction = onNew;
			tb.btnOpen.releaseFunction = onOpen;
			tb.btnSaveAs.releaseFunction = onSaveAs;
			
			var _lib : Library = new Library();
			_lib.x  = 400;
			_lib.y  = 200;
			
			addChild(_lib);
			
			initAirFunc();
		}
		
		public function initAirFunc():void
		{
			
		}
		
		private function onOpen(btn:BSSButton):void 
		{
			
		}
		
		private function onNew(btn:BSSButton):void 
		{
			Library.getS().onNew();
			m_mb.onNew();
			
		}
		private function onSaveAs(btn:BSSButton):void 
		{
			var _data : XML = <avt-mote/>;
			m_mb.onSave(_data);
			
			trace(_data.toXMLString());
		}
	}
	
}