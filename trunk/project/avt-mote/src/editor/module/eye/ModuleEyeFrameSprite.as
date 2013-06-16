package editor.module.eye 
{
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrameSprite extends Sprite 
	{
		public var data : ModuleEyeFrame;
		
		public var eyeWhite : Texture2DBitmap;
		public var eyeBall : Texture2DBitmap;
		public var eyeWBContainer : Sprite;
		public var eyeWBMask : Shape;
		public var eyeLip : Texture2DBitmap;
		
		public function ModuleEyeFrameSprite(_data : ModuleEyeFrame) 
		{
			data = _data;
			
			eyeWBContainer = new Sprite();
			eyeWhite = new Texture2DBitmap(null);
			eyeBall = new Texture2DBitmap(null);
			eyeWBMask = new Shape;
			eyeLip = new Texture2DBitmap(null);
			
			
			eyeWBContainer.addChild(eyeWhite);
			eyeWBContainer.addChild(eyeBall);
			
			addChild(eyeWBContainer);
			addChild(eyeWBMask);
			addChild(eyeLip);
			
			
			if (data && data.eyeMaskData)
				renderMask(false);
				
			maskMode = true;
			refresh();
		}
		private var _maskMode : Boolean;
		public function set maskMode(m:Boolean):void
		{
			_maskMode = m;
			if (m)
			{
				if (eyeWBMask.width )
					eyeWBContainer.mask = eyeWBMask;
				else
					eyeWBContainer.mask = null;
			}
			else
			{
				eyeWBContainer.mask = null;
			}
		}
		
		public function fitPos(w:Number , h:Number , minX : Number = 0 , minY : Number = 0):void
		{
			if (width && height)
			{
				scaleY = scaleX = 1;
				
				width = Math.min(w, width);
				height = Math.min(h, height);
				
				scaleY = scaleX = Math.min(scaleX , scaleY);
				
				var rect : Rectangle = this.getRect(this);
				
				x = minX + w / 2 - (rect.right + rect.left)*scaleX / 2;
				y = minY + h / 2 - (rect.bottom + rect.top)*scaleY / 2;
				
				
			}
		}
		
		public function refresh():void
		{
			if (data) {
				if (eyeWhite){ eyeWhite.texture2D = data.eyeWhite ; }
				if (eyeBall) { 
					eyeBall.texture2D = data.eyeBall ; 
					eyeBall.x = data.eyeBallX;
					eyeBall.y = data.eyeBallY;
					
				}
				if (eyeLip)  {
					eyeLip.texture2D = data.eyeLip ; 
					eyeLip.x = data.eyeLipX;
					eyeLip.y = data.eyeLipY;
				}
			}
			else
			{
				if (eyeWhite) { eyeWhite.texture2D = null; }
				if (eyeBall) { eyeBall.texture2D = null; }
				if (eyeLip) { eyeLip.texture2D = null; }
			}
			
		}
		public function clearMask():void
		{
			eyeWBMask.graphics.clear();
			eyeWBContainer.mask = null;
		}
		
		public function renderMask(showLine:Boolean):void
		{
			eyeWBMask.graphics.clear();
			
			if (!data)
				return;
				
			var _eyeMaskData : Vector.<EdtVertex3D> = data.eyeMaskData;
			var idx : int = 2;
			
			if (showLine)
				eyeWBMask.graphics.lineStyle(0.5 , 0xFF00000 , 0.75);
			
			while (idx < _eyeMaskData.length)
			{
				eyeWBMask.graphics.beginFill(0xFF00000 , 0.25);	
				eyeWBMask.graphics.moveTo(_eyeMaskData[0].x , _eyeMaskData[0].y);
				
				eyeWBMask.graphics.lineTo(_eyeMaskData[idx-1].x , _eyeMaskData[idx-1].y);
				eyeWBMask.graphics.lineTo(_eyeMaskData[idx].x , _eyeMaskData[idx].y);
				eyeWBMask.graphics.lineTo(_eyeMaskData[0].x , _eyeMaskData[0].y);
				eyeWBMask.graphics.endFill();	
				
				idx++;
			}
			if (_maskMode && eyeWBMask.width )
					eyeWBContainer.mask = eyeWBMask;
		}
		
		public function dispose():void 
		{
			if (eyeWhite) { eyeWhite.dispose(); eyeWhite = null; }
			if (eyeBall) { eyeBall.dispose(); eyeBall = null; }
			if (eyeLip) { eyeLip.dispose(); eyeLip = null; }
			
			if (parent)
				parent.removeChild(this);
			data = null;
		}
		
		
	}

}