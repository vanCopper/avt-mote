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
	import flash.display.Graphics;
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
		private var m_browser : ModuleHead3DBrowser;
		
		private var m_quadrant2 : EdtQuadrant;
		private var m_quadrant1 : EdtQuadrant;
		private var m_quadrant0 : EdtQuadrant;
		private var m_quadrant3 : EdtQuadrant;
		
		private var m_bmp : Bitmap;
		private var m_bmpShape : Shape;
		
		private var m_bmpCnt : DisplayObjectContainer;
		
		private var m_3dView : ModuleHead3DView;
		
		private var m_roterVector : Vector.<EdtVertex3D> ;
		private var m_edtVectorAll : Vector.<EdtVertex3D> ;
		
		private var m_circleAddUI : EdtAddUI;
		private var m_meridianAddUI : EdtAddUI;
		
		
		private var m_headRoot : Vertex3D = new Vertex3D;
		
		public function ModuleHead(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_HEAD);
			
			m_tb = new ModuleHeadToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			
			m_eqm = new ModuleHeadEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_bmp = new Bitmap();
			m_bmpShape = new Shape();
			m_bmpCnt = new Sprite();
			m_bmpCnt.addChild(m_bmp);
			m_bmpCnt.addChild(m_bmpShape);
			
			m_quadrant2.indicate = m_bmpCnt;
			
			m_quadrant2.fullScreen = (true);
			m_quadrant2.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant2;
			
			m_browser = new ModuleHead3DBrowser();
			
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_tb.btnImport.releaseFunction = onOpen;
			m_tb.btnAR.releaseFunction = onAddRoter;
			m_tb.btnAC.releaseFunction = onAddCircle;
			m_tb.btnAM.releaseFunction = onAddMeridian;
			
			m_tb.btnEdit.releaseFunction = function(btn:BSSButton)
			:void {
				if (m_browser.parent)
					m_browser.parent.removeChild(m_browser);
				if (!m_eqm.parent)
					m_content.addChild(m_eqm);
				m_eqm.activate();
				
				};
			m_tb.btnView.releaseFunction = function(btn:BSSButton)
			: void {	
				m_eqm.deactivate();
				if (m_eqm.parent)
					m_eqm.parent.removeChild(m_eqm);
				if (!m_browser.parent)
					m_content.addChild(m_browser);
					
				m_browser.activate();
			};
			
			m_circleAddUI = new EdtAddUI(1 , 12);
			m_circleAddUI.changeFunction = onCircleChanged;
			m_circleAddUI.okFunction = onCircleOK;
			
			m_meridianAddUI = new EdtAddUI(0 , 5);
			m_meridianAddUI.changeFunction = onMeridianChanged;
			m_meridianAddUI.okFunction = onMeridianOK;
			
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
		
		private function onMeridianChanged(s : int):void
		{
			drawRotor();
			
			if (s)
			{
				var g : Graphics = m_bmpShape.graphics;
				
				var sp : Number = s + 0.5;
				var pt0 : Point = new Point();
				var pt1 : Point = new Point();
				
				g.lineStyle(1, 0xFF0000 , 0.6);
				
				
				for (var i : int = 0 ; i < s ; i++ )
				{
					var rate : Number = (1 + i) / sp;
					for (var j : int = 3 ; j < m_edtVectorAll.length; j += 3 )
					{
						
						pt0.x = m_edtVectorAll[j-3].x + (m_edtVectorAll[j-2].x - m_edtVectorAll[j-3].x) * rate;
						pt0.y = m_edtVectorAll[j-3].y + (m_edtVectorAll[j-2].y - m_edtVectorAll[j-3].y) * rate;
						
						pt1.x = m_edtVectorAll[j].x + (m_edtVectorAll[j+1].x - m_edtVectorAll[j].x) * rate;
						pt1.y = m_edtVectorAll[j].y + (m_edtVectorAll[j+1].y - m_edtVectorAll[j].y) * rate;
						
						g.moveTo(pt0.x , pt0.y);
						g.lineTo(pt1.x , pt1.y);
					}
					
					for ( j  = 3 ; j < m_edtVectorAll.length; j += 3 )
					{
						
						pt0.x = m_edtVectorAll[j-1].x + (m_edtVectorAll[j-2].x - m_edtVectorAll[j-1].x) * rate;
						pt0.y = m_edtVectorAll[j-1].y + (m_edtVectorAll[j-2].y - m_edtVectorAll[j-1].y) * rate;
						
						pt1.x = m_edtVectorAll[j+2].x + (m_edtVectorAll[j+1].x - m_edtVectorAll[j+2].x) * rate;
						pt1.y = m_edtVectorAll[j+2].y + (m_edtVectorAll[j+1].y - m_edtVectorAll[j+2].y) * rate;
						
						g.moveTo(pt0.x , pt0.y);
						g.lineTo(pt1.x , pt1.y);
					}
					//trace( rate);
					
				}
				
			}
		}
		private function connect2PT(ev0 : EdtVertex3D , ev1 : EdtVertex3D  ) : void
		{
			ev0.conect.push(ev1);
			ev1.conect.push(ev0);
			
		}
		
		private function onMeridianOK(s : int):void
		{
			var _edtVectorAll : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
			
			
			drawRotor();
			
			const totalPerLine : int = (s == 0) ? 3 : ((s + 1) * 2);
			const totalLine : int = m_edtVectorAll.length / 3;
				
			
			
			
			if (s)
			{
				
				var sp : Number = s + 0.5;
				var pt1 : Point = new Point();
				
				
				var _roterVectorL : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
				var _roterVectorR : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
				var ev : EdtVertex3D;
				
				var p : int = 1;
				
				
				
				for (var j : int = 0 ; j < m_edtVectorAll.length; j += 3 )
				{
					_roterVectorL.length = 0;
					_roterVectorR.length = 0;
						
					_edtVectorAll.push(m_edtVectorAll[j].cloneV());
					for (var i : int = 0 ; i < s ; i++ )
					{
						var rate : Number = (1 + i) / sp;
						pt1.x = m_edtVectorAll[j].x + (m_edtVectorAll[j+1].x - m_edtVectorAll[j].x) * rate;
						pt1.y = m_edtVectorAll[j].y + (m_edtVectorAll[j+1].y - m_edtVectorAll[j].y) * rate;
						ev = new EdtVertex3D();
						ev.x = pt1.x;
						ev.y = pt1.y;
						
						_roterVectorL.push(ev);
						
						pt1.x = m_edtVectorAll[j+2].x + (m_edtVectorAll[j+1].x - m_edtVectorAll[j+2].x) * rate;
						pt1.y = m_edtVectorAll[j+2].y + (m_edtVectorAll[j+1].y - m_edtVectorAll[j+2].y) * rate;
						
						ev = new EdtVertex3D();
						ev.x = pt1.x;
						ev.y = pt1.y;
						
						_roterVectorR.push(ev);
						
						
						
						//trace( rate);
						
					}
					
					var ti : int = _edtVectorAll.length;
					
					for each (ev in _roterVectorL)
						_edtVectorAll.push(ev);
					
					
					_roterVectorR.reverse();	
					for each (ev in _roterVectorR)
						_edtVectorAll.push(ev);
					_edtVectorAll.push(m_edtVectorAll[j + 2].cloneV());	
					
					
					
					for ( ; ti < _edtVectorAll.length ; ti++ )
					{
						_edtVectorAll[ti - 1].priority = ti - 1;
						_edtVectorAll[ti].priority = ti;
						
						connect2PT(_edtVectorAll[ti] , _edtVectorAll[ti - 1] );

					}
				}
				
				for ( ti = 0 ; ti < totalPerLine ; ti++ )
				for (var l : int = 1 ; l < totalLine ;l++ )
				{
					connect2PT(_edtVectorAll[(l - 1) * totalPerLine + ti ] , _edtVectorAll[(l) * totalPerLine + ti ]);
				}
				
				m_edtVectorAll = _edtVectorAll;
				
			}
			
			const _angleView : int = 60;
			
			for (l = 0 ; l < totalLine ;l++ )
			
			//var stageShpae:Shape = new Shape();
			//m_content.stage.addChild(stageShpae);
			
			//stageShpae.x = stageShpae.y = 300;
			//stageShpae.graphics.lineStyle(1);
			
			//l = 0;
			{
				var startPos : int = l * totalPerLine;
				var _lengLine : Number = 0;
				for ( ti = 1 ; ti < totalPerLine ; ti++ )
				{
					var __xOff : Number = m_edtVectorAll[startPos + ti].x - m_edtVectorAll[startPos + ti - 1].x;
					var __yOff : Number = m_edtVectorAll[startPos + ti].y - m_edtVectorAll[startPos + ti - 1].y;
					
					_lengLine += Math.sqrt(__xOff * __xOff + __yOff * __yOff);
					
				}
				//var _rRate : Number = Math.sin(Math.PI * _angleView / 180);
				//var _r : Number = _lengLine / _rRate / 2;
				//var _lengLine1_2 : Number = _lengLine / 2;
				
				
				
				
				//var zhouchang : Number = 2 * Math.PI * _r;
				
				var zhouchang : Number = _lengLine / 60 * 180;
				var _r : Number = zhouchang / 2  / Math.PI ;
				
				var _lengLineCurAdd : Number = 0;
				
				var _zhongzhou : Number = _r * Math.cos(Math.PI * _angleView / 180);
				m_edtVectorAll[startPos + 0].z = _zhongzhou;
				
				for ( ti = 1 ; ti < totalPerLine ; ti++ )
				{
					__xOff = m_edtVectorAll[startPos + ti].x - m_edtVectorAll[startPos + ti - 1].x;
					__yOff = m_edtVectorAll[startPos + ti].y - m_edtVectorAll[startPos + ti - 1].y;
					
					var _lengLineCur : Number = Math.sqrt(__xOff * __xOff + __yOff * __yOff);
					_lengLineCurAdd += _lengLineCur;
					//trace("_lengLineCurAdd" , _lengLineCurAdd);
					var _rotOff : Number = _lengLineCurAdd / zhouchang * 360;
					var _rotOb : Number =  _rotOff + (90 - _angleView);
					//trace("_rotOb" , _rotOb);
					
					_rotOb = Math.abs(90  - _rotOb);
					
					//trace("_lengLineCur" , _lengLineCur);
					//trace("_lengLineCurAdd" , _lengLineCurAdd);
					
					//stageShpae.graphics.moveTo(_lengLine1_2, 0);
					//stageShpae.graphics.lineTo(_lengLineCurAdd, _zhongzhou);
					
					
					//var _lineHeng : Number = (_lengLineCurAdd <= _lengLine1_2) ? (_lengLine1_2 - _lengLineCurAdd) : (_lengLineCurAdd - _lengLine1_2);
					
					//if ((_lengLineCurAdd > _lengLine1_2))
					//	break;
					
					//trace("_lineHeng" , _lineHeng);
					
					//var _angleR : Number = Math.atan2(_lineHeng , _zhongzhou  );
					
					var _angleR : Number = _rotOb * Math.PI / 180;
					
					//trace("_angleR" , _angleR , _angleR / Math.PI * 180 , Math.cos(_angleR) );
					
					m_edtVectorAll[startPos + ti].z = Math.cos(_angleR) * _r;
					
					
					//stageShpae.graphics.moveTo(_lengLine1_2, 0);
					//stageShpae.graphics.lineTo(_lengLineCurAdd, _zhongzhou);
				}
				
			}
			
			
			m_eqm.changeFunction = null;
			if (m_meridianAddUI)
			{
				if (m_meridianAddUI.parent)
					m_meridianAddUI.parent.removeChild(m_meridianAddUI);
			}
			
			
			
			m_tb.deactivateAll([m_tb.btnEdit , m_tb.btnView]);
			
			ModuleHeadData.s_vertexData = m_edtVectorAll;
			ModuleHeadData.s_pointPerLine = totalPerLine;
			ModuleHeadData.s_totalLine = totalLine;
			ModuleHeadData.genindicesData();
			ModuleHeadData.genUVData();
			
			if (!m_quadrant1)
			{	
				m_quadrant1 = new EdtQuadrant(1);
				m_3dView = new ModuleHead3DView();
				m_quadrant1.indicate = m_3dView;
				
				
			}
			if (!m_quadrant0)
				m_quadrant0 = new EdtQuadrant(0);	
			if (!m_quadrant3)
				m_quadrant3 = new EdtQuadrant(3);	
				
			
			m_eqm.setQuadrant(m_quadrant0 , m_quadrant1 , m_quadrant2 , m_quadrant3);
			
			m_quadrant2.fullScreen = false;
			
			m_eqm.setVertex(m_edtVectorAll);
			
			m_tb.btnEdit.releaseFunction(m_tb.btnEdit);
			
			m_content.stage.focus = m_content.stage;
			
		}
		
		private function onCircleOK(m_2 : int):void
		{
			var v : Point = getRoter90Pt();
			var m : int = m_2 * 2;
			
			
			
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
			
			var _edtVectorAll : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
			
			
			
			for (var i : int = 0 ; i <=  m; i++ )
			{
				var rate : Number;
				
				var centerX : Number;
				var centerY : Number;
				var offX : Number;
				var offY : Number;
				var scale : Number;
				if (i < m_2)
				{
					rate = ( m_2 - i) / m_2;
					offX = m_roterVector[2].x - m_roterVector[1].x;
					offY = m_roterVector[2].y - m_roterVector[1].y;
					
					centerX = m_roterVector[1].x + offX * rate;
					centerY =  m_roterVector[1].y + offY * rate;
					
					scale = 1 - rate * 0.5;
					
					//trace(rate  , m_roterVector[1].x , offX , offY , centerX , centerY);
					
				} else {
					rate = (  i - m_2  ) / m_2;
					rate = 1 - rate;
					
					offX = m_roterVector[1].x - m_roterVector[0].x;
					offY = m_roterVector[1].y - m_roterVector[0].y;
					
					centerX = m_roterVector[0].x + offX * rate;
					centerY = m_roterVector[0].y + offY * rate;
					
					scale = rate * 0.3 + 0.7;

				}
				
				
					
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
				
				if (_edtVectorAll.length)
				{
					var _roterVectorAll_length : int = _edtVectorAll.length;
					_roterVector[0].conect.push(_edtVectorAll[_roterVectorAll_length - 3]);
					_edtVectorAll[_roterVectorAll_length - 3].conect.push(_roterVector[0]);
					_roterVector[1].conect.push(_edtVectorAll[_roterVectorAll_length - 2]);
					_edtVectorAll[_roterVectorAll_length - 2].conect.push(_roterVector[1]);
					_roterVector[2].conect.push(_edtVectorAll[_roterVectorAll_length - 1]);
					_edtVectorAll[_roterVectorAll_length - 1].conect.push(_roterVector[2]);
				}
				
				_edtVectorAll.push(_roterVector[0]);
				_edtVectorAll.push(_roterVector[1]);
				_edtVectorAll.push(_roterVector[2]);
				
			}
			drawRotor();
			m_quadrant2.setVertex(_edtVectorAll);
			m_edtVectorAll = _edtVectorAll;
			
			m_circleAddUI.visible = false;
			
			m_tb.deactivateAll([m_tb.btnAM]);
			
			
		}
		
		
		
		private function onCircleChanged(m_2 : int):void
		{
			
			
			var v : Point = getRoter90Pt();
			var m : int = m_2 * 2;
			
			drawRotor();
			m_bmpShape.graphics.lineStyle(1, 0xFF0000, 1);
			
			
			for (var i : int = 0 ; i <=  m; i++ )
			{
				var rate : Number;
				
				var centerX : Number;
				var centerY : Number;
				var offX : Number;
				var offY : Number;
				var scale : Number;
				if (i < m_2)
				{
					rate = ( m_2 - i) / m_2;
					offX = m_roterVector[2].x - m_roterVector[1].x;
					offY = m_roterVector[2].y - m_roterVector[1].y;
					
					centerX = m_roterVector[1].x + offX * rate;
					centerY =  m_roterVector[1].y + offY * rate;
					
					scale = 1 - rate * 0.5;
					
					//trace(rate  , m_roterVector[1].x , offX , offY , centerX , centerY);
					
				} else {
					rate = (  i - m_2  ) / m_2;
					rate = 1 - rate;

					offX = m_roterVector[1].x - m_roterVector[0].x;
					offY = m_roterVector[1].y - m_roterVector[0].y;
					
					centerX = m_roterVector[0].x + offX * rate;
					centerY = m_roterVector[0].y + offY * rate;
					
					scale = rate * 0.3 + 0.7;

				}
				
				
				
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
		
		private function onAddMeridian(btn : BSSButton) : void {
			if (!m_meridianAddUI.parent)
			{
				m_meridianAddUI.x = btn.x;
				m_meridianAddUI.y = btn.y + 50;
				m_content.addChild(m_meridianAddUI);
			
				m_eqm.changeFunction = function () : void {
					onMeridianChanged(m_meridianAddUI.value);
				}
			}
			
		}
		private function onAddCircle(btn : BSSButton) : void {
			
			
			if (!m_circleAddUI.parent)
			{
				m_circleAddUI.x = btn.x;
				m_circleAddUI.y = btn.y + 50;
				m_content.addChild(m_circleAddUI);
			
				
				
				ModuleHeadData.s_rotorR = 	Math.atan2(
					(m_roterVector[2].y - m_roterVector[0].y)
					,(m_roterVector[2].x - m_roterVector[0].x)
				);
				ModuleHeadData.s_rotorX = m_headRoot.x ;
				ModuleHeadData.s_rotorY = m_headRoot.y;
			
				
				m_quadrant2.setVertex(null);
				
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
			
			m_quadrant2.setVertex(m_roterVector);
			
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
			
			ModuleHeadData.s_texture = bitmapData;
			
			m_tb.deactivateAll([m_tb.btnAR]);
		}
		
		
		public override function activate() : void
		{
			if (m_eqm.parent)
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
			if (m_browser)
			{
				if (!m_browser.parent)
					m_content.addChild(m_browser); //TODO may not in stage
				m_browser.dispose(); 
				m_browser = null;
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
			m_3dView = null;
			
			m_bmpCnt = null;
			m_roterVector = null;
			m_edtVectorAll = null;
			
			if (m_quadrant2) { m_quadrant2.dispose(); m_quadrant2 = null; }
			if (m_quadrant1) { m_quadrant1.dispose(); m_quadrant1 = null; }
			if (m_quadrant0) { m_quadrant0.dispose(); m_quadrant0 = null; }
			if (m_quadrant3) { m_quadrant3.dispose(); m_quadrant3 = null; }

			super.dispose();
		}
	}

}