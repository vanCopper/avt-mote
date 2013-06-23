package editor.module.eye 
{
	import editor.module.head.ModuleHead3DBrowser;
	import editor.struct.Texture2DBitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.LineScaleMode;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeLocate extends Sprite
	{
		
	
		private var m_browser : ModuleHead3DBrowser;
		
		public function ModuleEyeLocate() 
		{
			m_browser = new ModuleHead3DBrowser();
			
			m_browser.disableEdit = true;
			
			addChild(m_browser);
			
			
		}
		
		public function reset():void
		{
			m_browser.reset();
		}
		
		
		private function onDown(e:MouseEvent):void 
		{
			var _dsp : Sprite = e.currentTarget as Sprite;
			
			if (_dsp.parent)
			{
				var _p : DisplayObjectContainer = _dsp.parent;
				_dsp.parent.removeChild(_dsp);
				_p.addChildAt(_dsp , 2);
			}
			
			_dsp.startDrag();
			
			
		}
		
		private function onUp(e:MouseEvent):void 
		{
			var _dsp : Sprite = e.currentTarget as Sprite;
			_dsp.stopDrag();
			
		}
		
		
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			m_browser.activate();
		}
		
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
			m_browser.deactivate();
		}
		
		private function onUpdate(e:Event):void 
		{
		
		}
		
		public function dispose():void
		{
			deactivate();
			
			GraphicsUtil.removeAllChildrenWithDispose(this);
		}
		
	
		public function setTemplate(mefs : ModuleEyeFrameSprite , _name : String):void
		{
			
			
		}
		
		public function toXMLString():String
		{
			var str : String = "<ModuleEyeLocate>";
						
			
			str += "</ModuleEyeLocate>";
			
			return str;
			
		}
		
		
		
		public function fromXMLString(s:XML):void
		{
			
		}
		
		
		
	}

}