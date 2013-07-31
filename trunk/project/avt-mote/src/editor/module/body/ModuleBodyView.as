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
	import editor.ui.EdtRotationAxis;
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

		private var m_xRD:Number = 0;
		private var m_yRD:Number = 0;
		private var m_zRD:Number = 0;
		
		private var sinWind : Number = 0;
		private var breath : Number = 0;
		private var breathOff : Number = 0.02;
		private var m_breath : EdtSliderNumber;
		private var m_connect : EdtSliderNumber;
		private var m_controler : EdtRotationAxis;
		
		
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
			
			
			m_connect = new EdtSliderNumber( 0 , 6 , "head connect line");
			addChild(m_connect);
			m_connect.x = 5;
			m_connect.y = 130;
			m_connect.value = 2;
			m_connect.intVer = true;
			m_connect.changeFunction = function(v:int) : void { if (m_bodyShape && m_bodyShape.data)  m_bodyShape.data.headLine = v; }
			
			m_controler = new EdtRotationAxis();
			m_controler.onUpdate = onUpdateAxis;
			m_controler.x = 100;
			m_controler.y = 300;
			
			addChild(m_controler);
			
		}
		
		
		private function onUpdateAxis(xValue : Number, yValue : Number, zValue : Number , end : Boolean):void
		{
			xValue /= 8;
			yValue /= 8;
			zValue /= 8;
			
			//trace(xValue , yValue, zValue);
			if (end)
			{
				m_xR += xValue;
				m_yR += yValue;
				m_zR += zValue;
			
				render(m_xR,m_yR,m_zR);
			}
			else
			{
				render(m_xR + xValue,m_yR+ yValue,m_zR+ zValue);
			}
		}
		
		private function render(xValue : Number, yValue : Number, zValue: Number):void
		{
			m_xRD = yValue;
			m_yRD = xValue;
			m_zRD = zValue;
			
		}
		
		public function setCurrentData(_data:ModuleBodyFrame):void
		{
			m_bodyShape.data = _data;
			if (_data)
			{	
				_data.genUVData();
				_data.genIndicesData();
				
				m_connect.value = _data.headLine;
				m_bodyShape.refreshInterp(breath , m_xRD, m_yRD, m_zRD );
			}
			
		}
		
		private function drawHeadVertex(xValue : Number, yValue : Number, zValue: Number):void
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
			
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			m_bodyShape.refreshInterp(breath , xValue, yValue , zValue );
			
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
		
		
		private function onUpdate(e:Event):void 
		{
			sinWind += breathOff;
			//m_zR = Math.sin(sinWind) * 0.05;
			//m_xR = m_yR = Math.sin(sinWind) * 0.02;
			m_currentMatrix = ModuleHead3DBrowser.getMatrix(m_xRD, m_yRD, m_zRD);
			
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
			
			drawHeadVertex(m_xRD, m_yRD, m_zRD);
		}
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			//m_headView.activate();
			
			m_currentMatrix.identity();	
			sinWind = 0;
			m_controler.activate();
			
			drawHeadVertex(m_xRD, m_yRD, m_zRD);
			
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
			
			m_controler.deactivate();
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