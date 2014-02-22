package CallbackUtil
{
	/**
	 * ...
	 * @author blueshell
	 */
	public class CallBackObj
	{
		
		public var obj : Object;
		public var func : Function;
		
		CONFIG::DEBUG
		{
			internal var functionCallStack:Array = [];
			
			internal function get functionCall() : FunctionCall { return FunctionCall(functionCallStack[0]); }
		} 
		
		public function CallBackObj(_func : Function , _obj : Object) 
		{
			func = _func;
			obj = _obj;
		}
		
		public function dispose()
		: void {
			func = null;
			obj = null;
			CONFIG::DEBUG
			{
				for each (var functionCall : FunctionCall in functionCallStack)
				{
					functionCall.dispose();
				}
				functionCallStack = null;
			}
		}
		
		CONFIG::DEBUG {
			public function toString()
			: String {
				return "CallBackObj obj=" + obj + "func =" + func;
				
			}
		
		}
		
	}

}