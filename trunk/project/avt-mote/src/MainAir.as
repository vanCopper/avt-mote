package 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.Config;
	import editor.Library;
	import editor.module.head.ModuleHead;
	import editor.ModuleBar;
	import editor.Toolbar;
	import editor.util.FilePicker;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class MainAir extends Main
	{
		
		public override function initAirFunc():void
		{
			m_tb.btnSave.releaseFunction = onSave;
			m_tb.btnOpen.releaseFunction = onOpenAir;
		}
		
		private function onOpenAir(btn:BSSButton):void 
		{
			
		}
		
		private function onSave(btn:BSSButton):void 
		{
			
		}
		
		public function MainAir()
		{
			Config.isAirVersion = true;
			super();			
		}
		
	}
	
}