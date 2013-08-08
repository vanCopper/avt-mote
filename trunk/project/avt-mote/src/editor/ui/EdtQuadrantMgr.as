package editor.ui 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.ui.EdtQuadrantOpt.EdtQuadrantFocusSwitch;
	import editor.ui.EdtQuadrantOpt.EdtQuadrantSelector;
	import editor.ui.EdtQuadrantOpt.EdtQuadrantViewCtrl;
	import editor.ui.EdtQuadrantOpt.EdtQuadrantVisibleCtrl;
	import editor.ui.EdtQuadrantOpt.EdtQuadrantVtxEditor;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class EdtQuadrantMgr extends Sprite
	{
		
		
		public var curEdtQuadrant : EdtQuadrant;
		private var m_edtQuadrantVector : Vector.<EdtQuadrant> = new Vector.<EdtQuadrant>(4 , true);
		protected var m_selectedEVI : Vector.<EdtVertexInfo> = new Vector.<EdtVertexInfo>();
		
		public var changeFunction : Function;
		
		private var m_has4Qurad : Boolean;
		private var m_crossShape : Shape;
		
		private var m_regCallBack : Boolean;
		
		
		protected var m_viewCtrl : EdtQuadrantViewCtrl;
		protected var m_selector : EdtQuadrantSelector;
		protected var m_vtxEditor : EdtQuadrantVtxEditor;
		protected var m_focusSwitch : EdtQuadrantFocusSwitch;
		protected var m_visbileCtrl : EdtQuadrantVisibleCtrl;
		private var m_indicate :  EdtQuadrantIndicate;
		
		public function setVertex(_vertexArray : Vector.<EdtVertex3D>) : void
		{
			for each( var _e : EdtQuadrant in m_edtQuadrantVector )
				 _e.setVertex(_vertexArray);
		}
		public function remainQuadrant(_e0 : EdtQuadrant):void
		{
			if (curEdtQuadrant  != _e0)
			{
				if (curEdtQuadrant.fullScreen)
				{	
					onFullScreenSet(curEdtQuadrant.quadrant , false);
					curEdtQuadrant.state = -1;
				}
			}
			
			if (m_edtQuadrantVector[0] && m_edtQuadrantVector[0].parent)
				m_edtQuadrantVector[0].parent.removeChild(m_edtQuadrantVector[0]);
			if (m_edtQuadrantVector[1] && m_edtQuadrantVector[1].parent)
				m_edtQuadrantVector[1].parent.removeChild(m_edtQuadrantVector[1]);
			if (m_edtQuadrantVector[2] && m_edtQuadrantVector[2].parent)
				m_edtQuadrantVector[2].parent.removeChild(m_edtQuadrantVector[2]);
			if (m_edtQuadrantVector[3] && m_edtQuadrantVector[3].parent)
				m_edtQuadrantVector[3].parent.removeChild(m_edtQuadrantVector[3]);
			
			m_edtQuadrantVector[0] = 	
			m_edtQuadrantVector[1] = 
			m_edtQuadrantVector[2] = 
			m_edtQuadrantVector[3] = null;
			curEdtQuadrant = _e0;
			curEdtQuadrant.state = 2;
			
			addChildAt(_e0 , 0);
			_e0.fullScreen = true;
			
			if (m_vtxEditor)
				m_vtxEditor.remainQuadrant(_e0);
		
			
			
			
			m_selectedEVI.length = 0;
			if (m_crossShape)
				m_crossShape.visible = false;
			
			m_has4Qurad = false;
		}
		
		public function setQuadrant(_e0 : EdtQuadrant , _e1 : EdtQuadrant , _e2 : EdtQuadrant , _e3 : EdtQuadrant ) : void
		{
			m_edtQuadrantVector[0] = _e0;
			m_edtQuadrantVector[1] = _e1;
			m_edtQuadrantVector[2] = _e2;
			m_edtQuadrantVector[3] = _e3;
			
			if (!m_crossShape)
			{
				var _shp : Shape = new Shape();
				_shp.graphics.lineStyle(1);
				
				_shp.graphics.moveTo(EdtDEF.QUADRANT_WIDTH , 0);
				_shp.graphics.lineTo(EdtDEF.QUADRANT_WIDTH , EdtDEF.QUADRANT_HEIGHT * 2);
				
				_shp.graphics.moveTo(0 ,  EdtDEF.QUADRANT_HEIGHT);
				_shp.graphics.lineTo(EdtDEF.QUADRANT_WIDTH * 2 , EdtDEF.QUADRANT_HEIGHT);
				
				m_crossShape = _shp;
				
			
			}
			m_crossShape.visible = true;
			
			addChildAt(m_edtQuadrantVector[3] , 0);
			addChildAt(m_edtQuadrantVector[2] , 0);
			addChildAt(m_edtQuadrantVector[1] , 0);
			addChildAt(m_edtQuadrantVector[0] , 0);
									
			addChild(m_crossShape);
			
			m_has4Qurad = true;
		}
		
		
		private function onUpdatePointStatus(except : EdtQuadrant , _ptVArr : Vector.<EdtVertexInfo>):void
		{
			for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
			{	
				if (_eq && _eq != except)
				{
					_eq.updateDotStatus(_ptVArr);
				}
			}
		}
		
		private function onFullScreenSet(pos : int , fullScreen : Boolean) : void
		{
			if (!fullScreen)
			{
				curEdtQuadrant.fullScreen = false;
				m_crossShape.visible = true;
				
				for each (_eq in m_edtQuadrantVector)
				{
					_eq.visible = true;
				}
				
				if (m_vtxEditor)
					m_vtxEditor.onSelectChanged(true , curEdtQuadrant);
				
			} else {
				curEdtQuadrant.fullScreen = true;
				
				for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
				{
					if (_eq != curEdtQuadrant)
						_eq.visible = false;
				}
				if (m_vtxEditor)
					m_vtxEditor.onSelectChanged(true , curEdtQuadrant);
					
				m_crossShape.visible = false;
			
			}
			
		}
			
		private function onFocusRealSet(pos : int , mode : int) : void
		{
			if (pos >= 4)
			{
				CONFIG::ASSERT {
					ASSERT(false , "error pos" + pos);
				}
				return;
			}
			
			var _ceq : EdtQuadrant  = m_edtQuadrantVector[pos];
			
			if (mode == 1)
			{
				for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
				{
					if (!_eq.isWorkOn)
					{
						_eq.state = -1;
					}
				}
				_ceq.state = 1;
			}
			else if (mode == 2)
			{
				for each (_eq  in m_edtQuadrantVector)
				{
					_eq.state = -1;
				}
				_ceq.state = 2;
				curEdtQuadrant = _ceq;
				
				if (m_vtxEditor)
					m_vtxEditor.onSelectChanged(true , curEdtQuadrant);

			}
			
			
			
		}
		
		
		
		private function onMouseMove(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			
			for (;; )
			{
				if (m_focusSwitch && m_has4Qurad)
				{
					if (m_focusSwitch.onMouseMove(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_vtxEditor)
				{
					if (m_vtxEditor.onMouseMove(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_viewCtrl)
				{
					if (m_viewCtrl.onMouseMove(me , curEdtQuadrant) != 0)
					{	
						if (m_vtxEditor) m_vtxEditor.onSelectChanged(true , curEdtQuadrant);
						break;
					}
				}
				if (m_selector)
				{
					if (m_selector.onMouseMove(me , curEdtQuadrant) != 0)
						break;
				}
				
				break;
			}
			
			
			return 0;
		}
		
		
		
		private function onMouseUp(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			
			for (;; )
			{
				if (m_vtxEditor)
				{
					if (m_vtxEditor.onMouseUp(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_viewCtrl)
				{
					if (m_viewCtrl.onMouseUp(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_selector)
				{
					var ret : int;
					ret = m_selector.onMouseUp(me , curEdtQuadrant)
					if (ret != 0)
					{	
						if (ret == 2)
						{
							if (m_vtxEditor) m_vtxEditor.onSelectChanged(false , curEdtQuadrant);
						}
						else
						{
							if (m_vtxEditor) m_vtxEditor.onSelectNothing(false , curEdtQuadrant);
						}
						
						break;
					}
				}
				
				break;
			}
			
			return 0;
		}
		private function onMouseDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			
			for (;; )
			{
				if (m_focusSwitch && m_has4Qurad)
				{
					if (m_focusSwitch.onMouseDown(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_vtxEditor)
				{
					if (m_vtxEditor.onMouseDown(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_viewCtrl)
				{
					if (m_viewCtrl.onMouseDown(me , curEdtQuadrant) != 0)
						break;
				}
				if (m_selector)
				{
					if (m_selector.onMouseDown(me , curEdtQuadrant) != 0)
					{	
						
						break;
					}
				}
				
				
				break;
			}
		
			
			
			
			return 0;
		}
		private function onMouseWheel(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			var me : MouseEvent = args as MouseEvent;
			
			for (;; )
			{
				if (m_viewCtrl)
				{
					if (m_viewCtrl.onMouseWheel(me , curEdtQuadrant) != 0)
					{	
						if (m_vtxEditor) m_vtxEditor.onSelectChanged(true , curEdtQuadrant);
						break;
					}
				}
				
				break;
			}
			
			return 0;
		}
		private function onKeyDown(evtId : int, args : Object , senderInfo : Object , registerObj:Object): int
		{
			
			var ke : KeyboardEvent = args as KeyboardEvent;
			for (;; )
			{
				if (m_selector)
				{
					if (m_selector.onKeyDown(ke , curEdtQuadrant) != 0)
						break;
				}
				if (m_vtxEditor)
				{
					if (m_vtxEditor.onKeyDown(ke , curEdtQuadrant) != 0)
						break;
				}
				
				if (m_focusSwitch && m_has4Qurad)
				{
					if (m_focusSwitch.onKeyDown(ke , curEdtQuadrant) != 0)
						break;
				}
				if (m_visbileCtrl)
				{
					if (m_visbileCtrl.onKeyDown(ke , curEdtQuadrant) != 0)
						break;
				}
				
				
				break;
			}
			
			return 0;
		}
		
		public function onVertexDataChange():void //for overrride
		{
			//ModuleHeadData.genUVData();
		}
		
		private function onVertexChange(onlyMoving : Boolean , operateEdtQuadrant : EdtQuadrant) : void
		{
			if (!onlyMoving || m_has4Qurad)
				operateEdtQuadrant.map2DTo3D();
			
			if (m_has4Qurad)
			{
				
				onVertexDataChange();
				
				for each (var _eq : EdtQuadrant in m_edtQuadrantVector)
				{	
					if (_eq && _eq != operateEdtQuadrant)
					{
						_eq.renderLine(true);
					}
				}
			}
			
			if (!onlyMoving) 
			{
				if (changeFunction != null)
					changeFunction();
			}
		}
		
		
		public function set useSelector(b : Boolean) : void
		{
			if (b) {
				if (!m_selector)
					m_selector = new EdtQuadrantSelector(m_indicate , this , onUpdatePointStatus ,m_selectedEVI);
			} else {
				if (m_selector)
				{
					m_selector.dispose();
					m_selector = null;
				}
			}
		}
		
		public function set useVtxEditor(b : Boolean) : void
		{
			if (b) {
				if (!m_vtxEditor)
					m_vtxEditor = new EdtQuadrantVtxEditor(m_indicate , this ,m_selectedEVI , onVertexChange );
			} else {
				if (m_vtxEditor)
				{
					m_vtxEditor.dispose();
					m_vtxEditor = null;
				}
			}
		}
		
		public function set useFocusSwitch(b : Boolean) : void
		{
			if (b) {
				if (!m_focusSwitch)
					m_focusSwitch = new EdtQuadrantFocusSwitch(onFocusRealSet , onFullScreenSet);
			} else {
				if (m_focusSwitch)
				{
					m_focusSwitch.dispose();
					m_focusSwitch = null;
				}
			}
		}
		
		public function EdtQuadrantMgr() 
		{
		
			m_indicate = new  EdtQuadrantIndicate;
			addChild(m_indicate); m_indicate.visible = false;
			m_viewCtrl = new EdtQuadrantViewCtrl(m_indicate);
			//m_selector = new EdtQuadrantSelector(m_indicate , this , onUpdatePointStatus ,m_selectedEVI);
			//m_vtxEditor = new EdtQuadrantVtxEditor(m_indicate , this ,m_selectedEVI , onVertexChange );
			//m_focusSwitch = new EdtQuadrantFocusSwitch(onFocusRealSet , onFullScreenSet);
			m_visbileCtrl = new EdtQuadrantVisibleCtrl();
			
			m_indicate.mode = EdtQuadrantIndicate.SELECT_POINT;
			
		}
		
		public function resetSelect():void
		{
			m_selectedEVI.length = 0;
			if (m_vtxEditor)
				m_vtxEditor.resetSelect();
		}
		
		public function dispose() : void
		{
			
			if (m_indicate)
			{
				m_indicate.dispose();
				m_indicate = null;
			}
			
			
			
			if ( m_viewCtrl) { m_viewCtrl.dispose() ; m_viewCtrl = null; }
			if ( m_selector) { m_selector.dispose() ; m_selector = null; }
			if ( m_vtxEditor) { m_vtxEditor.dispose() ; m_vtxEditor = null; }
			if ( m_focusSwitch) { m_focusSwitch.dispose() ; m_focusSwitch = null; }
			if ( m_visbileCtrl) { m_visbileCtrl.dispose() ; m_visbileCtrl = null; }
			if ( m_indicate) { m_indicate.dispose() ; m_indicate = null; }

			
			deactivate();
			
			GraphicsUtil.removeAllChildren(this);
			changeFunction = null;
			
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
		
	}

}