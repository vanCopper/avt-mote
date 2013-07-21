package editor.module.hair 
{
	import editor.config.EdtDEF;
	import editor.module.head.ModuleHead3DBrowser;
	import editor.module.head.ModuleHead3DView;
	import editor.module.head.ModuleHeadData;
	import editor.struct.Matrix4x4;
	import editor.struct.Plane3D;
	import editor.struct.Texture2DBitmap;
	import editor.struct.Vertex3D;
	import editor.ui.EdtQuadrant;
	import editor.ui.EdtVertex3D;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import UISuit.UIComponent.BSSButton;
	import UISuit.UIUtils.GraphicsUtil;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHairZAdjust extends Sprite
	{
		public var data : ModuleHairFrame;
		
		public function ModuleHairZAdjust() 
		{
			
	
			
		}
		
		public function setCurrentData(_data:ModuleHairFrame):void
		{
			data = _data;
			if (_data)
			{	
				_data.genUVData();
				_data.genIndicesData();
			}
		}
		
		
		
		
		public function reset():void
		{
			data = null;
		}
		
		public function onSetNewZ():void
		{
			if (m_lasttVertexArray && data)
			{
				var startIndex : int = ModuleHeadData.s_vertexRelativeData.length;
				for (var i : int =  0 ; i < data.vertexPerLine; i++ )
				{
					data.vertexData[i].z = m_lasttVertexArray[i + startIndex].z;
				}
			}
		}
		
		private var m_lasttVertexArray : Vector.<EdtVertex3D>;
		public function getVertex(): Vector.<EdtVertex3D>
		{
			var ret : Vector.<EdtVertex3D> = new Vector.<EdtVertex3D>();
			if (!ModuleHeadData.s_vertexRelativeData || !ModuleHeadData.s_vertexRelativeData.length)
				ModuleHeadData.genVertexRelativeData();
			
			for each ( var rv : Vertex3D in ModuleHeadData.s_vertexRelativeData )
			{
				newV = new EdtVertex3D();
				newV.x  = rv.x;
				newV.y  = rv.y;
				newV.z  = rv.z;
				
				ret.push(newV);
			}
			if (ret.length)
				ModuleHeadData.genConnect(ModuleHeadData.s_pointPerLine , ModuleHeadData.s_totalLine , ret);
			
			if (data)
			{
				var p : int = ret.length + 1;
				if (data.vertexData && data.vertexData.length)
				{
					var newV : EdtVertex3D = data.vertexData[0].cloneEdtVertex3D();
					newV.priority = p++;
					newV.x += data.offsetX;
					newV.y += data.offsetY;
					
					var lastV : EdtVertex3D = newV;
					ret.push(lastV);
					
					for (var i : int =  1 ; i < data.vertexPerLine; i++ )
					{
						newV = data.vertexData[i].cloneEdtVertex3D();
						newV.priority = p++;
						newV.x += data.offsetX;
						newV.y += data.offsetY;
						
						EdtVertex3D.connect2PT(newV , lastV);
						lastV  = newV;
						
						ret.push(lastV);
					}
					
					
				}
			}
			m_lasttVertexArray = ret;
			return ret;
			
		}

		
		
		public function activate():void
		{
			
		}
		
		public function deactivate():void
		{

		}
	
		
		public function dispose():void
		{
			deactivate();
			GraphicsUtil.removeAllChildrenWithDispose(this);
		}
		
	
		public function setTemplate(mefs : ModuleHairFrameSprite , _name : String):void
		{
						
		}
		
	}

}