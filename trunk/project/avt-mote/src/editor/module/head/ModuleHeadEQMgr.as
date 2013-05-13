package editor.module.head 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtSelector;
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
		public var isEditing : Boolean;
		
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
			
			
			
			return CallbackCenter.EVENT_OK;
		}
		
		private function checkAlt(me : MouseEvent): void
		{
			if (!me.altKey && isEditing)
			{
				isEditing = false;
				m_moveIndicate.visible = false;
				m_selectorIndicate.visible = true;
			}
		}
		
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
			if (isEditing && me.altKey )
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
						
						isEditing = true;
					}
				}
			} else {
				checkIndicateVisible(me);
			}
			
			
						
			return CallbackCenter.EVENT_OK;
		}
		private function checkIndicateVisible(me : MouseEvent) : void
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
					isEditing = true;
					
				}
				
			} else {
				checkIndicateVisible(me);
			}
			return CallbackCenter.EVENT_OK;
		}
		
		
		private function onMouseUp(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			
			var me : MouseEvent = args as MouseEvent;
			
			
			if (isEditing)
			{
				isEditing = false;
					
				m_selectorIndicate.visible = true;
				m_moveIndicate.visible = false;
			} 
			
			
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
			
			
			deactivate();
			
			GraphicsUtil.removeAllChildren(this);
			
			
		}
		
	}

}