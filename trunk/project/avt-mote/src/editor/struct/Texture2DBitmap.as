package editor.struct 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Texture2DBitmap extends Sprite 
	{
		private var _texture2D : Texture2D;
		private var _bmp : Bitmap;
		
		public function set texture2D (a_texture2D : Texture2D) : void
		{
			_texture2D = null;
			if (_bmp && _bmp.bitmapData)
			{
				_bmp.bitmapData.dispose();
				_bmp.bitmapData = null;
			}
			
			_texture2D = a_texture2D;
			
			if (!_texture2D)
				return;
			
			var bd : BitmapData = new BitmapData(Math.abs(a_texture2D.rectW) , a_texture2D.rectH);
			
			if (a_texture2D.rectW >= 0)
			{
				bd.copyPixels(
				a_texture2D.bitmapData , 
					new Rectangle(a_texture2D.rectX , a_texture2D.rectY , a_texture2D.rectW , a_texture2D.rectH),
					new Point(0,0)
				);	
			} else {
				bd.lock();
				var hy : int = 0;
				var wx : int = 0;
				
				for (var hi : int = a_texture2D.rectY ; hi < a_texture2D.rectY  +  a_texture2D.rectH ; hi++ , hy++)
				{
					var wi : int = a_texture2D.rectX;
					wx = 0;
					for ( ; wi > a_texture2D.rectX + a_texture2D.rectW ; wi-- , wx++)
					{
						bd.setPixel32(wx , hy , a_texture2D.bitmapData.getPixel32(wi - 1 , hi));
					}
				}
				
				bd.unlock();
				
			}
			
			_bmp.bitmapData = bd;
		}
		
		public function isTransArea():Boolean
		{
			var _color : uint = _bmp.bitmapData.getPixel32(_bmp.mouseX , _bmp.mouseY) ;
			var _colorAlpha : uint = ((_color >> 24) & 0xFF);
			return _colorAlpha < 5;
			
		}
		
		public function Texture2DBitmap(a_texture2D : Texture2D) 
		{
			mouseChildren = false;
			_bmp = new Bitmap();
			addChild(_bmp);
			
			texture2D = a_texture2D;
			
			
			
		}
		
		public function dispose():void
		{
			texture2D = null;
			if (_bmp )
			{
				if (_bmp.bitmapData)
				{
					_bmp.bitmapData.dispose();
					_bmp.bitmapData = null;
				}
				
				if (_bmp.parent)
					_bmp.parent.removeChild(_bmp);
				
				_bmp = null;

			}
			
		}
	}

}