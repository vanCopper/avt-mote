package editor.module.eye 
{
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.module.head.ModuleHead3DView;
	import editor.module.head.ModuleHeadData;
	import editor.struct.Matrix4x4;
	import editor.struct.Plane3D;
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
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
	public class ModuleEyeLocate extends Sprite
	{
		
		private var m_leftEye : ModuleEyeFrameSprite;
		private var m_rightEye : ModuleEyeFrameSprite;
		
		private var m_browser : ModuleHead3DBrowser;
		
		private var m_zoomL : TextField;
		private var m_zoomR : TextField;
		private var m_eyeView : Sprite;
		private var m_headView : ModuleHead3DView;
		
		public function ModuleEyeLocate() 
		{
			m_browser = new ModuleHead3DBrowser();
			m_browser.renderCallBack = onRenderChange;
			
			m_browser.disableEdit = true;
			
			addChild(m_browser);
			
			m_leftEye = new ModuleEyeFrameSprite(null);
			m_rightEye = new ModuleEyeFrameSprite(null);
			
			var sp : Sprite = new Sprite();
			
			sp.addChild(m_leftEye);
			sp.addChild(m_rightEye);
			
			addChild(sp);
			const OFFX:int = 150;
			m_browser.m_viewer.x = EdtDEF.QUADRANT_WIDTH - OFFX;
			
			sp.x = m_browser.m_viewer.x;
			sp.y = m_browser.m_viewer.y;
			
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
			_btn.x = sp.x - (_btn.width >> 1);
			_btn.y = 10;
			_btn.releaseFunction = setLocate;
			
			addChild(_btn);
			
			graphics.lineStyle(1);
			graphics.moveTo(0 , EdtDEF.QUADRANT_HEIGHT);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH*2 , EdtDEF.QUADRANT_HEIGHT);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH - OFFX , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH - OFFX , EdtDEF.QUADRANT_HEIGHT * 2);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH + OFFX , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH + OFFX , EdtDEF.QUADRANT_HEIGHT * 2);
			
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_eyeView = new Sprite();
			addChild(m_eyeView);
			
			m_headView.x = m_eyeView.x = sp.x + OFFX * 2;
			m_headView.y = m_eyeView.y = sp.y;
			
			
			//new Plane3D().
			//gen3Point(new Vertex3D(1, 2, 3), new Vertex3D(40, 50, 60), new Vertex3D(700, 808, 999));
			
		}
		
		private function onRenderChange(_browser : ModuleHead3DBrowser , __v : Vector.<Number> , md : Matrix4x4):void
		{
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			if (m_leftEye && m_leftEye.data && m_leftEye.data.eyeVertex3D )
			{
				drawEye(m_eyeView , md);
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
			
			var wl : Number;
			var hl : Number;
			
			wl = Math.abs(m_leftEye.data.eyeWhite.rectW) * m_leftEye.scaleX;
			hl = Math.abs(m_leftEye.data.eyeWhite.rectH) * m_leftEye.scaleY;
			
			var v0L : Vertex3D = new Vertex3D(m_leftEye.x, m_leftEye.y, 0);
			var v1L : Vertex3D = new Vertex3D(m_leftEye.x + wl , m_leftEye.y, 0);
			var v2L : Vertex3D = new Vertex3D(m_leftEye.x + wl / 2 , m_leftEye.y + hl, 0);
			
			fitZ3Point(v0L , _v);
			fitZ3Point(v1L , _v);
			fitZ3Point(v2L , _v);
			
			
			//md.effectPoint3D(v0L.x  , v0L.y , v0L.z , v0L);
			//md.effectPoint3D(v1L.x  , v1L.y , v1L.z , v1L);
			//md.effectPoint3D(v2L.x  , v2L.y , v2L.z , v2L);
			
			
			wl = Math.abs(m_rightEye.data.eyeWhite.rectW) * m_rightEye.scaleX;
			hl = Math.abs(m_rightEye.data.eyeWhite.rectH) * m_rightEye.scaleY;
			
			var v0R : Vertex3D = new Vertex3D(m_rightEye.x, m_rightEye.y, 0);
			var v1R : Vertex3D = new Vertex3D(m_rightEye.x + wl , m_rightEye.y, 0);
			var v2R : Vertex3D = new Vertex3D(m_rightEye.x + wl/2, m_rightEye.y + hl, 0);
			
			fitZ3Point(v0R , _v);
			fitZ3Point(v1R , _v);
			fitZ3Point(v2R , _v);
			
			
			//md.effectPoint3D(v0R.x  , v0R.y , v0R.z , v0R);
			//md.effectPoint3D(v1R.x  , v1R.y , v1R.z , v1R);
			//md.effectPoint3D(v2R.x  , v2R.y , v2R.z , v2R);
			
			ModuleEyeData.s_eyeLPlane.gen3Point(v0L, v1L, v2L);
			ModuleEyeData.s_eyeRPlane.gen3Point(v0R, v1R, v2R);
			ModuleEyeData.s_eyeMatrix = md;
			ModuleEyeData.s_eyeLScale =  m_leftEye.scaleX;
			ModuleEyeData.s_eyeRScale =  m_rightEye.scaleX;
			
			ModuleEyeData.s_eyeLLocateX =  m_leftEye.x;
			ModuleEyeData.s_eyeLLocateY =  m_leftEye.y;
			
			ModuleEyeData.s_eyeRLocateX =  m_rightEye.x;
			ModuleEyeData.s_eyeRLocateY =  m_rightEye.y;

			
			
			/*
			md.effectPoint3D(v0L.x  , v0L.y , v0L.z , v0L);
			md.effectPoint3D(v1L.x  , v1L.y , v1L.z , v1L);
			md.effectPoint3D(v2L.x  , v2L.y , v2L.z , v2L);
			
			md.effectPoint3D(v0R.x  , v0R.y , v0R.z , v0R);
			md.effectPoint3D(v1R.x  , v1R.y , v1R.z , v1R);
			md.effectPoint3D(v2R.x  , v2R.y , v2R.z , v2R);
			
			
			graphics.beginBitmapFill(m_leftEye.data.eyeWhite.bitmapData);
			
			graphics.drawTriangles(
				Vector.<Number>([v0L.x  , v0L.y , v1L.x  , v1L.y  , v2L.x  , v2L.y ]),
				Vector.<int>([0,1,2]),
				Vector.<Number>([0,0,1,0,0.5,1])
			);
			graphics.endFill();
			
			graphics.beginBitmapFill(m_rightEye.data.eyeWhite.bitmapData);
			graphics.drawTriangles(
				Vector.<Number>([v0R.x  , v0R.y , v1R.x  , v1R.y  , v2R.x  , v2R.y ]),
				Vector.<int>([0,1,2]),
				Vector.<Number>([0,0,1,0,0.5,1])
			);
			graphics.endFill();
			*/
			m_leftEye.data.genEyeVertex3D(true);
			m_rightEye.data.genEyeVertex3D(false);
			
			
			drawEye(m_eyeView , m_browser.getCurMatrix());
			
			
		}
		
	
		private function drawEyeMaskArray(g:Graphics , _eyeMaskData : Vector.<Vertex3D> , start : int = 0):void
		{
			var idx : int = start + 2;
			
		
			
			while (idx < _eyeMaskData.length)
			{
				g.beginFill(0xFF00000 , 0.25);	
				g.moveTo(_eyeMaskData[0].x , _eyeMaskData[0].y);
				
				g.lineTo(_eyeMaskData[idx-1].x , _eyeMaskData[idx-1].y);
				g.lineTo(_eyeMaskData[idx].x , _eyeMaskData[idx].y);
				g.lineTo(_eyeMaskData[0].x , _eyeMaskData[0].y);
				g.endFill();	
				
				idx++;
			}
		}
		private function drawEyeArray(g:Graphics , v : Vector.<Vertex3D> , bitmapData : BitmapData ,start : Number = NaN, end : Number = NaN):void
		{
			const indices : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
			const uvtData :  Vector.<Number> =  Vector.<Number>([0, 0, 1, 0, 0, 1, 1, 1]);
			var vertices : Vector.<Number> = new Vector.<Number>();
			
			
			if (isNaN(start))
			{
				for each(var vtx : Vertex3D in v)
				{
					vertices.push(vtx.x);
					vertices.push(vtx.y);
				}
			} else {
				for (var _i : int = start ; _i < end ; _i++ )
				{
					vtx = v[_i];
					vertices.push(vtx.x);
					vertices.push(vtx.y);
				}
			}
			
			
			g.beginBitmapFill(bitmapData,null,false,true);
			g.drawTriangles(
				vertices,
				indices , 
				uvtData
			);
			g.endFill();
		}
		
		private function drawEye(sp:Sprite , md : Matrix4x4) : void
		{
			
			
			GraphicsUtil.removeAllChildren(sp);
			
			var shp : Shape = new Shape();
			var shpLip : Shape = new Shape();
			var shpMask : Shape = new Shape();
			
			sp.addChild(shp);
			sp.addChild(shpMask);
			sp.addChild(shpLip);
			shp.mask = shpMask;
			
			var v : Vector.<Vertex3D> ;
			
			;
			var vtx : Vertex3D;
			var vtxD : Vertex3D;
			
			v = new Vector.<Vertex3D>();
			for each (vtx in m_leftEye.data.eyeVertex3D) {
				vtxD = vtx.cloneVertex3D();
				vtxD.x = (md.Xx * vtx.x + md.Xy * vtx.y + md.Xz * vtx.z) ;
				vtxD.y = (md.Yx * vtx.x + md.Yy * vtx.y + md.Yz * vtx.z) ;
				v.push(vtxD);
			}
			
			
			
			drawEyeArray(shp.graphics , v , m_leftEye.data.eyeWhite.bitmapData , 0  , 4);
			drawEyeArray(shp.graphics , v, m_leftEye.data.eyeBall.bitmapData, 4  , 8);
			drawEyeArray(shpLip.graphics , v, m_leftEye.data.eyeLip.bitmapData, 8  , 12);
			drawEyeMaskArray(shpMask.graphics , v , 12);
			
			
			v = new Vector.<Vertex3D>();
			for each (vtx in m_rightEye.data.eyeVertex3D) {
				vtxD = vtx.cloneVertex3D();
				vtxD.x = (md.Xx * vtx.x + md.Xy * vtx.y + md.Xz * vtx.z) ;
				vtxD.y = (md.Yx * vtx.x + md.Yy * vtx.y + md.Yz * vtx.z) ;
				v.push(vtxD);
			}
			
			drawEyeArray(shp.graphics , v , m_rightEye.data.eyeWhite.bitmapData , 0  , 4);
			drawEyeArray(shp.graphics , v, m_rightEye.data.eyeBall.bitmapData, 4  , 8);
			drawEyeArray(shpLip.graphics , v, m_rightEye.data.eyeLip.bitmapData, 8  , 12);
			drawEyeMaskArray(shpMask.graphics , v , 12);
			
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
			
			m_headView.graphics.clear();
			GraphicsUtil.removeAllChildren(m_eyeView);
			
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