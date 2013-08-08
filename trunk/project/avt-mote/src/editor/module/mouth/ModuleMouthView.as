package editor.module.mouth
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
	public class ModuleMouthView extends Sprite
	{
		
		private var m_data:ModuleMouthFrame;

		private var m_headView : ModuleHead3DView;
		private var m_currentMatrix : Matrix4x4 = new Matrix4x4();
		private var m_regCallBack : Boolean;
		private var m_mouthShape : ModuleMouthFrameShape;
		//	 m_needRedraw : Boolean;
		private var m_xR : Number;
		private var m_yR : Number;
		
		
		public function ModuleMouthView(showChotol : Boolean = true) 
		{
			
		//	m_browser = new ModuleHead3DBrowser();
		//	m_browser.renderCallBack = onRenderChange;
		//	m_browser.disableEdit = true;
			
		//	addChild(m_browser);
		
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_headView.x = EdtDEF.QUADRANT_WIDTH;
			m_headView.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_currentMatrix.identity();
			
			m_mouthShape = new ModuleMouthFrameShape(null);
			addChild(m_mouthShape);
			
			m_mouthShape.x = m_headView.x;
			m_mouthShape.y = m_headView.y;
		}
		
		public function setCurrentData(_data:ModuleMouthFrame):void
		{
			m_mouthShape.data = _data;
			m_data = _data;
			m_data.confitZ();
			m_data.genUVData();
			
			m_mouthShape.refresh(m_currentMatrix);
			
			
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
			
			
			//if (m_browser)
			//{	
			//	m_browser.dispose();
			//	m_browser = null;
			//}
			
			if (m_headView)
			{	
				//m_headView.dispose();
				m_headView = null;
				
			}
		}
		
		private function onRenderChange(_browser : ModuleHead3DBrowser , __v : Vector.<Number> , md : Matrix4x4):void
		{
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			
			m_mouthShape.refresh(md);
			
		}
		
		
		
		public function activate():void
		{
			
				
			m_currentMatrix.identity();	
			drawHeadVertex();
			if (!m_regCallBack)
			{
				m_regCallBack = true;
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				//CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);

			}
		}
		public function deactivate():void
		{
			if (m_regCallBack)
			{
				m_regCallBack = false;
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				//CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
			}
		}
		
		
		private function onMouseMoveD():void
		{
				
			var mXOff : Number = (mouseX - EdtDEF.QUADRANT_WIDTH);
			var mYOff : Number = (mouseY - EdtDEF.QUADRANT_HEIGHT);
			
			m_xR = - mXOff / EdtDEF.QUADRANT_WIDTH * 0.3;
			m_yR =  mYOff / EdtDEF.QUADRANT_HEIGHT  * 0.3;
			
			//m_xR = 0;
			//m_yR = 0;
			
			
			m_currentMatrix = ModuleHead3DBrowser.getMatrix(m_xR, m_yR, 0 /*- ModuleHeadData.s_absRZ*/);
			
			drawHeadVertex();
			
		}
		//private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		//{
		//	return 0;
		//}
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			onMouseMoveD();			
			return 0;
		}
	}

}