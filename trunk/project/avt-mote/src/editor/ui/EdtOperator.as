package editor.ui 
{
	import editor.config.EdtSET;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtOperator extends Sprite
	{
		private var m_moveOPTR : Sprite = new Sprite();
		private var m_moveOPTU : Sprite = new Sprite();
		
		
		private var m_moveOPTA : Sprite = new Sprite();
		
		
		public var startMoveFunc : Function;
		//private var movingFunc : Function;
		//private var endMoveFunc : Function;
		
		private function drawArrow(_graphics : Graphics) : void
		{
			const leng : int = 52;
			const leng2 : int = 35;
			const w : int = 5;
			const w2 : int = 0.75;
			
			//_opt.graphics.lineStyle(1);
			_graphics.beginFill(0xFFFFFF);
			
			//_opt.graphics.moveTo( -w2 , w2);
			//_opt.graphics.lineTo(-w2 , -leng2);
			_graphics.moveTo( -w , -leng2);
			_graphics.lineTo(0 , -leng);
			_graphics.lineTo(w , -leng2);
			_graphics.lineTo(-w , -leng2);
			_graphics.endFill();
			
			_graphics.lineStyle(1.5);
			_graphics.moveTo( 0 , 0);
			_graphics.lineTo( 0 , -leng2);
			
			
			
		}
		
		private static const X_CF : ColorTransform = new ColorTransform ( 0, 0, 0, 1, 255 ,0, 0, 0);
		private static const Y_CF : ColorTransform = new ColorTransform ( 0, 0, 0, 1, 0, 255, 0, 0);
		private static const Z_CF : ColorTransform = new ColorTransform ( 0, 0, 0, 1, 0, 0, 255, 0);
		
		public function setMode(_str : String) : void
		{
			if (_str == "XY")
			{
				m_moveOPTR.transform.colorTransform = X_CF;
				m_moveOPTU.transform.colorTransform = Y_CF;
			}
		}
		
		public function EdtOperator() 
		{
			addChild(m_moveOPTU);
			addChild(m_moveOPTR);
			addChild(m_moveOPTA);
			
			drawArrow(Shape(m_moveOPTU.addChild(new Shape())).graphics);
			drawArrow(Shape(m_moveOPTR.addChild(new Shape())).graphics);
			m_moveOPTR.rotation = 90;
			
			m_moveOPTA.graphics.lineStyle(1, 0xFFFF00 , 0.75);
			m_moveOPTA.graphics.beginFill(0xFFFFFF, 0.5);
			m_moveOPTA.graphics.drawRect( -8, -8, 16, 16);
			
			setMode("XY");
			//this.x = 760;
			//this.y = 4;
			
			m_moveOPTU.alpha = 0.5;
			m_moveOPTR.alpha = 0.5;
			m_moveOPTA.alpha = 0.5;
			
			
			m_moveOPTU.addEventListener(MouseEvent.MOUSE_OVER , onMouse);
			m_moveOPTR.addEventListener(MouseEvent.MOUSE_OVER , onMouse);
			m_moveOPTA.addEventListener(MouseEvent.MOUSE_OVER , onMouse);
			
			m_moveOPTU.addEventListener(MouseEvent.MOUSE_OUT , onMouse);
			m_moveOPTR.addEventListener(MouseEvent.MOUSE_OUT , onMouse);
			m_moveOPTA.addEventListener(MouseEvent.MOUSE_OUT , onMouse);
			
			m_moveOPTU.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
			m_moveOPTR.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
			m_moveOPTA.addEventListener(MouseEvent.MOUSE_DOWN , onMouse);
		}
		
		private function onMouse(e:MouseEvent):void 
		{
			
			m_moveOPTU.alpha = 0.5;
			m_moveOPTR.alpha = 0.5;
			m_moveOPTA.alpha = 0.5;
			
			if (e.type != MouseEvent.MOUSE_OUT)
			{
				e.currentTarget.alpha = 1;
				m_moveOPTA.alpha = 1;
				
				if (m_moveOPTA == e.currentTarget)
				{
					m_moveOPTU.alpha = 
					m_moveOPTR.alpha = 1;
				}
				
				if (e.type == MouseEvent.MOUSE_DOWN && startMoveFunc != null)
				{
					if (e.currentTarget == m_moveOPTR)
					{
						startMoveFunc(e,1);
					}
					else if (e.currentTarget == m_moveOPTU)
					{
						startMoveFunc(e,-1);
					}
					else if (e.currentTarget == m_moveOPTA)
					{
						startMoveFunc(e,0);
					}
				}
				
			}
			
			
			
		}
		
		public function dispose():void
		{
			if (m_moveOPTU)
			{	
				m_moveOPTU.removeEventListener(MouseEvent.MOUSE_OUT , onMouse);
				m_moveOPTR.removeEventListener(MouseEvent.MOUSE_OUT , onMouse);
				m_moveOPTA.removeEventListener(MouseEvent.MOUSE_OUT , onMouse);
				
				m_moveOPTU.removeEventListener(MouseEvent.MOUSE_DOWN , onMouse);
				m_moveOPTR.removeEventListener(MouseEvent.MOUSE_DOWN , onMouse);
				m_moveOPTA.removeEventListener(MouseEvent.MOUSE_DOWN , onMouse);
				
				m_moveOPTR = 
				m_moveOPTU =
				m_moveOPTA = null;
			}
			
			startMoveFunc = null;
		}
		
	}

}