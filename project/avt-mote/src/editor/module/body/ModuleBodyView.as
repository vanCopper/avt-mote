package editor.module.body 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.module.head.ModuleHead3DView;
	import editor.module.head.ModuleHeadData;
	import editor.struct.Matrix4x4;
	import editor.struct.Vertex3D;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtSlider;
	import editor.ui.EdtSliderNumber;
	import editor.ui.EdtVertex3D;
	import editor.ui.TextCheckBox;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBodyView extends Sprite
	{
		
		private var m_data:ModuleBodyFrame;

		private var m_headView : ModuleHead3DView;
		private var m_bodyShape : ModuleBodyFrameShape;
		
		private var m_currentMatrix : Matrix4x4 = new Matrix4x4();
		private var m_regCallBack : Boolean;
		private var m_xR:Number = 0;
		private var m_yR:Number = 0;
		private var m_zR:Number = 0;

		private var sinWind : Number = 0;
		private var breath : Number = 0;
		private var breathOff : Number = 0.02;
		private var m_breath : EdtSliderNumber;
		
		public function ModuleBodyView(showChotol : Boolean = true) 
		{
			
			m_bodyShape = new ModuleBodyFrameShape(null);
			addChild(m_bodyShape);
		
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_headView.x = EdtDEF.QUADRANT_WIDTH;
			m_headView.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_bodyShape.x = EdtDEF.QUADRANT_WIDTH;
			m_bodyShape.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_currentMatrix.identity();
			
			m_breath = new EdtSliderNumber( 0.01 , 0.1 , "breath speed");
			addChild(m_breath);
			m_breath.x = 5;
			m_breath.y = 70;
			m_breath.value = 0.02;
			
		}
		
		public function setCurrentData(_data:ModuleBodyFrame):void
		{
			m_bodyShape.data = _data;
			if (_data)
			{	
				_data.genUVData();
				_data.genIndicesData();
			}
			m_bodyShape.refreshInterp(breath);
		}
		
		private function drawHeadVertex():void
		{
			
			var md : Matrix4x4 = m_currentMatrix; 
			
		
			var __v : Vector.<Number> = new Vector.<Number>();
			var _vx : Number;
			var _vy : Number;
			
			//md = mY;
			
			if (!ModuleHeadData.s_vertexRelativeData || !ModuleHeadData.s_vertexRelativeData.length)
				ModuleHeadData.genVertexRelativeData();
			
			for each( var ev : Vertex3D in ModuleHeadData.s_vertexRelativeData)
			{
				_vx = (md.Xx * ev.x + md.Xy * ev.y + md.Xz * ev.z) ;
				_vy = (md.Yx * ev.x + md.Yy * ev.y + md.Yz * ev.z) ;
				
				__v.push(_vx  );
				__v.push(_vy  );
				
			}
			
			onRenderChange(null , __v , md );
			
		}
		
		public function dispose():void
		{
			GraphicsUtil.removeAllChildren(this);
			
			m_data = null;
			
			if (m_headView)
			{	
				//m_headView.dispose();
				m_headView = null;
				
			}
		}
		
		private function onRenderChange(_browser : ModuleHead3DBrowser , __v : Vector.<Number> , md : Matrix4x4):void
		{
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			
			m_bodyShape.refreshInterp(breath);
		}
		
		private function onUpdate(e:Event):void 
		{
			sinWind += breathOff;
			m_zR = Math.sin(sinWind) * 0.05;
			m_xR = m_yR = Math.sin(sinWind) * 0.02;
			m_currentMatrix = ModuleHead3DBrowser.getMatrix(m_xR, m_yR, m_zR);
			
			if (breathOff != 0)
				breathOff =  breathOff / Math.abs(breathOff) * m_breath.value;
			
			breath += breathOff;
			if (breath >= 1)
			{
				breath = 1;
				breathOff = -Math.abs(breathOff);
			}
			else if (breath <= 0)
			{
				breath = 0;
				breathOff = Math.abs(breathOff);
			}
			
			drawHeadVertex();
		}
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			//m_headView.activate();
			
			m_currentMatrix.identity();	
			sinWind = 0;
			
			
			drawHeadVertex();
			
		}
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
			

			if (m_regCallBack)
			{
				m_regCallBack = false;
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				//CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
			}
		}
		
		/*
		private function onMouseMoveD():void
		{
				
			var mXOff : Number = (mouseX - EdtDEF.QUADRANT_WIDTH);
			var mYOff : Number = (mouseY - EdtDEF.QUADRANT_HEIGHT);
			
			m_xR = - mXOff / EdtDEF.QUADRANT_WIDTH * 0.4;
			m_yR =  mYOff / EdtDEF.QUADRANT_HEIGHT  * 0.4;
			
			m_currentMatrix = ModuleHead3DBrowser.getMatrix(m_xR, m_yR, 0 /*- ModuleHeadData.s_absRZ* /);
			
			drawHeadVertex();
			
		}*/
		
		//private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		//{
		//	return 0;
		//}
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			//onMouseMoveD();			
			return 0;
		}
		
	}

}