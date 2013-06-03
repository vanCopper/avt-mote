package editor.ui.EdtQuadrantOpt 
{
	import editor.config.EdtDEF;
	import editor.ui.EdtMoveIndicate;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtQuadrantIndicate;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantViewCtrl 
	{
		private var m_isMovineQuadrant : Boolean;
		private var m_indicate : EdtQuadrantIndicate;
		
		
		public function EdtQuadrantViewCtrl(_indicate : EdtQuadrantIndicate) 
		{
			m_indicate = _indicate;
			m_indicate.moveIndicate = new EdtMoveIndicate();
			
		}
		public function onMouseDown(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			checkAlt(me);
			if (me.altKey && curEdtQuadrant)
			{
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen ? 2 : 1))
					)
				{
					
					m_indicate.visible = true;
					m_indicate.mode = EdtQuadrantIndicate.VIEW_CONTROL;
					
					
					m_indicate.x = pt.x + curEdtQuadrant.x;
					m_indicate.y = pt.y + curEdtQuadrant.y;
					m_isMovineQuadrant = true;
					
				}
				else
				{
					
				}
				return 1;
			} 
			return 0;
		}
		public function onMouseMove(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (m_isMovineQuadrant && me.altKey)
			{
				if (curEdtQuadrant)
				{
					var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
					if (pt.x >= 0
						&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen ? 2 : 1))
						&& pt.y >= 0
						&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen ? 2 : 1))
						)
					{
						m_indicate.mode = EdtQuadrantIndicate.VIEW_CONTROL;
						
						var offX : Number = -(m_indicate.x - curEdtQuadrant.x) + pt.x ;
						var offY : Number = -(m_indicate.y - curEdtQuadrant.y) + pt.y ;
						m_indicate.x = pt.x + curEdtQuadrant.x;
						m_indicate.y = pt.y + curEdtQuadrant.y;
						
						if (curEdtQuadrant.fullScreen)
						{
							offX /= 2;
							offY /= 2;
						}
						
						curEdtQuadrant.QuadrantRelateDrag(offX , offY);
						m_isMovineQuadrant = true;
					}
				}
				return 1;
			}
			return 0;
		}
		
		public function onMouseUp(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (m_isMovineQuadrant)
			{
				m_isMovineQuadrant = false;
				m_indicate.mode = EdtQuadrantIndicate.SELECT_POINT;
			}
			
			return 0;
		}
		
		public function onMouseWheel(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (me.altKey && curEdtQuadrant)
			{
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen ? 2 : 1))
					)
				{
					
					curEdtQuadrant._sQ += me.delta > 0 ? 1 : -1;
				}
				
				return 1;
			}
			return 0
		}
		
		
		private function checkAlt(me : MouseEvent): void
		{
			if (!me.altKey && m_isMovineQuadrant)
			{
				m_isMovineQuadrant = false;
				m_indicate.mode = EdtQuadrantIndicate.SELECT_POINT;
			}
		}
		
		public function dispose():void 
		{
			m_indicate = null;
		}
	}

}