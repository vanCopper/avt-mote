package CallbackUtil {
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

    
    public class CallbackCenter
	{
		
		public static const EVENT_OK : int = 0;
		
		private static var CALLBACK_ENTER_FRAME : int;
		private static var CALLBACK_STAGE_MOUSE_DOWN : int;
		private static var CALLBACK_STAGE_MOUSE_UP : int;
		private static var CALLBACK_STAGE_MOUSE_MOVE : int;
		private static var CALLBACK_STAGE_MOUSE_WHEEL : int;
		private static var CALLBACK_STAGE_MOUSE_LEAVE : int;
		
		private static var CALLBACK_STAGE_MOUSE_DOWN_CAPTURE : int;
		private static var CALLBACK_STAGE_MOUSE_UP_CAPTURE : int;
		
		private static var CALLBACK_KEY_DOWN : int;
		private static var CALLBACK_KEY_UP : int;
		
		private static var s_CallbackCenter_Dict : Dictionary;
		
		
		
		public static function notifyEvent (evtId : int , args : Object = null , senderInfo : Object = null)
		: void {
			CONFIG::ASSERT {ASSERT(evtId > 0 /*&& evtId < CALLBACK_CALLBACK_MAX*/ , "errorEventId" + evtId);}

			var CallbackCenter_CallBackList : Array  = s_CallbackCenter_Dict[evtId];
			
			if (CallbackCenter_CallBackList)
			{     
				var callBackFunc : CallBackObj;

				for (var i : int = 0 ; i < CallbackCenter_CallBackList.length;)
				{
					callBackFunc = CallBackObj(CallbackCenter_CallBackList[i]);
					callBackFunc.func(evtId , args , senderInfo , callBackFunc.obj );
					
					if (i < CallbackCenter_CallBackList.length && callBackFunc == CallbackCenter_CallBackList[i]) //not delete it self
						i++;
				}
				CallbackCenter_CallBackList = null;
			 }
		}
		
		public static function getCallBackIndex(evtId : int , callBackFunc : Function , obj : Object = null)
		: int {
			if (!s_CallbackCenter_Dict)
			{
				CONFIG::ASSERT {
					ASSERT(false , 	"CallbackCenter is dispose already when CallbackCenter_unregisterCallBack " );
				}
				return -1;
			}
			
			
			CONFIG::ASSERT {
				ASSERT(s_CallbackCenter_Dict[evtId] , "eventId List is Empty"  );
			}
			
			var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
			var funcIndex : int =  -1;
			
			var i : int = 0;
			for each (var cb : CallBackObj in CallBackList)
			{
				if ((cb.func == callBackFunc) && (cb.obj == obj))
				{
					funcIndex = i;
					break;
				}
				i++;
			}
			CONFIG::ASSERT {
				ASSERT (funcIndex != -1 , "has not register this function !!" );
			}
			return funcIndex;
		}

		public static function registerCallBackAt(evtId : int , callBackFunc : Function , obj : Object , funcIndex : int)
		:void {
			CONFIG::ASSERT {
				ASSERT(evtId > 0 /*&& evtId < CALLBACK_CALLBACK_MAX*/ , "errorEventId" + evtId);	
				ASSERT(callBackFunc != null && callBackFunc.length == 4 , 
				"function should be function callbackFunc(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int");
			}
			
			if (s_CallbackCenter_Dict[evtId] == null)	{	s_CallbackCenter_Dict[evtId] = new Array();}
			var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
			
			var newCALLBACK : CallBackObj = new CallBackObj(callBackFunc , obj);
			CONFIG::DEBUG {
				
				CONFIG::ASSERT {
					for each (var cb : CallBackObj in CallBackList)
					{
						ASSERT (((cb.func != callBackFunc) || (cb.obj != obj)), "s_CallbackCenter_Dict regisiter twice !!");
					}
				}
				var callStackString : String = (new Error().getStackTrace());
				setCallBackDetailInfo(newCALLBACK , evtId , callStackString);
			}
			
			CallBackList.splice(funcIndex , 0 , newCALLBACK);

		}
		
		public static function registerCallBack(evtId : int , callBackFunc : Function , obj : Object = null)
		:void {
		
			CONFIG::ASSERT {
				ASSERT(evtId > 0 /*&& evtId < CALLBACK_CALLBACK_MAX*/ , "errorEventId" + evtId);
			}
			CONFIG::ASSERT {
				ASSERT(callBackFunc != null && callBackFunc.length == 4 , 
				"function should be function callbackFunc(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int");
			}
			if (s_CallbackCenter_Dict[evtId] == null)
			{
				s_CallbackCenter_Dict[evtId] = new Array();
			}
			var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
			var newCALLBACK : CallBackObj = new CallBackObj(callBackFunc , obj);

						
			CONFIG::DEBUG {
				CONFIG::ASSERT {
					for each (var cb : CallBackObj in CallBackList)
					{
						ASSERT (((cb.func != callBackFunc) || (cb.obj != obj)), "s_CallbackCenter_Dict regisiter twice !!");
					}
				}
				
				var callStackString : String = (new Error().getStackTrace());
				setCallBackDetailInfo(newCALLBACK , evtId , callStackString);
			}

			CallBackList.push(newCALLBACK);
		}
		
		public static function unregisterCallBack(evtId : int , callBackFunc : Function , obj : Object = null)
		:void {
			
			if (!s_CallbackCenter_Dict)
			{
				CONFIG::ASSERT {
					ASSERT(false , 	"CallbackCenter is dispose already when CallbackCenter_unregisterCallBack " );
				}
				return;
			}
			
			
			
			CONFIG::ASSERT {
				ASSERT(evtId > 0 /*&& evtId < CALLBACK_CALLBACK_MAX*/ , "errorEventId" + evtId);
				ASSERT(s_CallbackCenter_Dict[evtId] , "eventId List is Empty"  );
			}
			
			var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
			var funcIndex : int =  -1;
			
			var i : int = 0;
			for each (var cb : CallBackObj in CallBackList)
			{
				if ((cb.func == callBackFunc) && (cb.obj == obj))
				{
					funcIndex = i;
					break;
				}
				i++;
			}
			CONFIG::ASSERT {
				ASSERT (funcIndex != -1 , "has not register this function !!" );
			}
			if( funcIndex != -1)
				CallBackList.splice(funcIndex,1);
			else
			{
				CONFIG::ASSERT {
					trace( "cann't find callback the func of callback ");
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////
/*		
		private static function onOnceCallBack(evtId : int, args : Object , senderInfo : Object , registerObj:Object)
		: int {
			var _callBackObj : CallBackObj = CallBackObj(registerObj);
			var oldFunc : Function = _callBackObj.func;
			var oldObject : Object = _callBackObj.obj;
			
			var retCode : int = oldFunc(evtId , args , senderInfo , oldObject);
			
			unregisterOnceCallBack(evtId , oldFunc  , oldObject);
			
			return retCode;
		}
		
		public static function registerOnceCallBack(evtId : int , callBackFunc : Function , obj : Object = null)
			:void {
			
			CONFIG::ASSERT {
				ASSERT(evtId > 0  , "errorEventId" + evtId);
			}
			CONFIG::ASSERT {
				ASSERT(callBackFunc != null && callBackFunc.length == 4 , 
					"function should be function callbackFunc(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int");
			}
			if (s_CallbackCenter_Dict[evtId] == null)
			{
				s_CallbackCenter_Dict[evtId] = new Array();
			}
			var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
			var newCALLBACK : CallBackObj = new CallBackObj(callBackFunc , obj);
			
			newCALLBACK.obj = new CallBackObj(newCALLBACK.func , newCALLBACK.obj);
			
			
			CONFIG::DEBUG {
				CONFIG::ASSERT {
					for each (var cb : CallBackObj in CallBackList)
					{
						ASSERT (((cb.func != callBackFunc) || (cb.obj != obj)), "s_CallbackCenter_Dict regisiter twice !!");
					}
				}
				var callStackString : String = (new Error().getStackTrace());
				setCallBackDetailInfo(newCALLBACK , evtId , callStackString);
			}
			newCALLBACK.func = CallbackCenter.onOnceCallBack;
			CallBackList.push(newCALLBACK);
			
		}
		
		public static function unregisterOnceCallBack(evtId : int , callBackFunc : Function , obj : Object = null)
		:void {
			
			if (!s_CallbackCenter_Dict)
			{
				CONFIG::ASSERT {
					ASSERT(false , 	"CallbackCenter is dispose already when CallbackCenter_unregisterCallBack " );
				}
				return;
			}
			
			
			
			CONFIG::ASSERT {
				ASSERT(evtId > 0  , "errorEventId" + evtId);
				ASSERT(s_CallbackCenter_Dict[evtId] , "eventId List is Empty"  );
			}
			
			var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
			var funcIndex : int =  -1;
			
			var i : int = 0;
			var _cbExpand : CallBackObj;
			for each (var cb : CallBackObj in CallBackList)
			{
				_cbExpand = cb.obj as CallBackObj;
				if (_cbExpand)
				{
					if ((_cbExpand.func == callBackFunc) && (_cbExpand.obj == obj))
					{
						funcIndex = i;
						break;
					}
				}
				i++;
			}
			CONFIG::ASSERT {
				ASSERT (funcIndex != -1 , "has not register this function !!" );
			}
			if( funcIndex != -1)
				CallBackList.splice(funcIndex,1);
			else
			{
				CONFIG::ASSERT {
					trace( "cann't find callback the func of callback ");
				}
			}
		}
*/
		//////////////////////////////////////////////////////////////////
		
		
		private static var s_stage : Stage;
		public static function init(
			 _stage : Stage
			,_obj : Object
		) :void
		{
						
			s_stage = _stage;
			CONFIG::ASSERT{
				ASSERT(s_CallbackCenter_Dict == null && _stage != null , "re init");
			}
			
			s_CallbackCenter_Dict  = new Dictionary() ;

			

			
			CALLBACK_ENTER_FRAME 				= (_obj[Event.ENTER_FRAME] != undefined) 				? _obj[Event.ENTER_FRAME] : -1;
			
			CALLBACK_STAGE_MOUSE_DOWN 			= (_obj[MouseEvent.MOUSE_DOWN] != undefined)			? _obj[MouseEvent.MOUSE_DOWN] : -1;
			CALLBACK_STAGE_MOUSE_UP 			= (_obj[MouseEvent.MOUSE_UP] != undefined)				? _obj[MouseEvent.MOUSE_UP] : -1;
			CALLBACK_STAGE_MOUSE_MOVE 			= (_obj[MouseEvent.MOUSE_MOVE] != undefined)			? _obj[MouseEvent.MOUSE_MOVE] : -1;
			CALLBACK_STAGE_MOUSE_WHEEL			= (_obj[MouseEvent.MOUSE_WHEEL] != undefined)			? _obj[MouseEvent.MOUSE_WHEEL] : -1;
			CALLBACK_STAGE_MOUSE_LEAVE			= (_obj[Event.MOUSE_LEAVE] != undefined)				? _obj[Event.MOUSE_LEAVE] : -1;
			
			CALLBACK_STAGE_MOUSE_DOWN_CAPTURE 	= (_obj[MouseEvent.MOUSE_DOWN + "Capture"] != undefined)? _obj[MouseEvent.MOUSE_DOWN + "Capture"] : -1;
			CALLBACK_STAGE_MOUSE_UP_CAPTURE 	= (_obj[MouseEvent.MOUSE_UP + "Capture"] != undefined)	? _obj[MouseEvent.MOUSE_UP + "Capture"] : -1;
			
			CALLBACK_KEY_DOWN 					= (_obj[KeyboardEvent.KEY_DOWN] != undefined) 			? _obj[KeyboardEvent.KEY_DOWN] : -1;
			CALLBACK_KEY_UP 					= (_obj[KeyboardEvent.KEY_UP] != undefined) 			? _obj[KeyboardEvent.KEY_UP] : -1;
			
			
			
			if (CALLBACK_ENTER_FRAME >= 0)
				_stage.addEventListener(Event.ENTER_FRAME , onEnterFrame);
			if (CALLBACK_STAGE_MOUSE_DOWN >= 0)	
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown , false );
			if (CALLBACK_STAGE_MOUSE_UP >= 0)	
				_stage.addEventListener(MouseEvent.MOUSE_UP  ,	onMouseUp , false);
			if (CALLBACK_STAGE_MOUSE_MOVE >= 0)	
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			if (CALLBACK_STAGE_MOUSE_WHEEL >= 0)	
				_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel );	
			if (CALLBACK_STAGE_MOUSE_LEAVE >= 0)	
				_stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave );		
				
			if (CALLBACK_STAGE_MOUSE_DOWN_CAPTURE >= 0)	
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_Capture , true);
			if (CALLBACK_STAGE_MOUSE_UP_CAPTURE	 >= 0)	
				_stage.addEventListener(MouseEvent.MOUSE_UP  ,	onMouseUp_Capture , true);
			if (CALLBACK_KEY_DOWN	 >= 0)		
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			if (CALLBACK_KEY_UP	 >= 0)		
				_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		}								

		private static function onMouseDown			(e : MouseEvent):void {	notifyEvent(CALLBACK_STAGE_MOUSE_DOWN , e);	}
		private static function onMouseUp			(e : MouseEvent):void {	notifyEvent(CALLBACK_STAGE_MOUSE_UP , e)  ;}
		private static function onMouseDown_Capture	(e : MouseEvent):void {	notifyEvent(CALLBACK_STAGE_MOUSE_DOWN_CAPTURE , e);}
		private static function onMouseUp_Capture	(e : MouseEvent):void {	notifyEvent(CALLBACK_STAGE_MOUSE_UP_CAPTURE , e)  ;}
		private static function onMouseMove			(e : MouseEvent):void {	notifyEvent(CALLBACK_STAGE_MOUSE_MOVE , e); }
		private static function onMouseWheel		(e : MouseEvent):void {	notifyEvent(CALLBACK_STAGE_MOUSE_WHEEL , e); }
		private static function onMouseLeave		(e : Event)		:void {	notifyEvent(CALLBACK_STAGE_MOUSE_LEAVE , e); }
		private static function onEnterFrame		(e : Event)		:void {	notifyEvent(CALLBACK_ENTER_FRAME , e); }
	
		
		private static function onKeyDown			(e : KeyboardEvent) :void {	notifyEvent(CALLBACK_KEY_DOWN , e);}
		private static function onKeyUp				(e : KeyboardEvent)	:void {	notifyEvent(CALLBACK_KEY_UP , e); }
		
		
		public static function dispose()
		:void {
			var leng : int;
			if (s_CallbackCenter_Dict)
			{
				
				var _CallbackCenter_Dict_arr : Array
				/*
				for (var i : Object in s_CallbackCenter_Dict)
				{
					if (s_CallbackCenter_Dict[i])
					{    
						_CallbackCenter_Dict_arr = s_CallbackCenter_Dict[i] as Array;
						leng  = s_CallbackCenter_Dict_arr.length;  
						{ 
							while (  leng --)   
							{
								_CallbackCenter_Dict_arr[leng].dispose();
								_CallbackCenter_Dict_arr[leng] = null; 
							}
						}
					}; 
					s_CallbackCenter_Dict[i] = null;
				} 
				*/
				
				
				for each (_CallbackCenter_Dict_arr in s_CallbackCenter_Dict)
				{
					//trace (_CallbackCenter_Dict_arr)
					{
						leng  = _CallbackCenter_Dict_arr.length;  
						{ 
							while (  leng --)   
							{
								_CallbackCenter_Dict_arr[leng].dispose();
								_CallbackCenter_Dict_arr[leng] = null; 
							}
						}
					};
				} 
				
			}
			s_CallbackCenter_Dict = null;
			
			
			if (s_stage)
			{
				if (CALLBACK_ENTER_FRAME >= 0)
					s_stage.removeEventListener(Event.ENTER_FRAME , onEnterFrame);
				if (CALLBACK_STAGE_MOUSE_DOWN >= 0)	
					s_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown , false );
				if (CALLBACK_STAGE_MOUSE_UP >= 0)	
					s_stage.removeEventListener(MouseEvent.MOUSE_UP  ,	onMouseUp , false);
				if (CALLBACK_STAGE_MOUSE_MOVE >= 0)	
					s_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
				if (CALLBACK_STAGE_MOUSE_WHEEL >= 0)	
					s_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel );		
				if (CALLBACK_STAGE_MOUSE_LEAVE >= 0)	
					s_stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave );	
				
				if (CALLBACK_STAGE_MOUSE_DOWN_CAPTURE >= 0)	
					s_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_Capture , true);
				if (CALLBACK_STAGE_MOUSE_UP_CAPTURE >= 0)	
					s_stage.removeEventListener(MouseEvent.MOUSE_UP  ,	onMouseUp_Capture , true);
				
				if (CALLBACK_KEY_DOWN	 >= 0)		
					s_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				if (CALLBACK_KEY_UP	 >= 0)		
					s_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				
				s_stage = null;
			}
			
			
			CONFIG::DEBUG
			{
				FileStringInfoMgr.dispose();
			}
		}
		
		
		
		CONFIG::DEBUG {
		public static function setCallBackDetailInfo(newCALLBACK : CallBackObj , eventId : int , callStackString : String )
		: void {
				callStackString = callStackString.slice(6); //remove error
				var callArray : Array = callStackString.split("\tat ");
				var isLast:Boolean = false;
				
				var functionCallStack:Array = [];
				
				for each (var callStackLineString : String in callArray)
				{	
					var lastIndexOfLK : int = callStackLineString.indexOf("[");
					if ( lastIndexOfLK != -1)
					{	
						if (!isLast)
						{
							isLast = true;
							continue;
						}
						var functionCall : FunctionCall = new FunctionCall();
						
						functionCall.eventId = eventId;
						functionCall.regObjToString = 	"" + newCALLBACK.obj;
						
						functionCallStack.push(functionCall);
						
						var lastIndexOfS : int =  callStackLineString.lastIndexOf(":");
						
						functionCall.fileLine = int(callStackLineString.slice(lastIndexOfS + 1 , callStackLineString.lastIndexOf("]")));
						functionCall.atFunction =  callStackLineString.slice(0, lastIndexOfLK);
						functionCall.fullFileName = (callStackLineString.slice(lastIndexOfLK + 1 , lastIndexOfS ));						
						//trace(functionCall.fileLine , functionCall.atFunction , functionCall.fullFileName );
						FileStringInfoMgr.setFileContent(functionCall);
						
					
					}
					
					newCALLBACK.functionCallStack = functionCallStack;
				}
			}
			
			public static function printCallBack(evtId : int)
			: void {
				CONFIG::ASSERT {
					ASSERT(evtId >= 0 /*&& evtId < CALLBACK_CALLBACK_MAX*/ , "errorEventId" + evtId);
				}
				
				var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
				if (!CallBackList)
				{
					trace("no");
				}
				else
				{
					for each (var cbo : CallBackObj in CallBackList)
					{
						var functionCall  : FunctionCall = cbo.functionCall;
						trace(functionCall.fileName , functionCall.atFunction , functionCall.regFunction , functionCall.content);
						
					}
				}
			}
			
			public static function getCallBackInfoArray(evtId : int)
			: Array {
				CONFIG::ASSERT {
					ASSERT(evtId >= 0 /*&& evtId < CALLBACK_CALLBACK_MAX*/ , "errorEventId" + evtId);
				}
				
				var CallBackList : Array  = s_CallbackCenter_Dict[evtId] as Array;
				if (!CallBackList)
				{
					return null;
				}
				else
				{
					var ret : Array = [];
					for each (var cbo : CallBackObj in CallBackList)
					{
						var functionCall  : FunctionCall = cbo.functionCall;
						ret.push(functionCall);
						//trace(functionCall.fileName , functionCall.atFunction , functionCall.regFunction , functionCall.content);
						
					}
					
					return ret;
				}
			}
		}
    }
}


