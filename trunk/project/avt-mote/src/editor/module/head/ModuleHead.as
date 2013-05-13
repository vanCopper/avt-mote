package editor.module.head 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.EdtDEF;
	import editor.config.StringPool;
	import editor.module.ModuleBase;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtVertex3D;
	import editor.util.ImagePicker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ConvolutionFilter;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleHead extends ModuleBase
	{	
		
		private var m_tb : ModuleHeadToolbar;
		
		private var m_eqm : ModuleHeadEQMgr;
		
		private var m_quadrant0 : EdtQuadrant;
		private var m_bmp : Bitmap;
		
		private var m_bmpCnt : DisplayObjectContainer;
		private var m_roterVector : Vector.<EdtVertex3D> ;
		
		public function ModuleHead(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_HEAD);
			
			m_tb = new ModuleHeadToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant0 = new EdtQuadrant(0);
			
			m_eqm = new ModuleHeadEQMgr();
			m_eqm.addChildAt(m_quadrant0 , 0);
			
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_bmp = new Bitmap();
			m_bmpCnt = new Sprite();
			m_bmpCnt.addChild(m_bmp);
			m_quadrant0.addChildAt(m_bmpCnt , 5);
			m_quadrant0.indicate = m_bmpCnt;
			
			m_quadrant0.fullSreen = (true);
			m_quadrant0.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant0;
			
			m_tb.deactivateAll([m_tb.btnImport]);
			
			m_tb.btnImport.releaseFunction = onOpen;
			m_tb.btnAR.releaseFunction = onAddRoter;
			
		}
		
		
		private function onAddRoter(btn : BSSButton) : void {
			
			if (!m_roterVector)
			{
				m_roterVector = new Vector.<EdtVertex3D>(3, true);
				
				m_roterVector[0] = new EdtVertex3D();
				m_roterVector[0].priority = 0;
				m_roterVector[1] = new EdtVertex3D();
				m_roterVector[1].priority = 2;
				m_roterVector[2] = new EdtVertex3D();
				m_roterVector[2].priority = 3;
				
				m_roterVector[0].conect.push(m_roterVector[1] );
				m_roterVector[1].conect.push(m_roterVector[0] );
				m_roterVector[1].conect.push(m_roterVector[2] );
				m_roterVector[2].conect.push(m_roterVector[1] );
				
			}
			
			m_roterVector[0].y =  - ((m_bmp.bitmapData.height)  >> 1);
			m_roterVector[1].y =  + ((m_bmp.bitmapData.height)  * 0.2);
			m_roterVector[2].y =  + ((m_bmp.bitmapData.height)  >> 1);
			
			m_quadrant0.setVertex(m_roterVector);
			
			m_tb.deactivateAll([m_tb.btnAC]);
			
		}
		
		private function onOpen(btn : BSSButton) : void {
			new ImagePicker( onLoadImage , [new FileFilter("image (*.png)" , "*.png")]);
			
		}
		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			
			if (m_bmp.bitmapData)
			{
				m_bmp.bitmapData.dispose();
				m_bmp.bitmapData = null;
			}
			m_bmp.bitmapData = bitmapData;
			m_bmp.x =  -  (( bitmapData.width ) >> 1);
			m_bmp.y =  - ((bitmapData.height)  >> 1);
			
			m_tb.deactivateAll([m_tb.btnAR]);
		}
		
		
		public override function activate() : void
		{
			m_eqm.activate();
			
			super.activate();
		}
		
		public override function deactivate() : void
		{
			
			m_eqm.deactivate();
			
			super.deactivate();
		}
		
		
		public override function dispose() : void
		{
			if (m_eqm)
			{
				m_eqm.dispose();
				m_eqm = null;
			}
			if (m_tb)
			{
				m_tb.dispose();
				m_tb = null;
			}
			if (m_quadrant0)
			{
				m_quadrant0.dispose();
				m_quadrant0 = null;
			}
			
			
			if (m_bmp )
			{
				if (m_bmp.bitmapData)
					m_bmp.bitmapData.dispose();
				m_bmp = null;
			}
			m_bmpCnt = null;
			m_roterVector = null;
			
			super.dispose();
		}
	}

}