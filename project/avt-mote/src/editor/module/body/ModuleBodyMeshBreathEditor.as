package editor.module.body 
{
	import editor.module.body.ModuleBodyFrame;
	import editor.module.head.ModuleHeadData;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtSlider;
	import editor.ui.EdtVertex3D;
	import editor.ui.EdtVertexInfo;
	import flash.display.Sprite;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBodyMeshBreathEditor extends Sprite
	{
		private var m_okBtn : BSSButton;
		private var m_data:ModuleBodyFrame;
		public var okFunction : Function;
		public var getFunction : Function;
		public var changeFunction : Function;
		
		public function ModuleBodyMeshBreathEditor() 
		{
			
			m_okBtn = BSSButton.createSimpleBSSButton(100, 20, "Breath extruder" , false);
			m_okBtn.releaseFunction = onOK;
			m_okBtn.x = 650;
			m_okBtn.y = 40;
			addChild(m_okBtn);
			
			setCurrentData(null);
		}
		
		public function setCurrentData(_data:ModuleBodyFrame):void
		{
			m_data = _data;
			
			if (m_data)
			{
				m_okBtn.activate();
				m_okBtn.alpha = 1;
				
				testReset();
				if (okFunction != null)
					okFunction(m_data);
				
			} else {
			
				m_okBtn.deactivate();
				m_okBtn.alpha = 0.5;
			}
			
		}
		
		private function onOK(btn:BSSButton):void 
		{
			btn.text = "Reset"
			btn.releaseFunction = onReset;
			
			if (m_data)
			{
				if (getFunction != null)
					var _vertexBreathData : Vector.<EdtVertexInfo> = getFunction();
			
				var _vertexBreathDataToExtrude : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
					
				if (_vertexBreathData)
				for each (var _evi : EdtVertexInfo in _vertexBreathData)
				{
					if (_evi.isSelectd())
					{
						_vertexBreathDataToExtrude.push(_evi.vertex);
					}
				}
				
				if (_vertexBreathDataToExtrude.length > 1)
				{
					
					var minX : Number = _vertexBreathDataToExtrude[0].x;
					var maxX : Number = minX;
					var minY : Number = _vertexBreathDataToExtrude[0].y;
					var maxY : Number = minY;
					
					for each (var _ev3d : EdtVertex3D in _vertexBreathDataToExtrude)
					{
						if (minX > _ev3d.x)
							minX = _ev3d.x;
						else if (maxX < _ev3d.x)
							maxX = _ev3d.x;
							
							
						if (minY > _ev3d.y)
							minY = _ev3d.y;
						else  if (maxY < _ev3d.y)
							maxY = _ev3d.y;	
					}
					
					var _centerX : Number = (minX + maxX) / 2;
					var _offX : Number =  (maxX - minX);
					var _offY : Number =  (maxY - minY);
					var _maxOffsetX : Number = ((maxX - minX) / 2);
					var _maxOffsetY : Number = ((maxY - minY));
					
					for each ( _ev3d in _vertexBreathDataToExtrude)
					{
						var _offsetX : Number = _ev3d.x - _centerX;
						var _offsetXABS : Number = Math.abs(_offsetX);
						var _rateX : Number = 1 - _offsetXABS / _maxOffsetX;
						_rateX *= 0.025;
						_rateX = 1 + _rateX;

						_ev3d.x = _centerX + _offsetX * _rateX;
						
						var _offsetYABS : Number = ((maxY - _ev3d.y) );
						var _rateY : Number = _offsetYABS / _maxOffsetY;
						_rateY *= 0.05;
						_rateY = 1 + _rateY;
						_ev3d.y = maxY - _offsetYABS * _rateY;
						
					}
					
				}
				testReset();
				
				if (okFunction != null)
					okFunction(m_data);
				if (changeFunction != null)
					changeFunction();
			}
		}
		
		public function testReset():void
		{
				var _vertexBreathData : Vector.<EdtVertex3D> = m_data.vertexBreathData;
				var _vertexData : Vector.<EdtVertex3D> = m_data.vertexData;
				var _same : Boolean = true;
				for (var i : int = 0 ; i < _vertexData.length ; i++ )
				{
					if (_vertexData[i].x != _vertexBreathData[i].x
					|| _vertexData[i].y != _vertexBreathData[i].y
					)
					{
						_same = false;
						break;
					}
				}
				
				if (!_same)
				{
					
					m_okBtn.text = "Reset"
					m_okBtn.releaseFunction = onReset;
					
				}
				else
				{
					m_okBtn.text = "Breath extruder"
					m_okBtn.releaseFunction = onOK;

				}
		}
		
		private function onReset(btn:BSSButton):void 
		{
			btn.text = "Breath extruder"
			btn.releaseFunction = onOK;
			
			if (m_data)
			{
				m_data.vertexBreathData.length = 0;
				if (okFunction != null)
					okFunction(m_data);
				if (changeFunction != null)
					changeFunction();
			}
			
			
		}
		
	}

}