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
		public var type : String = "";
		
		public function Texture2D(a_bitmapData : BitmapData
			,a_name : String
			,a_type : String
			,a_rectX : Number = NaN
			,a_rectY : Number = NaN
			,a_rectW : Number = NaN
			,a_rectH : Number = NaN
		
		)
		{
			bitmapData = a_bitmapData;
			name = a_name;
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
		public function dispose() : void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
		}
		
		
		
		public function toXMLString():String
		{
			return "<Texture2D>"
				+ "<name>" + name + "</name>"
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
			
		}
		
		
		
	}

}