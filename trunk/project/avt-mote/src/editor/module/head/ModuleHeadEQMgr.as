package editor.module.head 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.ui.EdtQuadrant;
	import flash.display.Shape;
	import flash.display.Sprite;
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
		
		public var curEdtQuadrant : EdtQuadrant;
		public var isEditing : Boolean;
		
		public function ModuleHeadEQMgr() 
		{
			m_moveIndicate = new Shape();
			m_moveIndicate.graphics.beginFill(0x0);
			
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

			}
			
		}
		
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			checkAlt(me);
			
			if (isEditing && me.altKey && curEdtQuadrant)
			{
				
				
				var pt : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
			
				if (pt.x >= 0
					&& pt.x < (EdtDEF.QUADRANT_WIDTH * (curEdtQuadrant.fullSreen ? 2 : 1))
					&& pt.y >= 0
					&& pt.y < (EdtDEF.QUADRANT_HEIGHT * (curEdtQuadrant.fullSreen ? 2 : 1))
					)
				{
					
					var offX : Number = -m_moveIndicate.x + pt.x;
					var offY : Number = -m_moveIndicate.y + pt.y;
					m_moveIndicate.x = pt.x;
					m_moveIndicate.y = pt.y;
					
					if (curEdtQuadrant.fullSreen)
					{
						offX /= 2;
						offY /= 2;
					}
					
					curEdtQuadrant.QuadrantRelateDrag(offX , offY);
					
					isEditing = true;
				}
				
				
			}
			
			
						
			return CallbackCenter.EVENT_OK;
		}
		private function checkAlt(me : MouseEvent): void
		{
			if (!me.altKey && isEditing)
			{
				isEditing = false;
				if (m_moveIndicate && m_moveIndicate.parent)
					m_moveIndicate.parent.removeChild(m_moveIndicate);
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
					
					
					curEdtQuadrant.addChild(m_moveIndicate);
					
					m_moveIndicate.x = pt.x;
					m_moveIndicate.y = pt.y;
					isEditing = true;
					
				}
				
				
			}
			
			
						
			return CallbackCenter.EVENT_OK;
		}
		private function onMouseUp(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			
			var me : MouseEvent = args as MouseEvent;
			
			
			if (isEditing)
			{
				isEditing = false;
				if (m_moveIndicate && m_moveIndicate.parent)
					m_moveIndicate.parent.removeChild(m_moveIndicate);
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
			
			if (m_moveIndicate)
			{
				if (m_moveIndicate.parent)
					m_moveIndicate.parent.removeChild(m_moveIndicate);
				m_moveIndicate = null;

			}
			deactivate();
			
			GraphicsUtil.removeAllChildren(this);
			
			
		}
		
	}

}