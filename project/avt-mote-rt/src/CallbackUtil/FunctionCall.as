package CallbackUtil
{
	/**
	 * ...
	 * @author blueshell
	 */
	CONFIG::DEBUG
	public class FunctionCall
	{
		public var fullFileName : String;
		public var fileLine : int;
		public var atFunction : String;
		public var content:String;
		
		public var eventId : int;
		public var eventIdString : String;
		public var regFunction : String;
		public var regObj : String;
		public var regObjToString : String;
		
		public function get fileName() : String
		{
			if (fullFileName)
			{
				for (var l : int = fullFileName.length - 1 ; l >= 0 ; l--)
				{
					var char : String = fullFileName.charAt(l);
					//trace(char);
					if (char == "\\" || char == "/" || char == "[")
					{
						return (fullFileName.slice(l+1));
					}
				}
				
			}
			
			return fullFileName;
		}

			
		public function dispose():void
		{
			fullFileName = null;
			content = null;
			atFunction = null;
			
			eventIdString = null;
			regFunction = null;
			regObj = null;
			regObjToString = null;
			
		}
		
	}

}