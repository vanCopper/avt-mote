package player 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import player.struct.EyeFrameData;
	import player.struct.Matrix4x4;
	import player.struct.Plane3D;
	import player.struct.Vertex3D;
	import player.util.ByteArrayUtil;
	import player.util.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class EyeRender 
	{
		
		public function EyeRender() 
		{
			
		}
		
		private var m_frameList : Vector.<EyeFrameData>;
		private var m_blinkIndexL : Vector.<int>;
		private var m_blinkIndexR : Vector.<int>;
		
		private var m_eaL: Number;
		private var m_ebL : Number;
		private var m_erL : Number;
		private var m_eCenterLX : Number;
		private var m_eCenterLY : Number;
		
		private var m_eaR : Number;
		private var m_ebR : Number;
		private var m_erR : Number;
		private var m_eCenterRX : Number;
		private var m_eCenterRY : Number;
		
		private var m_eyeMatrix : Matrix4x4;
			
		private var m_eyeLPlane : Plane3D;
		private var m_eyeLScale : Number;
		private var m_eyeLLocateX : Number;
		private var m_eyeLLocateY : Number;
			
			
		private var m_eyeRPlane : Plane3D;
		private var m_eyeRScale : Number;
		private var m_eyeRLocateX : Number;
		private var m_eyeRLocateY : Number;
		
		private var m_eyeLCenter : Vertex3D;
		private var m_eyeRCenter : Vertex3D;
		
		public var AIM_LENGTH : Number = 300;
		
		private var m_matrix : Matrix4x4;
		private var m_changed : Boolean = true;
		
		private const m_maxLag : int = 120;
		private const m_minLag : int = 60;
		private var m_curFrame : int;
		public var curLag : int = m_maxLag;
		
		public function decode(baData : ByteArray , endPos : uint ,a_bitmapData:BitmapData) : void
		{
			while (baData.position < endPos)
			{
				var _flag : int = baData.readByte();
				
				if (_flag == 1)
				{
					var _frameListLength : int = ByteArrayUtil.readUnsignedByteOrShort(baData);
					m_frameList = new Vector.<EyeFrameData>(_frameListLength , true);
					for (var i : int = 0 ; i < _frameListLength; i++ )
					{
						m_frameList[i] = EyeFrameData.decodeEyeFrameData(baData);
					}
				}
				else if (_flag == 2)
				{
					var blinkLength : int = baData.readByte();
					m_blinkIndexL = new Vector.<int>(blinkLength , true);
					m_blinkIndexR = new Vector.<int>(blinkLength , true);
					
					for (i = 0 ; i < blinkLength ; i++ )
					{
						m_blinkIndexL[i] = baData.readByte();
					}
					for (i = 0 ; i < blinkLength ; i++ )
					{
						m_blinkIndexR[i] = baData.readByte();
					}
					
				}
				else if (_flag == 3)
				{
					 m_eaL = baData.readFloat();
					 m_ebL = baData.readFloat();
					 m_erL = baData.readFloat();
					 m_eCenterLX = baData.readFloat();
					 m_eCenterLY = baData.readFloat();
					
					 m_eaR = baData.readFloat();
					 m_ebR = baData.readFloat();
					 m_erR = baData.readFloat();
					 m_eCenterRX  = baData.readFloat();
					 m_eCenterRY  = baData.readFloat();
					 
					 
				}
				else if (_flag == 4)
				{
					m_eyeMatrix = Matrix4x4.decodeMatrix4x4(baData);
			
					m_eyeLPlane = Plane3D.decodePlane3D(baData);
					m_eyeLScale = baData.readFloat();
					m_eyeLLocateX = baData.readFloat();
					m_eyeLLocateY = baData.readFloat();
				
					m_eyeLCenter = new Vertex3D();
					m_eyeLCenter.x = m_eyeLLocateX;
					m_eyeLCenter.y = m_eyeLLocateY;
					EyeFrameData.dealVertex3D(m_eyeLCenter , m_eyeLScale , m_eyeLPlane , m_eyeMatrix , m_eyeLLocateX , m_eyeLLocateY);
					
	
				
					m_eyeRPlane = Plane3D.decodePlane3D(baData);
					m_eyeRScale = baData.readFloat();
					m_eyeRLocateX = baData.readFloat();
					m_eyeRLocateY = baData.readFloat();
					
					m_eyeRCenter = new Vertex3D();
					m_eyeRCenter.x = m_eyeRLocateX;
					m_eyeRCenter.y = m_eyeRLocateY;
					EyeFrameData.dealVertex3D(m_eyeRCenter , m_eyeRScale , m_eyeRPlane , m_eyeMatrix , m_eyeRLocateX , m_eyeRLocateY);
					//trace(m_eyeMatrix);
				}	
			}
			
			if (m_frameList && m_blinkIndexL)
			{
				for each (var idx : int in m_blinkIndexL)
				{
					m_frameList[idx].init(a_bitmapData , m_eyeMatrix , m_eyeLPlane , m_eyeLScale , m_eyeLLocateX , m_eyeLLocateY);
				}
				
				for each (idx in m_blinkIndexR)
				{
					m_frameList[idx].init(a_bitmapData , m_eyeMatrix , m_eyeRPlane , m_eyeRScale , m_eyeRLocateX , m_eyeRLocateY );
				}
			}
			
			
		}
		
		public function render(sp:Sprite , bitmapData : BitmapData, md : Matrix4x4):void
		{
			
			if (!m_frameList || !m_frameList.length)
				return;
			
			if (!m_changed && md)
			{
				m_changed = !md.isEqual(m_matrix);
			}
			
			if (curLag > 0)
			{
				curLag--;
			}
			else {
				
				m_curFrame++;
				m_changed = true;
				if (m_curFrame >= m_blinkIndexL.length)
				{
					curLag = (Math.random() * (m_maxLag - m_minLag)) + m_minLag;
					m_curFrame = 0;
				}
				else 
				{
					
				}
			}
			
			if (m_changed)
			{
				m_matrix = md;
				m_changed = false;
				
				if (m_frameList && m_blinkIndexL)
				{	
					var _lEyeFrameData : EyeFrameData = m_frameList[m_blinkIndexL[m_curFrame]];
					var _rEyeFrameData : EyeFrameData = m_frameList[m_blinkIndexR[m_curFrame]];
					
					
					var _vx : Number;
					var _vy : Number;
					
					var mXOff : Number = (sp.mouseX);
					var mYOff : Number = (sp.mouseY);
						
					if (m_eyeLCenter)
					{
						_vx = (md.Xx * m_eyeLCenter.x + md.Xy * m_eyeLCenter.y + md.Xz * m_eyeLCenter.z) ;
						_vy = (md.Yx * m_eyeLCenter.x + md.Yy * m_eyeLCenter.y + md.Yz * m_eyeLCenter.z) ;
						
						
						
						var _lRadian : Number = Math.atan2(mYOff - _vy , mXOff - _vx );
						var _lRate : Number = Math.sqrt((mYOff - _vy)*(mYOff - _vy) + (mXOff - _vx )*(mXOff - _vx ));
							_lRate /= AIM_LENGTH;
						if (_lRate > 1) 
							_lRate = 1;
				
						if (!isNaN(m_eaL))
						{
							
							var pt : Point = getXYOfArea(_lRadian,true,_lRate);
						
							if (_lEyeFrameData.eyeBall)
							{
								_lEyeFrameData.eyeBallX = pt.x + m_eCenterLX - Math.abs(_lEyeFrameData.eyeBall.rectW) / 2; 
								_lEyeFrameData.eyeBallY = pt.y + m_eCenterLY - _lEyeFrameData.eyeBall.rectH / 2; 
								_lEyeFrameData.updateEyeBallVertex3D(m_eyeMatrix , m_eyeLPlane, m_eyeLScale , m_eyeLLocateX , m_eyeLLocateY);
							}
							
						}
					}
					if (m_eyeRCenter)
					{
						_vx = (md.Xx * m_eyeRCenter.x + md.Xy * m_eyeRCenter.y + md.Xz * m_eyeRCenter.z) ;
						_vy = (md.Yx * m_eyeRCenter.x + md.Yy * m_eyeRCenter.y + md.Yz * m_eyeRCenter.z) ;
						
						var _rRadian : Number = Math.atan2(mYOff - _vy , mXOff - _vx );
						var _rRate : Number = Math.sqrt((mYOff - _vy)*(mYOff - _vy) + (mXOff - _vx )*(mXOff - _vx ));
							_rRate /= AIM_LENGTH;
						if (_rRate > 1) 
							_rRate = 1;
				
						if (!isNaN(m_eaL))
						{
							
							pt = getXYOfArea(_rRadian,true,_rRate);
						
							if (_rEyeFrameData.eyeBall)
							{
								_rEyeFrameData.eyeBallX = pt.x + m_eCenterRX - Math.abs(_rEyeFrameData.eyeBall.rectW) / 2; 
								_rEyeFrameData.eyeBallY = pt.y + m_eCenterRY - _rEyeFrameData.eyeBall.rectH / 2; 
								_rEyeFrameData.updateEyeBallVertex3D(m_eyeMatrix , m_eyeRPlane, m_eyeRScale , m_eyeRLocateX , m_eyeRLocateY);
							}
							
							
							
						}
					}
					
					drawEye(sp , bitmapData , md , _lEyeFrameData , _rEyeFrameData);
				}
			} 
			//else
			//	trace("skip a eye render")
			
			
		}
		
		///////
		public function getXYOfArea(_radain : Number , _left : Boolean , _rate : Number) : Point
		{
			var ret : Point = new Point;
						
			
			var _er : Number;
			var _ea : Number;
			var _eb : Number;
			
			if (_left)
			{
				_er = m_erL ;
				_ea = m_eaL ;
				_eb = m_ebL ;
				
			}
			else {
				_er = m_erR ;
				_ea = m_eaR ;
				_eb = m_ebR ;
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
		
		///////
		private static function drawEyeMaskArray(g:Graphics , _eyeMaskData : Vector.<Number> , start : int = 0):void
		{
			var idx : int = start + 4;
			
		
			g.beginFill(0xFF00000 , 0.25);	
			while (idx < _eyeMaskData.length)
			{
				
				g.moveTo(_eyeMaskData[start] , _eyeMaskData[start+1]);
				
				g.lineTo(_eyeMaskData[idx-2] , _eyeMaskData[idx-1]);
				g.lineTo(_eyeMaskData[idx] , _eyeMaskData[idx+1]);
				g.lineTo(_eyeMaskData[start] , _eyeMaskData[start+1]);
				
				
				idx+=2;
			}
			g.endFill();	
		}
		
		private static const indices8 : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3]);
		private static const indices16 : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3 , 4, 5, 6, 6, 5, 7]);
		//private static const indices24 : Vector.<int> = Vector.<int>([0, 1, 2, 2, 1, 3 , 4, 5, 6, 6, 5, 7 , 8, 9, 10, 10, 9, 11 ]);
		
		private static function drawEyeArray(g:Graphics , vertices : Vector.<Number> , uvtData :  Vector.<Number>  , bitmapData : BitmapData , start : int , vleng : int):void
		{
			var indices : Vector.<int>;
			
			if (vleng == 8)
				indices = indices8;
			else if (vleng == 16)
				indices = indices16;
			//else if (vleng == 24)
			//	indices = indices24;
			
			g.beginBitmapFill(bitmapData,null,false,true);
			g.drawTriangles(
				vertices.slice(start,start + vleng),//flash bug
				indices,
				uvtData
			);
			g.endFill();
		}
		
		
		
		public static function drawEye(sp:Sprite  , bitmapData : BitmapData , md : Matrix4x4 , _leftEyeData : EyeFrameData, _rightEyeData  : EyeFrameData ) : void
		{
			
		
		
			
			GraphicsUtil.removeAllChildren(sp);
			
			var shp : Shape = new Shape();
			var shpLip : Shape = new Shape();
			var shpMask : Shape = new Shape();
			
			sp.addChild(shp);
			sp.addChild(shpMask);
			sp.addChild(shpLip);
			shp.mask = shpMask;
			
			var v : Vector.<Number> ;
			
			var vtx : Vertex3D;
			var start : int;
			
			v = new Vector.<Number>();
			for each (vtx in _leftEyeData.eyeVertex3D) {
				v.push((md.Xx * vtx.x + md.Xy * vtx.y + md.Xz * vtx.z));
				v.push((md.Yx * vtx.x + md.Yy * vtx.y + md.Yz * vtx.z));
			}
			
			start = 0;
			if (_leftEyeData.vertexLength)
			{	
				drawEyeArray(shp.graphics , v , _leftEyeData.eyeVertex3DUV, bitmapData , start , _leftEyeData.vertexLength);
				start += _leftEyeData.vertexLength;
			}
			if (_leftEyeData.eyeLip)
			{
				drawEyeArray(shpLip.graphics , v,_leftEyeData.eyeLip.genUV(bitmapData) , bitmapData , start  , 8);
				start += 8;
			}
			
			drawEyeMaskArray(shpMask.graphics , v , start);
			
			
			v = new Vector.<Number>();
			for each (vtx in _rightEyeData.eyeVertex3D) {
				v.push((md.Xx * vtx.x + md.Xy * vtx.y + md.Xz * vtx.z));
				v.push((md.Yx * vtx.x + md.Yy * vtx.y + md.Yz * vtx.z));
			}
			
			start = 0;
			if (_rightEyeData.vertexLength)
			{
				drawEyeArray(shp.graphics, v , _leftEyeData.eyeVertex3DUV, bitmapData , start , _rightEyeData.vertexLength);
				start +=  _rightEyeData.vertexLength;
			}
			if (_rightEyeData.eyeLip)
			{
				drawEyeArray(shpLip.graphics , v, _rightEyeData.eyeLip.genUV(bitmapData) , bitmapData , start  , 8);
				start += 8;
			}
			
			drawEyeMaskArray(shpMask.graphics , v , start);
			
		}
		
	}

}