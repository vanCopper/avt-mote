package editor.module.head 
{
	import editor.ui.EdtVertexInfo;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHead3DView extends Shape
	{
		
		public function render(_edtVertexArray : Vector.<EdtVertexInfo>) : void
		{
			var __v : Vector.<Number> = new Vector.<Number>();
				
			for each( var ev : EdtVertexInfo in _edtVertexArray)
			{
				__v.push(ev.dot.x);
				__v.push(ev.dot.y);
			}

			{
				ModuleHeadData.drawTriangles(this.graphics , __v);
			}
		}
		
	}

}