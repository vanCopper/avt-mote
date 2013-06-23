package editor.module.eye 
{
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.struct.Matrix4x4;
	import editor.struct.Plane3D;
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
	import flash.display.DisplayObjectContainer;
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
	public class ModuleEyeLocate extends Sprite
	{
		
		private var m_leftEye : ModuleEyeFrameSprite;
		private var m_rightEye : ModuleEyeFrameSprite;
		
		private var m_browser : ModuleHead3DBrowser;
		
		private var m_zoomL : TextField;
		private var m_zoomR : TextField;
		
		
		
		public function ModuleEyeLocate() 
		{
			m_browser = new ModuleHead3DBrowser();
			
			m_browser.disableEdit = true;
			
			addChild(m_browser);
			
			m_leftEye = new ModuleEyeFrameSprite(null);
			m_rightEye = new ModuleEyeFrameSprite(null);
			
			var sp : Sprite = new Sprite();
			
			sp.addChild(m_leftEye);
			sp.addChild(m_rightEye);
			
			addChild(sp);
			
			sp.x = EdtDEF.QUADRANT_WIDTH;
			sp.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_leftEye.x = -40;
			m_rightEye.x = 40;
			
			
			m_leftEye.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_leftEye.addEventListener(MouseEvent.MOUSE_UP , onUp);
			m_leftEye.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			
			m_rightEye.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_rightEye.addEventListener(MouseEvent.MOUSE_UP , onUp);
			m_rightEye.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel)
			
			m_zoomL = new TextField;
			m_zoomR  = new TextField;
			
			
			var indi : TextField  = new TextField;
			indi.text = "Zoom L:\nZoom R:"
			indi.mouseEnabled = false;
			
			addChild(indi);
			m_zoomL.x = 100;
			m_zoomR.x = 100;
			m_zoomR.y = 16;
			m_zoomL.text = "1.0";
			m_zoomR.text = "1.0";
			
			
			addChild(m_zoomL);
			addChild(m_zoomR);
			
			var _btn : BSSButton = BSSButton.createSimpleBSSButton(100, 20 , "locate");
			_btn.x = EdtDEF.QUADRANT_WIDTH - (_btn.width >> 1);
			_btn.y = 10;
			_btn.releaseFunction = setLocate;
			
			addChild(_btn);
			
			graphics.lineStyle(1);
			graphics.moveTo(0 , EdtDEF.QUADRANT_HEIGHT);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH*2 , EdtDEF.QUADRANT_HEIGHT);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH , EdtDEF.QUADRANT_HEIGHT * 2);
			
			//new Plane3D().
			//gen3Point(new Vertex3D(1, 2, 3), new Vertex3D(40, 50, 60), new Vertex3D(700, 808, 999));
			
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
		
	
		private function sortOnVLength(a:Object, b:Object):Number {  
			if (a.len2 > b.len2)
				return 1;
			else if (a.len2 < b.len2)
				return -1;
			else
				return 0;
		}
		
		private function setLocate(btn:BSSButton):void 
		{
			var md : Matrix4x4 = m_browser.getInvertMatrix();
			
			var _v : Vector.<Vertex3D> = m_browser.getVertexMatrixed();
			
			var v0L : Vertex3D = new Vertex3D(m_leftEye.x, m_leftEye.y, 0);
			var v1L : Vertex3D = new Vertex3D(m_leftEye.x + Math.abs(m_leftEye.data.eyeWhite.rectW) * m_leftEye.scaleX , m_leftEye.y, 0);
			var v2L : Vertex3D = new Vertex3D(m_leftEye.x + Math.abs(m_leftEye.data.eyeWhite.rectW) * m_leftEye.scaleX , m_leftEye.y + Math.abs(m_leftEye.data.eyeWhite.rectH) * m_leftEye.scaleY, 0);
			
			fitZ3Point(v0L , _v);
			fitZ3Point(v1L , _v);
			fitZ3Point(v2L , _v);
			
			ModuleEyeData.s_eyeLPlane.gen3Point(v0L, v1L, v2L);
			
			
			var v0R : Vertex3D = new Vertex3D(m_rightEye.x, m_rightEye.y, 0);
			var v1R : Vertex3D = new Vertex3D(m_rightEye.x + Math.abs(m_rightEye.data.eyeWhite.rectW) * m_rightEye.scaleX , m_rightEye.y, 0);
			var v2R : Vertex3D = new Vertex3D(m_rightEye.x , m_rightEye.y + Math.abs(m_rightEye.data.eyeWhite.rectH) * m_rightEye.scaleY, 0);
			
			fitZ3Point(v0R , _v);
			fitZ3Point(v1R , _v);
			fitZ3Point(v2R , _v);
			
			ModuleEyeData.s_eyeLPlane.gen3Point(v0L, v1L, v2L);
			ModuleEyeData.s_eyeRPlane.gen3Point(v0R, v1R, v2R);
			
			
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			var _dsp : Sprite = e.currentTarget as Sprite;
			
			if (e.delta > 0)
			{
				_dsp.scaleX = _dsp.scaleY = _dsp.scaleX + (e.shiftKey ? 0.03125 : 0.125);
			}
			else
			{
				_dsp.scaleX = _dsp.scaleY = _dsp.scaleX - (e.shiftKey ? 0.03125 : 0.125);
			}
			updateZoomText();
		}
		
		private function onDown(e:MouseEvent):void 
		{
			var _dsp : Sprite = e.currentTarget as Sprite;
			
			if (_dsp.parent)
			{
				var _p : DisplayObjectContainer = _dsp.parent;
				_p.addChild(_dsp);
			}
			
			_dsp.startDrag();
			
		}
		
		private function onUp(e:MouseEvent):void 
		{
			 e.currentTarget.stopDrag();
			
		}
		
		public function updateZoomText():void
		{
			m_zoomL.text = "" + m_leftEye.scaleX;
			m_zoomR.text = "" + m_rightEye.scaleX;
		}
		
		public function reset():void
		{
			m_browser.reset();
			m_leftEye.data = null;
			m_rightEye.data = null;
			
			m_leftEye.refresh();
			m_rightEye.refresh();
			
			m_leftEye.scaleX = m_leftEye.scaleY = 
			m_rightEye.scaleX = m_rightEye.scaleY = 1.0;
			
			
			m_zoomL.text = "1.0";
			m_zoomR.text = "1.0";
			
		}
		public function refresh():void
		{
			
			m_leftEye.data = null;
			m_rightEye.data = null;
			
			
			
			m_leftEye.data = ModuleEyeData.s_frameL;
			m_rightEye.data = ModuleEyeData.s_frameR;
			
			
			m_leftEye.renderMask(false);
			m_leftEye.refresh();
			
			m_rightEye.renderMask(false);
			m_rightEye.refresh();
			
			
		}

		
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			m_browser.activate();
			refresh();
			
			
			
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