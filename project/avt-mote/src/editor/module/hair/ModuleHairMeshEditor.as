package editor.module.hair 
{
	import editor.module.head.ModuleHeadData;
	import editor.ui.EdtAddUI;
	import editor.ui.EdtSlider;
	import editor.ui.EdtVertex3D;
	import flash.display.Sprite;
	import UISuit.UIComponent.BSSButton;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHairMeshEditor extends Sprite
	{
		private var m_hSlider : EdtSlider;
		private var m_vSlider : EdtSlider;
		private var m_okBtn : BSSButton;
		private var m_data:ModuleHairFrame;
		public var okFunction : Function;
		
		public function ModuleHairMeshEditor() 
		{
			m_hSlider = new EdtSlider(2, 20 , "水平切割");
			m_vSlider = new EdtSlider(2, 20 , "垂直切割");
			
			addChild(m_hSlider);
			m_hSlider.x = 650;
			m_hSlider.y = 80;
			
			
			addChild(m_vSlider);
			m_vSlider.x = 650;
			m_vSlider.y = m_hSlider.y + 35;
			
			m_okBtn = BSSButton.createSimpleBSSButton(60, 20, "OK" , false);
			m_okBtn.releaseFunction = onOK;
			m_okBtn.x = 650;
			m_okBtn.y = m_vSlider.y + 40;
			addChild(m_okBtn);
			
			setCurrentData(null);
		}
		
		public function setCurrentData(_data:ModuleHairFrame):void
		{
			m_data = _data;
			
			if (m_data)
			{
				m_hSlider.activate();
				m_vSlider.activate();
				m_okBtn.activate();
				m_okBtn.alpha = 1;
				
				if (m_data.vertexData.length && m_data.vertexPerLine)
				{
					m_hSlider.value = m_data.vertexPerLine;
					m_vSlider.value = m_data.vertexData.length / m_data.vertexPerLine;
					m_okBtn.text = "Reset"
					m_okBtn.releaseFunction = onReset;
					if (okFunction != null)
						okFunction(m_data);
				}
				else
				{
					m_okBtn.text = "OK"
					m_okBtn.releaseFunction = onOK;
					if (okFunction != null)
						okFunction(m_data);
				}
				
				
			} else {
				m_hSlider.deactivate();
				m_vSlider.deactivate();
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
				m_data.vertexData.length = 0;
				m_data.vertexPerLine = m_hSlider.value;
				var hNum : int = m_hSlider.value;
				var vNum : int = m_vSlider.value;
				var hOff : Number = Math.abs(m_data.texture.rectW) / (hNum - 1);
				var vOff : Number = Math.abs(m_data.texture.rectH) / (vNum - 1);

				for (var i : int = 0; i < vNum ; i++ )
				{
					for (var j : int = 0; j < hNum ; j++ )
					{
						m_data.vertexData.push(new EdtVertex3D(hOff * j , i * vOff));
					}
				}
				
				genConnect(hNum , vNum , m_data.vertexData);
				
				if (okFunction != null)
					okFunction(m_data);
			}
		}
		
		private function genConnect(pointPerLine:int, totalLine:int, _edtVectorAll:Vector.<EdtVertex3D>):void 
		{
			var ti : int = 0;
			
			ti = 0;
			for each(var __edtP : EdtVertex3D in _edtVectorAll)
			{
				__edtP.priority = ti++;
			}
			
			
			for ( l = 0 ; l < totalLine ;l++ )
			{
				var start : int = l * pointPerLine;
				for ( ti = 1 ; ti < pointPerLine ; ti++ )
				{
					EdtVertex3D.connect2PT(_edtVectorAll[start + ti - 1] , _edtVectorAll[start + ti]);
				}
			}
			
			for ( ti = 0 ; ti < pointPerLine ; ti++ )
			for (var l : int = 1 ; l < totalLine ;l++ )
			{
				EdtVertex3D.connect2PT(_edtVectorAll[(l - 1) * pointPerLine + ti ] , _edtVectorAll[(l) * pointPerLine + ti ]);
			}
		}
		
		private function onReset(btn:BSSButton):void 
		{
			btn.text = "OK"
			btn.releaseFunction = onOK;
			
			if (m_data)
			{
				m_data.vertexData.length = 0;
				m_data.vertexPerLine = 0;
				if (okFunction != null)
					okFunction(m_data);
			}
			
			
		}
		
	}

}