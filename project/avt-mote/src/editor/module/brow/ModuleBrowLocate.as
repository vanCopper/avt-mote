package editor.module.brow
{
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.module.head.ModuleHead3DView;
	import editor.module.head.ModuleHeadData;
	import editor.struct.Matrix4x4;
	import editor.struct.Plane3D;
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import editor.ui.TextCheckBox;
	import editor.util.ZFitter;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBrowLocate extends Sprite
	{
		private var m_headView : ModuleHead3DView;
		private var m_browSpriteL : ModuleBrowFrameSprite;
		private var m_browSpriteR : ModuleBrowFrameSprite;
		
		private var m_curLeft : Boolean = true;
		
			
			
		
		public function ModuleBrowLocate() 
		{
			
			//var _btn : BSSButton = BSSButton.createSimpleBSSButton(100, 20 , "locate");
			///_btn.x = sp.x - (_btn.width >> 1);
			//_btn.y = 30;
			//_btn.releaseFunction = setLocate;
			//addChild(_btn);
			
			graphics.lineStyle(1);
			graphics.moveTo(0 , EdtDEF.QUADRANT_HEIGHT);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH*2 , EdtDEF.QUADRANT_HEIGHT);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH  , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH  , EdtDEF.QUADRANT_HEIGHT * 2);
			
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_headView.x = EdtDEF.QUADRANT_WIDTH;
			m_headView.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_browSpriteL = new ModuleBrowFrameSprite(null);
			
			addChild(m_browSpriteL);
			m_browSpriteL.x = m_headView.x;
			m_browSpriteL.y = m_headView.y;
			m_browSpriteL.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_browSpriteL.addEventListener(MouseEvent.MOUSE_UP , onUp);
			
			m_browSpriteR = new ModuleBrowFrameSprite(null);
			
			addChild(m_browSpriteR);
			m_browSpriteR.x = m_headView.x;
			m_browSpriteR.y = m_headView.y;
			m_browSpriteR.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_browSpriteR.addEventListener(MouseEvent.MOUSE_UP , onUp);
			
			//new Plane3D().
			//gen3Point(new Vertex3D(1, 2, 3), new Vertex3D(40, 50, 60), new Vertex3D(700, 808, 999));
			
			var _btn : BSSButton = BSSButton.createSimpleBSSButton(100, 20 , "locate");
			_btn.x = EdtDEF.QUADRANT_WIDTH - (_btn.width >> 1);
			_btn.y = 60;
			_btn.releaseFunction = setLocate;
			addChild(_btn);
			
			var arr : Array = [];
			_btn = BSSButton.createSimpleBSSButton(30, 20, "Left", true, arr );
			_btn.setState(BSSButton.SBST_PRESS);
			_btn.releaseFunction = ChangeToLeft;
			addChild(_btn);
			_btn.statusMode = true;
			_btn.y = 60;
			_btn.x = 5;
			var last : BSSButton = _btn;
			_btn.setState(BSSButton.SBST_PRESS);
			
			_btn = BSSButton.createSimpleBSSButton(30, 20, "Right",true,arr );
			_btn.releaseFunction = ChangeToRight;
			addChild(_btn);
			_btn.statusMode = true;
			_btn.y = 60;
			_btn.x = last.x + last.width + 5;
			
			
			
			
		}
		
		private function ChangeToRight(btn : BSSButton):void 
		{
			if (m_curLeft)
			{
				
				m_curLeft = false;
			}
		}
		
		private function ChangeToLeft(btn : BSSButton):void 
		{
			if (!m_curLeft)
			{
				//m_browSpriteR.filters = [];
				//m_browSpriteL.filters = [];
				
				m_curLeft = true;
			}
		}
		
		public function setCurrentData(_data:ModuleBrowFrame):void
		{
			var _browSprite : ModuleBrowFrameSprite;
			
			if (m_curLeft)
				_browSprite = m_browSpriteL;
			else
				_browSprite = m_browSpriteR;
			
			_browSprite.data = _data;
			_browSprite.refresh();
			
			if (_data)
			{
				_browSprite.view.x  = _data.offsetX;
				_browSprite.view.y  = _data.offsetY;
			}
			
			if (m_curLeft)
			{
				m_browSpriteL.x = ModuleBrowData.centerLX + m_headView.x;
				m_browSpriteL.y = ModuleBrowData.centerLY + m_headView.y;
			}
			else
			{
				m_browSpriteR.x = ModuleBrowData.centerRX + m_headView.x;
				m_browSpriteR.y = ModuleBrowData.centerRY + m_headView.y;
			}
			
			
		}
		
		/*
		private function onRenderChange(_browser : ModuleHead3DBrowser , __v : Vector.<Number> , md : Matrix4x4):void
		{
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			if (m_leftEye && m_leftEye.data && m_leftEye.data.eyeVertex3D )
			{
				ModuleEyeFunc.drawEye(m_eyeView , md ,  m_leftEye.data ,  m_rightEye.data);
			}
		}
		private function fitZ3Point(v : Vertex3D , _v : Vector.<Vertex3D>):void
		{
			var arr : Array = [];
			for each (var headV : Vertex3D in _v)
			{
				var _x : Number = headV.x - v.x;
				var _y : Number = headV.y - v.y;
				
				arr.push( { len2:(_x * _x + _y * _y) , vtx : headV } );
			}
			
			arr.sort(sortOnVLength);  
			
			var _p : Plane3D = new Plane3D();
			 _p.gen3Point(arr[0].vtx , arr[1].vtx , arr[2].vtx );
			
			v.z = _p.confitZ(v.x, v.y);
		}
		
	
		*/
		
		private function setLocate(btn:BSSButton):void 
		{
			if (m_browSpriteL && m_browSpriteL.data && m_browSpriteL.data.texture)
			{
				if (!ModuleHeadData.s_vertexRelativeData || !ModuleHeadData.s_vertexRelativeData.length)
					ModuleHeadData.genVertexRelativeData();
				var _v : Vector.<Vertex3D> = ModuleHeadData.s_vertexRelativeData
			
				var wl : Number;
				var hl : Number;
				
				var _rectW : Number;
				var _rectH : Number;
				
				_rectW = Math.abs(m_browSpriteL.data.texture.rectW);
				_rectH = Math.abs(m_browSpriteL.data.texture.rectH);
				
				wl = _rectW / 2 ;
				hl = _rectH / 2 ;
				
				ModuleBrowData.browVL0 = new EdtVertex3D(ModuleBrowData.centerLX, ModuleBrowData.centerLY + hl, 0);
				ModuleBrowData.browVL1 = new EdtVertex3D(ModuleBrowData.centerLX - wl , ModuleBrowData.centerLY - hl, 0);
				ModuleBrowData.browVL2 = new EdtVertex3D(ModuleBrowData.centerLX + wl , ModuleBrowData.centerLY - hl, 0);
				
				ModuleBrowData.browVL0.priority = 1;
				ModuleBrowData.browVL1.priority = 2;
				ModuleBrowData.browVL2.priority = 3;
				
				EdtVertex3D.connect2PT(ModuleBrowData.browVL0 , ModuleBrowData.browVL1);
				EdtVertex3D.connect2PT(ModuleBrowData.browVL1 , ModuleBrowData.browVL2);
				EdtVertex3D.connect2PT(ModuleBrowData.browVL0 , ModuleBrowData.browVL2);
				
				ZFitter.fitZ3Point(ModuleBrowData.browVL0 , _v);
				ZFitter.fitZ3Point(ModuleBrowData.browVL1 , _v);
				ZFitter.fitZ3Point(ModuleBrowData.browVL2 , _v);
				
				ModuleBrowData.browPlaneL.gen3Point(ModuleBrowData.browVL0, ModuleBrowData.browVL1, ModuleBrowData.browVL2);
				
				//////////////////////////
				_rectW = Math.abs(m_browSpriteR.data.texture.rectW);
				_rectH = Math.abs(m_browSpriteR.data.texture.rectH);
				
				wl = _rectW / 2 ;
				hl = _rectH / 2 ;
				
				ModuleBrowData.browVR0 = new EdtVertex3D(ModuleBrowData.centerRX, ModuleBrowData.centerRY + hl, 0);
				ModuleBrowData.browVR1 = new EdtVertex3D(ModuleBrowData.centerRX - wl , ModuleBrowData.centerRY - hl, 0);
				ModuleBrowData.browVR2 = new EdtVertex3D(ModuleBrowData.centerRX + wl , ModuleBrowData.centerRY - hl, 0);
				
				ModuleBrowData.browVR0.priority = 4;
				ModuleBrowData.browVR1.priority = 5;
				ModuleBrowData.browVR2.priority = 6;
				
				EdtVertex3D.connect2PT(ModuleBrowData.browVR0 , ModuleBrowData.browVR1);
				EdtVertex3D.connect2PT(ModuleBrowData.browVR1 , ModuleBrowData.browVR2);
				EdtVertex3D.connect2PT(ModuleBrowData.browVR0 , ModuleBrowData.browVR2);
				
				ZFitter.fitZ3Point(ModuleBrowData.browVR0 , _v);
				ZFitter.fitZ3Point(ModuleBrowData.browVR1 , _v);
				ZFitter.fitZ3Point(ModuleBrowData.browVR2 , _v);
				
				ModuleBrowData.browPlaneR.gen3Point(ModuleBrowData.browVR0, ModuleBrowData.browVR1, ModuleBrowData.browVR2);
				
				
			}
			
		}
		
		private function onDown(e:MouseEvent):void 
		{
			var _dsp : Sprite = e.currentTarget as Sprite;
			
			//if (_dsp.parent)
			//{
			//	var _p : DisplayObjectContainer = _dsp.parent;
			//	_p.addChild(_dsp);
			//}
			
			_dsp.startDrag();
			
		}
		
		private function onUp(e:MouseEvent):void 
		{
			var _dsp : Sprite = e.currentTarget as Sprite;
			_dsp.stopDrag();
			
			if (_dsp == m_browSpriteL)
			{	
				ModuleBrowData.centerLX = m_browSpriteL.x - EdtDEF.QUADRANT_WIDTH;
				ModuleBrowData.centerLY = m_browSpriteL.y - EdtDEF.QUADRANT_HEIGHT;
			
				m_browSpriteL.refresh();
			}
			else if (_dsp == m_browSpriteR)
			{	
				ModuleBrowData.centerRX = m_browSpriteR.x - EdtDEF.QUADRANT_WIDTH;
				ModuleBrowData.centerRY = m_browSpriteR.y - EdtDEF.QUADRANT_HEIGHT;
			
				m_browSpriteR.refresh();
			}
			 
		}
		
		
		public function reset():void
		{
			
			m_headView.graphics.clear();
			
			m_browSpriteL.data = null;
			m_browSpriteL.refresh();
			
			m_browSpriteR.data = null;
			m_browSpriteR.refresh();
		}
		public function refresh():void
		{
			var __v : Vector.<Number> = new Vector.<Number>();
			var _vx : Number;
			var _vy : Number;
			
			//md = mY;
			
			if (!ModuleHeadData.s_vertexRelativeData || !ModuleHeadData.s_vertexRelativeData.length)
				ModuleHeadData.genVertexRelativeData();
			
			for each( var ev : Vertex3D in ModuleHeadData.s_vertexRelativeData)
			{
				_vx =  ev.x ;
				_vy =  ev.y ;
				
				__v.push(_vx  );
				__v.push(_vy  );
				
			}
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			m_browSpriteL.refresh();
			m_browSpriteR.refresh();
		}

		
		
		public function activate():void
		{
			
			refresh();
		}
		
		public function deactivate():void
		{

		}
	
		
		public function dispose():void
		{
			deactivate();
			GraphicsUtil.removeAllChildrenWithDispose(this);
		}
		
	
		public function setTemplate(mefs : ModuleBrowFrameSprite , _name : String):void
		{
						
		}
		
	}

}