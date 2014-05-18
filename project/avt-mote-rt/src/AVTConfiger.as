package 
{
	import CallbackUtil.CallbackCenter;
	import configer.CALLBACK;
	import configer.EdtSliderNumber;
	import configer.PNGEncoder;
	import configer.Toolbar;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import player.AVTMPlayer;
	import player.struct.Matrix4x4;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author blueshell
	 */
	public class AVTConfiger extends Sprite 
	{
		private var m_player : AVTMPlayer;
		private var m_Rz : Number = 0;
		private var m_Oz : Number = 0;
		
		private var m_lastRX : Number = 0;
		private var m_lastRY : Number = 0;
	
		public function AVTConfiger():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.addEventListener(Event.ENTER_FRAME , onUpdate);
			
			var _tb : Toolbar = new Toolbar();
			addChild(_tb);
			_tb.btnOpen.releaseFunction = onOpenAir;
			_tb.btnSnap.releaseFunction = onSnap;
			
			var obj : Object = { };
			obj[MouseEvent.MOUSE_WHEEL] = CALLBACK.AS3_ON_STAGE_MOUSE_WHEEL;
			obj[MouseEvent.MOUSE_DOWN] = CALLBACK.AS3_ON_STAGE_MOUSE_DOWN;
			obj[MouseEvent.MOUSE_UP] = CALLBACK.AS3_ON_STAGE_MOUSE_UP;
			obj[MouseEvent.MOUSE_MOVE] = CALLBACK.AS3_ON_STAGE_MOUSE_MOVE;
			obj[KeyboardEvent.KEY_DOWN] = CALLBACK.AS3_ON_STAGE_KEY_DOWN;
			obj[KeyboardEvent.KEY_UP] = CALLBACK.AS3_ON_STAGE_KEY_UP;

			CallbackCenter.init(stage , obj);
			
			 
		}
		
		private function onUpdate(e:Event):void 
		{
			if (m_player) {
				
				if (changeSomething)
				{
					changeSomething = false;
					
					m_player.eyeAimX = eyeAimXES.value;
					m_player.eyeAimY = eyeAimYES.value;
					m_player.mouth.currentFrame = mouthES.value;
					
					m_player.eye.forceIndexL = eyeIndexLES.value;
					m_player.eye.forceIndexR = eyeIndexRES.value;
					
					m_player.brow.browL = browLES.value;
					m_player.brow.browR = browRES.value;
					m_player.body.breathOff = 1 / breathES.value;
				}
				
				var _rx : Number = rxES.value;
				var _ry : Number = ryES.value;
				var _rz : Number = rzES.value;
				
				var _currentMatrix  : Matrix4x4 = m_player.getMatrix(_rx, _ry , _rz);
				
				
				m_player.render(_currentMatrix , _rx , _ry , _rz);
			}
			
		}		
		private var m_snapIndex : int = 0; 
		
		private function onSnap(btn:BSSButton):void 
		{
			if (m_player) {
				var _rect : Rectangle = m_player.getBounds(m_player);
				var _bd : BitmapData = new BitmapData(_rect.width + 4 , _rect.height - 1 ,true,0);
				var mt:Matrix = new Matrix();
				mt.translate(-(_rect.left - 2) , -_rect.top);
				
				_bd.draw(m_player , mt, null, null, null, true);
				new FileReference().save(PNGEncoder.encode(_bd), s_lastFileName.replace(".amxmlb" , "") + "_" +  (m_snapIndex++) + ".png") ;

								
				//stage.addChild(new Bitmap(_bd));
				
				
				
			}
			
			
		}
		
		
		
		private var m_loadFile:File;
		private function onOpenAir(btn:BSSButton):void 
		{
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, onLoaded);
			file.browseForOpen("open", [new FileFilter("avt-mote xml binary file" , "*.amxmlb")]);
			m_loadFile = file;
			m_snapIndex = 0;
		}
		private static var s_imgPath : String;
		private static var  s_lastFileNameFull : String;
		private static var  s_lastFileName : String;
		private var loadedBA : ByteArray;
		
		private function onLoaded(e:Event):void {
			
			e.currentTarget.removeEventListener(Event.SELECT, onLoaded);
			
			try{
				var data:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(m_loadFile, FileMode.READ);
				stream.position = 0;
				stream.readBytes(data, 0, stream.bytesAvailable);
				stream.close();
				data.position = 0;
				
				//Config.lastFileName = s_loadFile.name.replace(".amxmlb" , ".amxmla");
				
				var nativePath : String = m_loadFile.nativePath;
				s_lastFileNameFull = nativePath;
				s_lastFileName = m_loadFile.name;
				
				if (nativePath.lastIndexOf('\\') != -1)
				{
					nativePath = nativePath.substring(0 , nativePath.lastIndexOf('\\')) + "\\";
				} 
				else if (nativePath.lastIndexOf('/') != -1)
				{
					nativePath = nativePath.substring(0 , nativePath.lastIndexOf('/')) + "/";
				}
				
				s_imgPath = nativePath;
				
				trace(s_imgPath);
				loadedBA = data;
				
				data = new ByteArray();
				var imgFile:File = new File(s_imgPath+"mergeImage_0.png");
				stream = new FileStream();
				stream.open(imgFile, FileMode.READ);
				stream.position = 0;
				stream.readBytes(data, 0, stream.bytesAvailable);
				stream.close();
				data.position = 0;
				
				
				var ldr : Loader = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete );
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onComplete );
				ldr.loadBytes(data);
				
				//if (m_player) m_player.dispose();
			
				//new ImageByteLoader().load([data], __imageLoaded);
			}catch (e:Error) {
				
				//JOptionPane.showMessageDialog("读取图形文件出错", e+"", null, pane);
			}
			
			m_loadFile = null;
			
		}
		
		private var rxES : EdtSliderNumber;
		private var ryES : EdtSliderNumber;
		private var rzES : EdtSliderNumber;
		private var eyeAimXES : EdtSliderNumber;
		private var eyeAimYES : EdtSliderNumber;
		private var mouthES : EdtSliderNumber;
		private var eyeIndexLES : EdtSliderNumber;
		private var eyeIndexRES : EdtSliderNumber;
		private var browLES : EdtSliderNumber;
		private var browRES : EdtSliderNumber;
		private var breathES : EdtSliderNumber;
		
		private function initSilder():void
		{
			if (rxES)
				return;
			
			const arr : Array = [
				-0.1,+0.1,0,"rx",false
			,	-0.15,+0.15,0,"ry",false
			,	-0.1, +0.1, 0, "rz", false
			,	-800, 800, 0, "eyeAimX", true
			,	-800, 800, 0, "eyeAimY", true
			,	0, m_player.mouth.totalFrames - 1, 0, "mouth", true
			,	-1, m_player.eye.totalFrames - 1, -1, "eyeIndexL", true
			,	-1, m_player.eye.totalFrames - 1, -1, "eyeIndexR", true
			,	0, m_player.brow.totalFrames - 1, 0, "browL", true
			,	0, m_player.brow.totalFrames - 1, 0, "browR", true
			,	10, 70, 50, "breath", true
			
			];
			
			for (var i : int = 0 ; i < arr.length ; i+=5  )
			{
				var esn : EdtSliderNumber = new EdtSliderNumber( arr[i], arr[i+1], arr[i+3]);
				addChild(esn);
				esn.x = 520;
				esn.y = 10 + i * 6;
				esn.value = arr[i + 2];
				esn.intVer = arr[i + 4];
				esn.changeFunction = onSilderChange;
				this[arr[i + 3] + "ES"] = esn;
			}
			
			
			
			
		}
		private var changeSomething : Boolean = false;
		private function onSilderChange(esn : EdtSliderNumber , v : Number):void 
		{
			if (esn != rxES && esn != ryES && esn != rzES)
				changeSomething = true;
		}
		
		
		private function onComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE , onComplete );
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR , onComplete );
			
			if (e.type == IOErrorEvent.IO_ERROR)
			{
				trace(e);
				return;
			}
			
			var ldi : LoaderInfo = (e.currentTarget) as LoaderInfo;
			
			if (m_player) m_player.dispose();

			m_player = new AVTMPlayer(loadedBA , Bitmap(ldi.content).bitmapData);
			addChild(m_player);
			m_player.x = 300;
			m_player.y = 220;
			
			loadedBA = null;
			initSilder();
		}
		
		
		
		
		
		
		
	}
	
}