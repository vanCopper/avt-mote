package editor.module.eye 
{
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
	public class ModuleEyeMoveArea extends Sprite
	{
		
		//private var m_ea:Number;
		//private var m_eb:Number;
		//private var m_er:Number;
		
		private var m_circleShape : Shape;
		
		private var m_eyeBallLeft : Texture2DBitmap;
		private var m_eyeBallRight : Texture2DBitmap;
		private var m_eyeBallTop : Texture2DBitmap;
		
		
		private var m_eyeBallLeftSp : Sprite;
		private var m_eyeBallRightSp : Sprite;
		private var m_eyeBallTopSp : Sprite;
		
		private var m_mefs : ModuleEyeFrameSprite;
		private var m_mefsRoll : ModuleEyeFrameSprite;
		private var m_radianPlay : Number = 0;
		
		private var m_curLeft : Boolean = true;
		
		private var m_lastLModuleEyeFrame : ModuleEyeFrame;
		private var m_lastRModuleEyeFrame : ModuleEyeFrame;
		
		
		public function ModuleEyeMoveArea() 
		{
			m_mefs = new ModuleEyeFrameSprite(null);
			m_mefsRoll = new ModuleEyeFrameSprite(null);
			addChild(m_mefs);
			addChild(m_mefsRoll);
			m_mefs.x = 150;
			m_mefs.y = 200;
			m_mefsRoll.y = 200;
			m_mefsRoll.x = 350;
			
			m_circleShape = new Shape();
			
			
			
			m_eyeBallLeft = new Texture2DBitmap(null);
			m_eyeBallRight = new Texture2DBitmap(null);
			m_eyeBallTop = new Texture2DBitmap(null);
			
			
			m_eyeBallLeftSp = new Sprite;
			m_eyeBallRightSp = new Sprite;
			m_eyeBallTopSp = new Sprite;
			
			var _sp : Sprite = new Sprite();
			_sp.addChild(m_eyeBallLeftSp);
			_sp.addChild(m_eyeBallRightSp);
			_sp.addChild(m_eyeBallTopSp);
			_sp.x = m_mefs.x;
			_sp.y = m_mefs.y; 
						
			m_eyeBallLeftSp.addChild(m_eyeBallLeft).alpha = 0.75;
			m_eyeBallRightSp.addChild(m_eyeBallRight).alpha = 0.75;
			m_eyeBallTopSp.addChild(m_eyeBallTop).alpha = 0.75;
			
			//m_eyeBallLeft.transform.colorTransform.redOffset = 1;
			//m_eyeBallTop.transform.colorTransform.greenOffset = 1;
			
			
			
			addChild(_sp);
			_sp.addChild(m_circleShape);
			
			m_eyeBallLeftSp.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_eyeBallRightSp.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_eyeBallTopSp.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			
			m_eyeBallLeftSp.addEventListener(MouseEvent.MOUSE_UP , onUp);
			m_eyeBallRightSp.addEventListener(MouseEvent.MOUSE_UP , onUp);
			m_eyeBallTopSp.addEventListener(MouseEvent.MOUSE_UP , onUp);
			
			
			m_eyeBallLeftSp.buttonMode = 
			m_eyeBallRightSp.buttonMode = 
			m_eyeBallTopSp.buttonMode = true;
			
			var btn : BSSButton;
			
			var arr : Array = [];
			
			btn = BSSButton.createSimpleBSSButton(30, 20, "Left", true, arr );
			btn.setState(BSSButton.SBST_PRESS);
			btn.releaseFunction = ChangeToLeft;
			addChild(btn);
			btn.statusMode = true;
			btn.y = 5;
			btn.x = 5;
			var last : BSSButton = btn;
			
			btn = BSSButton.createSimpleBSSButton(30, 20, "Right",true,arr );
			btn.releaseFunction = ChangeToRight;
			addChild(btn);
			btn.statusMode = true;
			btn.y = 5;
			btn.x = last.x + last.width + 5;
			
			
		}
		
		public function reset():void
		{
			ModuleEyeData.s_eaL = NaN;
			
			m_lastLModuleEyeFrame = null;
			m_lastRModuleEyeFrame = null;
		}
		
		private function ChangeToRight(btn : BSSButton):void 
		{
			if (m_curLeft)
			{
				m_curLeft = false;
				m_mefs.data = m_lastRModuleEyeFrame;
				setData();
			}
		}
		
		private function ChangeToLeft(btn : BSSButton):void 
		{
			if (!m_curLeft)
			{
				m_curLeft = true;
				m_mefs.data = m_lastLModuleEyeFrame;
				setData();
			}
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
			
			computeCircle();
		}
		
		private function computeCircle():void 
		{
			var _y : Number = m_eyeBallRightSp.y - m_eyeBallLeftSp.y;
			var _x : Number = m_eyeBallRightSp.x - m_eyeBallLeftSp.x;
			
			var _er : Number;
			var _ea : Number;
			var _eb : Number;
			
			
			_er = Math.atan2(_y , _x);
			
			//trace("L:"+m_eyeBallLeftSp.x , m_eyeBallLeftSp.y);
			//trace("R:"+m_eyeBallRightSp.x , m_eyeBallRightSp.y);
			
			_ea = Math.sqrt(_y * _y + _x * _x); 
			m_circleShape.x = (m_eyeBallRightSp.x + m_eyeBallLeftSp.x) / 2;
			m_circleShape.y = (m_eyeBallRightSp.y + m_eyeBallLeftSp.y) / 2;
			
			_y = m_eyeBallTopSp.y - m_circleShape.y;
			_x = m_eyeBallTopSp.x - m_circleShape.x;
			
			_eb = Math.sqrt(_y * _y + _x * _x) * 2;
			
			
			m_eyeBallTopSp.x = m_circleShape.x + Math.cos(-Math.PI / 2 + _er) * _eb / 2;
			m_eyeBallTopSp.y = m_circleShape.y + Math.sin(-Math.PI / 2 + _er) * _eb / 2;
			
			
			m_circleShape.scaleX = _ea / 256;
			m_circleShape.scaleY = _eb / 256;
			m_circleShape.rotation = _er / Math.PI * 180;
			
			
			if (m_curLeft)
			{
				ModuleEyeData.s_erL = _er;
				ModuleEyeData.s_eaL = _ea;
				ModuleEyeData.s_ebL = _eb;
				
				ModuleEyeData.s_eCenterLX = m_circleShape.x;
				ModuleEyeData.s_eCenterLY = m_circleShape.y;
				
			}
			else {
				ModuleEyeData.s_erR = _er;
				ModuleEyeData.s_eaR = _ea;
				ModuleEyeData.s_ebR = _eb;
				
				ModuleEyeData.s_eCenterRX = m_circleShape.x;
				ModuleEyeData.s_eCenterRY = m_circleShape.y;
			}
			
			
		}
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
		}
		
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
		}
		
		private function getXYOfArea(_r : Number) : Point
		{
			var ret : Point = new Point;
						
			
			var _er : Number;
			var _ea : Number;
			var _eb : Number;
			
			if (m_curLeft)
			{
				_er = ModuleEyeData.s_erL ;
				_ea = ModuleEyeData.s_eaL ;
				_eb = ModuleEyeData.s_ebL ;
				
			}
			else {
				_er = ModuleEyeData.s_erR ;
				_ea = ModuleEyeData.s_eaR ;
				_eb = ModuleEyeData.s_ebR ;
			}
			
			
			var _rOff : Number = _r - _er;
			var _a : Number = _ea / 2;
			var _b : Number = _eb / 2;
			
			var _as : Number = _a * Math.sin(_rOff);
			var _bc : Number = _b * Math.cos(_rOff);
			
			
			var r:Number = (_a*_b)/Math.sqrt(_as*_as + _bc*_bc);
			ret.x =  Math.cos(_r) * r;
			ret.y =  Math.sin(_r) * r;
			
			//ret.x = Math.cos( _r ) * _re ;
			//ret.y = Math.sin( _r ) * _re;
				
		//	trace(_a  , ret.x);
		//	trace(_b  , ret.y);
			
			
			/*
			var _c : Number = Math.sqrt(Math.abs(_a * _a - _b * _b));
			var _e : Number;
			var _baBigger : Number = (_a > _b) ? _a : _b;
			

			_e = _c /_baBigger;
				
			var _p : Number = _baBigger * _baBigger / _c - _c;
			
			
			
			if (_a > _b) {
				var _lo : Number = _e * _p / (1 - _e * Math.cos(_rOff));
				ret.x = /*m_circleShape.x +* / Math.cos( _r ) * _lo /*+ _c* /;
				ret.y = /*m_circleShape.y +* / Math.sin( _r ) * _lo;
			} else {
				_lo = _e * _p / (1 - _e * Math.cos(_rOff + Math.PI / 2));
				
				ret.x = /*m_circleShape.x +* / Math.cos( _r ) * _lo ;
				ret.y = /*m_circleShape.y +* / Math.sin( _r ) * _lo /*- _c* / ;
			}*/
			
			ret.x += m_circleShape.x;
			ret.y += m_circleShape.y;
			
			
			return ret;
		}
		
		private function onUpdate(e:Event):void 
		{
			var _er : Number;
			var _ea : Number;
			var _eb : Number;
			
			if (m_curLeft)
			{
				_er = ModuleEyeData.s_erL ;
				_ea = ModuleEyeData.s_eaL ;
				_eb = ModuleEyeData.s_ebL ;
				
			}
			else {
				_er = ModuleEyeData.s_erR ;
				_ea = ModuleEyeData.s_eaR ;
				_eb = ModuleEyeData.s_ebR ;
			}
			
			if (!isNaN(_ea))
			{
				m_radianPlay += 0.05;
				if (m_radianPlay >= Math.PI * 2)
					m_radianPlay -= Math.PI * 2;
				
				var pt : Point = getXYOfArea(m_radianPlay);
				
				
				
				m_mefsRoll.eyeBall.x = -(m_mefsRoll.eyeBall.width >> 1) + pt.x ; 
				m_mefsRoll.eyeBall.y = -(m_mefsRoll.eyeBall.height >> 1) + pt.y ; 
				
				
			}
		}
		
		public function dispose():void
		{
			m_circleShape = null;
		
			
			m_eyeBallLeftSp.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_eyeBallRightSp.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_eyeBallTopSp.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			
			m_eyeBallLeftSp.removeEventListener(MouseEvent.MOUSE_UP , onUp);
			m_eyeBallRightSp.removeEventListener(MouseEvent.MOUSE_UP , onUp);
			m_eyeBallTopSp.removeEventListener(MouseEvent.MOUSE_UP , onUp);
			
			m_eyeBallLeft = null;
			m_eyeBallRight = null;
			m_eyeBallTop = null;
			
			m_eyeBallLeftSp = null;
			m_eyeBallRightSp = null;
			m_eyeBallTopSp = null;
			
			m_lastLModuleEyeFrame = null;
			m_lastRModuleEyeFrame = null;
			
			
			GraphicsUtil.removeAllChildrenWithDispose(this);
		}
		
		private function setData():void
		{
			
			m_mefs.renderMask(false);
			m_mefs.refresh();
			m_mefs.eyeBall.visible = false;
			
			m_mefsRoll.data = m_mefs.data;
			m_mefsRoll.renderMask(false);
			m_mefsRoll.refresh();
			
			if (m_mefs.data)
			{
				m_eyeBallLeft.texture2D =
				m_eyeBallRight.texture2D = 
				m_eyeBallTop.texture2D = m_mefs.data.eyeBall;
				
				
				m_eyeBallLeft.x = 
				m_eyeBallRight.x = 
				m_eyeBallTop.x = -(m_eyeBallTop.width >> 1);
				
				m_eyeBallLeft.y = 
				m_eyeBallRight.y = 
				m_eyeBallTop.y = -(m_eyeBallTop.height >> 1);
			
			}
			
			
			if (isNaN(ModuleEyeData.s_eaL))
			{
				var _w : Number;
				var _h : Number;
				if (m_mefs.eyeBall.width)
				{	
					_w = m_mefs.eyeBall.width;
					_h = m_mefs.eyeBall.height;
				}
				else if (m_mefs.eyeWhite.width)
				{	
					_w = m_mefs.eyeWhite.width;
					_h = m_mefs.eyeWhite.height;
				}
				else if (m_mefs.eyeLip.width)
				{	
					_w = m_mefs.eyeLip.width;
					_h = m_mefs.eyeLip.height;
				}
				else
				{
					_w = 100;
					_h = 75;
					
				}	
				m_circleShape.x = (m_mefs.eyeWhite.width >> 1);
				m_circleShape.y = (m_mefs.eyeWhite.height >> 1) ;
				
				ModuleEyeData.s_eaL = ModuleEyeData.s_eaR = _w * 1.5;
				ModuleEyeData.s_ebL = ModuleEyeData.s_ebR = _h * 0.6;
				ModuleEyeData.s_erL = ModuleEyeData.s_erR = 0;
				
				m_circleShape.graphics.lineStyle(1, 0xFFFF00, 0.8,false ,LineScaleMode.NONE);
				m_circleShape.graphics.drawCircle(0, 0, 128);
				m_circleShape.graphics.lineStyle(1, 0xFF0000, 0.5,false ,LineScaleMode.NONE);
				m_circleShape.graphics.moveTo( -128 , 0);
				m_circleShape.graphics.lineTo( +128 , 0);
				m_circleShape.graphics.lineStyle(1, 0x0000FF, 0.5,false ,LineScaleMode.NONE);
				m_circleShape.graphics.moveTo( 0 , -128);
				m_circleShape.graphics.lineTo( 0 , +128);
				
				
				m_circleShape.scaleX = ModuleEyeData.s_eaL  / 256;
				m_circleShape.scaleY = ModuleEyeData.s_ebL  / 256;
				
				m_eyeBallLeftSp.x = m_circleShape.x - ModuleEyeData.s_eaL  / 2;
				m_eyeBallLeftSp.y = m_circleShape.y;
				
				m_eyeBallRightSp.x = m_circleShape.x + ModuleEyeData.s_eaL  / 2;
				m_eyeBallRightSp.y = m_circleShape.y;
				
				m_eyeBallTopSp.x = m_circleShape.x;
				m_eyeBallTopSp.y = m_circleShape.y - ModuleEyeData.s_ebL / 2;
				
				computeCircle();
			}
			else {
				var pt : Point;
				var _er : Number;
				if (m_curLeft)
				{
					m_circleShape.x = ModuleEyeData.s_eCenterLX;
					m_circleShape.y = ModuleEyeData.s_eCenterLY;
					_er = ModuleEyeData.s_erL;
				}
				else
				{
					m_circleShape.x = ModuleEyeData.s_eCenterRX;
					m_circleShape.y = ModuleEyeData.s_eCenterRY;
					_er = ModuleEyeData.s_erR;
				}
				
				pt = getXYOfArea(_er);
				m_eyeBallRightSp.x = pt.x;
				m_eyeBallRightSp.y = pt.y;
				
				pt = getXYOfArea(_er+Math.PI);
				m_eyeBallLeftSp.x = pt.x;
				m_eyeBallLeftSp.y = pt.y;
				
				pt = getXYOfArea(_er-Math.PI/2);
				m_eyeBallTopSp.x = pt.x;
				m_eyeBallTopSp.y = pt.y;
				
				computeCircle();
			}
		}
		
		public function setTemplate(mefs : ModuleEyeFrameSprite , _name : String):void
		{
			m_mefs.data = mefs ? mefs.data : null;
			
			if (m_curLeft)
				m_lastLModuleEyeFrame = m_mefs.data;
			else
				m_lastRModuleEyeFrame = m_mefs.data;
				
			setData();
			
		}
		
	}

}