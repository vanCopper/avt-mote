package editor.module.head 
{
	import editor.config.EdtDEF;
	import editor.config.StringPool;
	import editor.module.ModuleBase;
	import editor.ui.EdtQuadrant;
	import editor.util.ImagePicker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
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
		private var m_quadrant0 : EdtQuadrant;
		private var m_bmp : Bitmap;
		
		public function ModuleHead(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_HEAD);
			
			m_tb = new ModuleHeadToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant0 = new EdtQuadrant(0);
			m_content.addChild(m_quadrant0).y = m_tb.y + m_tb.height; 
			
			m_quadrant0.setFullSreen(true);
			m_quadrant0.state = 2;
			
			m_tb.btnAC.deactivate();
			m_tb.btnAR.deactivate();
			m_tb.btnAC.alpha = 
			m_tb.btnAR.alpha = 0.5;
			
			m_tb.btnImport.releaseFunction = onOpen;
			
			m_bmp = new Bitmap();
		
			m_content.addChild(m_bmp);
			
			
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
			m_bmp.x = m_quadrant0.x + EdtDEF.QUADRANT_WIDTH -  (( bitmapData.width ) >> 1);
			m_bmp.y = m_quadrant0.y + EdtDEF.QUADRANT_HEIGHT - ((bitmapData.height)  >> 1);
			
			
		}
		
		
		public override function activate() : void
		{
			super.activate();
		}
		
		public override function deactivate() : void
		{
			super.deactivate();
		}
		public override function dispose() : void
		{
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
			
			super.dispose();
		}
	}

}