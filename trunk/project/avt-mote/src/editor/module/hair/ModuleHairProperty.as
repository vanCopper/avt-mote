package editor.module.hair 
{
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.module.head.ModuleHeadData;
	import editor.struct.Matrix4x4;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtSlider;
	import editor.ui.EdtSliderNumber;
	import editor.ui.EdtVertex3D;
	import editor.ui.TextCheckBox;
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
	public class ModuleHairProperty extends Sprite
	{
		
		private var m_data:ModuleHairFrame;
		private var m_hairShape:Shape;
		private var m_lineShape:Shape;
		private var m_massVector : Vector.<Vector.<ModuleHairMassPoint>>;
		
		
		private var m_damp : EdtSliderNumber;
		private var m_weightReciprocal : EdtSliderNumber;
			
		private var m_ductility : EdtSliderNumber;
		private var m_hardness : EdtSliderNumber;
		private var m_decline : EdtSliderNumber;
		
		private var m_wind : EdtSliderNumber;
		private var m_browser : ModuleHead3DBrowser;
		
		public function ModuleHairProperty(showChotol : Boolean = true) 
		{
			
			setCurrentData(null);
			
			m_hairShape = new Shape();
			m_hairShape.x = EdtDEF.QUADRANT_WIDTH;
			m_hairShape.y = EdtDEF.QUADRANT_HEIGHT;
			
			if (showChotol)
			{	
				m_lineShape = new Shape();
				m_lineShape.x = EdtDEF.QUADRANT_WIDTH;
				m_lineShape.y = EdtDEF.QUADRANT_HEIGHT;
			}
			
			
			
			
			if (showChotol)
			{	
				m_browser = new ModuleHead3DBrowser();
				m_browser.renderCallBack = onRenderChange;
				m_browser.disableEdit = true;
			}
			
			
			
			if(m_browser) addChild(m_browser);
			addChild(m_hairShape);
			if(m_lineShape) addChild(m_lineShape);
			
			if (showChotol)
			{
				m_weightReciprocal = new EdtSliderNumber(1 , 100 , "weight reciprocal");
				m_ductility = new EdtSliderNumber(0 , 1 , "ductility");
				m_hardness = new EdtSliderNumber(0 , 4 , "hardness");
				//m_decline = new EdtSliderNumber(0.5 , 2.5 , "weight decline");
				
				m_damp = new EdtSliderNumber(0 , 0.5 , "damp");
				m_wind = new EdtSliderNumber( -0.15 , 0.15 , "wind");
				
				

			
				addChild(m_weightReciprocal).y = 120;
				addChild(m_ductility).y = 150;
				addChild(m_hardness).y = 180;
				//addChild(m_decline).y = 160;
				
				addChild(m_damp).y = 270;
				addChild(m_wind).y = 300;
				
				m_damp.value = ModuleHairData.s_damp; m_damp.changeFunction = function(v:Number) : void { ModuleHairData.s_damp = ModuleHairData.s_damp; }
				
				m_weightReciprocal.changeFunction = function(v:Number) : void { if (m_data) m_data.weightReciprocal = v; }
				m_ductility.changeFunction = function(v:Number) : void { if (m_data) m_data.ductility = v; }
				m_hardness.changeFunction = function(v:Number) : void { if (m_data) m_data.hardness = v; }
				
				
				//m_decline.value = 1.05;
				
				m_wind.value = 0;
				
				
				var tcb : TextCheckBox;
				tcb = new TextCheckBox();
				tcb.text = "show bitmap";
				tcb.selected = true;
				tcb.x  = 5;
				tcb.y  = 360;
				tcb.changeFunction = function(_tcb:TextCheckBox):void { m_hairShape.visible = _tcb.selected ;	}
				addChild(tcb);
				
				
				tcb = new TextCheckBox();
				tcb.text = "show line";
				tcb.selected = true;
				tcb.x  = 5;
				tcb.y  = 390;
				tcb.changeFunction = function(_tcb:TextCheckBox):void { m_lineShape.visible = _tcb.selected ;	}
				
				addChild(tcb);
				
			}
		
			
		}
		
		public function get vz() : Number
		{
			if (m_data)
			{
				var sum : Number = 0;
				for (var j : int = 0 ; j < m_data.vertexPerLine ; j++ )
				{
					var _ev3d : EdtVertex3D = m_data.vertexData[j];
					sum += _ev3d.z;
				}
				
				return sum / m_data.vertexPerLine;
			}
			return 0;
			
		}
		
		public function dispose():void
		{
			deactivate();
			GraphicsUtil.removeAllChildren(this);
			
			m_data = null;
			m_hairShape = null;
			m_lineShape = null;
			m_massVector = null;
		
			if (m_damp)
			{
				m_damp.dispose();
				m_weightReciprocal.dispose();
				m_ductility.dispose();
				m_hardness.dispose();
				m_wind.dispose();
				
				
				m_damp = 
				m_weightReciprocal = 
				m_ductility =
				m_hardness = 
				m_wind = null;
			}
			
			if (m_browser)
			{	
				m_browser.dispose();
				m_browser = null;
				
			}
			
			if (parent)
				parent.removeChild(this);
		}
		
		internal function onRenderChange(_browser : ModuleHead3DBrowser , __v : Vector.<Number> , md : Matrix4x4 , xValue : Number, yValue : Number, zValue: Number):void
		{
			if (m_data && m_data.vertexPerLine && m_data.vertexData)
			{
				var i : int = 0 ;
				for each (var _hairSpring : Vector.<ModuleHairMassPoint> in m_massVector)
				{
					_hairSpring[0].pos.x  = (md.Xx * (m_data.vertexData[i].x + m_data.offsetX)  + md.Xy * (m_data.vertexData[i].y  + m_data.offsetY) + md.Xz * m_data.vertexData[i].z ) ;
					_hairSpring[0].pos.y  = (md.Yx * (m_data.vertexData[i].x + m_data.offsetX)  + md.Yy * (m_data.vertexData[i].y  + m_data.offsetY) + md.Yz * m_data.vertexData[i].z ) ;
					
					i++;
				}
			}
			
			m_roZ = zValue;
			
		}
		
		public function activate():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onUpdate);
			if (m_browser) m_browser.activate();
			
			
		}
		
		public function deactivate():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onUpdate);
			if (m_browser) m_browser.deactivate();
		}
		
		private var m_roZ : Number = 0;
		private function onUpdate(e:Event):void 
		{
			next(m_roZ);
		}
		
		
		
		private function next(_rz : Number):void 
		{
			
			const damp : Number = ModuleHairData.s_damp;
			
			if (!m_data)
				return;
			
			var weight_d : Number = m_data.weightReciprocal;
			const ductility : Number = m_data.ductility;
			const hardness : Number = m_data.hardness;
			//const decline : Number = m_decline.value;
			
			
			
			const wind : Number = m_wind ? m_wind.value : ModuleHairData.s_wind;
			var i : int = 1;
			
			//sinWind += 0.05;
			
			
			
			if (m_massVector)
			{
				const windStep : Number = 1 / 4;// (m_massVector[0].length - 1);
				for each (var _hairSpring : Vector.<ModuleHairMassPoint> in m_massVector)
				{
					var _li : int = 0;
					
					for each (var _hmp : ModuleHairMassPoint in _hairSpring)
					{
						if (!_hmp.preMassPoint)
							continue;
						
						
						weight_d = m_data.weightReciprocal ; //* pow(decline , i - 1)
						var _newOffX : Number = _hmp.pos.x - _hmp.preMassPoint.pos.x;
						var _newOffY : Number = _hmp.pos.y - _hmp.preMassPoint.pos.y;
						
						var _newLength : Number = Math.sqrt(_newOffX * _newOffX + _newOffY * _newOffY);
						var _newRadian : Number = Math.atan2(_newOffY , _newOffX);
						
						var _newOff : Number = - (_newLength -  _hmp.springLength);
						var _newRate : Number = _newOff /_hmp.springLength * ductility;
						
						var _fStringRate : Number = _newRate * weight_d;
						
							
						var fSpring : Point = new Point();
						fSpring.x = Math.cos(_newRadian) * _fStringRate;
						fSpring.y = Math.sin(_newRadian) * _fStringRate;
						
						
						
						var fRadian : Point = new Point();
						
						
						var _rOff : Number = _rz * 0 + _hmp.radian - _newRadian;
						if (_rOff > Math.PI *2)
							_rOff -= Math.PI * 2;
						else if (_rOff < 0)
							_rOff += Math.PI * 2;
							
						if (_rOff > Math.PI)
							_rOff -= Math.PI * 2;
						
						if (_rOff != 0)
						{
							var _rOffRate : Number = _rOff / (Math.PI * 2) ;
							fRadian.x = Math.cos(_newRadian + Math.PI / 2) * _rOffRate * hardness * weight_d;
							fRadian.y = Math.sin(_newRadian + Math.PI / 2) * _rOffRate * hardness * weight_d;
						}
						
						
						var _newX : Number = _hmp.pos.x + damp * (_hmp.pos.x - _hmp.lastPos.x ) +  fRadian.x +  fSpring.x + wind * (windStep * _li ) * weight_d ; //deltaT^2
						var _newY : Number = _hmp.pos.y + damp * (_hmp.pos.y - _hmp.lastPos.y ) +  fRadian.y +  fSpring.y; //deltaT^2
						_li++;
						
						/*
						if (true)//prevent too long
						{
							var _posOffX : Number = _newX - m_massPointArray[0].pos.x;
							var _posOffY : Number = _newY - m_massPointArray[0].pos.y;
							var _rootLengthNew : Number = Math.sqrt(_posOffX * _posOffX + _posOffY * _posOffY);
							var _limitRate : Number = m_massPointArray[i].rootLength / _rootLengthNew;
							
							
							if (_limitRate > 1.5)
							{
								trace(_limitRate);
								_limitRate = 1.5 ;// + (_limitRate - 1.5) * (_limitRate - 1.5);
								trace(_limitRate);
								
								_newX = m_massPointArray[0].pos.x + _posOffX * _limitRate;
								_newY = m_massPointArray[0].pos.y + _posOffY * _limitRate;
							}
							else if (_limitRate < 0.75)
							{
								_limitRate = 0.75 ;// - (0.75 - _limitRate) * (0.75 - _limitRate);
								
								_newX = m_massPointArray[0].pos.x + _posOffX * _limitRate;
								_newY = m_massPointArray[0].pos.y + _posOffY * _limitRate;
							}
							
							_newX = m_massPointArray[0].pos.x + _posOffX * _limitRate;
							_newY = m_massPointArray[0].pos.y + _posOffY * _limitRate;
						}*/
						
						_hmp.lastPos.x = _hmp.pos.x ;
						_hmp.lastPos.y = _hmp.pos.y ;
						
						_hmp.pos.x = _newX;
						_hmp.pos.y = _newY;
					}
				}
				
				refresh();
			}	
			
			
			
		}
		
		
		public function refresh():void
		{
			if (m_lineShape)
				m_lineShape.graphics.clear();
			m_hairShape.graphics.clear();
			
			if (m_massVector)
			{
				if (m_lineShape)
				{
					m_lineShape.graphics.lineStyle(1 , 0 , 0.5);
					for each (var _hairSpring : Vector.<ModuleHairMassPoint> in m_massVector)
					{
						var first : Boolean = true;
						
						for each (var _hmp : ModuleHairMassPoint in _hairSpring)
						{
							if (first)
							{
								m_lineShape.graphics.moveTo(_hmp.pos.x,_hmp.pos.y);
								first = false;
							}
							else
								m_lineShape.graphics.lineTo(_hmp.pos.x,_hmp.pos.y);
						}
						
					}
				}
				
				
				if (m_data && !m_data.uvData && m_data.vertexData)
				{	
					m_data.genUVData();
					m_data.genIndicesData();
				}
				if (m_data.vertexData && m_data.uvData && m_data.indices )
				{
					var g : Graphics = m_hairShape.graphics;
					if (m_data.texture && m_data.texture.bitmapData)
					{
						g.clear();
						g.beginBitmapFill(m_data.texture.bitmapData, null, false, true);
						
						
						{
							var __v : Vector.<Number> = new Vector.<Number>();
								
							var totalLine : int = m_data.vertexData.length / m_data.vertexPerLine;
							
							for (var i : int = 0 ; i < totalLine ; i++ )
							{
								for (var j : int = 0 ; j < m_data.vertexPerLine ; j++ )
								{
									__v.push(m_massVector[j][i].pos.x);
									__v.push(m_massVector[j][i].pos.y);
								}
							}
							

						}
						
						g.drawTriangles(__v, m_data.indices, m_data.uvData);
						g.endFill();
					}
				}
				
			}
		}
		
		public function setCurrentData(_data:ModuleHairFrame):void
		{
			m_data = _data;
			
			if (m_data && m_data.vertexPerLine)
			{
				if (m_weightReciprocal)
				m_weightReciprocal.value =  m_data.weightReciprocal;
				if (m_ductility)
				m_ductility.value =  m_data.ductility;
				if (m_hardness)
				m_hardness.value =  m_data.hardness;
				
				var underHead : Boolean = false;
				m_massVector = new Vector.<Vector.<ModuleHairMassPoint>>();
				var totalLine : int = m_data.vertexData.length / m_data.vertexPerLine;
				
				
				for (var i : int = 0 ; i < m_data.vertexPerLine ; i++ )
				{	
					var _hairSpring : Vector.<ModuleHairMassPoint> = new Vector.<ModuleHairMassPoint>(); 
					m_massVector.push(_hairSpring);
					
					for (var j : int = 0 ; j < totalLine ; j++ )
					{
						var _hmp : ModuleHairMassPoint = new ModuleHairMassPoint();
						var _ev3d : EdtVertex3D = m_data.vertexData[j * m_data.vertexPerLine + i];
						_hairSpring.push(_hmp);
						
						_hmp.pos.x = _hmp.lastPos.x = _ev3d.x  + m_data.offsetX;
						_hmp.pos.y = _hmp.lastPos.y = _ev3d.y  + m_data.offsetY;	
				
						if (!underHead)
						{
							if (_ev3d.z < 0)
								underHead = true;
							//trace(_ev3d.z)
						}
						
						if (j > 0)
						{	
							_hmp.preMassPoint = _hairSpring[j - 1];
							//if (i > 1)
							//	mp.prepreMassPoint = m_massPointArray[i - 2];
							_hmp.init();
						}	
					}
					
				}
				
				if(m_browser) removeChild(m_browser);
				removeChild(m_hairShape);
				if(m_lineShape) removeChild(m_lineShape);
				
				if (underHead)
				{
					
					addChild(m_hairShape);
					if(m_browser)  addChild(m_browser);
					
				}
				else
				{
					if(m_browser) addChild(m_browser);
					addChild(m_hairShape);
				}
				
				if(m_browser) addChild(m_lineShape);
				if(m_browser)
					onRenderChange(m_browser , null , m_browser.getCurMatrix() , 0 , 0 , m_roZ);
				
			} else {
				m_massVector = null;
			}
			
		}
		
		
		
		
		
	}

}