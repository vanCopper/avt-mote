package editor.module.head 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.config.StringPool;
	import editor.module.ModuleBase;
	import editor.struct.Vertex3D;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtVertex3D;
	import editor.util.ImagePicker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleHead extends ModuleBase
	{	
		
		private var m_tb : ModuleHeadToolbar;
		
		private var m_eqm : ModuleHeadEQMgr;
		
		private var m_quadrant0 : EdtQuadrant;
		private var m_bmp : Bitmap;
		private var m_bmpShape : Shape;
		
		private var m_bmpCnt : DisplayObjectContainer;
		private var m_roterVector : Vector.<EdtVertex3D> ;
		
		private var m_circleAddUI : EdtAddUI;
		private var m_headRoot : Vertex3D = new Vertex3D;
		
		public function ModuleHead(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_HEAD);
			
			m_tb = new ModuleHeadToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant0 = new EdtQuadrant(0);
			
			m_eqm = new ModuleHeadEQMgr();
			m_eqm.addChildAt(m_quadrant0 , 0);
			
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_bmp = new Bitmap();
			m_bmpShape = new Shape();
			m_bmpCnt = new Sprite();
			m_bmpCnt.addChild(m_bmp);
			m_bmpCnt.addChild(m_bmpShape);
			
			m_quadrant0.addChildAt(m_bmpCnt , 5);
			m_quadrant0.indicate = m_bmpCnt;
			
			m_quadrant0.fullSreen = (true);
			m_quadrant0.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant0;
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_tb.btnImport.releaseFunction = onOpen;
			m_tb.btnAR.releaseFunction = onAddRoter;
			m_tb.btnAC.releaseFunction = onAddCircle;
			
			m_circleAddUI = new EdtAddUI(3 , 12);
			m_circleAddUI.changeFunction = onCircleChanged;
			m_circleAddUI.okFunction = onCircleOK;
		}
		
		
		
		private function getRoter90Pt():Point
		{
			var v : Point = new Point();
			v.x = m_roterVector[2].y - m_roterVector[0].y;
			v.y = m_roterVector[2].x - m_roterVector[0].x;
			v.y = -v.y;
			
			var _leng : int = v.x * v.x + v.y * v.y;
			_leng = Math.sqrt(_leng);
			v.x /= _leng;
			v.y /= _leng;
			
			var maxR : int = m_bmp.bitmapData.width * 0.4;
			v.x *= maxR;
			v.y *= maxR;
			return v;
		}
		
		
		private function onCircleOK(m : int):void
		{
			var v : Point = getRoter90Pt();
			
			m--;
			
			var offX : Number = m_roterVector[2].x - m_roterVector[0].x;
			var offY : Number = m_roterVector[2].y - m_roterVector[0].y;
			
			
			var _roterVector : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>(3, true);
				
			_roterVector[0] = new EdtVertex3D();
			_roterVector[0].priority = 0;
			_roterVector[1] = new EdtVertex3D();
			_roterVector[1].priority = 2;
			_roterVector[2] = new EdtVertex3D();
			_roterVector[2].priority = 3;
			
			_roterVector[0].conect.push(_roterVector[1] );
			_roterVector[1].conect.push(_roterVector[0] );
			_roterVector[1].conect.push(_roterVector[2] );
			_roterVector[2].conect.push(_roterVector[1] );
			
			var _roterVectorAll : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
			
			for (var i : int = 0 ; i <=  m; i++ )
			{
				var rate : Number = i / m;
				var centerX : Number = m_roterVector[0].x + offX * rate;
				var centerY : Number =  m_roterVector[0].y + offY * rate;
				
				var scale : Number = ( ((m / 2) - Math.abs(i - m / 2)) / (m / 2)) * 0.3 + 0.7;
					
				_roterVector[0] = new EdtVertex3D();
				_roterVector[0].priority = 0 + i * 3;
				_roterVector[1] = new EdtVertex3D();
				_roterVector[1].priority = 2 + i * 3;
				_roterVector[2] = new EdtVertex3D();
				_roterVector[2].priority = 3 + i * 3;
				
				
				_roterVector[1].x = centerX;
				_roterVector[1].y = centerY;
				_roterVector[0].x = centerX + v.x * scale;
				_roterVector[0].y = centerY + v.y * scale;
				_roterVector[2].x = centerX - v.x * scale;
				_roterVector[2].y = centerY - v.y * scale;
				
				_roterVector[0].conect.push(_roterVector[1] );
				_roterVector[1].conect.push(_roterVector[0] );
				_roterVector[1].conect.push(_roterVector[2] );
				_roterVector[2].conect.push(_roterVector[1] );
				
				if (_roterVectorAll.length)
				{
					var _roterVectorAll_length : int = _roterVectorAll.length;
					_roterVector[0].conect.push(_roterVectorAll[_roterVectorAll_length - 3]);
					_roterVectorAll[_roterVectorAll_length - 3].conect.push(_roterVector[0]);
					_roterVector[1].conect.push(_roterVectorAll[_roterVectorAll_length - 2]);
					_roterVectorAll[_roterVectorAll_length - 2].conect.push(_roterVector[1]);
					_roterVector[2].conect.push(_roterVectorAll[_roterVectorAll_length - 1]);
					_roterVectorAll[_roterVectorAll_length - 1].conect.push(_roterVector[2]);
				}
				
				_roterVectorAll.push(_roterVector[0]);
				_roterVectorAll.push(_roterVector[1]);
				_roterVectorAll.push(_roterVector[2]);
				
			}
			drawRotor();
			m_quadrant0.setVertex(_roterVectorAll);
			m_circleAddUI.visible = false;
			
		}
		
		
		
		private function onCircleChanged(m : int):void
		{
			
			
			
			var v : Point = getRoter90Pt();
			
			m--;
			var offX : Number = m_roterVector[2].x - m_roterVector[0].x;
			var offY : Number = m_roterVector[2].y - m_roterVector[0].y;
			
			drawRotor();
			m_bmpShape.graphics.lineStyle(1, 0xFF0000, 1);
			
			for (var i : int = 0 ; i <=  m; i++ )
			{
				var rate : Number = i / m;
				var centerX : Number = m_roterVector[0].x + offX * rate;
				var centerY : Number =  m_roterVector[0].y + offY * rate;
				
				var scale : Number = ( ((m / 2) - Math.abs(i - m / 2)) / (m / 2)) * 0.3 + 0.7;
				
				m_bmpShape.graphics.moveTo(centerX + v.x * scale , centerY + v.y * scale );
				m_bmpShape.graphics.lineTo(centerX - v.x * scale , centerY - v.y * scale );
				
			}
			
		}
		private function drawRotor():void
		{
			m_bmpShape.graphics.clear();
			m_bmpShape.graphics.lineStyle(0.75 , 0xFFFF00 , 0.75);
			m_bmpShape.graphics.moveTo(m_roterVector[0].x , m_roterVector[0].y);
			m_bmpShape.graphics.lineTo(m_roterVector[2].x , m_roterVector[2].y);
			
			m_bmpShape.graphics.lineStyle(1 , 0x0000FF , 0.25);
			m_bmpShape.graphics.beginFill(0x4444FF , 0.75);
			m_bmpShape.graphics.drawCircle(m_headRoot.x , m_headRoot.y , 5);
		}
		
		
		
		
		private function onAddCircle(btn : BSSButton) : void {
			
			
			var radian : Number = Math.atan2(m_roterVector[2].x  - m_roterVector[0].x  , m_roterVector[2].y  - m_roterVector[0].y );
			
			if (!m_circleAddUI.parent)
			{
				m_circleAddUI.x = btn.x;
				m_circleAddUI.y = btn.y + 50;
				m_content.addChild(m_circleAddUI);
			
				m_quadrant0.setVertex(null);
				
				onCircleChanged(m_circleAddUI.value);
			}
		
			
		}
		
		
		private function onAddRoter(btn : BSSButton) : void {
			
			if (!m_roterVector)
			{
				m_roterVector = new Vector.<EdtVertex3D>(3, true);
				
				m_roterVector[0] = new EdtVertex3D();
				m_roterVector[0].priority = 0;
				m_roterVector[1] = new EdtVertex3D();
				m_roterVector[1].priority = 2;
				m_roterVector[2] = new EdtVertex3D();
				m_roterVector[2].priority = 3;
				
				m_roterVector[0].conect.push(m_roterVector[1] );
				m_roterVector[1].conect.push(m_roterVector[0] );
				m_roterVector[1].conect.push(m_roterVector[2] );
				m_roterVector[2].conect.push(m_roterVector[1] );
				
				m_roterVector[1].line0 = m_roterVector[0];
				m_roterVector[1].line1 = m_roterVector[2];
				
				m_headRoot = m_roterVector[1];
				
			}
			
			m_roterVector[0].y =  - ((m_bmp.bitmapData.height)  >> 1);
			m_roterVector[1].y =  + ((m_bmp.bitmapData.height)  * 0.2);
			m_roterVector[2].y =  + ((m_bmp.bitmapData.height)  >> 1);
			
			m_quadrant0.setVertex(m_roterVector);
			
			m_tb.deactivateAll([m_tb.btnAC]);
			
		}
		
		private function onOpen(btn : BSSButton) : void {
			new ImagePicker( onLoadImage , [new FileFilter("image (*.png)" , "*.png")]);
			
		}
		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			
			if (m_bmp.bitmapData)
			{
				m_bmp.bitmapData.dispose();
				m_bmp.bitmapData = null;
			}
			m_bmp.bitmapData = bitmapData;
			m_bmp.x =  -  (( bitmapData.width ) >> 1);
			m_bmp.y =  - ((bitmapData.height)  >> 1);
			
			m_tb.deactivateAll([m_tb.btnAR]);
		}
		
		
		public override function activate() : void
		{
			m_eqm.activate();
			
			super.activate();
		}
		
		public override function deactivate() : void
		{
			
			m_eqm.deactivate();
			
			super.deactivate();
		}
		
		
		public override function dispose() : void
		{
			if (m_eqm)
			{
				m_eqm.dispose();
				m_eqm = null;
			}
			if (m_tb)
			{
				m_tb.dispose();
				m_tb = null;
			}
			
			if (m_circleAddUI)
			{
				m_circleAddUI.dispose();
				m_circleAddUI = null;
			}
			
			if (m_bmp )
			{
				if (m_bmp.bitmapData)
					m_bmp.bitmapData.dispose();
				m_bmp = null;
			}
			m_bmpShape = null;
			
			
			m_bmpCnt = null;
			m_roterVector = null;
			
			super.dispose();
		}
	}

}