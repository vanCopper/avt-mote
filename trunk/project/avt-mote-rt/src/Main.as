package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import player.AVTMPlayer;
	import player.struct.Matrix4x4;
	
	/**
	 * ...
	 * @author blueshell
	 */
	public class Main extends Sprite 
	{
		private var m_player : AVTMPlayer;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			m_player = new AVTMPlayer();
			addChild(m_player);
			
			m_player.x = 300;
			m_player.y = 300;
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			
			m_player.render(null);
			
			
			//CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
			//CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
			
			this.addEventListener(Event.ENTER_FRAME , onUpdate);
		}
		
		private function onUpdate(e:Event):void 
		{
			var mXOff : Number = (mouseX - m_player.x);
			var mYOff : Number = (mouseY - m_player.y);
			
			var _xR : Number = - mXOff / 300 * 0.2;
			var _yR : Number =  mYOff / 300 * 0.2;
			
			var _currentMatrix  : Matrix4x4 = m_player.getMatrix(_xR, _yR, 0);
			//_currentMatrix.identity();
			m_player.render(_currentMatrix);
		}
		
		/*
		private function onMouseMove(e:MouseEvent):void 
		{
			
			var mXOff : Number = (mouseX - m_player.x);
			var mYOff : Number = (mouseY - m_player.y);
			
			var _xR : Number = - mXOff / 300 * 0.2;
			var _yR : Number =  mYOff / 300 * 0.2;
			
			var _currentMatrix  : Matrix4x4 = m_player.getMatrix(_xR, _yR, 0);
			//_currentMatrix.identity();
			m_player.render(_currentMatrix);
		}*/
		
		private function onMouseDown(e:MouseEvent):void 
		{
			m_player.blinkEye();
		}
		
		
		
	}
	
}