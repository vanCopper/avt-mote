package editor.module.mouth
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
	public class ModuleMouthLocate extends Sprite
	{
		private var m_headView : ModuleHead3DView;
		private var m_mouthSprite : ModuleMouthFrameSprite;
		
		public function ModuleMouthLocate() 
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
			
			m_mouthSprite = new ModuleMouthFrameSprite(null);
			
			addChild(m_mouthSprite);
			m_mouthSprite.x = m_headView.x;
			m_mouthSprite.y = m_headView.y;
			
			m_mouthSprite.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_mouthSprite.addEventListener(MouseEvent.MOUSE_UP , onUp);
			
			//new Plane3D().
			//gen3Point(new Vertex3D(1, 2, 3), new Vertex3D(40, 50, 60), new Vertex3D(700, 808, 999));
			
			var _btn : BSSButton = BSSButton.createSimpleBSSButton(100, 20 , "locate");
			_btn.x = EdtDEF.QUADRANT_WIDTH - (_btn.width >> 1);
			_btn.y = 60;
			_btn.releaseFunction = setLocate;
			addChild(_btn);
		}
		
		public function setCurrentData(_data:ModuleMouthFrame):void
		{
			m_mouthSprite.data = _data;
			m_mouthSprite.refresh();
			
			if (_data)
			{
				m_mouthSprite.view.x  = _data.offsetX;
				m_mouthSprite.view.y  = _data.offsetY;
			}
			
			m_mouthSprite.x = ModuleMouthData.centerX + EdtDEF.QUADRANT_WIDTH;
			m_mouthSprite.y = ModuleMouthData.centerY + EdtDEF.QUADRANT_HEIGHT;
			
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
			if (m_mouthSprite && m_mouthSprite.data && m_mouthSprite.data.texture)
			{
				if (!ModuleHeadData.s_vertexRelativeData || !ModuleHeadData.s_vertexRelativeData.length)
					ModuleHeadData.genVertexRelativeData();
				var _v : Vector.<Vertex3D> = ModuleHeadData.s_vertexRelativeData
				//var _v : Vector.<Vertex3D> = m_browser.getVertexMatrixed();
			
				var wl : Number;
				var hl : Number;
				
				var _rectW : Number;
				var _rectH : Number;
				
				_rectW = Math.abs(m_mouthSprite.data.texture.rectW);
				_rectH = Math.abs(m_mouthSprite.data.texture.rectH);
				
				wl = _rectW / 2 ;
				hl = _rectH / 2 ;
				
				ModuleMouthData.mouseV0 = new EdtVertex3D(ModuleMouthData.centerX, ModuleMouthData.centerY + hl, 0);
				ModuleMouthData.mouseV1 = new EdtVertex3D(ModuleMouthData.centerX - wl , ModuleMouthData.centerY - hl, 0);
				ModuleMouthData.mouseV2 = new EdtVertex3D(ModuleMouthData.centerX + wl , ModuleMouthData.centerY - hl, 0);
				
				ModuleMouthData.mouseV0.priority = 1;
				ModuleMouthData.mouseV1.priority = 2;
				ModuleMouthData.mouseV2.priority = 3;
				
				EdtVertex3D.connect2PT(ModuleMouthData.mouseV0 , ModuleMouthData.mouseV1);
				EdtVertex3D.connect2PT(ModuleMouthData.mouseV1 , ModuleMouthData.mouseV2);
				EdtVertex3D.connect2PT(ModuleMouthData.mouseV0 , ModuleMouthData.mouseV2);
				
				ZFitter.fitZ3Point(ModuleMouthData.mouseV0 , _v);
				ZFitter.fitZ3Point(ModuleMouthData.mouseV1 , _v);
				ZFitter.fitZ3Point(ModuleMouthData.mouseV2 , _v);
				
				ModuleMouthData.mouthPlane.gen3Point(ModuleMouthData.mouseV0, ModuleMouthData.mouseV1, ModuleMouthData.mouseV2);
				/*
				
				ModuleEyeData.s_eyeLPlane.gen3Point(v0L, v1L, v2L);
				ModuleEyeData.s_eyeRPlane.gen3Point(v0R, v1R, v2R);
				ModuleEyeData.s_eyeMatrix = md;
				ModuleEyeData.s_eyeLScale =  m_leftEye.scaleX;
				ModuleEyeData.s_eyeRScale =  m_rightEye.scaleX;
				
				ModuleEyeData.s_eyeLLocateX =  m_leftEye.x;
				ModuleEyeData.s_eyeLLocateY =  m_leftEye.y;
				
				ModuleEyeData.s_eyeRLocateX =  m_rightEye.x;
				ModuleEyeData.s_eyeRLocateY =  m_rightEye.y;

				ModuleEyeData.s_eyeLocated = true;*/
				
				
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
			
			ModuleMouthData.centerX = m_mouthSprite.x - EdtDEF.QUADRANT_WIDTH;
			ModuleMouthData.centerY = m_mouthSprite.y - EdtDEF.QUADRANT_HEIGHT;
			
			m_mouthSprite.refresh();
			 
		}
		
		
		public function reset():void
		{
			
			m_headView.graphics.clear();
			
			m_mouthSprite.data = null;
			m_mouthSprite.refresh();
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
			m_mouthSprite.refresh();
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
		
	
		public function setTemplate(mefs : ModuleMouthFrameSprite , _name : String):void
		{
						
		}
		
	}

}