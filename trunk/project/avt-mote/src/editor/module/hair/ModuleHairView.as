package editor.module.hair 
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
	public class ModuleHairView extends Sprite
	{
		
		private var m_data:ModuleHairFrame;
		private var m_hairVector : Vector.<ModuleHairProperty>;

		private var m_headView : ModuleHead3DView;
		private var m_currentMatrix : Matrix4x4 = new Matrix4x4();
		private var m_regCallBack : Boolean;
		private var m_xR:Number = 0;
		private var m_yR:Number = 0;

		private var m_wind : EdtSliderNumber;
		
		//	private var m_needRedraw : Boolean;

		//private var m_browser : ModuleHead3DBrowser;
		private var sinWind : Number = 0;
		
		public function ModuleHairView(showChotol : Boolean = true) 
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
			
			m_wind = new EdtSliderNumber( -0.05 , 0.05 , "sin wind max");
			addChild(m_wind);
			m_wind.x = 5;
			m_wind.y = 70;
			m_wind.value = 0;
			
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
			
			if (m_hairVector)
			{
				for each(var mhp : ModuleHairProperty in m_hairVector )
					mhp.onRenderChange(_browser , __v , md);
			} 
			
		}
		
		private function onUpdate(e:Event):void 
		{
			sinWind += 0.05;
			
			ModuleHairData.s_wind =  m_wind.value * Math.abs(Math.sin(sinWind));
		}
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			//m_headView.activate();
			
			if (m_hairVector)
			{
				for each(var mhp : ModuleHairProperty in m_hairVector )
					mhp.dispose();
				m_hairVector = null;
			}
			
			m_hairVector = new Vector.<ModuleHairProperty>();
			removeChild(m_headView);
			
			
			var arr : Array = [];
			arr.push(m_headView);
			
			
			for each (var mhf : ModuleHairFrame in ModuleHairData.s_frameList )
			{
				if (mhf.vertexData && mhf.vertexPerLine)
				{
					mhp = new ModuleHairProperty(false);
					mhp.setCurrentData(mhf);
					mhp.activate();
					arr.push(mhp);
					m_hairVector.push(mhp);
				}
			}
			
			arr.sort(sortZ);
			
			for each (var dsp : DisplayObject in arr)
				addChild(dsp);
				
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
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
			
			//m_browser.deactivate();
			if (m_hairVector)
			{
				for each(var mhp : ModuleHairProperty in m_hairVector )
					mhp.dispose();
				m_hairVector = null;
			}
			
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
			
			m_xR = - mXOff / EdtDEF.QUADRANT_WIDTH * 0.4;
			m_yR =  mYOff / EdtDEF.QUADRANT_HEIGHT  * 0.4;
			
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
		
		private function sortZ(a:*, b:*):Number
		{
			var az : Number = ((a == m_headView) ? 0 : a.vz);
			var bz : Number = ((b == m_headView) ? 0 : b.vz);
			
			if (az > bz)
				return 1;
			else if (az < bz)
				return -1;
			else
				return 0;
				
		}
		
		
		
		
		
	}

}