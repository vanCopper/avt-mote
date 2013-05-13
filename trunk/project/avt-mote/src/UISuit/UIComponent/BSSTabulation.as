package   UISuit.UIComponent   {  
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import UISuit.UIUtils.GraphicsUtil;


	public class BSSTabulation extends Sprite
	{
		 
		 
		private var m_TextFieldTotalSp : Sprite = new Sprite();
		private var m_TextFieldSp : Sprite = new Sprite();
		 
		private var m_TextFieldStyleList : Array  = new Array();
		 
		private var m_tabulationTextFieldList : Array   = new  Array();
		 
		private  var m_stringList : Array; 
		 
		private var m_tabulationHeight : int;
		 
		private var m_tabulationColumnWidthList   : Array = new Array ();
		 
		private var m_bgData : DisplayObject;
		private var m_selectBg : DisplayObject;
		
		private var m_translate : int;

		public var selectFunction : Function;  

         public function set translate ( __translate : int  )
         : void {
                if (m_selectBg)
                    m_selectBg.y += (m_translate - __translate);
                m_translate = __translate;
                updateDisplay();
         }

         public function activate() : void {
			mouseChildren =
			mouseEnabled = true;

            if (m_selectBg && !hasEventListener(MouseEvent.MOUSE_DOWN))
                addEventListener(MouseEvent.MOUSE_DOWN , onSelect);
		}					
		public function deactivate() : void {
			mouseChildren = 
			mouseEnabled = false;

            if (m_selectBg && hasEventListener(MouseEvent.MOUSE_DOWN))
                removeEventListener(MouseEvent.MOUSE_DOWN , onSelect);
		}


		public static function createSimpleBSSTabulation (tabulationHeight : int , totalHeight : int = 1 , selectble : Boolean = false )
		: BSSTabulation {
			
			var bgShape : Shape = new Shape();
			GraphicsUtil.DrawRect(bgShape.graphics, 0 , 0 , 1, 1 , 0xFFFFFF );

            if (selectble)
            {
                var selectBg : Shape = new Shape();
                GraphicsUtil.DrawRect(selectBg.graphics, 0 , 0 , 1, tabulationHeight , 0x9999FF );

            }
			
			return new BSSTabulation( tabulationHeight ,totalHeight, bgShape , selectBg);
			
			// null;
		}

		private function freeStringData ()
		: void {
			var i : int ;
			var leng2 : int ;
			if (m_stringList )
			{
				var leng : int = m_stringList.length;
				for  (i = 0 ; i < leng; i ++ )
				{
					if( m_stringList[i]  ){    leng2  =  m_stringList[i]  .length;  { while(  leng2 --)   {  m_stringList[i]  [  leng2 ] = null;}};  m_stringList[i]   = null; } 
				}
				m_stringList = null;
			}
			
			if(m_tabulationTextFieldList)
			{
				var rowNum : int = m_tabulationTextFieldList.length;
				var colNum : int = m_tabulationColumnWidthList.length;
				var contentString : String;
				for ( i = 0 ; i < rowNum ; i++ )
				{	
					for (var k : int = 0 ; k < colNum ; k++ )
					{
						
						m_tabulationTextFieldList[i][k].text = "";
					}
				}
				
			}
			
		}
		 
		public function initStringData ( iRow : int)
		: void {
			
			var i : int ;
			var j : int ;
			freeStringData();
			m_stringList = new  Array(iRow); 
			for (i = 0 ; i < iRow; i ++ )
				m_stringList[i] = new Array(m_tabulationColumnWidthList.length);
		}
		
		 
		public function updateDisplay()
		: void {
		        if (!m_stringList)
		            return;
			var firstText : int = m_translate / m_tabulationHeight;
			m_TextFieldSp.y = -(m_translate % m_tabulationHeight);
			
			var rowNum : int = Math.min(m_tabulationTextFieldList.length , m_stringList.length - firstText );
			var colNum : int = m_tabulationColumnWidthList.length
                    var contentString : String;
			for (var i : int = 0 ; i < rowNum ; i++ )
			{
			      if ( i + firstText >= m_stringList.length )
			        contentString = "";
			      else
			        contentString = null;
			        
				for (var k : int = 0 ; k < colNum ; k++ )
				{
				 
					if (m_tabulationTextFieldList[i][k].text !== m_stringList[i + firstText][k])  
					{	
						m_tabulationTextFieldList[i][k].text = 
							contentString == null ? 
							(m_stringList[i + firstText][k] ? m_stringList[i + firstText][k]  : "null")
							: contentString;
						
						//TODO
						//	Text_Util.Text_Util_setTextWithFormat(m_tabulationTextFieldList[i][k] , 
						//contentString == null ? 
						//(m_stringList[i + firstText][k] ? m_stringList[i + firstText][k]  : "null")

						//: contentString
					//)	;
					}
				}
			}
		}
		 
		public function setAStringData ( ix : int , iy : int , data : String  , bUpdateDisplay : Boolean = true)
		: void {
			CONFIG::ASSERT {	
			ASSERT(m_stringList && iy < m_stringList.length && m_stringList[0] && ix < m_stringList[0].length , "string is not inited");
			}
			m_stringList[iy][ix] = data;
			
			 
			
			if (bUpdateDisplay)
				updateDisplay();
			
			 
		}


     public function getStringData()
     :  Array {
        return m_stringList;
     }

		
		 
		public function setStringData ( data : Array  , bUpdateDisplay : Boolean = true)
		: void {
            if (!data)
            {    
                freeStringData();
                return;
            }    

            if (!m_stringList)
            {
				CONFIG::ASSERT {
                ASSERT(data.length % m_tabulationColumnWidthList.length  == 0 , "error data!!");
				}
				initStringData(data.length /m_tabulationColumnWidthList.length );
            }
                    
			CONFIG::ASSERT {   
			ASSERT(data.length == m_stringList.length * m_tabulationColumnWidthList.length , "error data!!");
			}
			var indexD :int;
			
			if(data.length >= m_stringList.length*m_tabulationColumnWidthList.length)
			{
				var leng : int = m_stringList[0].length;;
			    for each (var stringList : Array  in m_stringList )
			    {
			            for (var i : int = 0 ; i < leng ; i++)
							stringList[i] = data[indexD++];
			    }
			}
			stringList = null;
			if (bUpdateDisplay)
				updateDisplay();
		}
		 
		public function setStringRowData ( rowIndex : int ,  data : Array    , bUpdateDisplay : Boolean = true)
		: void {
			CONFIG::ASSERT {
			ASSERT(data.length == m_tabulationColumnWidthList.length && rowIndex < m_stringList.length, 
				"error data!!data.length " + data.length + " m_tabulationColumnWidthList.length " + m_tabulationColumnWidthList.length
	                    + " rowIndex " + rowIndex+ " m_stringList.length " + m_stringList.length
				);
			}
			var i:int;
			if (rowIndex < m_stringList.length)
        		{	
        		      var StringList : Array  = m_stringList[rowIndex];
        		      var tmpLeng : int = StringList.length;
    				for(i=0;i < tmpLeng ;i++)
    				{
    				    if (data[i])
    					StringList[i] = data[i];
    				}

        		}
			if (bUpdateDisplay)
				updateDisplay();
			
		}
		 
		public function setStringColumeData ( colIndex : int ,data : Array  , bUpdateDisplay : Boolean = true)
		: void {
			CONFIG::ASSERT {	
			ASSERT(data.length == m_stringList.length , "error data!!");
			}
			var row :int;
			
			if(data.length == m_stringList.length)
			{
        			for each (var StringList :  Array  in m_stringList )
        			{
        			    if (data[row] != null)
        				StringList[colIndex] = data[row++];
        		          else
        		             row++;
        			}
			}
			StringList = null;
			if (bUpdateDisplay)
				updateDisplay();
			
		}
		 
		public function BSSTabulation(  tabulationHeight : int , totalHeight : int = 1, bgData : DisplayObject = null , selectBg  : DisplayObject = null     ) 
		{
			if (bgData)
			{	
				m_bgData = bgData;
				addChild(m_bgData);
			}

			
				
			m_tabulationHeight = tabulationHeight;
           addChild(m_TextFieldTotalSp);

			

			if (selectBg)
			{
                m_selectBg = selectBg;
                m_TextFieldTotalSp.addChild(m_selectBg);
                m_selectBg.visible = false;
			}
			m_TextFieldTotalSp.addChild(m_TextFieldSp);
			
			var _mask : Shape = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0,0,bgData ? bgData.width : 1 ,totalHeight);
			_mask.graphics.endFill();
			m_TextFieldTotalSp.mask = _mask;
			addChild(_mask);
			
			height = totalHeight;

                    if (m_selectBg)
                   {     
                        addEventListener(MouseEvent.MOUSE_DOWN , onSelect);
                   }
            }
            
            private function onSelect(e : MouseEvent)
            : void {
                
                
                var firstText : int = m_translate / m_tabulationHeight;
                var localIndex : int = ((globalToLocal(new Point(e.stageX, e.stageY)).y +  (m_translate % m_tabulationHeight))
								/ m_tabulationHeight) ;
                m_selectBg.y = ( localIndex * m_tabulationHeight	) -  (m_translate % m_tabulationHeight);

                 localIndex += firstText;
                m_selectBg.visible = localIndex < (m_tabulationTextFieldList ? m_tabulationTextFieldList.length : 0);
                
                if ( selectFunction != null)  
                    selectFunction(this , localIndex  ,  (m_selectBg.visible && m_stringList && m_stringList[localIndex]) ? m_stringList[localIndex] : null );
            }

		
		 
		private function setTextFieldFormat ( textField : TextField , ix : int , iy : int  )
		: void {
			
				textField.border = true;  
				textField.x = (ix == 0) ? 0 : m_tabulationTextFieldList[iy][ix - 1].x + m_tabulationColumnWidthList[ix - 1];
				textField.width = m_tabulationColumnWidthList[ix];
				textField.y = iy * m_tabulationHeight;
				textField.height = m_tabulationHeight;
				
				if (m_TextFieldStyleList[ix])
				{	
					var tempText : TextField = m_TextFieldStyleList[ix];
					textField.defaultTextFormat = (tempText.getTextFormat());
					textField.filters = tempText.filters;
					textField.transform.colorTransform = tempText.transform.colorTransform;
					textField.selectable = tempText.selectable;
					textField.border =  tempText.border;
					
				}
			
		}

            public function get contentHeight ()
            : int {
                    return m_stringList ? m_tabulationHeight * m_stringList.length : 0;
            }
		
		 
		public override function set height ( nHeight : Number  )
		: void {
			m_bgData.height = nHeight;
			m_TextFieldTotalSp.mask.height = nHeight;
			
			
			var newRowNum : int = (nHeight + m_tabulationHeight - 1) / m_tabulationHeight;
			
			
			if (m_tabulationTextFieldList.length < newRowNum)
			{
				var colLength : int = m_tabulationColumnWidthList.length;
				CONFIG::ASSERT {
				ASSERT (m_tabulationColumnWidthList.length == m_TextFieldStyleList.length , "error text data");
				}
				var textFieldList : Array  ;//= new Vector.< TextField >(colLength);
				for (var i : int = m_tabulationTextFieldList.length ; i < newRowNum ; i++ )
				{
					textFieldList = new Array (colLength);
					m_tabulationTextFieldList.push(textFieldList);
					for (var tl : int = 0 ; tl < colLength; tl++ )
					{	
						textFieldList[tl] = new TextField();
						m_TextFieldSp.addChild(textFieldList[tl]);
						setTextFieldFormat(textFieldList[tl] , tl , i);
					}
					
				}
				
			}
			else if (m_tabulationTextFieldList.length > newRowNum)
			{
				i = m_tabulationTextFieldList.length - newRowNum;
				while (i--)
				{
					tl = newRowNum + i;
					var leng : int;
					if (m_tabulationTextFieldList[tl])
					{  
						leng = m_tabulationTextFieldList[tl].length; 
						while (leng--) 
						{ 
							m_TextFieldSp.removeChild(m_tabulationTextFieldList[tl][leng]);
							m_tabulationTextFieldList[tl][leng] = null;
						}
						m_tabulationTextFieldList[tl] = null;
					}
					m_tabulationTextFieldList.length--;
					
				}
			}
			textFieldList = null;
			CONFIG::ASSERT {
			ASSERT( (m_tabulationTextFieldList.length == newRowNum) , "error deal setTextFieldNum");
			}
		}
		
		 
		public override function set width ( nWidth : Number  )
		: void {
			 
			if (m_bgData)
			    m_bgData.width = nWidth;
			m_TextFieldTotalSp.mask.width = nWidth;

			if (m_selectBg)
			    m_selectBg.width = nWidth;
			
			 
		}
		
		 
		public function addColumnAt(columnWidth : int , nTextFormatTemplate : TextField = null , pos : int = -1 )
		: void {
			CONFIG::ASSERT {	
			ASSERT(m_TextFieldStyleList.length == m_tabulationColumnWidthList.length && (!m_tabulationTextFieldList[0] || m_TextFieldStyleList.length == m_tabulationTextFieldList[0].length) , "error data st");
			}	
			if (pos == -1)
				pos = m_tabulationColumnWidthList.length;
				
			m_tabulationColumnWidthList.splice (pos, 0 ,columnWidth);
			m_TextFieldStyleList.splice (pos, 0 ,nTextFormatTemplate);
			
			var xi : int = m_TextFieldStyleList.length - 1;;
			var yi : int = 0;

			for each (var tabulationTextFieldList :  Array  in m_tabulationTextFieldList )
			{	
				var newTextField : TextField = new TextField();
				setTextFieldFormat(newTextField , xi , yi++);

				tabulationTextFieldList.splice (pos, 0 , newTextField);
				m_TextFieldSp.addChild(newTextField);
			}
			for each (var StringList : Array  in m_stringList )
			{
				StringList.push("");
			}
			tabulationTextFieldList = null;
			
		}
 









		
		
		public function setColumnWidth(cIndex : int , newWidth : int , fixNextWidth : Boolean = false)
		: void {
			CONFIG::ASSERT {
				ASSERT(cIndex < m_tabulationColumnWidthList.length , "error index");
			}
			//trace ("c "+cIndex);
			var maxIndex : int = m_tabulationColumnWidthList.length - 1 ;
			
			var offWidth : int ;
			if (cIndex < m_tabulationColumnWidthList.length)
			{
				offWidth =  newWidth - m_tabulationColumnWidthList[cIndex];
				m_tabulationColumnWidthList[cIndex] = newWidth;

				if (fixNextWidth)
				{
					var loopIndex : int = cIndex + 1;
					if (loopIndex <= maxIndex)
						m_tabulationColumnWidthList[loopIndex] -= offWidth;
					
					for each (var tabulationTextFieldList : Array  in m_tabulationTextFieldList)
					{
						tabulationTextFieldList[cIndex].width = newWidth;
						
						
						if (loopIndex <= maxIndex)
						{
							tabulationTextFieldList[loopIndex].x += offWidth;
							tabulationTextFieldList[loopIndex].width -= offWidth;
						}
					}
				}
				else
				{
					for each ( tabulationTextFieldList  in m_tabulationTextFieldList)
					{
						tabulationTextFieldList[cIndex].width = newWidth;
						
						loopIndex = cIndex;
						while (loopIndex++ < maxIndex)
						{
							tabulationTextFieldList[loopIndex].x += offWidth;
						}
					}
				}
				
				tabulationTextFieldList = null;
			}
			
			
			
		 
		 
			
		}
		
		
	public function dispose() 
	: void {
            GraphicsUtil.removeAllChildren(this);
            if (parent)
                parent.removeChild(this);

            if(m_TextFieldTotalSp) {
                GraphicsUtil.removeAllChildren(m_TextFieldTotalSp);
                m_TextFieldTotalSp = null;
            }
		if(m_TextFieldSp) {
		      GraphicsUtil.removeAllChildren(m_TextFieldSp);
			m_TextFieldSp = null;
		}

        var tmpLength : int;
		if( m_TextFieldStyleList  ){    tmpLength  =  m_TextFieldStyleList  .length;  { while(  tmpLength --)   {  m_TextFieldStyleList  [  tmpLength ] = null;}};  m_TextFieldStyleList   = null; } ;

		var tmpLength2 : int;
		if(m_tabulationTextFieldList)
		{
		       tmpLength2 = m_tabulationTextFieldList.length
			for(var i:int = 0;i < tmpLength2;++i )
			{
				 if( m_tabulationTextFieldList[i]  ){    tmpLength  =  m_tabulationTextFieldList[i]  .length;  { while(  tmpLength --)   {  m_tabulationTextFieldList[i]  [  tmpLength ] = null;}};  m_tabulationTextFieldList[i]   = null; } ;
			}
			m_tabulationTextFieldList = null;
		}
		
		freeStringData ();
		m_tabulationColumnWidthList = null;
		m_bgData = null;
            if (m_selectBg && hasEventListener(MouseEvent.MOUSE_DOWN))
                removeEventListener(MouseEvent.MOUSE_DOWN , onSelect);
            m_selectBg = null;
            selectFunction = null;
	}	
		
	}
	
}
