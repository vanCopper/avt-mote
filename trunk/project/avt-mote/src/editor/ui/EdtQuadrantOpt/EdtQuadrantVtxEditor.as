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
		private var m_editModeInsertBack : int;
		private static const EDIT_MODE_MOVE : int = 1;
		private static const EDIT_MODE_SCALE : int = 2;
		private static const EDIT_MODE_ROTATION : int = 3;
		
		private static const EDIT_MODE_INSERT : int = 5;
		
		private var m_operatorCenter : Point = new Point ();
		private var m_operatorOffset : Point = new Point ();

		private var m_operatorDoing : Boolean;
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
			if (m_editMode == EDIT_MODE_MOVE || m_editMode == EDIT_MODE_SCALE || m_editMode == EDIT_MODE_ROTATION)
			{
				m_editMode = 0;
				m_indicate.mode = /*ke.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : */EdtQuadrantIndicate.SELECT_POINT;
				if (m_operatorDoing)
					m_operatorDoing = false;
				m_operatorIndicate.visible = false;	
			}
		}
		public function onSelectNothing(quadChange : Boolean , curEdtQuadrant:EdtQuadrant) : void
		{
			if (m_editMode != EDIT_MODE_INSERT)
				m_operatorIndicate.alpha = 0.5;
		}
		public function onSelectChanged(quadChange : Boolean , curEdtQuadrant:EdtQuadrant) : void
		{
			if (m_editMode)
			{
				if (m_editMode != EDIT_MODE_INSERT)
					computeOperatorIndicatePos(quadChange , curEdtQuadrant);
				else
					m_operatorIndicate.alpha = 1;
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
			
		}
		
		private function onStartMove(me : MouseEvent , m : int):void 
		{
			if (!m_selectedEVI.length)
				return;
			
			m_operatorOffset.x = -me.stageX + m_operatorIndicate.x;
			m_operatorOffset.y = -me.stageY + m_operatorIndicate.y;
			
			
			m_operatorDir = m;
			m_operatorDoing = true;
			m_indicate.mode = EdtQuadrantIndicate.NONE;
			
			m_operatorCenter.x = m_operatorIndicate.x;
			m_operatorCenter.y = m_operatorIndicate.y;
			
			///
			///var curEdtQuadrant : EdtQuadrant;
			///curEdtQuadrant.getMappedPoint(null);
		}
		
		private function onStartInsert(me : MouseEvent , m : int):void 
		{
			
			
			m_operatorOffset.x = -me.stageX + m_operatorIndicate.x;
			m_operatorOffset.y = -me.stageY + m_operatorIndicate.y;
			m_operatorDir = m;
			m_operatorDoing = true;
			m_indicate.mode = EdtQuadrantIndicate.NONE;
			
						
		}
		
		private function onStartScale(me : MouseEvent , m : int):void 
		{
			if (!m_selectedEVI.length)
				return;
				
			m_operatorOffset.x = -me.stageX + m_operatorIndicate.x;
			m_operatorOffset.y = -me.stageY + m_operatorIndicate.y;
			
			
			m_operatorDir = m;
			m_operatorDoing = true;
			m_indicate.mode = EdtQuadrantIndicate.NONE;
			
			m_operatorCenter.x = m_operatorIndicate.x;
			m_operatorCenter.y = m_operatorIndicate.y;
			
			
		}
		
		private function onStartRotation(me : MouseEvent , m : int):void 
		{
			if (!m_selectedEVI.length)
				return;
				
			m_operatorOffset.x = -me.stageX + m_operatorIndicate.x;
			m_operatorOffset.y = -me.stageY + m_operatorIndicate.y;
			
			
			m_operatorDir = m;
			m_operatorDoing = true;
			m_indicate.mode = EdtQuadrantIndicate.NONE;
			
			m_operatorCenter.x = m_operatorIndicate.x;
			m_operatorCenter.y = m_operatorIndicate.y;
			
			//trace(m_operatorIndicate.mouseY , m_operatorIndicate.mouseX );
			m_operatorIndicate.startRadian = Math.atan2(m_operatorIndicate.mouseY , m_operatorIndicate.mouseX );
			//trace(m_operatorIndicate.startRadian);
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
			if (m_operatorDoing)
			{
				return 1;
			}
			return 0;
		}
		private function setVertexPosRotation(curEdtQuadrant : EdtQuadrant , offRadian : Number) : void
		{
			var __pt : Point = new Point();
			for each (var __ptv : EdtVertexInfo in m_selectedEVI)
			{
				var offX : Number = __ptv.point.x -  m_operatorCenter.x;
				var offY : Number = __ptv.point.y -  m_operatorCenter.y;
				
				var length : Number = Math.sqrt(offX * offX + offY * offY);
				var oldR : Number = Math.atan2(offY , offX);
				var newR : Number = oldR - offRadian;
				__pt.x = m_operatorCenter.x + Math.cos(newR) * length;
				__pt.y = m_operatorCenter.y + Math.sin(newR) * length;
			
				//trace(__ptv.dot.x , __ptv.dot.y , __ptv.dot.transform.colorTransform);
				curEdtQuadrant.converMappedPointToDot(__pt , __ptv.dot);
				//trace(__ptv.dot.x , __ptv.dot.y);
			}
			
			
			curEdtQuadrant.renderLine(false);
			
			if (m_changeFunction != null)
				m_changeFunction(true , curEdtQuadrant);
			
		}
		
		
		private function setVertexPosScale(curEdtQuadrant : EdtQuadrant , optPosScale : Point) : void
		{
			var offX : Number = -optPosScale.x + m_operatorCenter.x ;
			var offY : Number = -optPosScale.y + m_operatorCenter.y ;
			var __pt : Point = new Point();
			
			offX /= curEdtQuadrant._sQ;
			offY /= curEdtQuadrant._sQ;
			
			//trace(curEdtQuadrant._sQ)
			for each (var __ptv : EdtVertexInfo in m_selectedEVI)
			{
				__pt.x = __ptv.point.x +  (-__ptv.point.x + m_operatorCenter.x) * offX / (4);
				__pt.y = __ptv.point.y +  (-__ptv.point.y + m_operatorCenter.y) * offY / (4);
			
				//trace(__ptv.dot.x , __ptv.dot.y , __ptv.dot.transform.colorTransform);
				curEdtQuadrant.converMappedPointToDot(__pt , __ptv.dot);
				//trace(__ptv.dot.x , __ptv.dot.y);
			}
			
			
			curEdtQuadrant.renderLine(false);
			
			if (m_changeFunction != null)
				m_changeFunction(true , curEdtQuadrant);
					
			
			
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
			
			if (m_operatorDoing)
			{
				if (!m_selectedEVI.length && m_editMode != EDIT_MODE_INSERT)
					return 1;
					
				var optPos : Point = new Point();
				optPos.x = m_operatorOffset.x + me.stageX;
				optPos.y = m_operatorOffset.y + me.stageY;
				
				if (m_editMode == EDIT_MODE_MOVE)
				{
					if (m_operatorDir != -1)
						m_operatorIndicate.x = optPos.x;
					if (m_operatorDir != 1)
						m_operatorIndicate.y = optPos.y;
					setVertexPosMove(curEdtQuadrant);
				}
				else if (m_editMode == EDIT_MODE_SCALE) {
					var optPosScale : Point = new Point();
					
					if (m_operatorDir == -1)
					{	
						optPosScale.x = m_operatorIndicate.x;
						optPosScale.y = optPos.y;
					}
					else if (m_operatorDir == 0)
					{	
						var newOff : Number = (Math.abs(m_operatorIndicate.x -  optPos.x) + Math.abs(m_operatorIndicate.y -  optPos.y)) / 2
						
						optPosScale.x = (optPos.x - m_operatorIndicate.x);
						optPosScale.y = (optPos.y - m_operatorIndicate.y);
						
						if (optPosScale.x)
							optPosScale.x = Math.abs(optPosScale.x) / optPosScale.x * newOff + m_operatorIndicate.x;
						else
							optPosScale.x = m_operatorIndicate.x;
							
						if (optPosScale.y)
							optPosScale.y = Math.abs(optPosScale.y) / optPosScale.y * newOff + m_operatorIndicate.y;
						else
							optPosScale.y = m_operatorIndicate.y;
					}	
					else if (m_operatorDir == 1)
					{	
						optPosScale.x = optPos.x;
						optPosScale.y = m_operatorIndicate.y;	
					}	
					setVertexPosScale(curEdtQuadrant , optPosScale);
				}
				else if (m_editMode == EDIT_MODE_ROTATION) {
					var newR : Number = Math.atan2(m_operatorIndicate.mouseY , m_operatorIndicate.mouseX );
					m_operatorIndicate.drawRotationUpdate(newR);
					
					setVertexPosRotation(curEdtQuadrant , newR - m_operatorIndicate.startRadian);
					 
				} 
				else if (m_editMode == EDIT_MODE_INSERT) {
					if (m_operatorDir != -1)
						m_operatorIndicate.x = optPos.x;
					if (m_operatorDir != 1)
						m_operatorIndicate.y = optPos.y;
				}
				return 1;
					
			}
			return 0;
		}
		
		public function onMouseUp(me : MouseEvent , curEdtQuadrant : EdtQuadrant):int
		{
			
			if (m_operatorDoing)
			{
				if (m_editMode == EDIT_MODE_MOVE)
					setVertexPosMove(curEdtQuadrant);
				else if (m_editMode == EDIT_MODE_SCALE)
				{
					//donothing for simple deal
				}
				else if (m_editMode == EDIT_MODE_ROTATION)
				{
					m_operatorIndicate.drawRotationUpdate(m_operatorIndicate.startRadian); //just clean
				}
				else if (m_editMode == EDIT_MODE_INSERT)
				{
					m_operatorDoing = false;
					m_indicate.mode = me.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : EdtQuadrantIndicate.SELECT_POINT;
					return 1;
				}
				
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
				m_operatorDoing = false;
				m_indicate.mode = me.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : EdtQuadrantIndicate.SELECT_POINT;
				
				
				return 1;
			}
		
		
		
			return 0;
		}
		
		
		public function onKeyDown(ke : KeyboardEvent , curEdtQuadrant : EdtQuadrant):int
		{
			//trace (ke.keyCode);
			var _oldEditMode : int = m_editMode;
			
			if (ke.keyCode == 27) // esc
			{
				
				if (m_editMode == EDIT_MODE_MOVE || m_editMode == EDIT_MODE_SCALE || m_editMode == EDIT_MODE_ROTATION)
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
					if (m_operatorDoing)
						m_operatorDoing = false;
					m_operatorIndicate.visible = false;	
				}
				else if (m_editMode != EDIT_MODE_INSERT)
				{
					m_editMode = EDIT_MODE_MOVE;
					if (m_selectedEVI.length)
					{
						if (_oldEditMode == 0)
							computeOperatorIndicatePos(true, curEdtQuadrant);
						else
							setOperatorIndicate(curEdtQuadrant);
					}
					setStartMoveFunc();
				}
				return 1;
			} 
			else if (ke.keyCode == 87) // w
			{
				if (m_editMode == EDIT_MODE_SCALE)
				{
					m_editMode = 0;
					m_indicate.mode = ke.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : EdtQuadrantIndicate.SELECT_POINT;
					if (m_operatorDoing)
						m_operatorDoing = false;
					m_operatorIndicate.visible = false;	
				}
				else if (m_editMode != EDIT_MODE_INSERT)
				{
					m_editMode = EDIT_MODE_SCALE;
					if (m_selectedEVI.length)
					{
						if (_oldEditMode == 0)
							computeOperatorIndicatePos(true, curEdtQuadrant);
						else
							setOperatorIndicate(curEdtQuadrant);
					}
					setStartMoveFunc();
				}
				return 1;
			} 
			else if (ke.keyCode == 69) // e
			{
				
				if (m_editMode == EDIT_MODE_ROTATION)
				{
					m_editMode = 0;
					m_indicate.mode = ke.altKey ? EdtQuadrantIndicate.VIEW_CONTROL : EdtQuadrantIndicate.SELECT_POINT;
					if (m_operatorDoing)
						m_operatorDoing = false;
					m_operatorIndicate.visible = false;	
				}
				else if (m_editMode != EDIT_MODE_INSERT)
				{
					m_editMode = EDIT_MODE_ROTATION;
					if (m_selectedEVI.length)
					{
						if (_oldEditMode == 0)
							computeOperatorIndicatePos(true, curEdtQuadrant);
						else
							setOperatorIndicate(curEdtQuadrant);
					}
					setStartMoveFunc();
				}
				return 1;
				
			}
			else if (ke.keyCode == 45) // insert
			{
				
				if (m_editMode == EDIT_MODE_SCALE || m_editMode == EDIT_MODE_MOVE || m_editMode == EDIT_MODE_ROTATION)
				{
					m_editModeInsertBack = m_editMode;
					m_editMode = EDIT_MODE_INSERT;
					setStartMoveFunc();
					setOperatorIndicate(curEdtQuadrant);
					m_operatorIndicate.alpha = 1;
				}
				else if (m_editMode == EDIT_MODE_INSERT)
				{
					m_editMode = m_editModeInsertBack;
					setStartMoveFunc();
					setOperatorIndicate(curEdtQuadrant);
					m_operatorIndicate.alpha = m_selectedEVI.length ? 1 : 0.5;
				}
				
				
			}
			return 0;
		}
		private function setStartMoveFunc():void
		{
			if (m_editMode == EDIT_MODE_MOVE)
			{
				m_operatorIndicate.startMoveFunc = onStartMove;
			}
			else if (m_editMode == EDIT_MODE_SCALE)
			{
				m_operatorIndicate.startMoveFunc = onStartScale;
			}
			else if (m_editMode == EDIT_MODE_ROTATION)
			{
				m_operatorIndicate.startMoveFunc = onStartRotation;
			}
			else if (m_editMode == EDIT_MODE_INSERT)
			{
				m_operatorIndicate.startMoveFunc = onStartInsert;
			}
		}
		
		private function setOperatorIndicate(curEdtQuadrant : EdtQuadrant):void
		{
			//if (quadChange)
			{
				if (curEdtQuadrant.quadrant == 0)
				{	
					m_operatorIndicate.setMode("XZ" , m_editMode);
					//m_operatorIndicate.rotation = 0;
				}
				else if (curEdtQuadrant.quadrant == 1)
				{	
					m_operatorIndicate.setMode("PERSP" , m_editMode);
					//m_operatorIndicate.rotation = (-curEdtQuadrant._yQ);
				}
				else if (curEdtQuadrant.quadrant == 2)
				{	
					m_operatorIndicate.setMode("XY" , m_editMode);
					//m_operatorIndicate.rotation = 0;
				}
				else if (curEdtQuadrant.quadrant == 3)
				{	
					m_operatorIndicate.setMode("ZY" , m_editMode);
					//m_operatorIndicate.rotation = 0;
				}
			}
			
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
			
			if (!m_selectedEVI.length)
			{	
				m_operatorIndicate.alpha = 0.5;
				setOperatorIndicate(curEdtQuadrant);
				return;
			}
			else
				m_operatorIndicate.alpha = 1 ;
			
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
			
			setOperatorIndicate(curEdtQuadrant);
			
			
		}
		
		
		
	}

}