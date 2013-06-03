package editor.ui.EdtQuadrantOpt 
{
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
			if (ke.keyCode >= 49 || ke.keyCode <= 52 )
			{
				if (curEdtQuadrant)
					curEdtQuadrant.setViewVisible(ke.keyCode - 48);
				return 1;
			}
			return 0;
		}
	}

}