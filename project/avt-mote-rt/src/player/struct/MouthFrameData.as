package player.struct 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import player.HairRender;
	import player.util.ByteArrayUtil;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class MouthFrameData
	{
		//public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<Vector3D>;
	
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		
		public var vertices : Vector.<Number>;
		
		public var uvData : Vector.<Number>;
		
		public static const indices : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
		
		//public var verticesOff : Vector.<Number>;
		
		public static function decodeMouthFrameData(ba:ByteArray,a_bitmapData:BitmapData):MouthFrameData
		{
			var ret : MouthFrameData = new MouthFrameData();
			ret.decode(ba,a_bitmapData);
			return ret;
		}
		
		public function decode(ba:ByteArray , a_bitmapData:BitmapData):void
		{
			texture = Texture2D.decodeTexture2D(ba);
			
			offsetX =  ba.readFloat();
			offsetY = ba.readFloat();
		}
		
		public function confitZ(mouthPlane : Plane3D , centerX : Number , centerY : Number ) : void
		{
			vertexData = new Vector.<Vector3D>();
			vertexData.length = 0;
			
			vertexData.push(new Vector3D(0, 0));
			vertexData.push(new Vector3D(Math.abs(texture.rectW), 0));
			vertexData.push(new Vector3D(0, Math.abs(texture.rectH)));
			vertexData.push(new Vector3D(Math.abs(texture.rectW), Math.abs(texture.rectH)));
			
			for each( var ev : Vector3D in vertexData)
			{
				ev.x += offsetX + centerX;
				ev.y += offsetY + centerY;
				
				ev.z = mouthPlane.confitZ(ev.x , ev.y);
			}
		}
		
		private function getVerticesMatrixed(md : Matrix4x4):Vector.<Number>
		{
			var __v : Vector.<Number> = new Vector.<Number>();
				
			for each( var ev : Vector3D in vertexData)
			{
				__v.push( md.Xx * ev.x + md.Xy * ev.y + md.Xz * ev.z) ;
				__v.push( md.Yx * ev.x + md.Yy * ev.y + md.Yz * ev.z) ;
				
			}
			return __v;
		}
		
		public function render(g:Graphics,a_bitmapData:BitmapData, md : Matrix4x4):void
		{
			g.clear();
			g.beginBitmapFill(a_bitmapData,null,false,true);
			g.drawTriangles(getVerticesMatrixed(md), indices, uvData);
			g.endFill();
		}
				
		
		public function genUVData(bitmapData:BitmapData):void
		{
			uvData = new Vector.<Number>();
			
			uvData.push (( texture.rectX) / bitmapData.width);
			uvData.push (( texture.rectY) / bitmapData.height);
			
			uvData.push (( texture.rectX + texture.rectW) / bitmapData.width);
			uvData.push (( texture.rectY) / bitmapData.height);
			
			uvData.push (( texture.rectX) / bitmapData.width);
			uvData.push (( texture.rectY + texture.rectH) / bitmapData.height);
			
			uvData.push (( texture.rectX + texture.rectW) / bitmapData.width);
			uvData.push (( texture.rectY + texture.rectH) / bitmapData.height);
			
		}
		
	}

}