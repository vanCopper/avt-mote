package editor.module.head 
{
	import editor.config.EdtDEF;
	import editor.struct.Matrix4x4;
	import editor.struct.Vertex3D;
	import editor.ui.EdtRotationAxis;
	import editor.ui.EdtVertexInfo;
	import flash.display.Sprite;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleHead3DBrowser extends Sprite
	{
		public var m_viewer : ModuleHead3DView;
		public var m_controler : EdtRotationAxis;
		
		private var m_roX : Number = 0;
		private var m_roY : Number = 0;
		private var m_roZ : Number = 0;
		
		public function ModuleHead3DBrowser() 
		{
			m_viewer = new ModuleHead3DView();
			m_controler = new EdtRotationAxis();
			m_controler.onUpdate = onUpdate;
			addChild(m_viewer);
			addChild(m_controler);
			
			m_controler.x = m_controler.y = 500;
		}
		
		private function onUpdate(xValue : Number, yValue : Number, zValue : Number , end : Boolean):void
		{
			xValue /= 8;
			yValue /= 8;
			zValue /= 8;
			
			//trace(xValue , yValue, zValue);
			if (end)
			{
				m_roX += xValue;
				m_roY += yValue;
				m_roZ += zValue;
			
				render(m_roX,m_roY,m_roZ);
			}
			else
			{
				render(m_roX + xValue,m_roY+ yValue,m_roZ+ zValue);
			}
		}
		
		private function render(xValue : Number, yValue : Number, zValue: Number):void
		{
						
			var mX : Matrix4x4 = new Matrix4x4();
			//var mXT : Matrix4x4 = new Matrix4x4();
			
			var v : Vertex3D = new Vertex3D();
			var vX : Vertex3D = new Vertex3D();
			var vY : Vertex3D = new Vertex3D();
			var vZ : Vertex3D = new Vertex3D();
			
			v.y = Math.sin(ModuleHeadData.s_rotorR);
			v.x = Math.cos(ModuleHeadData.s_rotorR);
			
			
			vX.x = v.x;
			vX.y = v.y;
			
			Matrix4x4.rotateArbitraryAxis(mX ,  vX  , xValue);
			//Matrix4x4.rotateArbitraryAxis(mXT , vX  , -xValue);
			
			var mY : Matrix4x4 = new Matrix4x4();
			mX.effectPoint3D(v.y , -v.x , 0 , vY);
			Matrix4x4.rotateArbitraryAxis(mY , vY  , yValue);
			
			var mXY : Matrix4x4 = Matrix4x4.contact(mX , mY); 
			
			var mZ : Matrix4x4 = new Matrix4x4();
			mXY.effectPoint3D(0 , 0 , 1 ,vZ);
			Matrix4x4.rotateArbitraryAxis(mZ , vZ  , -zValue);
			
			
			var md : Matrix4x4 = Matrix4x4.contact(mXY , mZ);
			//trace(md);
			
			
			var __v : Vector.<Number> = new Vector.<Number>();
			var _vx : Number;
			var _vy : Number;
			
			//md = mY;
			
			for each( var ev : Vertex3D in ModuleHeadData.s_vertexRelativeData)
			{
				//__v.push(ev.dot.x);
				//__v.push(ev.dot.y);
				
				_vx = (md.Xx * ev.x + md.Xy * ev.y + md.Xz * ev.z) ;
				_vy = (md.Yx * ev.x + md.Yy * ev.y + md.Yz * ev.z) ;
				
				__v.push(_vx + EdtDEF.QUADRANT_WIDTH );
				__v.push(_vy + EdtDEF.QUADRANT_HEIGHT );
				
			}

			{
				ModuleHeadData.drawTriangles(m_viewer.graphics , __v);
			}
		}
		
		public function activate() : void
		{
			m_controler.rotation = ModuleHeadData.s_rotorR * 180 / Math.PI;
			ModuleHeadData.genVertexRelativeData();
			render(m_roX,m_roY,m_roZ);
		
		}
		
		public function dispose() : void 
		{
			if (m_viewer)
			{
				m_viewer = null;
			}
			
			if (m_controler)
			{
				m_controler.dispose();
				m_controler = null;
			}
			
			GraphicsUtil.removeAllChildren(this);
		}
	}

}