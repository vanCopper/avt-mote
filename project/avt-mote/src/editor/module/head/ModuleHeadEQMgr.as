package editor.module.head 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.config.EdtSET;
	import editor.ui.EdtDot;
	import editor.ui.EdtMoveIndicate;
	import editor.ui.EdtOperator;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtSelector;
	import editor.ui.EdtVertex3D;
	import editor.ui.EdtVertexInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import UISuit.UIUtils.GraphicsUtil;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHeadEQMgr extends Sprite 
	{
		private var m_regCallBack : Boolean;
		private var m_moveIndicate : EdtMoveIndicate;
		private var m_selectorIndicate : EdtSelector;
		private var m_operatorIndicate : EdtOperator;
		
		private var m_indicate : Sprite;
		
		public var curEdtQuadrant : EdtQuadrant;
		public var isMovineQuadrant : Boolean;
		
		public var m_selecingShape : Shape;
		public var m_selecingHitPoint : Point;
		
		private var m_editMode : int;
		private static const EDIT_MODE_MOVE : int = 1;
		private static const EDIT_MODE_SCALE : int = 2;
		
		private var m_selectedEVI : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
		private var m_operatorCenter : Point = new Point ();
		private var m_operatorOffset : Point = new Point ();
		private var m_operatorDir : int;
		private var m_operatorMoving : Boolean;
		
		public var changeFunction : Function;
		
		public var m_edtQuadrantVector : Vector.<EdtQuadrant> = new Vector.<EdtQuadrant>(4 , true);
		
		private var m_autoSwitch : Boolean;
		private var m_timeoutInv : int;
		private var m_crossShape : Shape;
		
		public function setVertex(_vertexArray : Vector.<EdtVertex3D>) : void
		public function setVertex(_vertexArray : Vector.<EdtVertex3D>) : void
		{
			for each( var _e : EdtQuadrant in m_edtQuadrantVector )
				 _e.setVertex(_vertexArray);
		}
		
		public function setQuadrant(_e0 : EdtQuadrant , _e1 : EdtQuadrant , _e2 : EdtQuadrant , _e3 : EdtQuadrant ) : void
		{
			m_edtQuadrantVector[0] = _e0;
			m_edtQuadrantVector[1] = _e1;
			m_edtQuadrantVector[2] = _e2;
			m_edtQuadrantVector[3] = _e3;
			
			var _shp : Shape = new Shape();
			_shp.graphics.lineStyle(1);
			
			_shp.graphics.moveTo(EdtDEF.QUADRANT_WIDTH , 0);
			_shp.graphics.lineTo(EdtDEF.QUADRANT_WIDTH , EdtDEF.QUADRANT_HEIGHT * 2);
			
			_shp.graphics.moveTo(0 ,  EdtDEF.QUADRANT_HEIGHT);
			_shp.graphics.lineTo(EdtDEF.QUADRANT_WIDTH * 2 , EdtDEF.QUADRANT_HEIGHT);
			
			
			addChildAt(m_edtQuadrantVector[3] , 0);
			addChildAt(m_edtQuadrantVector[2] , 0);
			addChildAt(m_edtQuadrantVector[1] , 0);
			addChildAt(m_edtQuadrantVector[0] , 0);
									
			addChild(_shp);
			m_crossShape = _shp;
			
			m_autoSwitch = true;
		}
		
		public function ModuleHeadEQMgr() 
		{
			m_indicate = new Sprite();
			
			m_moveIndicate = new EdtMoveIndicate();
			m_selectorIndicate = new EdtSelector();
			m_operatorIndicate = new EdtOperator();
			
			m_indicate.addChild(m_moveIndicate);
			m_indicate.addChild(m_selectorIndicate);
			//m_moveIndicate.graphics.lineStyle(1);
			
			
			
			
			
			m_moveIndicate.visible = false;
			m_selectorIndicate.visible = true;
			
			addChild(m_indicate);
			
			m_selecingShape = new Shape();
			addChild(m_selecingShape);
			
			
			m_operatorIndicate.x = 100;
			m_operatorIndicate.y = 100;
			addChild(m_operatorIndicate);
			m_operatorIndicate.visible = false;
			m_operatorIndicate.startMoveFunc = onStartMove;
			
			
			m_indicate.visible = false;
			
			
		}
		
		private function onStartMove(me : MouseEvent , m : int):void 
		{
			m_operatorOffset.x = -me.stageX + m_operatorIndicate.x;
			m_operatorOffset.y = -me.stageY + m_operatorIndicate.y;
			
			
			m_operatorDir = m;
			m_operatorMoving = true;
			m_selectorIndicate.visible = false;
			
			m_operatorCenter.x = m_operatorIndicate.x;
			m_operatorCenter.y = m_operatorIndicate.y;
			
			curEdtQuadrant.getMappedPoint(null);
		}
		
		
		public function activate() : void
		{
			if (!m_regCallBack)
			{
				m_regCallBack = true;
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_UP , onMouseUp);
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_WHEEL , onMouseWheel);
				CallbackCenter.registerCallBack(CALLBACK.AS3_ON_STAGE_KEY_DOWN , onKeyDown);
			}
			
		}
		
		public function deactivate() : void
		{
			
			if (m_regCallBack)
			{
				m_regCallBack = false;
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_DOWN , onMouseDown);
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_UP , onMouseUp);
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_MOVE , onMouseMove);
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_MOUSE_WHEEL , onMouseWheel);
				CallbackCenter.unregisterCallBack(CALLBACK.AS3_ON_STAGE_KEY_DOWN , onKeyDown);

			}
			
		}
		
		

		private function onKeyDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : KeyboardEvent = args as KeyboardEvent;
			
			if (me.keyCode == 187) //+
			{
				EdtSET.click_accuracy++; 
				m_selectorIndicate.clickAccuracy = EdtSET.click_accuracy;
				
			} 
			else if (me.keyCode == 189) // -
			{
				if (EdtSET.click_accuracy > 1)
					EdtSET.click_accuracy--;
				m_selectorIndicate.clickAccuracy = 	EdtSET.click_accuracy;
			}
			else if (me.keyCode == 27) // esc
			{
				if (m_editMode == EDIT_MODE_MOVE)
				{
					m_editMode = 0;
					m_selectorIndicate.visible = true;
					if (m_operatorMoving)
						m_operatorMoving = false;
					m_operatorIndicate.visible = false;	
				}
			}
			else if (me.keyCode == 81) // q
			{
				if (m_editMode == EDIT_MODE_MOVE)
				{
					m_editMode = 0;
					m_selectorIndicate.visible = true;
					if (m_operatorMoving)
						m_operatorMoving = false;
					m_operatorIndicate.visible = false;	
				}
				else
				{
					m_editMode = EDIT_MODE_MOVE;
					if (m_selectedEVI.length)
					{
						computeOperatorIndicatePos(true);
					}
					
				}
			} 
			else if (me.keyCode == 32)
			{
				if (m_autoSwitch)
				{
					if (mouseX < 0 || mouseX >= EdtDEF.QUADRANT_WIDTH*2 
					|| mouseY < 0 || mouseY >= EdtDEF.QUADRANT_HEIGHT*2 
					)
						return CallbackCenter.EVENT_OK;
					
					if (curEdtQuadrant.fullScreen)
					{	
						curEdtQuadrant.fullScreen = false;
						m_crossShape.visible = true;
						
						for each (_eq in m_edtQuadrantVector)
						{
							_eq.visible = true;
						}
						if (m_operatorIndicate.visible)
							computeOperatorIndicatePos(true);
						return CallbackCenter.EVENT_OK;
					}
					
					var _curPos : int = int(mouseX / EdtDEF.QUADRANT_WIDTH) + int(mouseY / EdtDEF.QUADRANT_HEIGHT) * 2;
					setFocusQuadrant(m_edtQuadrantVector[_curPos] , true);
					curEdtQuadrant.fullScreen = true;
					
					for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
					{
						if (_eq != curEdtQuadrant)
							_eq.visible = false;
					}
					if (m_operatorIndicate.visible)
						computeOperatorIndicatePos(true);
					m_crossShape.visible = false;
				}
				
			}
			
			return CallbackCenter.EVENT_OK;
		}
		
		private function checkAlt(me : MouseEvent): void
		{
			if (!me.altKey && isMovineQuadrant)
			{
				isMovineQuadrant = false;
				m_moveIndicate.visible = false;
				m_selectorIndicate.visible = true;
			}
		}
		private function setFocusQuadrant( _ceq : EdtQuadrant , directSet : Boolean) : void
		{
			if (_ceq != curEdtQuadrant)
			{
				for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
				{
					if (!_eq.isWorkOn || directSet)
					{
						_eq.state = -1;
					}
				}
				
				if (m_timeoutInv)
				{
					clearTimeout(m_timeoutInv);
					m_timeoutInv = 0;
				}
				
				_ceq.state = directSet ? 2 : 1;
				
				if (directSet)
				{
					curEdtQuadrant = _ceq;
					if (m_operatorIndicate.visible)
						computeOperatorIndicatePos(true);
					return;
				}
				m_timeoutInv = setTimeout (
					function():void {
						if (m_timeoutInv)
						{
							clearTimeout(m_timeoutInv);
							m_timeoutInv = 0;
						}
						
						for each (_eq in m_edtQuadrantVector)
						{
							_eq.state = -1;
						}
				
						_ceq.state = 2;
						curEdtQuadrant = _ceq;
						
						if (m_operatorIndicate.visible)
							computeOperatorIndicatePos(true);
						
					} , 200);

			}
		}
		
		private function setFocus(me : MouseEvent,directSet : Boolean) : void
		{
			
			if (!curEdtQuadrant.fullScreen && m_autoSwitch)
			{
				if (me.stageX < 0 || me.stageX >= EdtDEF.QUADRANT_WIDTH*2 
				|| me.stageY < 0 || me.stageY >= EdtDEF.QUADRANT_HEIGHT*2 
				)
					return;
				
				var _ptA : Point = this.globalToLocal(new Point(me.stageX , me.stageY));

				var _curPos : int = int(_ptA.x / EdtDEF.QUADRANT_WIDTH) + int(_ptA.y / EdtDEF.QUADRANT_HEIGHT) * 2;
				setFocusQuadrant(m_edtQuadrantVector[_curPos] , directSet);
				
				
			}
			
		}
		
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
			setFocus(me,false);
			
			if (m_operatorMoving)
			{
				var optPos : Point = new Point();
				optPos.x = m_operatorOffset.x + me.stageX;
				optPos.y = m_operatorOffset.y + me.stageY;
				
				if (m_operatorDir != -1)
					m_operatorIndicate.x = optPos.x;
				if (m_operatorDir != 1)
					m_operatorIndicate.y = optPos.y;
					
				setVertexPosMove();
					
			}
			else if (isMovineQuadrant && me.altKey )
			{
				if (curEdtQuadrant)
				{
					var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
					if (pt.x >= 0
						&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen ? 2 : 1))
						&& pt.y >= 0
						&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen ? 2 : 1))
						)
					{
						m_selectorIndicate.visible = false;
						m_moveIndicate.visible = true;
						
						
						var offX : Number = -(m_indicate.x - curEdtQuadrant.x) + pt.x ;
						var offY : Number = -(m_indicate.y - curEdtQuadrant.y) + pt.y ;
						m_indicate.x = pt.x + curEdtQuadrant.x;
						m_indicate.y = pt.y + curEdtQuadrant.y;
						
						if (curEdtQuadrant.fullScreen)
						{
							offX /= 2;
							offY /= 2;
						}
						
						curEdtQuadrant.QuadrantRelateDrag(offX , offY);
						
						isMovineQuadrant = true;
					}
				}
			} else {
				pt = checkIndicateVisible(me);
				
				if (m_indicate.visible)
				{
					
					if (m_selecingHitPoint && pt)
					{
						if (m_selectorIndicate.alpha == 1)
						{
							
							if (Math.abs (m_selecingHitPoint.x - pt.x ) >= 3 ||
								Math.abs (m_selecingHitPoint.y - pt.y ) >= 3 ) 
							m_selectorIndicate.alpha = 0;	
						}		
								
						if (m_selectorIndicate.alpha == 0)
						{
							
							m_selecingShape.graphics.clear();
							m_selecingShape.graphics.beginFill(0x9999FF , 0.45);
							m_selecingShape.graphics.lineStyle(1 , 0x6666FF);
							m_selecingShape.graphics.drawRect( m_selecingHitPoint.x, m_selecingHitPoint.y, -m_selecingHitPoint.x + pt.x , -m_selecingHitPoint.y + pt.y  );
							m_selecingShape.graphics.endFill();
							
							
							var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
							curEdtQuadrant.getMappedPoint(_ptVArr);
							var rect : Rectangle = m_selecingShape.getRect(this);
							
							
							for each (var __ptv : EdtVertexInfo in _ptVArr)
							{
								
								if (me.shiftKey)
								{
									if (rect.containsPoint(__ptv.point))
									{
										if (__ptv.dot.selected)
										{	
											__ptv.dot.mode = EdtDot.DOT_UNSELECTING_MODE;
										}
										else
										{	__ptv.dot.mode = EdtDot.DOT_SELECTING_MODE;}
									}
									else {
										if (__ptv.dot.selected)
											__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
										else
											__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
									}
								}
								else
								{
									if (rect.containsPoint(__ptv.point))
									{
										__ptv.dot.mode = EdtDot.DOT_SELECTING_MODE;
									}
									else 
									{
										__ptv.dot.mode = EdtDot.DOT_UNSELECTING_MODE;
									}
								}
							}
							
							for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
							{	
								if (_eq && _eq != curEdtQuadrant)
								{
									_eq.updateDotStatus(_ptVArr);
								}
							}
						}
						
					}
				}
				
				
			}
			
			
						
			return CallbackCenter.EVENT_OK;
		}
		private function checkIndicateVisible(me : MouseEvent) : Point
		{
			var pt : Point = this.globalToLocal(new Point(me.stageX , me.stageY));
			if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * 2)
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * 2)
					)
			{
				m_indicate.x = pt.x;
				m_indicate.y = pt.y;
				m_indicate.visible = true;
			}
			else
			{
				m_indicate.visible = false;
			}
			
			return pt;
		}
		
		private function setVertexPosMove() : void
		{
			var offX : Number = m_operatorIndicate.x - m_operatorCenter.x ;
			var offY : Number = m_operatorIndicate.y - m_operatorCenter.y ;
			var __pt : Point = new Point();
			
			
			for each (var __ptv : EdtVertexInfo in m_selectedEVI)
			{
				__pt.x = __ptv.point.x + offX;
				__pt.y = __ptv.point.y + offY;
			
				//trace(__ptv.dot.x , __ptv.dot.y , __ptv.dot.transform.colorTransform);
				curEdtQuadrant.converMappedPointToDot(__pt , __ptv.dot);
				//trace(__ptv.dot.x , __ptv.dot.y);
			}
			
			
			curEdtQuadrant.renderLine(false);
			
			if (m_autoSwitch)
			{
				curEdtQuadrant.map2DTo3D();
				
				for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
				{	
					if (_eq && _eq != curEdtQuadrant)
					{
						_eq.renderLine(true);
					}
				}
			}
		}
		
		private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			
			checkAlt(me);
			setFocus(me, true);
			
			if (!curEdtQuadrant)
				return CallbackCenter.EVENT_OK;
			if (m_operatorMoving)
			{
				
			}
			else if (me.altKey )
			{
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen ? 2 : 1))
					)
				{
					m_indicate.visible = true;
					m_selectorIndicate.visible = false;
					m_moveIndicate.visible = true;
					
					m_indicate.x = pt.x + curEdtQuadrant.x;
					m_indicate.y = pt.y + curEdtQuadrant.y;
					isMovineQuadrant = true;
					
				}
				
			} else {
				pt = checkIndicateVisible(me);
				
				if (m_indicate.visible)
				{
					m_selecingHitPoint = pt;
					
					if (!me.shiftKey)
					{
						var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
						curEdtQuadrant.getMappedPoint(_ptVArr);
						var rect : Rectangle = m_selecingShape.getRect(this);
							
							
						for each (var __ptv : EdtVertexInfo in _ptVArr)
						{
							__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
						}
						
					}
					
					
					
				}
				else {
					m_selecingHitPoint = null;
				}
			}
			
			if (!m_operatorMoving)
				m_operatorIndicate.visible = false;
			
			return CallbackCenter.EVENT_OK;
		}
		
		
		private function onMouseUp(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			
			var me : MouseEvent = args as MouseEvent;
			
			
			
			if (m_operatorMoving)
			{
				setVertexPosMove();
				
				var _ptm : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
				m_indicate.x = _ptm.x + curEdtQuadrant.x;
				m_indicate.y = _ptm.y + curEdtQuadrant.y;
				
				
				curEdtQuadrant.map2DTo3D();
				if (m_autoSwitch) 
				{
					
					for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
					{	
						if (_eq && _eq != curEdtQuadrant)
						{
							_eq.renderLine(true);
						}
					}
				}
				if (changeFunction != null)
					changeFunction();
				
				_ptVArr = new Vector.<EdtVertexInfo>();
				curEdtQuadrant.getMappedPoint(_ptVArr);
				var needReselect : Boolean;
				
				for each (__ptv in _ptVArr)
				{
					if (__ptv.vertex.line0 && __ptv.vertex.line1)
					{
						var len0 : Number 
							= 
							(__ptv.vertex.line0.x - __ptv.vertex.x) * (__ptv.vertex.line0.x - __ptv.vertex.x)
							+ (__ptv.vertex.line0.y - __ptv.vertex.y) * (__ptv.vertex.line0.y - __ptv.vertex.y)
							+ (__ptv.vertex.line0.z - __ptv.vertex.z) * (__ptv.vertex.line0.z - __ptv.vertex.z);
						len0 = Math.sqrt(len0);
						
						var len1 : Number 
							= 
							(__ptv.vertex.line1.x - __ptv.vertex.x) * (__ptv.vertex.line1.x - __ptv.vertex.x)
							+ (__ptv.vertex.line1.y - __ptv.vertex.y) * (__ptv.vertex.line1.y - __ptv.vertex.y)
							+ (__ptv.vertex.line1.z - __ptv.vertex.z) * (__ptv.vertex.line1.z - __ptv.vertex.z);
						len1 = Math.sqrt(len1);
						
						var _lineRate : Number = (len0 / (len0 + len1));
						__ptv.vertex.x = __ptv.vertex.line0.x + (__ptv.vertex.line1.x  - __ptv.vertex.line0.x ) * _lineRate;
						__ptv.vertex.y = __ptv.vertex.line0.y + (__ptv.vertex.line1.y  - __ptv.vertex.line0.y ) * _lineRate;
						
						needReselect = true;
					}
				}
				
				curEdtQuadrant.renderLine();
				
				if (needReselect)
				{
					curEdtQuadrant.getMappedPoint(null);
					computeOperatorIndicatePos();
				}
				m_operatorMoving = false;
				m_selectorIndicate.alpha = 1;
				m_selectorIndicate.visible = true;
				
				
			} else if (isMovineQuadrant)
			{
				isMovineQuadrant = false;
					
				m_selectorIndicate.visible = true;
				m_moveIndicate.visible = false;
				
				
			} else {
				//pt = checkIndicateVisible(me);
				
				if (m_selecingHitPoint)
				{
					var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
					curEdtQuadrant.getMappedPoint(_ptVArr);
					var rect : Rectangle ;
					
					if (m_selectorIndicate.alpha == 1)
					{
						
						var pt : Point = this.globalToLocal(new Point(me.stageX , me.stageY));
						rect = m_selectorIndicate.getRect(this);
						
						
						for each (var __ptv : EdtVertexInfo in _ptVArr)
						{
							
							
							if (me.shiftKey)
							{
								if (rect.containsPoint(__ptv.point))
								{
									if (__ptv.dot.mode == EdtDot.DOT_SELECTED_MODE)
										__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
									else
										__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
								}
							}
							else {
								
								if (rect.containsPoint(__ptv.point))
								{
									__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
								}
								else 
								{
									__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
								}
							}
						}
						
						
					} else {
						
						
						rect = m_selecingShape.getRect(this);
						
						for each (__ptv in _ptVArr)
						{
							if (__ptv.dot.mode == EdtDot.DOT_SELECTING_MODE)
								__ptv.dot.mode = EdtDot.DOT_SELECTED_MODE;
							else if (__ptv.dot.mode == EdtDot.DOT_UNSELECTING_MODE)
								__ptv.dot.mode = EdtDot.DOT_NORMAL_MODE;
								
						}
					}
					
					for each (_eq in m_edtQuadrantVector)
					{	
						if (_eq && _eq != curEdtQuadrant)
						{
							_eq.updateDotStatus(_ptVArr);
						}
					}
					
					m_selecingShape.graphics.clear();
					m_selecingHitPoint = null;
					
					
					m_selectedEVI.length = 0;
					for each (__ptv in _ptVArr)
					{
						if (__ptv.dot.selected)
						{
							m_selectedEVI.push(__ptv);
							//trace(__ptv.dot.x , __ptv.dot.y);
						}
					}
					
					if (m_selectedEVI.length)
					{
						if (m_editMode == EDIT_MODE_MOVE)
						{
							computeOperatorIndicatePos();
						}
					}
				}
				
			}
			m_selectorIndicate.alpha = 1;
			
			return CallbackCenter.EVENT_OK;
		}
		
		private function computeOperatorIndicatePos(quadChange : Boolean = false):void
		{
			m_operatorIndicate.visible = true;
			var __x : Number = 0;
			var __y : Number = 0;
			
			if (quadChange)
			{
				var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
				curEdtQuadrant.getMappedPoint(_ptVArr);
				m_selectedEVI.length = 0;
				for each (__ptv in _ptVArr)
				{
					if (__ptv.dot.selected)
					{
						m_selectedEVI.push(__ptv);
					}
				}
			}
			
			
			
			for each (var __ptv : EdtVertexInfo in m_selectedEVI)
			{
				__x += __ptv.point.x;
				__y += __ptv.point.y;
				
			}
			//trace(__x , __y);
			
			__x /= m_selectedEVI.length;
			__y /= m_selectedEVI.length;
			
			m_operatorIndicate.x = __x;
			m_operatorIndicate.y = __y;
			
			if (quadChange)
			{
				if (curEdtQuadrant == m_edtQuadrantVector[0])
					m_operatorIndicate.setMode("XZ");
				else if (curEdtQuadrant == m_edtQuadrantVector[1])
					m_operatorIndicate.setMode("PERSP");
				else if (curEdtQuadrant == m_edtQuadrantVector[2])
					m_operatorIndicate.setMode("XY");
				else if (curEdtQuadrant == m_edtQuadrantVector[3])
					m_operatorIndicate.setMode("ZY");
			}
			
				
			
			
			
			
		}
		
		private function onMouseWheel(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
			
			if (me.altKey && curEdtQuadrant)
			{
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullScreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullScreen ? 2 : 1))
					)
				{
					
					curEdtQuadrant._sQ += me.delta > 0 ? 1 : -1;
				}
				
				
			}
			

			
			return CallbackCenter.EVENT_OK;
		}
		
		public function dispose() : void
		{
			
			if (m_indicate)
			{
				if (m_indicate.parent)
					m_indicate.parent.removeChild(m_indicate);
				m_moveIndicate = null;
				m_selectorIndicate = null;

				
				GraphicsUtil.removeAllChildren(m_indicate);
				
				m_indicate = null;

			}
			
			if (m_operatorIndicate)
			{
				m_operatorIndicate.dispose();
				m_operatorIndicate = null;
			}
			
			curEdtQuadrant = null;
			m_selecingShape = null;
			m_selecingHitPoint = null;
			m_selectedEVI = null;
			m_operatorCenter = null;
			m_operatorOffset = null;
			
			deactivate();
			
			GraphicsUtil.removeAllChildren(this);
			
			changeFunction = null;
		}
		
	}

}