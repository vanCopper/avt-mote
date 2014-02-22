package CallbackUtil 
{
	/**
	 * ...
	 * @author blueshell
	 */
	public class CallbackDym
	{
		public static var s_callbackDymFlag : int;
		private static var infoArray : Array = [];
		public static function init() : void 
		{
			if (!infoArray)
				infoArray = null;
		}
		
		public static function dispose() : void 
		{
			if (infoArray)
			{	
				infoArray.length = 0;
				infoArray = null;
			}
		}
		
		
		public static function getCallbackDymIndex(str : String) : int  
		{
			var idx : int = infoArray.indexOf(str);
			if (idx == -1)
			{
				infoArray.push(str);
				return (infoArray.length - 1) | s_callbackDymFlag;
			}
			else
				return (idx | s_callbackDymFlag);
		}
		
	}

}