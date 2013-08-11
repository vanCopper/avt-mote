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
	public class BrowFrameData
	{
		//public var name : String;
		public var texture : Texture2D;
		
		public var vertexDataL : Vector.<Vector3D>;
		public var vertexDataR : Vector.<Vector3D>;
	
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		
		public var vertices : Vector.<Number>;
		
		public var uvData : Vector.<Number>;
		
		public static const indices : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
		
		//public var verticesOff : Vector.<Number>;
		
		public static function decodeBrowFrameData(ba:ByteArray,a_bitmapData:BitmapData):BrowFrameData
		{
			var ret : BrowFrameData = new BrowFrameData();
			ret.decode(ba,a_bitmapData);
			return ret;
		}
		
		public function decode(ba:ByteArray , a_bitmapData:BitmapData):void
		{
			texture = Texture2D.decodeTexture2D(ba);
			
			offsetX = ba.readFloat();
			offsetY = ba.readFloat();
		}
		
		public function confitZ(browPlaneL : Plane3D , centerLX : Number , centerLY : Number , browPlaneR : Plane3D , centerRX : Number , centerRY : Number ) : void
		{
			var _absRectW : Number = Math.abs(texture.rectW);
			var _absRectH : Number = Math.abs(texture.rectH);
			
			
			vertexDataL = new Vector.<Vector3D>();
			
			vertexDataL.push(new Vector3D(0, 0));
			vertexDataL.push(new Vector3D(_absRectW, 0));
			vertexDataL.push(new Vector3D(0, _absRectH));
			vertexDataL.push(new Vector3D(_absRectW, _absRectH));
			
			for each( var ev : Vector3D in vertexDataL)
			{
				ev.x += offsetX + centerLX;
				ev.y += offsetY + centerLY;
				
				ev.z = browPlaneL.confitZ(ev.x , ev.y);
			}
			
			vertexDataR = new Vector.<Vector3D>();
			
			vertexDataR.push(new Vector3D(_absRectW, 0));
			vertexDataR.push(new Vector3D(0, 0));
			vertexDataR.push(new Vector3D(_absRectW, _absRectH));
			vertexDataR.push(new Vector3D(0, _absRectH));
			
			
			for each( ev in vertexDataR)
			{
				ev.x += -(_absRectW + offsetX) + centerRX;
				ev.y += offsetY + centerRY;
				
				ev.z = browPlaneR.confitZ(ev.x , ev.y);
			}
			
		}
		
		private function getVerticesMatrixed(md : Matrix4x4 , _left : Boolean):Vector.<Number>
		{
			var __v : Vector.<Number> = new Vector.<Number>();
				
			var vertexData : Vector.<Vector3D> =  _left ? vertexDataL : vertexDataR;
			
			for each( var ev : Vector3D in vertexData)
			{
				__v.push( md.Xx * ev.x + md.Xy * ev.y + md.Xz * ev.z) ;
				__v.push( md.Yx * ev.x + md.Yy * ev.y + md.Yz * ev.z) ;
				
			}
			return __v;
		}
		
		public function render(g:Graphics,a_bitmapData:BitmapData, md : Matrix4x4  , _left : Boolean):void
		{
			g.beginBitmapFill(a_bitmapData,null,false,true);
			g.drawTriangles(getVerticesMatrixed(md , _left), indices, uvData);
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