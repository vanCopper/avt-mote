package player.struct 
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import player.HairRender;
	import player.util.ByteArrayUtil;
	import player.util.MeshUtil;
	/**
	 * ...
	 * @author blueshell
	 */
	public class BodyFrameData
	{
		public var name : String;
		public var texture : Texture2D;
		public var vertexData : Vector.<Point>;
		public var breathChangeIndex : Vector.<int>;
		public var vertexBreathData : Vector.<Point>;
		
		public var vertexPerLine : int;
		public var totalLine : int;
		public var uvData : Vector.<Number>;
		public var indices : Vector.<int>;
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		public var vertices : Vector.<Number>;
		
		public static function decodeBodyFrameData(ba:ByteArray):BodyFrameData
		{
			var ret : BodyFrameData = new BodyFrameData();
			ret.decode(ba);
			return ret;
		}
		
		public function decode(ba:ByteArray):void
		{
			texture = Texture2D.decodeTexture2D(ba);
			
			
			vertexPerLine = ba.readByte();
			totalLine = ba.readByte();
			
			var _total : int = vertexPerLine * totalLine;
			vertexData = new Vector.<Point>(_total , true);
		
			for (var i : int = 0 ; i < _total ; i++ )
			{
				var _x : Number = ba.readFloat();
				var _y : Number = ba.readFloat();
				
				vertexData[i] = new Point(_x , _y);
			}
				
			var _changeIndex : int = ba.readUnsignedShort();
			breathChangeIndex = new Vector.<int>(_changeIndex , true);
			
			for (i = 0 ; i < _changeIndex ; i++ )	
			{
				breathChangeIndex[i] = ByteArrayUtil.readUnsignedByteOrShort(ba);
			}
			vertexBreathData = new Vector.<Point>(_changeIndex , true);
			for (i = 0 ; i < _changeIndex ; i++ )
			{
				_x = ba.readFloat();
				_y = ba.readFloat();
				vertexBreathData[i] = new Point(_x , _y);
			}
			
			
			offsetX =  ba.readFloat();
			offsetY = ba.readFloat();
		
			genUVData();
			indices = new Vector.<int>();
			MeshUtil.genIndicesData(indices , vertexPerLine , totalLine);
			
			
			vertices = new Vector.<Number>();
			for each (var _pt : Point in vertexData)
			{
				vertices.push(_pt.x + offsetX);
				vertices.push(_pt.y + offsetY);
			}
		}
		
		private function updatePos( interp : Number):void 
		{
			var _breathChangeIndexLength : int = breathChangeIndex.length;
			for (var i : int = 0 ; i < _breathChangeIndexLength ; i++)
			{
				var _index : int = breathChangeIndex[i];
				var _index2 : int = _index << 1;
				vertices[_index2] = vertexData[_index].x + (vertexBreathData[i].x - vertexData[_index].x) * interp;
				vertices[_index2 + 1] = vertexData[_index].y + (vertexBreathData[i].y - vertexData[_index].y) * interp;
			}
			
		}
		
		public function updateAndRender(g:Graphics , interp : Number):void
		{
			updatePos(interp);
			g.drawTriangles(vertices, indices, uvData);
		}
				
		
		private function genUVData():void
		{
			uvData = new Vector.<Number>();
			for each (var _ev : Point in vertexData)
			{
				uvData.push ((_ev.x /*+ (s_texture.rectW >> 1)*/ + texture.rectX) / 512);
				uvData.push ((_ev.y /*+ (s_texture.rectH >> 1)*/ + texture.rectY) / 1024);//TODO
			}
			
		}
		
	}

}