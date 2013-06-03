package editor.module.eye 
{
	import editor.config.StringPool;
	import editor.Library;
	import editor.module.ModuleBase;
	import editor.struct.Texture2D;
	import editor.ui.EdtQuadrant;
	import editor.util.ImageListPicker;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.net.FileFilter;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEye extends ModuleBase 
	{
		private var m_tb : ModuleEyeToolbar;
		private var m_eqm : ModuleEyeEQMgr;
		private var m_quadrant2 : EdtQuadrant;
		private var m_eyeContainer : Sprite;
		
		private var m_eyeWhite : Bitmap;
		private var m_eyeBall : Bitmap;
		private var m_eyeWBContainer : Sprite;
		private var m_eyeWBMask : Shape;
		private var m_eyeLip : Bitmap;
		
		
		public function ModuleEye(_content : DisplayObjectContainer) 
		{
			super(_content , StringPool.MODULE_EYE);
			
			m_tb = new ModuleEyeToolbar();
			m_content.addChild(m_tb).y = 25;
			
			m_quadrant2 = new EdtQuadrant(2);
			
			m_eqm = new ModuleEyeEQMgr();
			m_eqm.addChildAt(m_quadrant2 , 0);
			
			m_eyeContainer = new Sprite();
			
			m_eyeWBContainer = new Sprite();
			
			
			
			
			m_eyeWhite = new Bitmap;
			m_eyeBall = new Bitmap;
			m_eyeWBMask = new Shape;
			m_eyeLip = new Bitmap;
			

			m_eyeContainer.addChild(m_eyeWBContainer);
			m_eyeWBContainer.addChild(m_eyeWhite);
			m_eyeWBContainer.addChild(m_eyeBall);
			
			m_eyeContainer.addChild(m_eyeWBMask);
			m_eyeContainer.addChild(m_eyeLip);
			
			/*
			m_bmp = new Bitmap();
			m_bmpShape = new Shape();
			
			m_bmpCnt.addChild(m_bmp);
			m_bmpCnt.addChild(m_bmpShape);
			*/
			
			m_quadrant2.indicate = m_eyeContainer;
			
			m_quadrant2.fullScreen = (true);
			m_quadrant2.state = 2;
			
			m_eqm.curEdtQuadrant = m_quadrant2;
			m_content.addChild(m_eqm).y = m_tb.y + m_tb.height; 
			
			m_tb.btnImport.releaseFunction = onOpen;
		}
		
		private function onOpen(btn : BSSButton) : void {
			new ImageListPicker( onLoadImage , [new FileFilter("image list(*.imglist)" , "*.imglist") , new FileFilter("image (*.png)" , "*.png")]);
		}
		
		private function onLoadImage(_filename : String ,bitmapData : BitmapData) : void
		{
			var _texture : Texture2D = new Texture2D(bitmapData , _filename , "EYE");
			Library.getS().addTexture(_texture);
			Library.getS().addTexture(new Texture2D(bitmapData , _filename+"#FILP" , "EYE" , _texture.rectX + _texture.rectW , _texture.rectY , -_texture.rectW , _texture.rectH));
			//m_tb.deactivateAll([m_tb.btnAR]);
		}
		
		public override function activate() : void
		{
			if (m_eqm.parent)
				m_eqm.activate();
			
			super.activate();
		}
		
		public override function deactivate() : void
		{
			
			m_eqm.deactivate();
			
			super.deactivate();
		}
		
	}

}