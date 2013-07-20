package editor.ui 
{
	import editor.config.EdtSET;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtOperator extends Sprite
	{
		private var m_moveOPTR : Sprite = new Sprite();
		private var m_moveOPTU : Sprite = new Sprite();
		
		
		private var m_moveOPTA : Sprite = new Sprite();
		public var startRadian : Number;
		public var lastEndDegree : Number;
		
		public var startMoveFunc : Function;
		//private var movingFunc : Function;
		//private var endMoveFunc : Function;
		private var m_curMode : String;
		private var m_curOptMode : int = -1;
		
		private static function D2R(degress:Number):Number
		{
			return degress / 180 * Math.PI;
		}
		private static function R2D(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		public static function drawSector(g:Graphics , startRadian : Number , endRadian : Number , r : int):void
		{
			
			
			//g.clear();
			var totalRadian : Number = endRadian- startRadian;
			
			var _2PI : Number = Math.PI * 2;
			if (totalRadian > 0)
			{
				while (totalRadian >  _2PI)
				{
					totalRadian -= _2PI;
				}
			} else {
				while (totalRadian < -_2PI)
				{
					totalRadian += _2PI;
				}
			}
			
			
				
			var angle : Number;
			const dAng:Number = 1;

			
			{
				
				var startDegress : int = R2D(startRadian);
				var endDegress : int = startDegress;
				
				
				endDegress = R2D(totalRadian + startRadian) ;
				
				//trace("beginFill");
				g.beginFill(0xFFFFFF, 0.4);
				//g.drawRect(0, 0, 100, 100);
				
				g.moveTo(0,0);
				
				var _dDegree : int;
				if (endDegress > startDegress)
				{	

					for (_dDegree = startDegress ;_dDegree <= endDegress; _dDegree++) 
					{
						g.lineTo(Math.cos(D2R(_dDegree)) * r,Math.sin(D2R(_dDegree)) * r);
					}
				}
				else
				{	
					for (_dDegree = startDegress ;_dDegree >= endDegress; _dDegree--) 
					{
						//trace(Math.cos(D2R(_dDegree)) * r,Math.sin(D2R(_dDegree)) * r)
						g.lineTo(Math.cos(D2R(_dDegree)) * r,Math.sin(D2R(_dDegree)) * r);
					}
				}
				
				//trace("endFIll");
				g.lineTo(0, 0);
				g.endFill();
				
			}
		
		}
		
		
		private function drawInsert(_graphics : Graphics , drawArrow : Boolean) : void
		{
			const r : int = 10;
			const leng : int = 52;
			
			_graphics.clear();
			
			if (drawArrow)
			{
				_graphics.beginFill(0xFFFFFF , 0.0);
				_graphics.drawRect(0 - r / 2, -leng - r / 2, r ,leng + r / 2);
				_graphics.endFill();
			} else {
				
			}
			
			_graphics.lineStyle(1.5);
			_graphics.moveTo( 0 , 0);
			_graphics.lineTo( 0 , -leng);
				
			
		}
		
		public function drawRotationUpdate(newR : Number):void
		{
			if (m_curOptMode == 3) {
				var g : Graphics = Shape(m_moveOPTU.getChildAt(0)).graphics;
				drawRotation(g);
				
				//trace(newR ,startRadian );
				
				if (newR != startRadian)
					drawSector(g, startRadian, newR , 52);
				
				
				/*
				m_moveOPTU.alpha = 
				m_moveOPTR.alpha = 
				m_moveOPTA.alpha = 1
				m_moveOPTU.filters =
				m_moveOPTR.filters =
				m_moveOPTA.filters = s_filterArray;*/
			
				
			}
		}
		
		private function drawRotation(_graphics : Graphics) : void
		{
			const leng : int = 52;
			_graphics.clear();
			
			
			_graphics.lineStyle(8,0,0);
			_graphics.drawCircle(0, 0, 52);
			
			_graphics.lineStyle(1);
			_graphics.drawCircle(0, 0, 52);
			_graphics.lineStyle(NaN);
		}
		
		private function drawScale(_graphics : Graphics , drawArrow : Boolean) : void
		{

			const r : int = 10;
			const leng : int = 52;
			
			_graphics.clear();
			
			_graphics.lineStyle(1.5);
			_graphics.moveTo( 0 , 0);
			_graphics.lineTo( 0 , -leng);
				
			if (drawArrow)
			{
				_graphics.beginFill(0xFFFFFF);
				_graphics.drawRect(0 - r / 2, -leng - r / 2, r , r);
			
			} else {
				
			}
			
			
		}
		private function drawArrow(_graphics : Graphics , drawArrow : Boolean) : void
		{
			const leng : int = 52;
			const leng2 : int = 35;
			const w : int = 5;
			const w2 : Number = 0.75;
			
			//_opt.graphics.lineStyle(1);
			_graphics.clear();
			
			if (drawArrow)
			{
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
			
			} else {
				_graphics.lineStyle(1.5);
				_graphics.moveTo( 0 , 0);
				_graphics.lineTo( 0 , -leng);
			}
			
			
			
		}
		
		private static const X_CF : ColorTransform = new ColorTransform ( 0, 0, 0, 1, 255 ,0, 0, 0);
		private static const Y_CF : ColorTransform = new ColorTransform ( 0, 0, 0, 1, 0, 255, 0, 0);
		private static const Z_CF : ColorTransform = new ColorTransform ( 0, 0, 0, 1, 0, 0, 255, 0);
		
		public function setMode(_str : String , optMode : int) : void
		{
			if (m_curMode == _str && m_curOptMode == optMode)
				return;
				
			var _redraw : Boolean;
			if (m_curMode == "PERSP" || _str == "PERSP" || m_curOptMode != optMode)	
				_redraw = true;
				
			m_curMode = _str;
			m_curOptMode = optMode;
			
			var drawFunc : Function;
			if (m_curOptMode == 1)
				drawFunc =  drawArrow;
			else if (m_curOptMode == 2)
				drawFunc =  drawScale;
			else if (m_curOptMode == 3)
			{	
				drawFunc =  drawScale;
				
				drawRotation(Shape(m_moveOPTU.getChildAt(0)).graphics);
				Shape(m_moveOPTR.getChildAt(0)).graphics.clear();
				if (_str == "XY")
					m_moveOPTU.transform.colorTransform  = Z_CF;
				else if (_str == "XZ")
					m_moveOPTU.transform.colorTransform = Y_CF;
				else if (_str == "ZY")
					m_moveOPTU.transform.colorTransform = X_CF;
				else if (_str == "PERSP")
					m_moveOPTU.transform.colorTransform = Z_CF;
				return;
			}
			else if (m_curOptMode == 5)
			{
				drawFunc =  drawInsert;
			}	
			mouseChildren = mouseEnabled = true;
			if (_str == "XY")
			{
				m_moveOPTR.transform.colorTransform = X_CF;
				m_moveOPTU.transform.colorTransform = Y_CF;
				scaleY = -1;
				if (_redraw)
				{
					drawFunc(Shape(m_moveOPTR.getChildAt(0)).graphics , true);
					drawFunc(Shape(m_moveOPTU.getChildAt(0)).graphics , true);
				}
			}
			else if (_str == "XZ")
			{
				m_moveOPTR.transform.colorTransform = X_CF;
				m_moveOPTU.transform.colorTransform = Z_CF;
				scaleY = 1;
				if (_redraw)
				{
					drawFunc(Shape(m_moveOPTR.getChildAt(0)).graphics , true);
					drawFunc(Shape(m_moveOPTU.getChildAt(0)).graphics , true);
				}
			}
			else if (_str == "ZY")
			{
				m_moveOPTR.transform.colorTransform = Z_CF;
				m_moveOPTU.transform.colorTransform = Y_CF;
				scaleY = -1;
				if (_redraw)
				{
					drawFunc(Shape(m_moveOPTR.getChildAt(0)).graphics , true);
					drawFunc(Shape(m_moveOPTU.getChildAt(0)).graphics , true);
				}
			}
			else if (_str == "PERSP")
			{
				m_moveOPTR.transform.colorTransform = X_CF;
				m_moveOPTU.transform.colorTransform = Y_CF;
				scaleY = -1;
				if (_redraw)
				{
					drawFunc(Shape(m_moveOPTR.getChildAt(0)).graphics , false);
					drawFunc(Shape(m_moveOPTU.getChildAt(0)).graphics , false);
				}
				
				mouseChildren = mouseEnabled = false;
			}
		}
	
		
		public function EdtOperator() 
		{
			addChild(m_moveOPTU);
			addChild(m_moveOPTR);
			addChild(m_moveOPTA);
			
			drawArrow(Shape(m_moveOPTU.addChild(new Shape())).graphics , true);
			drawArrow(Shape(m_moveOPTR.addChild(new Shape())).graphics , true);
			m_moveOPTR.rotation = 90;
			
			m_moveOPTA.graphics.lineStyle(1, 0xFFFF00 , 0.75);
			m_moveOPTA.graphics.beginFill(0xFFFFFF, 0.5);
			m_moveOPTA.graphics.drawRect( -8, -8, 16, 16);
			
			setMode("XY" , 1);
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
		private static const s_filterArray : Array = [new GlowFilter(0xFFFFFF, 0.3, 3, 3, 5)];
		private function onMouse(e:MouseEvent):void 
		{
			
			m_moveOPTU.alpha = 0.5;
			m_moveOPTR.alpha = 0.5;
			m_moveOPTA.alpha = 0.5;
			m_moveOPTU.filters =
			m_moveOPTR.filters =
			m_moveOPTA.filters = [];
			
			
			if (e.type != MouseEvent.MOUSE_OUT)
			{
				e.currentTarget.alpha = 1;
				m_moveOPTA.alpha = 1;
				
				e.currentTarget.filters =
				m_moveOPTA.filters = s_filterArray;
				
				if (m_moveOPTA == e.currentTarget)
				{
					m_moveOPTU.alpha = 
					m_moveOPTR.alpha = 1;
					
					m_moveOPTU.filters = 
					m_moveOPTR.filters = s_filterArray;
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
			
			if (parent)
				parent.removeChild(this);
			
			startMoveFunc = null;
		}
		
	}

}