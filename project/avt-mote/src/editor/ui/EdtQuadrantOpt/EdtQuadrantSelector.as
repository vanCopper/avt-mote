package editor.ui.EdtQuadrantOpt 
{
	import editor.config.EdtDEF;
	import editor.config.EdtSET;
	import editor.ui.EdtDot;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtQuadrantIndicate;
	import editor.ui.EdtSelector;
	import editor.ui.EdtVertexInfo;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantSelector
	{
		private var m_indicate : EdtQuadrantIndicate;
		private var m_selectorIndicate : EdtSelector;
		
		private var m_selecingShape : Shape;
		private var m_selecingHitPoint : Point;
		private var m_updateFunction : Function;
		private var m_selectedEVI : Vector.<EdtVertexInfo>;
		
		public function EdtQuadrantSelector(_indicate : EdtQuadrantIndicate , _root : DisplayObjectContainer , a_updateFunction : Function , a_selectedEVI : Vector.<EdtVertexInfo>) 
		{
			m_indicate = _indicate;
			m_selectorIndicate = new EdtSelector();
			m_indicate.selectorIndicate = m_selectorIndicate;
			
			m_selecingShape = new Shape();
			m_updateFunction = a_updateFunction;
			
			_root.addChild(m_selecingShape);
			
			m_selectedEVI = a_selectedEVI;
		}
		

		
		public function dispose():void 
		{
			m_indicate = null;
			m_selectorIndicate = null;
			
			if (m_selecingShape && m_selecingShape.parent)
				m_selecingShape.parent.removeChild(m_selecingShape);
			m_selecingShape = null;
			m_updateFunction = null;
		}
		
		
		
		
		public function onMouseDown(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			var pt : Point = checkIndicateVisible(me,curEdtQuadrant);
				
			if (m_indicate.visible)
			{
				m_selecingHitPoint = pt;
				
				if (!me.shiftKey)
				{
					var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
					curEdtQuadrant.getMappedPoint(_ptVArr);
					var rect : Rectangle = m_selecingShape.getRect(curEdtQuadrant.parent);
						
						
					for each (var __ptv : EdtVertexInfo in _ptVArr)
					{
						__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
					}
					
				}
				
				return 1;
			}
			return 0;
		}
		
		private function checkIndicateVisible(me : MouseEvent , curEdtQuadrant : EdtQuadrant) : Point
		{
			var pt : Point = curEdtQuadrant.parent.globalToLocal(new Point(me.stageX , me.stageY));
			if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * 2)
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * 2)
					)
			{
				m_indicate.x = pt.x;
				m_indicate.y = pt.y;
				m_indicate.visible = true;
			}
			else
			{
				m_indicate.visible = false;
			}
			
			return pt;
		}
		
		public function onMouseMove(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			var pt : Point = checkIndicateVisible(me,curEdtQuadrant);
				
			if (m_indicate.visible)
			{
				
				if (m_selecingHitPoint && pt)
				{
					if (m_selectorIndicate.alpha == 1)
					{
						
						if (Math.abs (m_selecingHitPoint.x - pt.x ) >= 3 ||
							Math.abs (m_selecingHitPoint.y - pt.y ) >= 3 ) 
						m_selectorIndicate.alpha = 0;	
					}		
							
					if (m_selectorIndicate.alpha == 0)
					{
						
						m_selecingShape.graphics.clear();
						m_selecingShape.graphics.beginFill(0x9999FF , 0.45);
						m_selecingShape.graphics.lineStyle(1 , 0x6666FF);
						m_selecingShape.graphics.drawRect( m_selecingHitPoint.x, m_selecingHitPoint.y, -m_selecingHitPoint.x + pt.x , -m_selecingHitPoint.y + pt.y  );
						m_selecingShape.graphics.endFill();
						
						
						var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
						curEdtQuadrant.getMappedPoint(_ptVArr);
						var rect : Rectangle = m_selecingShape.getRect(curEdtQuadrant.parent);
						
						
						for each (var __ptv : EdtVertexInfo in _ptVArr)
						{
							
							if (me.shiftKey)
							{
								if (rect.containsPoint(__ptv.point))
								{
									if (__ptv.dot.selected)
									{	
										__ptv.dot.mode = EdtDot.DOT_UNSELECTING_MODE;
									}
									else
									{	__ptv.dot.mode = EdtDot.DOT_SELECTING_MODE;}
								}
								else {
									if (__ptv.dot.selected)
										__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
									else
										__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
								}
							}
							else
							{
								if (rect.containsPoint(__ptv.point))
								{
									__ptv.dot.mode = EdtDot.DOT_SELECTING_MODE;
								}
								else 
								{
									__ptv.dot.mode = EdtDot.DOT_UNSELECTING_MODE;
								}
							}
						}
						
						if (m_updateFunction != null)
							m_updateFunction(curEdtQuadrant , _ptVArr);
						
					}
					
				}
				
				return 1;
			}
			return 0;
		}
		
		public function onMouseUp(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			var __root : DisplayObject = curEdtQuadrant.parent;
			var pt : Point =__root.globalToLocal(new Point(me.stageX , me.stageY));
			if (!(pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * 2)
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * 2)
					))
				return 0;
			
			if (m_selecingHitPoint)
			{
				var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
				curEdtQuadrant.getMappedPoint(_ptVArr);
				var rect : Rectangle ;
				
				if (m_selectorIndicate.alpha == 1)
				{
					rect = m_selectorIndicate.getRect(__root);
					
					
					for each (var __ptv : EdtVertexInfo in _ptVArr)
					{
						if (me.shiftKey)
						{
							if (rect.containsPoint(__ptv.point))
							{
								if (__ptv.dot.mode == EdtDot.DOT_SELECTED_MODE)
									__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
								else
									__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
							}
						}
						else {
							
							if (rect.containsPoint(__ptv.point))
							{
								__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
							}
							else 
							{
								__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
							}
						}
					}
		
		
				} else {
		
					rect = m_selecingShape.getRect(__root);
					
					for each (__ptv in _ptVArr)
					{
						if (__ptv.dot.mode == EdtDot.DOT_SELECTING_MODE)
							__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
						else if (__ptv.dot.mode == EdtDot.DOT_UNSELECTING_MODE)
							__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
							
					}
				}
				
				if (m_updateFunction != null)
					m_updateFunction(curEdtQuadrant , _ptVArr);
					
				m_selecingShape.graphics.clear();
				m_selecingHitPoint = null;
				
				
				m_selectedEVI.length = 0;
				for each (__ptv in _ptVArr)
				{
					if (__ptv.dot.selected)
					{
						m_selectedEVI.push(__ptv);
						//trace(__ptv.dot.x , __ptv.dot.y);
					}
				}
				
				
				
				if (m_selectedEVI.length)
				{
					m_selectorIndicate.alpha = 1;
					return 2;
					
				}
			}

			m_selectorIndicate.alpha = 1;
		
		
		
			return 1;
		}
		
		
		public function onKeyDown(ke : KeyboardEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (ke.keyCode == 187) //+
			{
				EdtSET.click_accuracy++; 
				m_selectorIndicate.clickAccuracy = EdtSET.click_accuracy;
				
				return 1;
			} 
			else if (ke.keyCode == 189) // -
			{
				if (EdtSET.click_accuracy > 1)
					EdtSET.click_accuracy--;
				m_selectorIndicate.clickAccuracy = 	EdtSET.click_accuracy;
				
				return 1;
			}
			
			return 0;
		}
		
		
		
	}

}