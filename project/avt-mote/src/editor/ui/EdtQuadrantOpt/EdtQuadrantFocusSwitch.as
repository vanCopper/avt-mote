package editor.ui.EdtQuadrantOpt 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.EdtDEF;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtQuadrantIndicate;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantFocusSwitch
	{
		
		
		public function EdtQuadrantFocusSwitch(_focusFunction : Function , _fullFunction : Function) 
		{
			focusFunction = _focusFunction;
			fullFunction = _fullFunction;
		}
		public function dispose():void 
		{
			clearTimeoutSet();
			focusFunction = null;
			fullFunction = null;
			
		}
		
		private var m_timeoutInv : int;
		
		private function setFocusQuadrant( _curPos : int ,curEdtQuadrant : EdtQuadrant , directSet : Boolean) : int
		{
			if (_curPos != curEdtQuadrant.quadrant)
			{
				if (focusFunction != null)
					focusFunction(_curPos , directSet ? 2 : 1);
				
					
				clearTimeoutSet();
				
				if (directSet)
					return 1;
					
				m_timeoutInv = setTimeout (
					function():void {
						clearTimeoutSet();
						
						if (focusFunction != null)
							focusFunction(_curPos , 2);
						///
						/*if (m_operatorIndicate.visible)
							computeOperatorIndicatePos(true);
						*/
					} , 150);

			}
			return 0;
		}
		private function clearTimeoutSet():void
		{
			if (m_timeoutInv)
			{
				clearTimeout(m_timeoutInv);
				m_timeoutInv = 0;
			}
		}
		private function setFocus(me : MouseEvent,curEdtQuadrant : EdtQuadrant,directSet : Boolean) : int
		{
			
			if (!curEdtQuadrant.fullScreen)
			{
				if (curEdtQuadrant.parent.mouseX < 0 || curEdtQuadrant.parent.mouseX >= EdtDEF.QUADRANT_WIDTH*2 
				|| curEdtQuadrant.parent.mouseY < 0 || curEdtQuadrant.parent.mouseY >= EdtDEF.QUADRANT_HEIGHT*2 
				)
				{	
					clearTimeoutSet();
					return 0;
				}
				var _ptA : Point = curEdtQuadrant.parent.globalToLocal(new Point(me.stageX , me.stageY));

				var _curPos : int = int(_ptA.x / EdtDEF.QUADRANT_WIDTH) + int(_ptA.y / EdtDEF.QUADRANT_HEIGHT) * 2;
				return setFocusQuadrant(_curPos , curEdtQuadrant , directSet);
				
			}
			
			return 0;
			
		}
		
		public var focusFunction : Function;
		public var fullFunction : Function;
		
		public function onMouseDown(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			setFocus(me ,  curEdtQuadrant, true);
			return 0;
		}
		
		public function onMouseMove(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			setFocus(me , curEdtQuadrant, false);
			return 0;
		}
		
		public function onKeyDown(ke : KeyboardEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (ke.keyCode == 32)
			{
				if (curEdtQuadrant)
				{
					if (curEdtQuadrant.parent.mouseX < 0 || curEdtQuadrant.parent.mouseX >= EdtDEF.QUADRANT_WIDTH*2 
					|| curEdtQuadrant.parent.mouseY < 0 || curEdtQuadrant.parent.mouseY >= EdtDEF.QUADRANT_HEIGHT*2 
					)
						return 1;
					
					if (curEdtQuadrant.fullScreen)
					{	
						if (fullFunction != null)
							fullFunction(curEdtQuadrant.quadrant , false);
							
						
						return 1;
					}
					
					var _curPos : int = int(curEdtQuadrant.parent.mouseX / EdtDEF.QUADRANT_WIDTH) + int(curEdtQuadrant.parent.mouseY / EdtDEF.QUADRANT_HEIGHT) * 2;
					setFocusQuadrant(_curPos , curEdtQuadrant , true);
					
					if (fullFunction != null)
						fullFunction(curEdtQuadrant.quadrant , true);
				
				}
				
				return 1;
			}
			
			return 0;
		}
	}

}