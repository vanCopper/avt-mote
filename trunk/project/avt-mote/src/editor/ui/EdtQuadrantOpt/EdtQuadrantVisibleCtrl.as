package editor.ui.EdtQuadrantOpt 
{
	import editor.config.EdtDEF;
	import editor.ui.EdtQuadrant;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantVisibleCtrl
	{
		
		public function EdtQuadrantVisibleCtrl() 
		{
			
		}
		public function dispose():void
		{
			
		}
		public function onKeyDown(ke : KeyboardEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (ke.keyCode >= 49 && ke.keyCode <= 52  )
			{
				if (curEdtQuadrant.mouseX < 0 || curEdtQuadrant.mouseX >= EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen?2:1)
				|| curEdtQuadrant.mouseY < 0 || curEdtQuadrant.mouseY >= EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen?2:1)
				)
					return 0;
					
				if (curEdtQuadrant)
					curEdtQuadrant.setViewVisible(ke.keyCode - 48);
				return 1;
			}
			return 0;
		}
	}

}