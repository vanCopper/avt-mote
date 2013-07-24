package editor.module.eye 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.module.head.ModuleHead3DView;
	import editor.module.head.ModuleHeadData;
	import editor.struct.Matrix4x4;
	import editor.struct.Plane3D;
	import editor.struct.Texture2D;
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
	public class ModuleEyeView extends Sprite
	{
		private var m_leftEyeData : ModuleEyeFrame;
		private var m_rightEyeData : ModuleEyeFrame;
		private var m_leftEyeDataBase : ModuleEyeFrame;
		private var m_rightEyeDataBase : ModuleEyeFrame;

		private var m_eyeView : Sprite;
		private var m_headView : ModuleHead3DView;
		private var m_currentMatrix : Matrix4x4 = new Matrix4x4();
		private var m_regCallBack : Boolean;
		private var m_xR:Number = 0;
		private var m_yR:Number = 0;
		private var m_needRedraw : Boolean;
		
		
		private const m_maxLag : int = 120;
		private const m_minLag : int = 60;
		private var m_curFrame : int;
		private var m_curLag : int;
		
		
		public function ModuleEyeView() 
		{
			
			graphics.lineStyle(1);
			graphics.moveTo(0 , EdtDEF.QUADRANT_HEIGHT);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH*2 , EdtDEF.QUADRANT_HEIGHT);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH  , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH  , EdtDEF.QUADRANT_HEIGHT * 2);
			
			graphics.moveTo(EdtDEF.QUADRANT_WIDTH  , 0);
			graphics.lineTo(EdtDEF.QUADRANT_WIDTH  , EdtDEF.QUADRANT_HEIGHT * 2);
			
			m_headView = new ModuleHead3DView();
			addChild(m_headView);
			
			m_eyeView = new Sprite();
			addChild(m_eyeView);
			
			m_headView.x = m_eyeView.x = EdtDEF.QUADRANT_WIDTH;
			m_headView.y = m_eyeView.y = EdtDEF.QUADRANT_HEIGHT;
						
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
			
			onRenderChange(__v , md );
			
		}
		
		private function onRenderChange(__v : Vector.<Number> , md : Matrix4x4):void
		{
			ModuleHeadData.drawTriangles(m_headView.graphics , __v);
			if (m_leftEyeData )
			{
				if (!m_leftEyeData.eyeVertex3D || !m_leftEyeData.eyeVertex3D.length)
				{
					m_leftEyeData.genEyeVertex3D(true);
					m_rightEyeData.genEyeVertex3D(false);
				}
				ModuleEyeFunc.drawEye(m_eyeView , md  , m_leftEyeData , m_rightEyeData);
			}
		}
		
		public function reset():void
		{
			
			m_leftEyeData = null;
			m_rightEyeData = null;
			
			m_headView.graphics.clear();
			GraphicsUtil.removeAllChildren(m_eyeView);
			
		}
		public function refresh():void
		{
			
			m_leftEyeDataBase = ModuleEyeData.s_frameL;
			m_rightEyeDataBase = ModuleEyeData.s_frameR;
			m_curFrame = 0;
			
			drawHeadVertex();
		}
		private function onMouseMoveD():void
		{
			if (!m_leftEyeDataBase || !m_rightEyeDataBase)
				return;
				
			var mXOff : Number = (mouseX - EdtDEF.QUADRANT_WIDTH);
			var mYOff : Number = (mouseY - EdtDEF.QUADRANT_HEIGHT);
			
			m_xR = - mXOff / EdtDEF.QUADRANT_WIDTH * 0.2;
			m_yR =  mYOff / EdtDEF.QUADRANT_HEIGHT  * 0.2;
			
			m_currentMatrix = ModuleHead3DBrowser.getMatrix(m_xR, m_yR, - ModuleHeadData.s_absRZ);
			
			m_leftEyeData = m_leftEyeDataBase.cloneData();
			m_rightEyeData = m_rightEyeDataBase.cloneData();

			m_leftEyeData.genEyeVertex3D(true);
			m_rightEyeData.genEyeVertex3D(false);
			
			
			var md : Matrix4x4 = m_currentMatrix; 
			
			var lCenter : Vertex3D = new Vertex3D();
			lCenter.x = ModuleEyeData.s_eCenterLX;
			lCenter.y = ModuleEyeData.s_eCenterLY;
			ModuleEyeFrame.dealVertex3D(lCenter , ModuleEyeData.s_eyeLScale , ModuleEyeData.s_eyeLPlane , ModuleEyeData.s_eyeMatrix , ModuleEyeData.s_eyeLLocateX , ModuleEyeData.s_eyeLLocateY);
			
			var _vx : Number;
			var _vy : Number;
			
			{
				_vx = (md.Xx * lCenter.x + md.Xy * lCenter.y + md.Xz * lCenter.z) ;
				_vy = (md.Yx * lCenter.x + md.Yy * lCenter.y + md.Yz * lCenter.z) ;
			}
			
			//trace(_vx , _vy , mXOff , mYOff);
			
			var _lRadian : Number = Math.atan2(mYOff - _vy , mXOff - _vx );
			var _lRate : Number = Math.sqrt((mYOff - _vy)*(mYOff - _vy) + (mXOff - _vx )*(mXOff - _vx ));
			_lRate /= EdtDEF.QUADRANT_WIDTH * 1.5;
			if (_lRate > 1) _lRate = 1;
			
			var rCenter : Vertex3D = new Vertex3D();
			rCenter.x = ModuleEyeData.s_eCenterRX;
			rCenter.y = ModuleEyeData.s_eCenterRY;
			ModuleEyeFrame.dealVertex3D(rCenter , ModuleEyeData.s_eyeRScale , ModuleEyeData.s_eyeRPlane , ModuleEyeData.s_eyeMatrix , ModuleEyeData.s_eyeRLocateX , ModuleEyeData.s_eyeRLocateY);

			{
				_vx = (md.Xx * rCenter.x + md.Xy * rCenter.y + md.Xz * rCenter.z) ;
				_vy = (md.Yx * rCenter.x + md.Yy * rCenter.y + md.Yz * rCenter.z) ;
			}
			
			var _rRadian : Number = Math.atan2(mYOff - _vy , mXOff - _vx );
			var _rRate : Number = Math.sqrt((mYOff - _vy)*(mYOff - _vy) + (mXOff - _vx )*(mXOff - _vx ));
			_rRate /= EdtDEF.QUADRANT_WIDTH * 1.5;
			if (_rRate > 1) _rRate = 1;
			
			var _er : Number;
			var _ea : Number;
			var _eb : Number;
			
			
			_er = ModuleEyeData.s_erL ;
			_ea = ModuleEyeData.s_eaL ;
			_eb = ModuleEyeData.s_ebL ;
				
			
			
			if (!isNaN(_ea))
			{
				
				var pt : Point = ModuleEyeFunc.getXYOfArea(_lRadian,true,_lRate);
			
				if (m_leftEyeData.eyeBall)
				{
					m_leftEyeData.eyeBallX = pt.x + ModuleEyeData.s_eCenterLX - Math.abs(m_leftEyeData.eyeBall.rectW) / 2; 
					m_leftEyeData.eyeBallY = pt.y + ModuleEyeData.s_eCenterLY - m_leftEyeData.eyeBall.rectH / 2; 
				}
				
				m_leftEyeData.genEyeVertex3D(true);
				
			}
			
			_er = ModuleEyeData.s_erR ;
			_ea = ModuleEyeData.s_eaR ;
			_eb = ModuleEyeData.s_ebR ;
			
			
			if (!isNaN(_ea))
			{
				pt = ModuleEyeFunc.getXYOfArea(_rRadian, true, _rRate);
				if (m_rightEyeData.eyeBall)
				{
					m_rightEyeData.eyeBallX = pt.x + ModuleEyeData.s_eCenterRX - Math.abs(m_rightEyeData.eyeBall.rectW) / 2; 
					m_rightEyeData.eyeBallY = pt.y + ModuleEyeData.s_eCenterRY - m_rightEyeData.eyeBall.rectH / 2; 
				}
				
				m_rightEyeData.genEyeVertex3D(false);
				
			}
			
			m_needRedraw = true;
			
		}
		private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			m_curLag = 0;
			return 0;
		}
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			onMouseMoveD();			
			return 0;
		}
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			
			if (!m_regCallBack)
			{
				m_regCallBack = true;
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
			}
			
			refresh();
		}
		
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
			if (m_regCallBack)
			{
				m_regCallBack = false;
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);

			}
		}
		
		private function onUpdate(e:Event):void 
		{
			
			if (ModuleEyeData.s_leftAnime.length != 0)
			{
				if (m_curLag > 0)
				{
					m_curLag--;
				}
				else {
					if (m_curFrame == ModuleEyeData.s_leftAnime.length / 2)
					m_curFrame++;//闭眼有2帧
						
					if (m_curFrame >= ModuleEyeData.s_leftAnime.length)
					{
						m_curLag = (Math.random() * (m_maxLag - m_minLag)) + m_minLag;
						m_curFrame = 0;
					}
					else 
					{
						
						
						m_leftEyeDataBase = (ModuleEyeData.s_leftAnime[m_curFrame]);
						m_rightEyeDataBase = (ModuleEyeData.s_rightAnime[m_curFrame]);
						
						m_curFrame++;
						
						onMouseMoveD();
					}
				}
				
				
			}
			
			
			
			if (m_needRedraw)
			{
				m_needRedraw = false;
				drawHeadVertex();
			}
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
			if (ModuleEyeData.s_eyeLocated)
			{
				str += "<eyeMatrix>";
				str += ModuleEyeData.s_eyeMatrix.toXMLString();
				str += "</eyeMatrix>";
				
				str += "<left>";
					str += "<Plane>";
					str += ModuleEyeData.s_eyeLPlane.toXMLString();
					str += "</Plane>";
					
					str += "<Scale>";
					str += ModuleEyeData.s_eyeLScale;
					str += "</Scale>";
					
					str += "<Locate>";
					str += ModuleEyeData.s_eyeLLocateX + ":" + ModuleEyeData.s_eyeLLocateY ;
					str += "</Locate>";
				str += "</left>";
				
				str += "<right>";
					str += "<Plane>";
					str += ModuleEyeData.s_eyeRPlane.toXMLString();
					str += "</Plane>";
					
					str += "<Scale>";
					str += ModuleEyeData.s_eyeRScale;
					str += "</Scale>";
					
					str += "<Locate>";
					str += ModuleEyeData.s_eyeRLocateX + ":" + ModuleEyeData.s_eyeRLocateY ;
					str += "</Locate>";
				str += "</right>";
			}
	
			str += "</ModuleEyeLocate>";
			
			return str;
			
		}
		
		
		
		public function fromXMLString(s:XML):void
		{
			
			var mStr : String = s.eyeMatrix.text();
			if (mStr)
			{
				ModuleEyeData.s_eyeLocated = true;
				ModuleEyeData.s_eyeMatrix = new Matrix4x4();
				ModuleEyeData.s_eyeMatrix.fromXMLString(mStr);
				
				
				ModuleEyeData.s_eyeLPlane.fromXMLString(s.left.Plane.text());
				ModuleEyeData.s_eyeLScale = Number(s.left.Scale.text());
				
				var arr : Array;
				arr = s.left.Locate.text().split(":");
				ModuleEyeData.s_eyeLLocateX = Number(arr[0]);
				ModuleEyeData.s_eyeLLocateY = Number(arr[1]);
				
				
				ModuleEyeData.s_eyeRPlane.fromXMLString(s.right.Plane.text());
				ModuleEyeData.s_eyeRScale = Number(s.right.Scale.text());
				
				arr = s.right.Locate.text().split(":");
				ModuleEyeData.s_eyeRLocateX = Number(arr[0]);
				ModuleEyeData.s_eyeRLocateY = Number(arr[1]);
				
				
				
			}
			
			
		}
		
		
		
	}

}