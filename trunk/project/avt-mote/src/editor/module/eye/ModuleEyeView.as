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
	public class ModuleEyeView extends Sprite
	{
		private var m_leftEyeData : ModuleEyeFrame;
		private var m_rightEyeData : ModuleEyeFrame;

		private var m_eyeView : Sprite;
		private var m_headView : ModuleHead3DView;
		private var m_currentMatrix : Matrix4x4 = new Matrix4x4();
		
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
			
			var md : Matrix4x4 = ModuleHead3DBrowser.getMatrix(0, 0, 0);
			m_currentMatrix = md;
		
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
			
			m_leftEyeData = ModuleEyeData.s_frameL;
			m_rightEyeData = ModuleEyeData.s_frameR;
			
			
			drawHeadVertex();
		}

		
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			refresh();
		}
		
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
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