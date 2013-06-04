package editor.module.eye 
{
	import editor.Library;
	import editor.struct.Texture2D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import editor.util.TextureLoader;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrame 
	{
		public var name : String;
		public var eyeWhite : Texture2D;
		
		
		public var eyeBall : Texture2D;
		public var eyeBallX : Number;
		public var eyeBallY : Number;
		
		
		public var eyeLip : Texture2D;
		public var eyeLipX : Number;
		public var eyeLipY : Number;
		
		
		public var eyeMaskData : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		
		public function ModuleEyeFrame() 
		{
			
			
			
			
		}
		
		
		public function toXMLString():String
		{
			
			var str : String = "<ModuleEyeFrame>";
			str += "<name>";
				str += name;
			str += "</name>";
			
			str += "<eyeWhite>";
				if (eyeWhite) str += eyeWhite.toXMLString();
			str += "</eyeWhite>";
			
			str += "<eyeBall>";
				if (eyeBall) str += eyeBall.toXMLString();
				str += "<position>" + eyeBallX +":" + eyeBallY + "</position>";
			str += "</eyeBall>";
			
			
			str += "<eyeLip>";
				if (eyeLip) str += eyeLip.toXMLString();
				str += "<position>" + eyeLipX +":" + eyeLipY + "</position>";
			str += "</eyeLip>";
			
			str += "<eyeMaskData>";
			var first : Boolean = true;
			for each (var _v : Vertex3D in eyeMaskData)	
			{
				if (first)
				{
					str += _v.toXMLString();
					first = false;
				}
				else
					str += "," + _v.toXMLString();
			}
			str += "</eyeMaskData>";
			
			str += "</ModuleEyeFrame>";
			return str;
		}
		public var loadStep : int;
		public var callback :Function;
		
		public function fromXMLString(s:XML , a_callback :Function):void
		{
			eyeMaskData.length = 0;
			callback = a_callback;
			if (s)
			{
				name = s.name.text();
				
				var _tname : String;
				_tname = s.eyeWhite.Texture2D.name.text();
				eyeWhite = Library.getS().getTexture2D(_tname);
				if (!eyeWhite)
				{
					if (s.eyeWhite.Texture2D != undefined)
					{
						loadStep++;
						new TextureLoader(s.eyeWhite.Texture2D[0], onTextureLoadedEW);
					}
				}

				_tname = s.eyeBall.Texture2D.name.text();
				eyeBall = Library.getS().getTexture2D(_tname);
				if (!eyeBall)
				{
					if (s.eyeBall.Texture2D != undefined)
					{	
						loadStep++;
						new TextureLoader(s.eyeBall.Texture2D[0] , onTextureLoadedEB);
					}
				}
				var _p :Array;
				_p = String(s.eyeBall.position.text()).split(":");
				eyeBallX = Number(_p[0]);
				eyeBallY = Number(_p[1]);
				
				_tname = s.eyeLip.Texture2D.name.text();
				eyeLip = Library.getS().getTexture2D(_tname);
				if (!eyeLip)
				{
					if (s.eyeLip.Texture2D != undefined)
					{
						loadStep++;
						new TextureLoader(s.eyeLip.Texture2D[0] , onTextureLoadedEL);
					}
				}
				_p = String(s.eyeLip.position.text()).split(":");
				eyeLipX = Number(_p[0]);
				eyeLipY = Number(_p[1]);
				
				var __dataString : String = String(s.eyeMaskData.text());
				if (__dataString)
				{
					var __data : Array = __dataString.split(",");
					for each (var vstr : String in __data )
					{
						var _ev : EdtVertex3D = new EdtVertex3D();
						_ev.fromXMLString(vstr);
						eyeMaskData.push(_ev);
					}
					genConnect();
				}
				
				
				if (loadStep == 0)
				{
					if (callback != null)
						callback(this);
					callback = null;
				}
				
			}
			
		}
		
		private function onATextureLoaded():void
		{
			loadStep--;
			if (loadStep == 0)
			{
				if (callback != null)
					callback(this);
				callback = null;
			}
		}
		private function onTextureLoadedEW(_name : String , _texture2D : Texture2D):void 
		{
			eyeWhite = _texture2D;
			onATextureLoaded();
		}
		private function onTextureLoadedEB(_name : String , _texture2D : Texture2D):void 
		{
			eyeBall = _texture2D;
			onATextureLoaded();
		}
		private function onTextureLoadedEL(_name : String , _texture2D : Texture2D):void 
		{
			eyeLip = _texture2D;
			onATextureLoaded();
		}
		public function flipData():ModuleEyeFrame
		{
			var n : ModuleEyeFrame = new ModuleEyeFrame();
			n.eyeWhite = eyeWhite ? Library.getS().getTexture2DFlip(eyeWhite.name) : null;
			n.eyeBall = eyeBall ? Library.getS().getTexture2DFlip(eyeBall.name) : null;
			n.eyeLip = eyeLip ? Library.getS().getTexture2DFlip(eyeLip.name) : null;
			
			
			n.eyeBallX = eyeBallX;
			n.eyeBallY = eyeBallY;
			n.eyeLipX = eyeLipX;
			n.eyeLipY = eyeLipY;
			
			n.eyeMaskData = new Vector.<EdtVertex3D>(); 
			
			
			if (eyeWhite)
			{
				for each (var _ev3d : EdtVertex3D in eyeMaskData)
				{	
					var _ev3dC : EdtVertex3D = _ev3d.cloneV();
					
					_ev3dC.x = Math.abs(eyeWhite.rectW) - _ev3dC.x; 
					
					n.eyeMaskData.push(_ev3dC);
				}
				n.genConnect();
			}
			
			return n;
		}
		
		private function genConnect():void
		{
			var p : int = 1;
			for each (var _v3d : EdtVertex3D in eyeMaskData)
			{
				_v3d.priority = p++;
			}
			
			
			var idx : int = 2;
			while (idx < eyeMaskData.length)
			{
				EdtVertex3D.connect2PT(eyeMaskData[0] , eyeMaskData[idx - 1]);
				EdtVertex3D.connect2PT(eyeMaskData[0] , eyeMaskData[idx]);
				EdtVertex3D.connect2PT(eyeMaskData[idx] , eyeMaskData[idx - 1]);
				idx++;
			}
		}
		
		public function cloneData():ModuleEyeFrame
		{
			var n : ModuleEyeFrame = new ModuleEyeFrame();
			n.eyeWhite = eyeWhite;
			n.eyeBall = eyeBall;
			n.eyeLip = eyeLip;
			
			
			n.eyeBallX = eyeBallX;
			n.eyeBallY = eyeBallY;
			n.eyeLipX = eyeLipX;
			n.eyeLipY = eyeLipY;
			
			n.eyeMaskData = new Vector.<EdtVertex3D>(); 
			for each (var _ev3d : EdtVertex3D in eyeMaskData)
				n.eyeMaskData.push(_ev3d.cloneV());
			
			n.genConnect();
			
			return n;
		}
		public function createSprite() : ModuleEyeFrameSprite
		{
			return new ModuleEyeFrameSprite(this);
		}
		public function dispose():void 
		{
			eyeWhite = null;
			eyeBall = null;
			eyeLip = null;
			eyeMaskData = null;
			
			callback = null;
		}
	}

}