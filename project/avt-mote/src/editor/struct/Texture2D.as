package editor.struct 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Texture2D 
	{
		public var rectX : Number;
		public var rectY : Number;
		public var rectW : Number;
		public var rectH : Number;
		
		public var bitmapData : BitmapData;
		public var name:String;
		public var filename:String;
		public var type : String = "";
		private var  uvtData :  Vector.<Number>;
		public function Texture2D(a_bitmapData : BitmapData
			,a_name : String
			,a_filename : String
			,a_type : String
			,a_rectX : Number = NaN
			,a_rectY : Number = NaN
			,a_rectW : Number = NaN
			,a_rectH : Number = NaN
		
		)
		{
			bitmapData = a_bitmapData;
			name = a_name;
			filename = a_filename;
			type = a_type;
			
			if (isNaN(a_rectX) || isNaN(a_rectY) || isNaN(a_rectW) || isNaN(a_rectH) )
			{
				rectX = rectY = 0;
				rectW = bitmapData.width;
				rectH = bitmapData.height;
			}
			else
			{
				rectX = a_rectX;
				rectY = a_rectY;
				rectW = a_rectW;
				rectH = a_rectH;
			}
			
		
		}
		public function genUV(): Vector.<Number> {
			
			if (!uvtData && bitmapData)
			{
				var startX : Number;
				var endX : Number;
				
				if (rectW < 0)
				{
					startX = (rectX + rectW) / bitmapData.width;
					endX = (rectX) / bitmapData.width;
				} else 
				{
					startX = (rectX) / bitmapData.width;
					endX = (rectX + rectW) / bitmapData.width;
				}
				
				var startY : Number =  (rectY) / bitmapData.height;
				var endY : Number =  (rectY + rectH) / bitmapData.height;
				
				uvtData =  Vector.<Number>([startX, startY,
											endX, startY, 
											startX, endY,
											endX, endY]);
			}
			
			return uvtData;
			
			
		}
		
		public function dispose() : void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			name = null;
			filename = null;
			type = null;
			uvtData = null;
		}
		
		
		
		public function toXMLString():String
		{
			return "<Texture2D>"
				+ "<name>" + name + "</name>"
				+ "<filename>" + filename + "</filename>"
				+ "<rectX>" + rectX + "</rectX>"
				+ "<rectY>" + rectY + "</rectY>"
				+ "<rectW>" + rectW + "</rectW>"
				+ "<rectH>" + rectH + "</rectH>"
				+ "<type>" + type + "</type>"
				+ "</Texture2D>";
		}
		public function fromXMLString(xml:XML):void
		{
			rectX = Number(xml.name.text());
			rectY = Number(xml.name.text());
			rectW = Number(xml.name.text());
			rectH = Number(xml.name.text());
			name = xml.name.text();
			if (xml.filename == undefined)
				filename = name.replace("#FLIP" , "");
			else
				filename = xml.filename.text();
		}
		
		
		
	}

}