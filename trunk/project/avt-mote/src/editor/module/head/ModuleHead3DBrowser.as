package editor.module.head 
{
	import editor.config.EdtDEF;
	import editor.config.StringPool;
	import editor.struct.Matrix4x4;
	import editor.struct.Vertex3D;
	import editor.ui.EdtRotationAxis;
	import editor.ui.EdtVertexInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
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
		
		private var m_tfMode : TextField;
		private var m_tfModeR : TextField;
		private var m_tfModeO : TextField;
		
		
		private var m_tfXIndi : TextField;
		private var m_tfYIndi : TextField;
		private var m_tfZIndi : TextField;
		
		private var m_tfXRO : TextField;
		private var m_tfYRO : TextField;
		private var m_tfZRO : TextField;
		
		private var m_tfXRR : TextField;
		private var m_tfYRR : TextField;
		private var m_tfZRR : TextField;
		
		private var m_textCnt : Sprite = new Sprite();
		private var m_xyzShape : Shape = new Shape();
		private var btn : BSSButton;
		
		public function set disableEdit (v : Boolean) : void
		{
			btn.visible = !v;
		}
		
		public function set approximationMode(v : Boolean) : void
		{
			if (v)
			{
				btn.releaseFunction = onAdjust;
				btn.text = StringPool.MODULE_HEAD_BROWSE_ADJUST;
				m_xyzShape.visible = false;
			}
			else
			{
				btn.releaseFunction = onReset;
				btn.text = StringPool.MODULE_HEAD_BROWSE_RESET;
				m_xyzShape.visible = true;
			}
		}
		
		public function ModuleHead3DBrowser() 
		{
			m_viewer = new ModuleHead3DView();
			m_controler = new EdtRotationAxis();
			m_controler.onUpdate = onUpdate;
			addChild(m_viewer);
			addChild(m_controler);
			addChild(m_textCnt);
			
			m_controler.x = m_controler.y = 600;
			
			
			
			
			m_tfMode = new TextField;
			m_tfModeR = new TextField;
			m_tfModeO = new TextField;
		
			m_tfXIndi = new TextField;
			m_tfYIndi = new TextField;
			m_tfZIndi = new TextField;
		
			m_tfXRO = new TextField;
			m_tfYRO = new TextField;
			m_tfZRO = new TextField;
		
			m_tfXRR = new TextField;
			m_tfYRR = new TextField;
			m_tfZRR = new TextField;
		
			
			m_textCnt.addChild(m_tfMode);
			m_textCnt.addChild(m_tfModeR).x = 120;
			m_textCnt.addChild(m_tfModeO).x = 240;

			
			
			m_textCnt.addChild(m_tfXIndi);
			m_textCnt.addChild(m_tfYIndi);
			m_textCnt.addChild(m_tfZIndi);
			
			m_textCnt.addChild(m_tfXRO).x = 240;
			m_textCnt.addChild(m_tfYRO).x = 240;
			m_textCnt.addChild(m_tfZRO).x = 240;
			
			
			m_textCnt.addChild(m_tfXRR).x = 120;
			m_textCnt.addChild(m_tfYRR).x = 120;
			m_textCnt.addChild(m_tfZRR).x = 120;
			
			
			
			
			m_tfXRR.text =
			m_tfYRR.text =
			m_tfZRR.text = "0";
			
			m_tfXRO.text =
			m_tfYRO.text =
			m_tfZRO.text = "-";
			
			m_tfMode.text = StringPool.MODULE_HEAD_BROWSE_APPRO;
			m_tfModeR.text = StringPool.MODULE_HEAD_BROWSE_RELATIVE;
			m_tfModeO.text = StringPool.MODULE_HEAD_BROWSE_ABSOLUTE;
			
			m_tfXIndi.text = "头转动";
			m_tfYIndi.text = "头仰合";
			m_tfZIndi.text = "头摆动";
			
		
			m_tfXIndi.y = 20;
			m_tfYIndi.y = 40;
			m_tfZIndi.y = 60;

			
			m_tfXIndi.y = 20;
			m_tfYIndi.y = 40;
			m_tfZIndi.y = 60;
			
			
			m_tfXRO.y = 20;
			m_tfYRO.y = 40;
			m_tfZRO.y = 60;
			
			m_tfXRR.y = 20;
			m_tfYRR.y = 40;
			m_tfZRR.y = 60;
			
			m_textCnt.x = 500;
			m_textCnt.y = 100;
			
			btn = BSSButton.createSimpleBSSButton(120 , 20 , StringPool.MODULE_HEAD_BROWSE_ADJUST , false);
			addChild(btn);
			btn.x = 500;
			btn.y = 400;
			btn.releaseFunction = onAdjust;
			
			addChild(m_xyzShape);
			m_xyzShape.x = 700;
			m_xyzShape.y = 410;
			
			
		}
		private function onReset(btn:BSSButton):void
		{
			m_xyzShape.visible = false;
			ModuleHeadData.s_approximationMode = true;
			btn.text = StringPool.MODULE_HEAD_BROWSE_ADJUST;
			m_tfMode.text = StringPool.MODULE_HEAD_BROWSE_APPRO;
			btn.releaseFunction = onAdjust;
			
			m_tfXRR.text =
			m_tfYRR.text =
			m_tfZRR.text = "0";
			
			m_tfXRO.text =
			m_tfYRO.text =
			m_tfZRO.text = "-";
			
			m_roX =
			m_roY =
			m_roZ = 0;
			
			render(m_roX, m_roY, m_roZ);
			
		}
		private function onAdjust(btn:BSSButton):void 
		{
			m_xyzShape.visible = true;
			ModuleHeadData.s_approximationMode = false;
			btn.text = StringPool.MODULE_HEAD_BROWSE_RESET;
			m_tfMode.text = StringPool.MODULE_HEAD_BROWSE_EXACT;
			btn.releaseFunction = onReset;
			
			ModuleHeadData.s_yRotor.x = 0;
			ModuleHeadData.s_yRotor.y = 1;
			ModuleHeadData.s_yRotor.z = 0;
			
			
			ModuleHeadData.s_xRotor.x = 1;
			ModuleHeadData.s_xRotor.y = 0;
			ModuleHeadData.s_xRotor.z = 0;
			
			ModuleHeadData.s_zRotor.x = 0;
			ModuleHeadData.s_zRotor.y = 0;
			ModuleHeadData.s_zRotor.z = -1;
			
			
			m_tfXRR.text =
			m_tfYRR.text =
			m_tfZRR.text = "0";
			
			
			ModuleHeadData.s_absRX = -m_roZ;
			ModuleHeadData.s_absRY = -m_roY;
			ModuleHeadData.s_absRZ = -m_roZ;

			
			m_tfXRO.text = getDataText(ModuleHeadData.s_absRX);
			m_tfYRO.text = getDataText(ModuleHeadData.s_absRY);
			m_tfZRO.text = getDataText(ModuleHeadData.s_absRZ);
			
			
			var vY1 : Vertex3D = ModuleHeadData.s_yRotor.clone();
			var vX1 : Vertex3D = ModuleHeadData.s_xRotor.clone();
			var vZ1 : Vertex3D = ModuleHeadData.s_zRotor.clone();

			
			
			var mZXY : Matrix4x4 = new Matrix4x4();
			var mZX : Matrix4x4 = new Matrix4x4();
			var mZ : Matrix4x4 = new Matrix4x4();
			
			
			
			Matrix4x4.rotateArbitraryAxis(mZ ,  vZ1 , -m_roZ);
			mZ.effectPoint3D(vX1.x , vX1.y , vX1.z , vX1);
			mZ.effectPoint3D(vY1.x , vY1.y , vY1.z , vY1);
			mZ.effectPoint3D(vZ1.x , vZ1.y , vZ1.z , vZ1);
			
			Matrix4x4.rotateArbitraryAxis(mZX ,  vX1 , -m_roY);
			
			mZX.effectPoint3D(vX1.x , vX1.y , vX1.z , vX1);
			mZX.effectPoint3D(vY1.x , vY1.y , vY1.z , vY1);
			mZX.effectPoint3D(vZ1.x , vZ1.y , vZ1.z , vZ1);
			
			
			Matrix4x4.rotateArbitraryAxis(mZXY ,  vY1 , -m_roX);
			
			mZXY.effectPoint3D(vX1.x , vX1.y , vX1.z , vX1);
			mZXY.effectPoint3D(vY1.x , vY1.y , vY1.z , vY1);
			mZXY.effectPoint3D(vZ1.x , vZ1.y , vZ1.z , vZ1);
			
			
			
			
			ModuleHeadData.s_yRotor = vY1;
			ModuleHeadData.s_xRotor = vX1;
			ModuleHeadData.s_zRotor = vZ1;
			
			//trace(ModuleHeadData.s_yRotor.x , ModuleHeadData.s_yRotor.y , ModuleHeadData.s_yRotor.z);
			
			m_roX =
			m_roY =
			m_roZ = 0;
			
			render(m_roX, m_roY, m_roZ);
		}
		
		private function getDataText(v:Number):String
		{
			var _vInt : int = v * 1000;
			return "" + _vInt / 1000;
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
		
		public function reset():void
		{
			onReset(btn);
		}
		
		private function render(xValue : Number, yValue : Number, zValue: Number):void
		{
			
			m_tfXRR.text = getDataText(xValue);
			m_tfYRR.text = getDataText(yValue);
			m_tfZRR.text = getDataText(zValue);
			
			
			var md : Matrix4x4;
			var mX : Matrix4x4 = new Matrix4x4();
			var mY : Matrix4x4 = new Matrix4x4();
			var mZ : Matrix4x4 = new Matrix4x4();
			var mXY : Matrix4x4;
			
			var v : Vertex3D = new Vertex3D();
			var vX : Vertex3D = new Vertex3D();
			var vY : Vertex3D = new Vertex3D();
			var vZ : Vertex3D = new Vertex3D();
				
			if (ModuleHeadData.s_approximationMode)
			{
				v = new Vertex3D();
				v.y = Math.sin(ModuleHeadData.s_rotorR);
				v.x = Math.cos(ModuleHeadData.s_rotorR);
				
				vX.x = v.x;
				vX.y = v.y;
				
				//trace(vX.x , vX.y)
				
				Matrix4x4.rotateArbitraryAxis(mX ,  vX  , xValue);
				//Matrix4x4.rotateArbitraryAxis(mXT , vX  , -xValue);
				
				mX.effectPoint3D(v.y , -v.x , 0 , vY);
				Matrix4x4.rotateArbitraryAxis(mY , vY  , yValue);
				
				mXY = Matrix4x4.contact(mX , mY); 
				
				mXY.effectPoint3D(0 , 0 , 1 ,vZ);
				Matrix4x4.rotateArbitraryAxis(mZ , vZ  , -zValue);
				
				
				md = Matrix4x4.contact(mXY , mZ);
			}
			else {
				vX = ModuleHeadData.s_yRotor;
				
				
				Matrix4x4.rotateArbitraryAxis(mX , vX  , xValue);
				
				
				mX.effectPoint3D(ModuleHeadData.s_xRotor.x , ModuleHeadData.s_xRotor.y , ModuleHeadData.s_xRotor.z , vY);
				Matrix4x4.rotateArbitraryAxis(mY , vY  , yValue);
				mXY = Matrix4x4.contact(mX , mY); 
				
				
				mXY.effectPoint3D(ModuleHeadData.s_zRotor.x , ModuleHeadData.s_zRotor.y , ModuleHeadData.s_zRotor.z , vZ);
				Matrix4x4.rotateArbitraryAxis(mZ , vZ  , zValue);
				md = Matrix4x4.contact(mXY , mZ);
				
				
				m_tfXRO.text = getDataText(xValue + ModuleHeadData.s_absRX);
				m_tfYRO.text = getDataText(yValue + ModuleHeadData.s_absRY);
				m_tfZRO.text = getDataText(zValue + ModuleHeadData.s_absRZ);
			
				var _yRotor : Vertex3D = ModuleHeadData.s_yRotor.clone();
				//_yRotor.x = -_yRotor.x;
				//_yRotor.y = -_yRotor.y;
				//_yRotor.z = -_yRotor.x;
				
				var _xRotor : Vertex3D = ModuleHeadData.s_xRotor.clone();
				var _zRotor : Vertex3D = ModuleHeadData.s_zRotor.clone();
				
				md.effectPoint3D(_yRotor.x,_yRotor.y,_yRotor.z , _yRotor);
				md.effectPoint3D(_xRotor.x,_xRotor.y,_xRotor.z , _xRotor);
				md.effectPoint3D(_zRotor.x,_zRotor.y,_zRotor.z , _zRotor);
				
				m_xyzShape.graphics.clear();
				m_xyzShape.graphics.lineStyle(1, 0x00FF00);
				m_xyzShape.graphics.moveTo(0, 0);
				m_xyzShape.graphics.lineTo(_yRotor.x * 50, _yRotor.y * 50);
				
				m_xyzShape.graphics.lineStyle(1, 0xFF0000);
				m_xyzShape.graphics.moveTo(0, 0);
				m_xyzShape.graphics.lineTo(_xRotor.x * 50, _xRotor.y * 50);
				
				m_xyzShape.graphics.lineStyle(1, 0x0000FF);
				m_xyzShape.graphics.moveTo(0, 0);
				m_xyzShape.graphics.lineTo(_zRotor.x * 50, _zRotor.y * 50);
			}
			
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
			m_controler.activate();
			m_controler.rotation = ModuleHeadData.s_rotorR * 180 / Math.PI;
			ModuleHeadData.genVertexRelativeData();
			render(m_roX,m_roY,m_roZ);
		
		}
		
		public function deactivate() : void
		{
			m_controler.deactivate();
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
			
			m_xyzShape = null;
			
			m_tfMode =
			m_tfModeR =
			m_tfModeO =
					
					
			m_tfXIndi =
			m_tfYIndi =
			m_tfZIndi =
					
			m_tfXRO =
			m_tfYRO =
			m_tfZRO =
					
			m_tfXRR =
			m_tfYRR =
			m_tfZRR = null;
					
			m_textCnt = null;
		}
	}

}