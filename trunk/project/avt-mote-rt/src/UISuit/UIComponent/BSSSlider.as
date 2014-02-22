package   UISuit.UIComponent   {  
	

	import flash.ui.Mouse;
	import UISuit.UIUtils.GraphicsUtil;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
	


	public class BSSSlider extends Sprite
	{
		
		private var m_thumbList : Array  = new Array();
		private var m_left : int;
		private var m_right : int;
		
		private var m_min : Number;
		private var m_max : Number;
		
		private  var m_isHorizontal : Boolean;

		
		public var dragFunction : Function;
		public var changeFunction : Function;
		
		private var m_bgData : DisplayObject;

		  public function activate() 
             : void {
                    mouseChildren = true;
                    mouseEnabled = true;
                    for each (var btn : BSSButton in m_thumbList)
                        btn.activate() 
             }

             public function deactivate() 
             : void {
                    mouseChildren = false;
                    mouseEnabled = false;  
                    for each (var btn : BSSButton in m_thumbList)
                        btn.deactivate() 
             }

             
		public function BSSSlider(bgData : DisplayObject  = null , thumbData : DisplayObject  = null , isHorizontal : Boolean = true, __left : Number = NaN, __right : Number = NaN , min : Number = 0, max : Number = 0) 
		{
			m_isHorizontal = isHorizontal;
			m_bgData = bgData;
			if (m_bgData) 
				this.addChild (m_bgData) ;
				
			if (isNaN(__left ))
				m_left = this.getRect(this).left;
			else
				m_left = __left;
				
			if (isNaN(__right))
				m_right = this.getRect(this).right;
			else
				m_right = __right;

			
			m_min = min;
			m_max = max;
			
			if (thumbData)
				addAThumb ( (thumbData is BSSButton) ? BSSButton(thumbData) :  new BSSButton (DisplayObjectContainer(thumbData)));
			
		}
		
		public function addAThumb ( thumbBtn : BSSButton )
		: void {
			m_thumbList.push(thumbBtn);
			//ASSERT(thumbBtn.areaArray == null , "add a error button with aeraArray");
			thumbBtn.setAreaArray(m_thumbList);
			
			addChild(thumbBtn);
			thumbBtn.pressFunction = BSSSlider_onBSSSliderThumbClick;
			//NO CALLBACK
			//thumbBtn.releaseFunction = function(btn:BSSButton):void {btn.stopDrag();}
				
				
			//
			 
			{
				thumbBtn.y = 0 ;
				thumbBtn.x = m_right ;
			}
			 
			 
			 
			 
			 
		}
		
		
		
		public override function set width ( newWidth : Number)
		: void {
		       
			if (m_bgData)
				m_bgData.width = newWidth;
			m_right = m_left + newWidth;
			for each (var thumbBtn : BSSButton in m_thumbList)
				if (thumbBtn.x > m_right)
					thumbBtn.x = m_right;
		}
		
		public function setThumbValue ( thumbIndex : int , newValue : Number , ignoreCallback: Boolean = false)
		: void {
			CONFIG::ASSERT {
			    ASSERT(m_max != m_min , "min and max must be different when use set value")
				ASSERT(thumbIndex >= 0 && thumbIndex < m_thumbList.length , "error thumb index");
			}
			if (thumbIndex >= 0 && thumbIndex < m_thumbList.length)
			{
				 
				m_thumbList[thumbIndex].x = (newValue - m_min ) * (m_right - m_left) / (m_max - m_min) + m_left;
				if (!ignoreCallback && changeFunction != null)
					changeFunction(this);
			}
		}
		
		public function getThumbValue(  thumbIndex : int ) : Number
		{
			CONFIG::ASSERT {
				ASSERT(thumbIndex >= 0 && thumbIndex < m_thumbList.length , ("error index "));
			}
			if (thumbIndex >= 0 && thumbIndex < m_thumbList.length)
			{
				return ( (m_max - m_min) * (m_thumbList[thumbIndex].x - m_left) / (m_right - m_left) + m_min );
			}
			else
				return(m_min);
		}
		
		public function setThumbPos ( thumbIndex : int , newPos : int , bound : Boolean = true)
		: void {
			CONFIG::ASSERT {
			ASSERT(thumbIndex >= 0 && thumbIndex < m_thumbList.length , "error thumb index");
			}
			if (thumbIndex >= 0 && thumbIndex < m_thumbList.length)
			{
				 
				if (bound)
				{
				
        				var leftBound : Number = (thumbIndex > 0 ) ? m_thumbList[thumbIndex - 1].x : m_left;
        				var rightBound : Number = (thumbIndex + 1 < m_thumbList.length) ? m_thumbList[thumbIndex + 1].x : m_right;
        				
        				m_thumbList[thumbIndex].x = Math.max(leftBound, Math.min(newPos , rightBound));
				}
				else
					m_thumbList[thumbIndex].x = newPos;
				
				if (changeFunction != null)
					changeFunction(this);		
			}
		}

		public function getThumbPos ( thumbIndex : int )
		 : int {
		 CONFIG::ASSERT {
			 ASSERT( (thumbIndex >= 0 && thumbIndex < m_thumbList.length) , "error index " + thumbIndex+" of " + m_thumbList.length)
		 }
			if (thumbIndex >= 0 && thumbIndex < m_thumbList.length)
			{
				return m_thumbList[thumbIndex].x ;
			}
			else
				return(-1);
		}
		
		
		private function getDragRect(btn : BSSButton ) : Rectangle
		{
			var btnIndex : int = m_thumbList.indexOf(btn);
			CONFIG::ASSERT {
			ASSERT(btnIndex != -1 && this.contains(btn) , "error button of Slider");
			}
			var left : Number = (btnIndex == 0) ? m_left : m_thumbList[btnIndex - 1].x;
			var lastIndex : int = m_thumbList.length - 1;
			return new Rectangle ( left , btn.y 
				,(btnIndex == lastIndex) ? m_right : m_thumbList[btnIndex + 1].x 
				,0);
			
		}

		public function dispose()
		: void {
		    GraphicsUtil.removeAllChildren(this);
		    var leng : int;
            if(  m_thumbList  ){    leng   =   m_thumbList  .length;  { while(  leng  --)   { if (   m_thumbList  [  leng  ] ) {   m_thumbList  [  leng  ] .dispose();    m_thumbList  [  leng  ]  = null;} ;}};   m_thumbList   = null; } ;
		    dragFunction = null;
		    changeFunction = null;
			m_bgData = null;
		}

		public static function createSimpleBSSSlider ( isHorizontal : Boolean = true, _btn:BSSButton = null , __left : Number = NaN, __right : Number = NaN , min : Number = 0, max : Number = 0 )
		: BSSSlider {
				
				/*
				var g : Graphics = shape.graphics;
				g.lineStyle(2, 0, 1);
				g.moveTo( -2, -10);
				g.lineTo( -2, 10);
				g.lineStyle(2, 0, 0.5);
				g.moveTo( +2, -10);
				g.lineTo( +2, 10);
				*/
				
				if (!_btn)
				{
					var shape : Shape = new Shape();
					GraphicsUtil.DrawRect(shape.graphics , -6 , -12 , 12 , 24 , 0xFFCCCC , 0.8);
					var btnCtar : Sprite = new Sprite();
					btnCtar.addChild(shape);
					_btn = new BSSButton(btnCtar);
				}
				
				var bgData : Shape ;
				if (!isNaN(__left) && !isNaN(__right))
				{ 
					bgData = new Shape();
					bgData.graphics.lineStyle(2, 0 , 0.5);
					bgData.graphics.moveTo(__left , 0);
					bgData.graphics.lineTo(__right , 0);
				}

				return new BSSSlider(bgData , _btn , isHorizontal, __left, __right , min , max ) ;
		}


        public static function BSSSlider_init()
        : void {           }

         public static function BSSSlider_dispose()
        : void {  BSSSlider.s_BSSSlider_FocusBSSSlider = null;         }

        
		private  static var s_BSSSlider_FocusBSSSlider : BSSSlider;
		public var focusBSSSliderBtnIndex : int = -1;
      
        private static function BSSSlider_onBSSSliderThumbClick ( btn : BSSButton  )
        : void { 
			CONFIG::ASSERT {
			ASSERT(btn.parent is BSSSlider , "error scroll bar");
			}
			BSSSlider_setFocusBSSSlider( BSSSlider(btn.parent));
			CONFIG::ASSERT {
			ASSERT(s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex == -1 , "forget reset");
			}
			s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex = s_BSSSlider_FocusBSSSlider.m_thumbList.indexOf(btn);
			CONFIG::ASSERT {
			ASSERT(s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex != -1 , "error btn!!");
			}
			//NO CALLBACL
			btn.startDrag(false , BSSSlider(btn.parent).getDragRect(btn));
			//
			//MouseManager.setDragingObject(btn , BSSSlider(btn.parent).getDragRect(btn), false);
			 
		}
			
		
		public static function BSSSlider_setFocusBSSSlider(fBSSSlider_FocusBSSSlider : BSSSlider)
		: void {
			
			if (!s_BSSSlider_FocusBSSSlider) //��Ϊ�� ��ǰ��ӹ� ��ûɾ��
			{
				//fBSSSlider_FocusBSSSlider.addEventListener(MouseEvent.MOUSE_MOVE , BSSSlider_onFocusBSSSliderThumbMouseMove);
				//fBSSSlider_FocusBSSSlider.addEventListener(MouseEvent.MOUSE_UP , BSSSlider_onFocusBSSSliderThumbMouseUp);
				
				import CallbackUtil.CallbackCenter;
				import configer.CALLBACK;
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , BSSSlider_onFocusBSSSliderThumbMouseMove_CB);
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_UP , BSSSlider_onFocusBSSSliderThumbMouseUp_CB);
			}
			s_BSSSlider_FocusBSSSlider = fBSSSlider_FocusBSSSlider;
		}
		private static function BSSSlider_onFocusBSSSliderThumbMouseMove_CB(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			BSSSlider_onFocusBSSSliderThumbMouseMove(args as MouseEvent);
			return 0;
		}
		private static function BSSSlider_onFocusBSSSliderThumbMouseUp_CB(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			BSSSlider_onFocusBSSSliderThumbMouseUp(args as MouseEvent);
			return 0;
		}
		
		
		private static function BSSSlider_onFocusBSSSliderThumbMouseMove(e : MouseEvent): void
		 {
			 if (s_BSSSlider_FocusBSSSlider)
			 {
				if (s_BSSSlider_FocusBSSSlider.dragFunction != null)
					s_BSSSlider_FocusBSSSlider.dragFunction(s_BSSSlider_FocusBSSSlider);
			 }
			 else
			 {   
				BSSSlider_onFocusBSSSliderThumbMouseUp(e);
			 }
			//return CallBackMgr.EVENT_OK;
		}
		
		private static function BSSSlider_onFocusBSSSliderThumbMouseUp(e : MouseEvent): void
		 {
		
			if (s_BSSSlider_FocusBSSSlider)
			{
				s_BSSSlider_FocusBSSSlider.m_thumbList[s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex].stopDrag();
				
				if (s_BSSSlider_FocusBSSSlider.dragFunction != null)
					s_BSSSlider_FocusBSSSlider.dragFunction(s_BSSSlider_FocusBSSSlider);
				if (s_BSSSlider_FocusBSSSlider.changeFunction != null)
					s_BSSSlider_FocusBSSSlider.changeFunction(s_BSSSlider_FocusBSSSlider);	
		
				
				//s_BSSSlider_FocusBSSSlider.removeEventListener(MouseEvent.MOUSE_MOVE , BSSSlider_onFocusBSSSliderThumbMouseMove);
				//s_BSSSlider_FocusBSSSlider.removeEventListener(MouseEvent.MOUSE_UP , BSSSlider_onFocusBSSSliderThumbMouseUp);
				
				import CallbackUtil.CallbackCenter;
				import configer.CALLBACK;
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , BSSSlider_onFocusBSSSliderThumbMouseMove_CB);
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_UP , BSSSlider_onFocusBSSSliderThumbMouseUp_CB);
			  
				s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex = -1;
				s_BSSSlider_FocusBSSSlider = null;
			}
			//return CallBackMgr.EVENT_OK;
		}
		/////////////////////////////////////////////////
		//public static function BSSSlider_setFocusBSSSlider(fBSSSlider_FocusBSSSlider : BSSSlider)
		//: void {
			
		//	if (!s_BSSSlider_FocusBSSSlider) //��Ϊ�� ��ǰ��ӹ� ��ûɾ��
		//	{
		//		CallBackMgr.registerCallBack(CALLBACK.STAGE_MOUSE_MOVE , BSSSlider_onFocusBSSSliderThumbMouseMove);
		//		CallBackMgr.registerCallBack(CALLBACK.STAGE_MOUSE_UP , BSSSlider_onFocusBSSSliderThumbMouseUp);
		//	}
		//	s_BSSSlider_FocusBSSSlider = fBSSSlider_FocusBSSSlider;
		//}
		
		//TODO
		//private static function BSSSlider_onFocusBSSSliderThumbMouseMove(evtId : int, e : Object , senderInfo : Object , registerObj:Object): int
		// {
		//	 if (s_BSSSlider_FocusBSSSlider)
		//	 {
		//		if (s_BSSSlider_FocusBSSSlider.dragFunction != null)
		//			s_BSSSlider_FocusBSSSlider.dragFunction(s_BSSSlider_FocusBSSSlider);
		//	 }
		//	 else
		//	 {   
		//		BSSSlider_onFocusBSSSliderThumbMouseUp(CALLBACK.STAGE_MOUSE_UP , e , senderInfo , registerObj);
		//	 }
		//	 return CallBackMgr.EVENT_OK;
		//}
		//
		//private static function BSSSlider_onFocusBSSSliderThumbMouseUp(evtId : int, e : Object , senderInfo : Object , registerObj:Object): int
		// {
		
		//	if (s_BSSSlider_FocusBSSSlider)
		//	{
		//		s_BSSSlider_FocusBSSSlider.m_thumbList[s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex].stopDrag();
		//		
		//		if (s_BSSSlider_FocusBSSSlider.dragFunction != null)
		//			s_BSSSlider_FocusBSSSlider.dragFunction(s_BSSSlider_FocusBSSSlider);
		//		if (s_BSSSlider_FocusBSSSlider.changeFunction != null)
		//			s_BSSSlider_FocusBSSSlider.changeFunction(s_BSSSlider_FocusBSSSlider);	
		//
		//		CallBackMgr.unregisterCallBack(CALLBACK.STAGE_MOUSE_MOVE , BSSSlider_onFocusBSSSliderThumbMouseMove);
		//		CallBackMgr.unregisterCallBack(CALLBACK.STAGE_MOUSE_UP , BSSSlider_onFocusBSSSliderThumbMouseUp);
		//		
		//	  
		//		s_BSSSlider_FocusBSSSlider.focusBSSSliderBtnIndex = -1;
		//		s_BSSSlider_FocusBSSSlider = null;
		//	}
		//	return CallBackMgr.EVENT_OK;
		//}
		
		
		
	}
	
}
