package 
{
	import CallbackUtil.CallbackCenter;
	import editor.config.CALLBACK;
	import editor.config.Config;
	import editor.Library;
	import flash.utils.Endian;
	
	import editor.ModuleBar;
	import editor.Toolbar;
	import editor.util.FilePicker;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import UISuit.UIComponent.BSSButton;
	
	/**
	 * ...
	 * @author Blueshell
	 */
	public class Main extends Sprite 
	{
		private var m_mb : ModuleBar;
		protected var m_tb : Toolbar;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = "LT";
			stage.scaleMode = "noScale";
			
			//import editor.ui.EdtRotationAxis;
			///var _dtRotationAxis : EdtRotationAxis = new EdtRotationAxis();
			//addChild(_dtRotationAxis);
			//_dtRotationAxis.x = _dtRotationAxis.y = 500;
			//return;
			
			// entry point
			var tb : Toolbar = new Toolbar();
			m_tb = tb;
			addChild(tb);
			
			m_mb = new ModuleBar();
			addChild(m_mb).x = tb.x + tb.width + 10;
			
			var _mContainer : Sprite = new Sprite();
			_mContainer.graphics.lineStyle(1,0,0.55);
			_mContainer.graphics.moveTo(0, 0);
			_mContainer.graphics.lineTo(800, 0);
			
			
			import editor.module.head.ModuleHead;
			m_mb.addModule(new ModuleHead(_mContainer));
			import editor.module.eye.ModuleEye;
			m_mb.addModule(new ModuleEye(_mContainer));
			import editor.module.hair.ModuleHair;
			m_mb.addModule(new ModuleHair(_mContainer));
			import editor.module.body.ModuleBody;
			m_mb.addModule(new ModuleBody(_mContainer));
			import editor.module.mouth.ModuleMouth;
			m_mb.addModule(new ModuleMouth(_mContainer));
			import editor.module.brow.ModuleBrow;
			m_mb.addModule(new ModuleBrow(_mContainer));
			
			
			addChild(_mContainer).y = m_mb.y + m_mb.height + 5;
			
			var obj : Object = { };
			obj[MouseEvent.MOUSE_WHEEL] = CALLBACK.AS3_ON_STAGE_MOUSE_WHEEL;
			obj[MouseEvent.MOUSE_DOWN] = CALLBACK.AS3_ON_STAGE_MOUSE_DOWN;
			obj[MouseEvent.MOUSE_UP] = CALLBACK.AS3_ON_STAGE_MOUSE_UP;
			obj[MouseEvent.MOUSE_MOVE] = CALLBACK.AS3_ON_STAGE_MOUSE_MOVE;
			obj[KeyboardEvent.KEY_DOWN] = CALLBACK.AS3_ON_STAGE_KEY_DOWN;
			obj[KeyboardEvent.KEY_UP] = CALLBACK.AS3_ON_STAGE_KEY_UP;

			 CallbackCenter.init(stage , obj);
			
			
			tb.btnNew.releaseFunction = onNewBtn;
			tb.btnOpen.releaseFunction = onOpen;
			tb.btnSaveAs.releaseFunction = onSaveAs;
			tb.btnExport.releaseFunction = onExport;
			
			var _lib : Library = new Library();
			_lib.x  = 400;
			_lib.y  = 200;
			
			addChild(_lib);
			
			initAirFunc();
		}
		
		public function initAirFunc():void
		{
			
		}
		protected static const inputFilterArray : Array = [new FileFilter("avt-mote xml ascii file)" , "*.amxmla") /* , new FileFilter("avt-mote xml binary file" , "*.amxmlb")*/ ]
		private function onOpen(btn:BSSButton):void 
		{
			new FilePicker( onOpenBA , inputFilterArray , false);			
		}
		protected function onOpenBA(_filename : String , ba : ByteArray):void
		{
			Config.lastFileName = _filename.replace(".amxmlb" , ".amxmla");
			
			if (ba[0] == 0x61
			&& ba[1] == 0x6D
			&& ba[2] == 0x78
			&& ba[3] == 0x62
			) //amxb
			{
				
			}
			else
			{
				var _xml : XML = new XML(String(ba));
				
				if (_xml.name() == "avt-mote")
				{
					newDoc();
					m_mb.onOpenXML(_xml);
				} else {
					CONFIG::ASSERT {
						ASSERT(false , "unknown file");
					}
				}
				
			}
		}
		
		
		private function newDoc():void 
		{
			Library.getS().onNew();
			m_mb.onNew();
			
		}
		
		private function onNewBtn(btn:BSSButton):void 
		{
			Config.lastFileName = "avt-mote.amxmla";
			Config.lastFileNameFull = null;
			newDoc();
			
		}
		

		private function onFileSaveCancel(e:Event):void
		{
			
			e.currentTarget.removeEventListener(Event.SELECT, onFileSaveSelect);
			e.currentTarget.removeEventListener(Event.CANCEL , onFileSaveCancel);
			
		}
		private function onFileSaveSelect(e:Event):void
		{
		
			e.currentTarget.removeEventListener(Event.SELECT, onFileSaveSelect);
			e.currentTarget.removeEventListener(Event.CANCEL , onFileSaveCancel);
		
			var fb : FileReference = FileReference(e.currentTarget);
			Config.lastFileName = fb.name;
		}
		protected function getXMLData() : XML
		{
			var _data : XML = <avt-mote/>;
			m_mb.onSave(_data);
			return _data;
		}
		
		private function onSaveAs(btn:BSSButton):void 
		{
			var _data : XML = getXMLData();
			
			var fr : FileReference = new FileReference;
			
			fr.addEventListener(Event.SELECT, onFileSaveSelect);
			fr.addEventListener(Event.CANCEL , onFileSaveCancel);
			
			
			fr.save(_data, Config.lastFileName);
			
		}
		
		private function onExport(btn:BSSButton):void 
		{
			var _data : ByteArray = new ByteArray();
			_data.endian = Endian.LITTLE_ENDIAN;
			
			_data.writeByte('A'.charCodeAt(0));
			_data.writeByte('M'.charCodeAt(0));
			_data.writeByte('X'.charCodeAt(0));
			_data.writeByte('B'.charCodeAt(0));
			
			m_mb.onExport(_data);
			var fr : FileReference = new FileReference;
			
			//fr.addEventListener(Event.SELECT, onFileSaveSelect);
			//fr.addEventListener(Event.CANCEL , onFileSaveCancel);
			
			
			fr.save(_data, Config.lastFileName.replace(".amxmla" , ".amxmlb"));
			
		}
	}
	
}