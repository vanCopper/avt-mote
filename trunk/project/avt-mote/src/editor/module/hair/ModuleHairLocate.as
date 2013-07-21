package editor.module.hair 
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
	public class ModuleHairLocate extends Sprite
	{
		private var m_headView : ModuleHead3DView;
		private var m_hairShape : ModuleHairFrameShape;
		
		public function ModuleHairLocate() 
		{
			
			var _btn : BSSButton = BSSButton.createSimpleBSSButton(100, 20 , "locate");
			//_btn.x = sp.x - (_btn.width >> 1);
			_btn.y = 30;
			_btn.releaseFunction = setLocate;
			
			addChild(_btn);
			
			graphics.lineStyle(1);
			graphics.moveTo(0 , EdtDEF.QUADRANT_HEIGHT);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH*2 , EdtDEF.QUADRANT_HEIGHT);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH  , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH  , EdtDEF.QUADRANT_HEIGHT * 2);
			
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_headView.x = EdtDEF.QUADRANT_WIDTH;
			m_headView.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_hairShape = new ModuleHairFrameShape(null);
			
			addChild(m_hairShape);
			m_hairShape.x = m_headView.x;
			m_hairShape.y = m_headView.y;
			
			m_hairShape.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			m_hairShape.addEventListener(MouseEvent.MOUSE_UP , onUp);
			
			//new Plane3D().
			//gen3Point(new Vertex3D(1, 2, 3), new Vertex3D(40, 50, 60), new Vertex3D(700, 808, 999));
			
		}
		
		public function setCurrentData(_data:ModuleHairFrame):void
		{
			m_hairShape.data = _data;
			if (_data)
			{	
				_data.genUVData();
				_data.genIndicesData();
			}
			m_hairShape.refresh();
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
		
	
		private function sortOnVLength(a:Object, b:Object):Number {  
			if (a.len2 > b.len2)
				return 1;
			else if (a.len2 < b.len2)
				return -1;
			else
				return 0;
		}
		*/
		
		private function setLocate(btn:BSSButton):void 
		{
			
			
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
			var _dsp : Sprite = e.currentTarget as Sprite;
			_dsp.stopDrag();
			
			m_hairShape.data.offsetX = m_hairShape.data.offsetX + m_hairShape.x - EdtDEF.QUADRANT_WIDTH;
			m_hairShape.data.offsetY = m_hairShape.data.offsetY + m_hairShape.y - EdtDEF.QUADRANT_HEIGHT;
			
			m_hairShape.x = EdtDEF.QUADRANT_WIDTH;
			m_hairShape.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_hairShape.refresh();
			 
			
		}
		
		
		public function reset():void
		{
			
			m_headView.graphics.clear();
			
			m_hairShape.data = null;
			m_hairShape.refresh();
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
			m_hairShape.refresh();
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
		
	
		public function setTemplate(mefs : ModuleHairFrameSprite , _name : String):void
		{
						
		}
		
	}

}