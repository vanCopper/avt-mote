package editor.ui 
{
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EdtMoveIndicate extends Shape
	{
		
		public function EdtMoveIndicate() 
		{
			const leng : int = 10;
			const leng2 : int = 4;
			const w : int = 3;
			const w2 : int = 1;
			
			this.graphics.beginFill(0x0);
			
			this.graphics.moveTo(0 , -leng);
			this.graphics.lineTo(w , -leng2);
			this.graphics.lineTo(w2 , -leng2);
			this.graphics.lineTo(w2 , -w2);
			this.graphics.lineTo(leng2 , -w2);
			this.graphics.lineTo(leng2 , -w);
			this.graphics.lineTo(leng , 0);
			this.graphics.lineTo(leng2 , w);
			this.graphics.lineTo(leng2 , w2);
			this.graphics.lineTo(w2 , w2);
			this.graphics.lineTo(w2 , leng2);
			this.graphics.lineTo(w , leng2);
			this.graphics.lineTo(0 , leng);
			this.graphics.lineTo(-w , leng2);
			this.graphics.lineTo(-w2 , leng2);
			this.graphics.lineTo( -w2 , w2);
			this.graphics.lineTo( -leng2 , w2);
			this.graphics.lineTo( -leng2 , w);
			this.graphics.lineTo( -leng , 0);
			this.graphics.lineTo( -leng2 , -w);
			this.graphics.lineTo( -leng2 , -w2);
			this.graphics.lineTo( -w2 , -w2);
			this.graphics.lineTo(-w2 , -leng2);
			this.graphics.lineTo( -w , -leng2);
			this.graphics.lineTo(0 , -leng);
		
			this.graphics.endFill();
			
			
			//this.x = 760;
			//this.y = 4;
			this.filters = [new GlowFilter(0xFFFF00 , 0.75)]
			//this.visible = false;
			//m_indicate.x = m_indicate.y = 100;
		}
		
	}

}