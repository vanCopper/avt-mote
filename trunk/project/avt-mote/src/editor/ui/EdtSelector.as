package editor.ui 
{
	import editor.config.EdtSET;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtSelector extends Shape
	{
		public function set clickAccuracy(v : int) : void
		{
			graphics.clear();
			graphics.beginFill(0x9999FF , 0.45);
			graphics.lineStyle(1 , 0x6666FF);
			graphics.drawRect( -v, -v, v * 2 , v * 2 );
			graphics.endFill();
			
		}
		
		public function get clickAccuracy() : int
		{
			return width >> 1;
		}
		
		public function EdtSelector() 
		{
			clickAccuracy = EdtSET.click_accuracy;
		}
		
	}

}