package editor.module.hair 
{
	import editor.struct.Texture2D;
	import editor.ui.EdtVertex3D;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHairFrame 
	{
		public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
		public var vertexPerLine : int = 0 ;
		
		public function ModuleHairFrame(_texture : Texture2D) 
		{
			texture = _texture;
			name = texture.name;
		}
		
		public function dispose():void 
		{
			name = null;
			texture = null;
		}
		
		public function createSprite() : ModuleHairFrameSprite
		{
			return new ModuleHairFrameSprite(this);
		}
	}

}