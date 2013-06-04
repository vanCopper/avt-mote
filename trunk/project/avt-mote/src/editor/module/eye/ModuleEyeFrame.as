package editor.module.eye 
{
	import editor.Library;
	import editor.struct.Texture2D;
	import editor.struct.Vertex3D;
	import editor.ui.EdtVertex3D;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleEyeFrame 
	{
		
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
		}
	}

}