CONFIG::DEBUG
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import CallbackUtil.*;
	
	class FileStringInfoMgr {
		private static var fileStringArray : Array = [];
		private static var functionCallArray : Array = [];
		internal static function onNewFileInfoLoaded(fsi : FileStringInfo )
		: void {
			if (functionCallArray)
			for (var i : int = 0 ; i < functionCallArray.length; )
			{
				var functionCall : FunctionCall =  FunctionCall(functionCallArray[i]);
				
				if (functionCall.fullFileName == fsi.fullFileName )
				{
					if (fsi.fileStringLineArray)
					{
						var content :String = 	fsi.fileStringLineArray[functionCall.fileLine - 1].replace("\r" , "");;
						//functionCall.content = 	functionCall.content
						
						
						for (var tabI : int = 0 ; tabI < content.length ; tabI++)
						{
							if (content.charAt(tabI) != "\t" && content.charAt(tabI) != ' ')
								break;
						}
						if (tabI)
							content= content.slice(tabI);
						functionCall.content = content;
						
						if (functionCall.content.indexOf("register") != -1)
						{
							if (functionCall.content.indexOf("registerCallBack") != -1 || functionCall.content.indexOf("registerOnceCallBack") != -1)
							{
								var contentString  : String = functionCall.content.slice(functionCall.content.indexOf("(") + 1 , functionCall.content.lastIndexOf(")"));
								var contentStringArray : Array = contentString.split(/[\s]*,[\s]*/);
							
								functionCall.eventIdString = contentStringArray[0];
								functionCall.regFunction = contentStringArray[1];
							
								if (contentStringArray.length >=3)
									functionCall.regObj = contentStringArray[2];
							}
							
							
						}
					}
					else
					{
						functionCall.eventIdString  = "****error****";
						functionCall.regFunction = "****error****";
						functionCall.regObj = "****error****";
					}
					//trace(functionCall.content +":"+ functionCall.eventId  +":"+ functionCall.regFunction +":"+ functionCall.regObj);
					//trace(functionCallArray.length);
					functionCallArray.splice(functionCallArray.indexOf(functionCall) , 1);
					//trace(functionCallArray.length);
				}
				else
				{
					i++;
				}
				
			}
		}

		
		public static function setFileContent(functionCall : FunctionCall)
		: void 
		{
			//trace("setFileContent")
			for each(var fsi : FileStringInfo in fileStringArray)
			{	
				//trace(functionCall.fullFileName , fsi.fullFileName)
				if (functionCall.fullFileName == fsi.fullFileName)
				{
					if (fsi.fileStringLineArray && fsi.fileStringLineArray.length)
					{
						functionCall.content = fsi.fileStringLineArray[functionCall.fileLine - 1];
						return;
					}
					else
					{
						functionCallArray.push(functionCall); //alreay loading
						return;
					}
					
				}
			}

			functionCallArray.push(functionCall);
			fsi = new FileStringInfo(functionCall.fullFileName);
			fileStringArray.push(fsi);
			
		}

		
		public static function dispose():void
		{
			if (fileStringArray)
			{
				for each(var fsi : FileStringInfo in fileStringArray)
				{	
					fsi.dispose();
				}
				fileStringArray.length = 0;
				fileStringArray = null;
			}
			
			if (functionCallArray)
			{
				functionCallArray.length = 0;
				functionCallArray = null;
			}
			
			
		}
	}
	
	class FileStringInfo {
		
		internal var fileStringLineArray : Array;
		internal var fullFileName : String;
		private var urlLoader : URLLoader;
		public function FileStringInfo (_fullFileName : String)
		{
			fullFileName = _fullFileName;
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE , onLoadFileComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileIoError);
			urlLoader.load(new URLRequest(fullFileName));
		}
		private function onLoadFileIoError(e:Event):void
		{
			trace(e);
			if (urlLoader)
			{
				if (urlLoader.hasEventListener(Event.COMPLETE ))
				{	
					urlLoader.removeEventListener(Event.COMPLETE , onLoadFileComplete);
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFileIoError);
				}
				urlLoader = null;
			}
			FileStringInfoMgr.onNewFileInfoLoaded(this);
		}
		private function onLoadFileComplete(e:Event):void
		{
			if (urlLoader)
			{
				if (urlLoader.hasEventListener(Event.COMPLETE ))
				{	
					urlLoader.removeEventListener(Event.COMPLETE , onLoadFileComplete);
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFileIoError);
				}
				urlLoader = null;
			}
			
			var fileString : String = (e.target.data);
			fileStringLineArray = fileString.split("\n");
			
			FileStringInfoMgr.onNewFileInfoLoaded(this);

		}
		
		internal function dispose():void
		{
			if (fileStringLineArray)
			{
				fileStringLineArray.length = 0;
				fileStringLineArray = null;
			}
			
			if (urlLoader)
			{
				if (urlLoader.hasEventListener(Event.COMPLETE))
				{
					urlLoader.removeEventListener(Event.COMPLETE , onLoadFileComplete);
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFileIoError);

				}
				try {
					urlLoader.close();
				} catch(e:Error) {}
				
				urlLoader = null;
			}
			
		}
	}
	
}
