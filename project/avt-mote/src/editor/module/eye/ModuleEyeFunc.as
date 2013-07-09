package editor.module.eye 
{
	import editor.struct.Matrix4x4;
	import editor.struct.Vertex3D;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleEyeFunc
	{
		
		private static function drawEyeMaskArray(g:Graphics , _eyeMaskData : Vector.<Vertex3D> , start : int = 0):void
		{
			var idx : int = start + 2;
			
		
			
			while (idx < _eyeMaskData.length)
			{
				g.beginFill(0xFF00000 , 0.25);	
				g.moveTo(_eyeMaskData[0].x , _eyeMaskData[0].y);
				
				g.lineTo(_eyeMaskData[idx-1].x , _eyeMaskData[idx-1].y);
				g.lineTo(_eyeMaskData[idx].x , _eyeMaskData[idx].y);
				g.lineTo(_eyeMaskData[0].x , _eyeMaskData[0].y);
				g.endFill();	
				
				idx++;
			}
		}
		private static function drawEyeArray(g:Graphics , v : Vector.<Vertex3D> , bitmapData : BitmapData ,start : Number = NaN, end : Number = NaN):void
		{
			const indices : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
			const uvtData :  Vector.<Number> =  Vector.<Number>([0, 0, 1, 0, 0, 1, 1, 1]);
			var vertices : Vector.<Number> = new Vector.<Number>();
			
			
			if (isNaN(start))
			{
				for each(var vtx : Vertex3D in v)
				{
					vertices.push(vtx.x);
					vertices.push(vtx.y);
				}
			} else {
				for (var _i : int = start ; _i < end ; _i++ )
				{
					vtx = v[_i];
					vertices.push(vtx.x);
					vertices.push(vtx.y);
				}
			}
			
			
			g.beginBitmapFill(bitmapData,null,false,true);
			g.drawTriangles(
				vertices,
				indices , 
				uvtData
			);
			g.endFill();
		}
		
		public static function drawEye(sp:Sprite , md : Matrix4x4 , _leftEyeData : ModuleEyeFrame, _rightEyeData  : ModuleEyeFrame ) : void
		{
			
			
			
			GraphicsUtil.removeAllChildren(sp);
			
			var shp : Shape = new Shape();
			var shpLip : Shape = new Shape();
			var shpMask : Shape = new Shape();
			
			sp.addChild(shp);
			sp.addChild(shpMask);
			sp.addChild(shpLip);
			shp.mask = shpMask;
			
			var v : Vector.<Vertex3D> ;
			
			;
			var vtx : Vertex3D;
			var vtxD : Vertex3D;
			
			v = new Vector.<Vertex3D>();
			for each (vtx in _leftEyeData.eyeVertex3D) {
				vtxD = vtx.cloneVertex3D();
				vtxD.x = (md.Xx * vtx.x + md.Xy * vtx.y + md.Xz * vtx.z) ;
				vtxD.y = (md.Yx * vtx.x + md.Yy * vtx.y + md.Yz * vtx.z) ;
				v.push(vtxD);
			}
			
			drawEyeArray(shp.graphics , v , _leftEyeData.eyeWhite.bitmapData , 0  , 4);
			drawEyeArray(shp.graphics , v, _leftEyeData.eyeBall.bitmapData, 4  , 8);
			drawEyeArray(shpLip.graphics , v, _leftEyeData.eyeLip.bitmapData, 8  , 12);
			drawEyeMaskArray(shpMask.graphics , v , 12);
			
			
			v = new Vector.<Vertex3D>();
			for each (vtx in _rightEyeData.eyeVertex3D) {
				vtxD = vtx.cloneVertex3D();
				vtxD.x = (md.Xx * vtx.x + md.Xy * vtx.y + md.Xz * vtx.z) ;
				vtxD.y = (md.Yx * vtx.x + md.Yy * vtx.y + md.Yz * vtx.z) ;
				v.push(vtxD);
			}
			
			drawEyeArray(shp.graphics , v , _rightEyeData.eyeWhite.bitmapData , 0  , 4);
			drawEyeArray(shp.graphics , v, _rightEyeData.eyeBall.bitmapData, 4  , 8);
			drawEyeArray(shpLip.graphics , v, _rightEyeData.eyeLip.bitmapData, 8  , 12);
			drawEyeMaskArray(shpMask.graphics , v , 12);
			
		}
		
		public static function getXYOfArea(_radain : Number , _left : Boolean , _rate : Number) : Point
		{
			var ret : Point = new Point;
						
			
			var _er : Number;
			var _ea : Number;
			var _eb : Number;
			
			if (_left)
			{
				_er = ModuleEyeData.s_erL ;
				_ea = ModuleEyeData.s_eaL ;
				_eb = ModuleEyeData.s_ebL ;
				
			}
			else {
				_er = ModuleEyeData.s_erR ;
				_ea = ModuleEyeData.s_eaR ;
				_eb = ModuleEyeData.s_ebR ;
			}
			
			
			var _rOff : Number = _radain - _er;
			var _a : Number = _ea / 2;
			var _b : Number = _eb / 2;
			
			var _as : Number = _a * Math.sin(_rOff);
			var _bc : Number = _b * Math.cos(_rOff);
			
			
			var r:Number = (_a*_b)/Math.sqrt(_as*_as + _bc*_bc);
			ret.x =  Math.cos(_radain) * r * _rate;
			ret.y =  Math.sin(_radain) * r * _rate;
			
			return ret;
			
		}
		
	}

}