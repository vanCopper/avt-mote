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
		private var m_Rz : Number = 0;
		private var m_Oz : Number = 0;
		
		private var m_lastRX : Number = 0;
		private var m_lastRY : Number = 0;
	
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
			m_player.y = 220;
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheel);
			
			m_player.render(null , 0 , 0 ,0);
			
			
			//CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
			//CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
			
			this.addEventListener(Event.ENTER_FRAME , onUpdate);
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (e.delta > 0)
				m_Oz += 0.01;
			else
				m_Oz -= 0.01;
		}
		
		private function onUpdate(e:Event):void 
		{
			var mXOff : Number = (mouseX - m_player.x);
			var mYOff : Number = (mouseY - m_player.y);
			
			var _xR : Number = - mXOff / 600 * 0.1;
			var _yR : Number = mYOff / 600 * 0.1;
			m_Rz += 0.02;
			var _zR : Number =  Math.sin(m_Rz) * Math.PI / 180 * 2;
			
			
			var  _dx : Number;
			var  _dy : Number;
			
			var _dRx : Number;
			var _dRy : Number;
	
			_dx = (_xR - m_lastRX);
			_dy = (_yR - m_lastRY);
			
			var _lengthSQ2 : Number = _dx * _dx + _dy * _dy ;
			var _length  : Number = Math.sqrt(_lengthSQ2) ;

			if (_length < 0.005)
			{
				_dRx = _xR;
				_dRy = _yR; 
			}
			else
			{
				if (_length > 0.25)
				{
					_dx /= _length;
					_dy /= _length;

					_dx *= 0.1;
					_dy *= 0.1;
				}
				else
				{
					_dx *= 0.4;
					_dy *= 0.4;
				}
				

				_dRx = m_lastRX + _dx;
				_dRy = m_lastRY + _dy;
			}
			

			var _currentMatrix  : Matrix4x4 = m_player.getMatrix(_dRx, _dRy, m_Oz + _zR);
			//_currentMatrix.identity();
			m_player.render(_currentMatrix , _dRx , _dRy , m_Oz + _zR);
			
			m_lastRX = _dRx;
			m_lastRY = _dRy;
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
			m_player.mouthSpeak();
		}
		
		
		
	}
	
}