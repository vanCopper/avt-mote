package editor.ui {


	
	import editor.struct.Matrix4x4;
	import editor.struct.Vertex3D;
	import flash.display.DisplayObject;
	import flash.display.Shape;	
	import flash.display.Sprite;	

	import flash.text.TextField;	
	import flash.geom.Point;

	import editor.config.*;

	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	
	/**	
	 * BSS假3D类 之编辑器之 象限
	 * @author blueshell
	 * @version		0.2.1
	 * @date 		01.19.2008
  	 * @MSN blueshell＠live.com
	 * @QQ 87453144
	 */
	public class EdtQuadrant extends Sprite {
		
		private var _gird : Shape;
		private var _girdBG : Shape;
		public var _CoordinateAxisX : Shape;
		public var _CoordinateAxisY : Shape;
		private var _hotSpots : Shape = new Shape;
		
		private var _quadrant : int;
		private var _state : int;
		
		private var _posX : TextField = new TextField();	
		private var _posY : TextField = new TextField();
		private var _scaleQ : TextField = new TextField();
		
		private var _quadrantInfo : TextField = new TextField();
		
		public static const _quadrantInfoArray : Array = ["top","persp","front","side"];
		
		public var _edtVertexArray : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
		
		public var _lineShape : Shape = new Shape();
		public var _lineShapeDym : Shape = new Shape();
		public var _dotShape : Sprite = new Sprite();
		
		private var scaleQ : Number = 1;
		private var scaleQ10 : int = 10;
		
		private var xQ : Number = 0;
		private var yQ : Number = 0;
		
		private var _CoordinateAxisY_x : Number;
		private var _CoordinateAxisX_y : Number;
		
		private var _indicate : DisplayObject;
		private var _maskContainer : Sprite;
		
		public function set indicate ( _dsp : DisplayObject) : void {
			
			if (_dsp)
			{
				_indicate = _dsp;
				_indicate.x = _CoordinateAxisY.x;
				_indicate.y = _CoordinateAxisX.y;
				
				_maskContainer.addChildAt(_indicate , 0);
				
				if (_indicate)
				{	
					_indicate.scaleX = _indicate.scaleY = (fullScreen ? 2 : 1) * scaleQ;
				}
			}
			else 
			{
				if (_indicate && _indicate.parent)
					_indicate.parent.removeChild( _indicate);
				_indicate = null;
			}
		}
		
		public static const PERSP : int = 1;
		
		private var _isThisFull : Boolean = false;
		
		public function dispose():void
		{
			_gird = null;
			_girdBG = null;
			_CoordinateAxisX = null;
			_CoordinateAxisY= null;
			_hotSpots= null;
			
			_posX= null;
			_posY = null;
			_scaleQ = null;
			_quadrantInfo = null;
			
			_edtVertexArray = null;
			
			_lineShape = null;
			_lineShapeDym = null;
			_dotShape = null;
		
			_indicate = null;
			 
			if (_maskContainer)
				_maskContainer.mask = null;
			_maskContainer = null;
			
			import  UISuit.UIUtils.*;
			GraphicsUtil.removeAllChildren(this);
		
		}
		
		public function get quadrant() : int
		{
			return _quadrant;
		}
		
		public function setViewVisible(v : int) : void
		{
			if (v == 1)
			{
				_dotShape.visible = !_dotShape.visible;
			} 
			else if (v == 2)
			{
				_lineShape.visible = !_lineShape.visible;
			}
			else if (v == 3)
			{
				if (_indicate)
					_indicate.visible = !_indicate.visible;
			}
			else if (v == 4)
			{
				if (_indicate)
					_indicate.alpha = (_indicate.alpha == 1) ? 0.5 : 1;
			}
		}
		
		public function EdtQuadrant( position : int ) {
			
			_quadrant = position;
			
			this.x = (_quadrant % 2) * EdtDEF.QUADRANT_WIDTH ;
			this.y = (int)(_quadrant / 2) * EdtDEF.QUADRANT_HEIGHT ;
			
			
			
			
			
		
			if ( null == _girdBG ) {
				_girdBG = new Shape();
				_girdBG.graphics.beginFill(0xFFFFFF);
				_girdBG.graphics.drawRect(0,0,EdtDEF.QUADRANT_WIDTH,EdtDEF.QUADRANT_HEIGHT);
				_girdBG.graphics.endFill();
				BGColor = EdtSET.bg_color;
				
				
				var _girdMask : Shape;
				_maskContainer = new Sprite();
				{
					_girdMask = new Shape();
					_girdMask.graphics.beginFill(0xFFFFFF);
					_girdMask.graphics.drawRect(0,0,EdtDEF.QUADRANT_WIDTH,EdtDEF.QUADRANT_HEIGHT);
					_girdMask.graphics.endFill();
					addChild(_girdMask);
					_maskContainer.mask = _girdMask;
				}
				
				
				
				
				
				_gird = new Shape(); 
				{
					_girdMask = new Shape();
					_girdMask.graphics.beginFill(0xFFFFFF);
					_girdMask.graphics.drawRect(0,0,EdtDEF.QUADRANT_WIDTH,EdtDEF.QUADRANT_HEIGHT);
					_girdMask.graphics.endFill();
					addChild(_girdMask);
					_gird.mask = _girdMask;
				}
				
				var l : int;
			
				_gird.graphics.lineStyle (1, 0xAAAAAA);  
				
				
				
				const  EdtDEF_TILE_WIDTH_2 : int = EdtDEF.TILE_WIDTH >> 1;
				
				for (l = -EdtDEF_TILE_WIDTH_2;l <=  EdtDEF.QUADRANT_WIDTH ; l += EdtDEF.TILE_WIDTH ) {
					_gird.graphics.moveTo (l,0);
					_gird.graphics.lineTo (l,EdtDEF.QUADRANT_HEIGHT + EdtDEF.TILE_WIDTH);
				}
				
				for (l = -EdtDEF_TILE_WIDTH_2;l < EdtDEF.QUADRANT_HEIGHT  + EdtDEF.TILE_WIDTH ; l += EdtDEF.TILE_WIDTH ) {
					_gird.graphics.moveTo (0,l);
					_gird.graphics.lineTo (EdtDEF.QUADRANT_WIDTH + EdtDEF.TILE_WIDTH ,l);
				}
				_gird.cacheAsBitmap = true;
				///_gird.x = - EdtDEF.TILE_WIDTH /2;
				//_gird.y = - EdtDEF.TILE_WIDTH /2;
				
				_CoordinateAxisX = new Shape();
				_CoordinateAxisY = new Shape();
				
				_CoordinateAxisY.graphics.lineStyle (0,0xFFFFFF); 				
				l= EdtDEF.QUADRANT_WIDTH /2;
				_CoordinateAxisY.graphics.moveTo (0,0);
				_CoordinateAxisY.graphics.lineTo (0,EdtDEF.QUADRANT_HEIGHT );
				//_CoordinateAxisY.x = l;
				
				
				l= EdtDEF.QUADRANT_HEIGHT /2;
				_CoordinateAxisX.graphics.lineStyle (0,0xFFFFFF); 
				_CoordinateAxisX.graphics.moveTo (0,0);
				_CoordinateAxisX.graphics.lineTo (EdtDEF.QUADRANT_WIDTH ,0);
				//_CoordinateAxisX.y = l;
				
				_hotSpots.graphics.lineStyle (1.6,0x0); 
				_hotSpots.graphics.drawRect(0.5, 0.5, EdtDEF.QUADRANT_WIDTH  -1, EdtDEF.QUADRANT_HEIGHT  - 1);
				_hotSpots.visible = false;
								
				_quadrantInfo.x = EdtDEF.INFOX ;
				_quadrantInfo.y = EdtDEF.INFOY ;
				_quadrantInfo.text = _quadrantInfoArray[_quadrant];
				_quadrantInfo.selectable = false;
				
				
				_posX.x = EdtDEF.POSX ;
				_posX.y = EdtDEF.INFOY ;
				_posX.selectable = false;
				_posY.x = EdtDEF.POSX  + 55;
				_posY.y = EdtDEF.INFOY ;
				_posY.selectable = false;
				updataPosInfo();
				
				_sQ = 10;
				_scaleQ.x = EdtDEF.POSX  - 48;
				_scaleQ.y = EdtDEF.INFOY ;
				_scaleQ.selectable = false;
				
				_posX.mouseEnabled = 
				_posY.mouseEnabled = 
				_scaleQ.mouseEnabled = false;
				
				
				//_dotShape.x = EdtDEF.QUADRANT_WIDTH /2;
				//_dotShape.y = EdtDEF.QUADRANT_HEIGHT /2;
				
				//_lineShape.x = EdtDEF.QUADRANT_WIDTH /2;
				//_lineShape.y = EdtDEF.QUADRANT_HEIGHT /2;
				_lineShape.alpha = 0.6;
				_lineShape.cacheAsBitmap = true;
				
				//_lineShapeDym.x = EdtDEF.QUADRANT_WIDTH /2;
				//_lineShapeDym.y = EdtDEF.QUADRANT_HEIGHT /2;
				_lineShapeDym.alpha = 0.3;
				
			}
			
			addChild (_girdBG);
			addChild (_gird);
			addChild (_CoordinateAxisX);
			addChild (_CoordinateAxisY);
			addChild (_hotSpots);
			addChild (_quadrantInfo);
			
			
			/*
			if (_quadrant == PERSP ) {
				addChild (EditorMain.myWorld3D);
				EditorMain.myWorld3D.x =  EdtDEF.QUADRANT_WIDTH /2;
				EditorMain.myWorld3D.y =  EdtDEF.QUADRANT_HEIGHT /2;
			}*/
			
			_maskContainer.addChild (_lineShape);
			_maskContainer.addChild (_lineShapeDym);
			_maskContainer.addChild (_dotShape);
			addChild(_maskContainer);
			
			addChild (_posX);
			addChild (_posY);
			addChild (_scaleQ);
			
			
			_xQ = 0;
			_yQ = 0;
			
		}
		
		public function  updateDotStatus(_ptVArr : Vector.<EdtVertexInfo>):void
		{
			for each (var _ev : EdtVertexInfo in _ptVArr)
			{
				var _myev : EdtVertexInfo = EdtVertexInfo.getEdtVertexInfo(_ev.vertex , _edtVertexArray);
				
				_myev.dot.mode = _ev.dot.mode;
			}
			
		}
		
		public function setVertex(_vertexArray : Vector.<EdtVertex3D>) : void
		{
			for each( var ev : EdtVertexInfo in _edtVertexArray)
			{
				if (ev && ev.dot && ev.dot.parent)
					ev.dot.parent.removeChild(ev.dot);
			}
			_edtVertexArray.length = 0;
			
			if (_vertexArray)
			for each (var v : EdtVertex3D in _vertexArray)
			{
				ev = new EdtVertexInfo(v);
				_edtVertexArray.push(ev);
				
				_dotShape.addChild(ev.dot);
			}
			
			renderLine();
		}
		
		public function converMappedPointToDot(_pt : Point , dot : EdtDot) : void
		{
			dot.x  = _pt.x - _dotShape.x - this.x;
			dot.y  = _pt.y - _dotShape.y - this.y;
		}
		
		public function getMappedPoint(_v :Vector.<EdtVertexInfo>) : void
		{
			for each( var ev : EdtVertexInfo in _edtVertexArray)
			{
				var _pt : Point = new Point();
				_pt.x = ev.dot.x + _dotShape.x + this.x;
				_pt.y = ev.dot.y + _dotShape.y + this.y;
				ev.point = _pt;
				
				if (_v)
					_v.push(ev);
				
			}
			
		}
		
		//public static var PERSP_Y_R : Number = 0;
		//public static var PERSP_X_R : Number = 0;
		
		
		public function map3DTo2D() : void
		{
			var __scale : Number = (_isThisFull ? 2 : 1) * scaleQ ;
			
			if (_quadrant == PERSP)
			{
				//var _g3 : Number = Math.sqrt(3);
				//var xV : Point = new Point();
				//xV.x = -_g3;
				//xV.y = -0.5;
				
				//var zV : Point = new Point();
				//zV.x = _g3;
				//zV.y = -0.5;
				
				
				var m : Matrix4x4 = new Matrix4x4();
				var v : Vertex3D = new Vertex3D();
				v.y = -xQ;
				v.x = yQ;
				
				Matrix4x4.rotateArbitraryAxis(m , v  , Math.sqrt(yQ * yQ + xQ * xQ)/180*Math.PI);
				
			}
			for each( var ev : EdtVertexInfo in _edtVertexArray)
			{
				if (_quadrant == 2)
				{
					ev.dot.x = ev.vertex.x * __scale;
					ev.dot.y = ev.vertex.y * __scale;
				}
				else if (_quadrant == PERSP)
				{
					
					ev.dot.x = (m.Xx * ev.vertex.x + m.Xy * ev.vertex.y + m.Xz * ev.vertex.z)  * __scale;
					ev.dot.y = (m.Yx * ev.vertex.x + m.Yy * ev.vertex.y + m.Yz * ev.vertex.z)  * __scale;
					
				}
				else if (_quadrant == 0)
				{
					ev.dot.x = ev.vertex.x * __scale;
					ev.dot.y = -ev.vertex.z * __scale;
				}
				else if (_quadrant == 3)
				{
					ev.dot.x = ev.vertex.z * __scale;
					ev.dot.y = ev.vertex.y * __scale;
				}
				else
				{
					ASSERT(false , "");
				}
			}
			
			if (_quadrant == PERSP && _indicate && _indicate["render"])
			{
				_indicate["render"](_edtVertexArray);
				
			}
			
		}
		public function map2DTo3D() : void
		{
			var __scale : Number = (_isThisFull ? 2 : 1) * scaleQ ;
			for each( var ev : EdtVertexInfo in _edtVertexArray)
			{
				if (_quadrant == 2)
				{
					ev.vertex.x = ev.dot.x / __scale;
					ev.vertex.y = ev.dot.y / __scale;
				}
				else if (_quadrant == 0)
				{
					ev.vertex.x = ev.dot.x / __scale;
					ev.vertex.z = -ev.dot.y / __scale;
				}
				else if (_quadrant == 3)
				{
					ev.vertex.z = ev.dot.x / __scale;
					ev.vertex.y = ev.dot.y / __scale;
				}
			}
		}
		
		
		public function renderLine(map : Boolean = true ):void
		{
			 var __scale : Number = (_isThisFull ? 2 : 1) * scaleQ ;
			 if (map)
				map3DTo2D();
			 _lineShape.graphics.clear();
			 _lineShape.graphics.lineStyle(1 , EdtSET.LINE_SHAPE_COLOR);
			 
			 for each( var evi : EdtVertexInfo in _edtVertexArray)
			 {
				var _p : int = evi.vertex.priority;
				var _conect : Vector.<EdtVertex3D> = evi.vertex.conect;
				
				for each (var ev : EdtVertex3D in _conect)
				{
					if (_p < ev.priority )
					{
						_lineShape.graphics.moveTo(evi.dot.x , evi.dot.y);
						
						var evic : EdtVertexInfo = EdtVertexInfo.getEdtVertexInfo(ev , _edtVertexArray);
						_lineShape.graphics.lineTo(evic.dot.x , evic.dot.y);
					}
				}
				
			 }
			
			 _lineShape.graphics.lineStyle(NaN);
		}
		
		
		public function updataPosInfo() : void {
			if (_quadrant == 0 ) {
				_posX.text = "X: "+ int(_xQ);
				_posY.text = "Z: " + int(-_yQ);
			}
			else if (_quadrant == 1 ) {
				_posX.text = "XR: " + int(xQ) + "." + (int(xQ * 10) % 10);
				_posY.text = "YR: " + int(yQ) + "." + (int(yQ * 10) % 10);
			}
			else if (_quadrant == 2 ) {
				_posX.text = "X: "+ int(_xQ);
				_posY.text = "Y: "+ int(_yQ);	
			}
			else if (_quadrant == 3 )
			{
				_posX.text = "Z: "+ int(_xQ);
				_posY.text = "Y: "+ int(_yQ);	
			}
		}
		
		
		
		public function set BGColor (inColor : uint ) : void {
			EdtSET.bg_color = (inColor);
			_girdBG.transform.colorTransform = EdtSET.bg_color_t;	
		}
		
		public function set Lineolor (inColor : uint ) : void {
			EdtSET.gird_color = (inColor);
			_gird.transform.colorTransform = EdtSET.gird_color_t;	
		}
		

		public function set state (inState : int ) : void {
			
			if (inState == 2 ) {
				_hotSpots.visible = true;
				_hotSpots.transform.colorTransform = EdtSET.HOT_WORKON;
				_state = inState;
			}
			else if (inState == 1 ) {
				_hotSpots.visible = true;
				if ( _state != 2) {
					_hotSpots.transform.colorTransform = EdtSET.HOT_MOVEON;
					_state = inState;
				}
				
			}
			else if (inState == -1)
			{
				_hotSpots.visible = false;
				_state = inState;
			}
			else if (_state !== 2)
			{
				_hotSpots.visible = false;
				_state = inState;
			}
			
			
			
		}
		
		public function get isWorkOn () : Boolean {
			return (_state == 2);
		}
		
		public function QuadrantRelateDrag ( xOff : Number , yOff : Number) : void {
			
			if (_quadrant != PERSP)
			{
				_yQ += yOff;
				_xQ += xOff;
			}
			else
			{
				yQ += yOff;
				xQ += xOff;
				renderLine();
			}
			
		//	_gird.x = (_gird.x + xOff) % DEF_TILE_WIDTH;
		//	_gird.y = (_gird.y + yOff) % DEF_TILE_WIDTH;
			updataPosInfo();
			
			
		}
		
		
		
		public function get _xQ () : Number {
		//	return (_CoordinateAxisY.x - EdtDEF_QUADRANT_WIDTH/2 );
			return (xQ );
		}
		public function get _yQ () : Number {
		//	return (_CoordinateAxisX.y - EdtDEF_QUADRANT_HEIGHT/2 );
			return ( yQ );
		}
		public function get _sQ () : int {
			return scaleQ10;
		}	
		
		public function set _sQ ( s : int) : void {
			
			scaleQ10 = s;
			scaleQ10 = Math.min (scaleQ10,EdtDEF.MAX_SCALE );
			scaleQ10 = Math.max (scaleQ10,EdtDEF.MIN_SCALE );

			scaleQ = scaleQ10/10;
			
			_scaleQ.text = "scale: "+ (scaleQ);

			if (_indicate)
			{	
				_indicate.scaleX = _indicate.scaleY = (fullScreen ? 2 : 1) * scaleQ;
			}
			
			renderLine();
			
		}	
		
		public function set _xQ (x : Number) : void {
		//	trace (EditorMain.myWorld3D.x)
			xQ = x;
			_gird.x = int(x * (_isThisFull ? 2 : 1)) % (_isThisFull ? EdtDEF.TILE_WIDTH*2 : EdtDEF.TILE_WIDTH) ;
			
			
			_CoordinateAxisY_x = x + EdtDEF.QUADRANT_WIDTH /2;
			_CoordinateAxisY.x = int(_CoordinateAxisY_x * (_isThisFull ? 2 : 1));
			if (_indicate)
			{
				_indicate.x = _CoordinateAxisY.x;
			}
			_dotShape.x = 
			_lineShape.x = 
			_lineShapeDym.x = _CoordinateAxisY.x;
			
			updataPosInfo();
			
			/*
			if (_quadrant == PERSP ) {

				EditorMain.myWorld3D.x = x + EdtDEF.QUADRANT_WIDTH /2;
		//		trace (EditorMain.myWorld3D.x)
				Values.s_cam_x = _xQ;
				reDrawAll();
				
				if (isThisFull) {
					EditorMain.myWorld3D.x -= EdtDEF.QUADRANT_WIDTH  / 2 ;
					_dotShape.x -= EdtDEF.QUADRANT_WIDTH  / 2 ;
					_lineShapeDym.x -= EdtDEF.QUADRANT_WIDTH  / 2 ;
					_lineShape.x -= EdtDEF.QUADRANT_WIDTH  / 2 ;
					_CoordinateAxisY.x -= (EdtDEF.QUADRANT_WIDTH  / 2);
				}
			}*/
		}
		
		public function set _yQ (y : Number) : void {
			yQ = y;
			_gird.y = int(y * (_isThisFull ? 2 : 1)) % (_isThisFull ? EdtDEF.TILE_WIDTH*2 : EdtDEF.TILE_WIDTH) ;
			
			_CoordinateAxisX_y = y + EdtDEF.QUADRANT_HEIGHT /2;
			_CoordinateAxisX.y = int(_CoordinateAxisX_y * (_isThisFull ? 2 : 1));
			if (_indicate)
			{
				_indicate.y = _CoordinateAxisX.y;
			}
			_dotShape.y = 
			_lineShape.y = 
			_lineShapeDym.y = _CoordinateAxisX.y;
			updataPosInfo();
			
			
			/*
			if (_quadrant == PERSP ) {
				EditorMain.myWorld3D.y = y + EdtDEF.QUADRANT_HEIGHT /2;
				Values.s_cam_y = _yQ;
		//		
				reDrawAll();
				
				if (isThisFull) {
					EditorMain.myWorld3D.y += EdtDEF.QUADRANT_HEIGHT  / 2 ;
					_dotShape.y += EdtDEF.QUADRANT_HEIGHT  / 2 ;
					_lineShapeDym.y += EdtDEF.QUADRANT_HEIGHT  / 2 ;
					_lineShape.y += EdtDEF.QUADRANT_HEIGHT  / 2 ;
					_CoordinateAxisX.y += (EdtDEF.QUADRANT_HEIGHT  / 2 );
				}
				
			}*/
				
		}
		
		
		
		public function get fullScreen() : Boolean
		{
			return _isThisFull;
		}
		public function set fullScreen(isFull : Boolean): void {
			
			_isThisFull = isFull;
			
			if (isFull)
			{
				this.x = 
				this.y = 0;
			} 
			else {
				this.x = (_quadrant % 2) * EdtDEF.QUADRANT_WIDTH ;
				this.y = (int)(_quadrant / 2) * EdtDEF.QUADRANT_HEIGHT ;
			}
			
			
			//_hotSpots.visible = !isFull;
			//_quadrantInfo.visible = !isFull;
			//_posX.visible = !isFull;
			//_posY.visible = !isFull;
			//_scaleQ.visible = !isFull;
			_hotSpots.scaleX = 
			_hotSpots.scaleY = 
			_CoordinateAxisX.scaleX = 
			_CoordinateAxisY.scaleY = 
			_girdBG.scaleX = 
			_girdBG.scaleY = 
			_maskContainer.mask.scaleX = 
			_maskContainer.mask.scaleY = 
			_gird.mask.scaleX = 
			_gird.mask.scaleY = 
			_gird.scaleX = 
			_gird.scaleY = isFull ? 2 : 1;
			
			if (_indicate)
			{	
				_indicate.scaleX = _indicate.scaleY = (isFull ? 2 : 1) * scaleQ;
			}
			
			if (_quadrant != EdtQuadrant.PERSP)
			{
				_xQ = _xQ;
				_yQ = _yQ;
			}
			else {
				var _CoordinateAxisY_x : int = EdtDEF.QUADRANT_WIDTH /2;
				_CoordinateAxisY.x = int(_CoordinateAxisY_x * (isFull ? 2 : 1));
				var _CoordinateAxisX_y : int = EdtDEF.QUADRANT_WIDTH /2;
				_CoordinateAxisX.y = int(_CoordinateAxisX_y * (isFull ? 2 : 1));
				
				_dotShape.x = 
				_lineShape.x = 
				_lineShapeDym.x = _CoordinateAxisY.x;
			
				_dotShape.y = 
				_lineShape.y = 
				_lineShapeDym.y = _CoordinateAxisX.y;
				
				if (_indicate) {
					_indicate.x = _CoordinateAxisY.x;
					_indicate.y = _CoordinateAxisX.y;
				}
			}
			
			//_xQ -= ((((_quadrant&1)!=0)?1:-1)* EdtDEF.QUADRANT_WIDTH /2) * (isFull ? 1:-1);
			//_yQ -= ((((_quadrant&2)!=0)?1:-1)* EdtDEF.QUADRANT_HEIGHT /2) * (isFull ? 1:-1);
			
			//trace(_xQ);
			
			//_CoordinateAxisX.x -= (((_quadrant&1)!=0)? EdtDEF.QUADRANT_WIDTH : 0 )* (isFull ? 1:-1);
			//_CoordinateAxisY.y -= (((_quadrant&2)!=0)? EdtDEF.QUADRANT_HEIGHT : 0 )* (isFull ? 1:-1);
		
					
			
			
			//if (_quadrant == EdtQuadrant.PERSP) {
				renderLine();
			//}
			
		}
		
		
		
	}
}
