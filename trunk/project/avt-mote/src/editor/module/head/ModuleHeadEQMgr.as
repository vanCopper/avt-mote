package editor.module.head 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.ui.EdtDot;
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
		private var m_moveIndicate : Shape;
		private var m_selectorIndicate : EdtSelector;
		private var m_indicate : Sprite;
		
		public var curEdtQuadrant : EdtQuadrant;
		public var isMovine : Boolean;
		
		public var m_selecingShape : Shape;
		public var m_selecingHitPoint : Point;
		
		public function ModuleHeadEQMgr() 
		{
			m_indicate = new Sprite();
			
			m_moveIndicate = new Shape();
			m_moveIndicate.graphics.beginFill(0x0);
			
			m_selectorIndicate = new EdtSelector();
			
			m_indicate.addChild(m_moveIndicate);
			m_indicate.addChild(m_selectorIndicate);
			//m_moveIndicate.graphics.lineStyle(1);
			
			const leng : int = 10;
			const leng2 : int = 4;
			const w : int = 3;
			const w2 : int = 1;
			
			m_moveIndicate.graphics.moveTo(0 , -leng);
			m_moveIndicate.graphics.lineTo(w , -leng2);
			m_moveIndicate.graphics.lineTo(w2 , -leng2);
			m_moveIndicate.graphics.lineTo(w2 , -w2);
			m_moveIndicate.graphics.lineTo(leng2 , -w2);
			m_moveIndicate.graphics.lineTo(leng2 , -w);
			m_moveIndicate.graphics.lineTo(leng , 0);
			m_moveIndicate.graphics.lineTo(leng2 , w);
			m_moveIndicate.graphics.lineTo(leng2 , w2);
			m_moveIndicate.graphics.lineTo(w2 , w2);
			m_moveIndicate.graphics.lineTo(w2 , leng2);
			m_moveIndicate.graphics.lineTo(w , leng2);
			m_moveIndicate.graphics.lineTo(0 , leng);
			m_moveIndicate.graphics.lineTo(-w , leng2);
			m_moveIndicate.graphics.lineTo(-w2 , leng2);
			m_moveIndicate.graphics.lineTo( -w2 , w2);
			m_moveIndicate.graphics.lineTo( -leng2 , w2);
			m_moveIndicate.graphics.lineTo( -leng2 , w);
			m_moveIndicate.graphics.lineTo( -leng , 0);
			m_moveIndicate.graphics.lineTo( -leng2 , -w);
			m_moveIndicate.graphics.lineTo( -leng2 , -w2);
			m_moveIndicate.graphics.lineTo( -w2 , -w2);
			m_moveIndicate.graphics.lineTo(-w2 , -leng2);
			m_moveIndicate.graphics.lineTo( -w , -leng2);
			m_moveIndicate.graphics.lineTo(0 , -leng);
		
			m_moveIndicate.graphics.endFill();
			
			
			//m_moveIndicate.x = 760;
			//m_moveIndicate.y = 4;
			m_moveIndicate.filters = [new GlowFilter(0xFFFF00 , 0.75)]
			//m_moveIndicate.visible = false;
			//m_indicate.x = m_indicate.y = 100;
			
			m_moveIndicate.visible = false;
			m_selectorIndicate.visible = true;
			
			addChild(m_indicate);
			
			m_selecingShape = new Shape();
			addChild(m_selecingShape);
			
			
			
			//addChild(m_moveIndicate);
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
				m_selectorIndicate.clickAccuracy++;
			} 
			else if (me.keyCode == 189) // -
			{
				var clickAccuracy : int = m_selectorIndicate.clickAccuracy;
				if (clickAccuracy > 1)
					clickAccuracy--;
				m_selectorIndicate.clickAccuracy = 	clickAccuracy;
			}
			
			return CallbackCenter.EVENT_OK;
		}
		
		private function checkAlt(me : MouseEvent): void
		{
			if (!me.altKey && isMovine)
			{
				isMovine = false;
				m_moveIndicate.visible = false;
				m_selectorIndicate.visible = true;
			}
		}
		
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
			if (isMovine && me.altKey )
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
						
						isMovine = true;
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
		
		private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
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
					m_indicate.visible = true;
					m_selectorIndicate.visible = false;
					m_moveIndicate.visible = true;
					
					m_indicate.x = pt.x;
					m_indicate.y = pt.y;
					isMovine = true;
					
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
			return CallbackCenter.EVENT_OK;
		}
		
		
		private function onMouseUp(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			
			var me : MouseEvent = args as MouseEvent;
			
			
			if (isMovine)
			{
				isMovine = false;
					
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
				}
				
			}
			m_selectorIndicate.alpha = 1;
			
			return CallbackCenter.EVENT_OK;
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
			m_selecingShape = null;
			m_selecingHitPoint = null;
			
			deactivate();
			
			GraphicsUtil.removeAllChildren(this);
			
			
		}
		
	}

}