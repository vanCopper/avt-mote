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
	import editor.ui.EdtVertexInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
				if (m_editMode)
					m_editMode = 0;
			}
			else if (me.keyCode == 81) // esc
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
						setOperatorIndicatePos();
					}
					
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
		
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
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
						&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullSreen ? 2 : 1))
						&& pt.y >= 0
						&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullSreen ? 2 : 1))
						)
					{
						m_selectorIndicate.visible = false;
						m_moveIndicate.visible = true;
						
						
						var offX : Number = -m_indicate.x + pt.x;
						var offY : Number = -m_indicate.y + pt.y;
						m_indicate.x = pt.x;
						m_indicate.y = pt.y;
						
						if (curEdtQuadrant.fullSreen)
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
		}
		
		private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			
			checkAlt(me);
			
			if (!curEdtQuadrant)
				return CallbackCenter.EVENT_OK;
			if (m_operatorMoving)
			{
				
			}
			else if (me.altKey )
			{
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullSreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullSreen ? 2 : 1))
					)
				{
					m_indicate.visible = true;
					m_selectorIndicate.visible = false;
					m_moveIndicate.visible = true;
					
					m_indicate.x = pt.x;
					m_indicate.y = pt.y;
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
				
				
				
				curEdtQuadrant.map2DTo3D();
				
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
					setOperatorIndicatePos();
				}
				m_operatorMoving = false;
				
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
							setOperatorIndicatePos();
						}
						
						
					}
				}
				
			}
			m_selectorIndicate.alpha = 1;
			
			return CallbackCenter.EVENT_OK;
		}
		
		private function setOperatorIndicatePos():void
		{
			m_operatorIndicate.visible = true;
			var __x : Number = 0;
			var __y : Number = 0;
			
			for each (var __ptv : EdtVertexInfo in m_selectedEVI)
			{
				__x += __ptv.point.x;
				__y += __ptv.point.y;
				
			}
			trace(__x , __y);
			
			__x /= m_selectedEVI.length;
			__y /= m_selectedEVI.length;
			
			m_operatorIndicate.x = __x;
			m_operatorIndicate.y = __y;
			
			
			
			
		}
		
		private function onMouseWheel(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
			
			if (me.altKey && curEdtQuadrant)
			{
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullSreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullSreen ? 2 : 1))
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
			
			
		}
		
	}

}