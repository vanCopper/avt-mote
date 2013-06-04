package editor.ui.EdtQuadrantOpt 
{
	import editor.ui.EdtOperator;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtQuadrantIndicate;
	import editor.ui.EdtVertexInfo;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantVtxEditor
	{
		
		private var m_editMode : int;
		private static const EDIT_MODE_MOVE : int = 1;
		private static const EDIT_MODE_SCALE : int = 2;
		

		private var m_operatorCenter : Point = new Point ();
		private var m_operatorOffset : Point = new Point ();

		private var m_operatorMoving : Boolean;
		private var m_operatorDir : int;
		
		private var m_selectedEVI : Vector.<EdtVertexInfo>;
		private var m_operatorIndicate : EdtOperator;
		private var m_indicate : EdtQuadrantIndicate;
		private var m_changeFunction : Function;
		
		public function remainQuadrant(_e0 : EdtQuadrant):void
		{	
			m_operatorDir = _e0.quadrant;
		}
		public function resetSelect():void
		{
			if (m_editMode == EDIT_MODE_MOVE)
			{
				m_editMode = 0;
				m_indicate.mode = /*ke.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : */EdtQuadrantIndicate.SELECT_POINT;
				if (m_operatorMoving)
					m_operatorMoving = false;
				m_operatorIndicate.visible = false;	
			}
		}
		
		public function onSelectChanged(quadChange : Boolean , curEdtQuadrant:EdtQuadrant) : void
		{
			if (m_editMode)
			{
				computeOperatorIndicatePos(quadChange , curEdtQuadrant);
			}
		}
		
		public function EdtQuadrantVtxEditor(_indicate : EdtQuadrantIndicate ,  _root : DisplayObjectContainer , a_selectedEVI : Vector.<EdtVertexInfo> , a_changeFunction : Function) 
		{
			m_selectedEVI = a_selectedEVI;
			m_indicate = _indicate;
			m_operatorIndicate = new EdtOperator();
			m_changeFunction = a_changeFunction;
		
			
			m_operatorIndicate.x = 100;
			m_operatorIndicate.y = 100;
			_root.addChild(m_operatorIndicate);
			m_operatorIndicate.visible = false;
			m_operatorIndicate.startMoveFunc = onStartMove;
		}
		
		private function onStartMove(me : MouseEvent , m : int):void 
		{
			m_operatorOffset.x = -me.stageX + m_operatorIndicate.x;
			m_operatorOffset.y = -me.stageY + m_operatorIndicate.y;
			
			
			m_operatorDir = m;
			m_operatorMoving = true;
			m_indicate.mode = EdtQuadrantIndicate.NONE;
			
			m_operatorCenter.x = m_operatorIndicate.x;
			m_operatorCenter.y = m_operatorIndicate.y;
			
			///
			///var curEdtQuadrant : EdtQuadrant;
			///curEdtQuadrant.getMappedPoint(null);
		}
		
		public function dispose(): void
		{
			m_selectedEVI = null;
			
			if (m_operatorIndicate)
			{	
				
				m_operatorIndicate.dispose();
				m_operatorIndicate = null;
			}
			m_indicate = null;
			m_changeFunction = null;
		}
		
		
		
		
		
		public function onMouseDown(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (m_operatorMoving)
			{
				return 1;
			}
			return 0;
		}
		
		private function setVertexPosMove(curEdtQuadrant : EdtQuadrant ) : void
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
			
			if (m_changeFunction != null)
				m_changeFunction(true , curEdtQuadrant);
					
			
			
		}
		
		
		public function onMouseMove(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			
			if (m_operatorMoving)
			{
				var optPos : Point = new Point();
				optPos.x = m_operatorOffset.x + me.stageX;
				optPos.y = m_operatorOffset.y + me.stageY;
				
				if (m_operatorDir != -1)
					m_operatorIndicate.x = optPos.x;
				if (m_operatorDir != 1)
					m_operatorIndicate.y = optPos.y;
					
				setVertexPosMove(curEdtQuadrant);
				
				return 1;
					
			}
			return 0;
		}
		
		public function onMouseUp(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			
			if (m_operatorMoving)
			{
				setVertexPosMove(curEdtQuadrant);
				
				var _ptm : Point = curEdtQuadrant.globalToLocal(new Point(me.stageX , me.stageY));
				m_indicate.x = _ptm.x + curEdtQuadrant.x;
				m_indicate.y = _ptm.y + curEdtQuadrant.y;
				
				
				curEdtQuadrant.map2DTo3D();
				
				if (m_changeFunction != null)
					m_changeFunction(false , curEdtQuadrant);
				
					
				
				var _ptVArr : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
				curEdtQuadrant.getMappedPoint(_ptVArr);
				var needReselect : Boolean;
				
				for each (var __ptv : EdtVertexInfo in _ptVArr)
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
					computeOperatorIndicatePos(false , curEdtQuadrant );
				}
				m_operatorMoving = false;
				m_indicate.mode = me.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : EdtQuadrantIndicate.SELECT_POINT;
				
				
				return 1;
			}
		
		
		
			return 0;
		}
		
		
		public function onKeyDown(ke : KeyboardEvent , curEdtQuadrant : EdtQuadrant):int
		{
			if (ke.keyCode == 27) // esc
			{
				
				if (m_editMode == EDIT_MODE_MOVE)
				{
					resetSelect();
					return 1;
				}
			}
			else if (ke.keyCode == 81) // q
			{
				if (m_editMode == EDIT_MODE_MOVE)
				{
					m_editMode = 0;
					m_indicate.mode = ke.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : EdtQuadrantIndicate.SELECT_POINT;
					if (m_operatorMoving)
						m_operatorMoving = false;
					m_operatorIndicate.visible = false;	
				}
				else
				{
					m_editMode = EDIT_MODE_MOVE;
					if (m_selectedEVI.length)
					{
						computeOperatorIndicatePos(true,curEdtQuadrant);
					}
				}
				return 1;
			} 
			
			return 0;
		}
		
		
		private function computeOperatorIndicatePos(quadChange : Boolean , curEdtQuadrant : EdtQuadrant ):void
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
			
			//if (quadChange)
			{
				if (curEdtQuadrant.quadrant == 0)
				{	
					m_operatorIndicate.setMode("XZ");
					//m_operatorIndicate.rotation = 0;
				}
				else if (curEdtQuadrant.quadrant == 1)
				{	
					m_operatorIndicate.setMode("PERSP");
					//m_operatorIndicate.rotation = (-curEdtQuadrant._yQ);
				}
				else if (curEdtQuadrant.quadrant == 2)
				{	
					m_operatorIndicate.setMode("XY");
					//m_operatorIndicate.rotation = 0;
				}
				else if (curEdtQuadrant.quadrant == 3)
				{	
					m_operatorIndicate.setMode("ZY");
					//m_operatorIndicate.rotation = 0;
				}
			}
			
				
			
			
			
			
		}
		
		
		
	}

}