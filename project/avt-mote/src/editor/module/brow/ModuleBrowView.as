package editor.module.brow
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
	public class ModuleBrowView extends Sprite
	{
		
		private var m_dataL:ModuleBrowFrame;
		private var m_dataR:ModuleBrowFrame;

		
		private var m_headView : ModuleHead3DView;
		private var m_currentMatrix : Matrix4x4 = new Matrix4x4();
		private var m_regCallBack : Boolean;
		private var m_browShapeL : ModuleBrowFrameShape;
		private var m_browShapeR : ModuleBrowFrameShape;
		//	 m_needRedraw : Boolean;
		private var m_xR : Number;
		private var m_yR : Number;
		
		private var m_curLeft : Boolean = true;

		
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
				m_curLeft = true;
			}
		}
		
		public function ModuleBrowView(showChotol : Boolean = true) 
		{
			
			var arr : Array = [];
			var _btn : BSSButton;
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
			
			
			
		//	m_browser = new ModuleHead3DBrowser();
		//	m_browser.renderCallBack = onRenderChange;
		//	m_browser.disableEdit = true;
			
		//	addChild(m_browser);
		
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_headView.x = EdtDEF.QUADRANT_WIDTH;
			m_headView.y = EdtDEF.QUADRANT_HEIGHT;
			
			m_currentMatrix.identity();
			
			m_browShapeL = new ModuleBrowFrameShape(null);
			addChild(m_browShapeL);
			
			m_browShapeL.x = m_headView.x;
			m_browShapeL.y = m_headView.y;
			
			m_browShapeR = new ModuleBrowFrameShape(null);
			addChild(m_browShapeR);
			
			m_browShapeR.x = m_headView.x;
			m_browShapeR.y = m_headView.y;
			
		}
		
		public function setCurrentData(_data:ModuleBrowFrame):void
		{
			if (m_curLeft)
			{
				m_browShapeL.data = _data;
				m_dataL = _data;
				m_dataL.confitZ();
				m_dataL.genUVData();
			
				m_browShapeL.refresh(m_currentMatrix , true);
			}
			
			else
			{
				m_browShapeR.data = _data;
				m_dataR = _data;
				m_dataR.confitZ();
				m_dataR.genUVData();
			
				m_browShapeR.refresh(m_currentMatrix , false);
			}
			
			
			
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
			
			m_dataL = null;
			m_dataR = null;
			
			if (m_browShapeL) { m_browShapeL.dsipose(); m_browShapeL = null; }
			if (m_browShapeR) { m_browShapeR.dsipose(); m_browShapeR = null; }
			
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
			
			m_browShapeL.refresh(md, true);
			m_browShapeR.refresh(md, false);
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