package editor.module.body 
{
	import editor.ui.EdtQuadrantMgr;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleBodyEQMgr  extends EdtQuadrantMgr 
	{
		
		public function ModuleBodyEQMgr()
		{
			useSelector = true;
			useVtxEditor = true;
			//useFocusSwitch = true;
		}
		
		public override function onVertexDataChange():void
		{
			//if (changeFunction != null)
			//	changeFunction();
		}
		
	}

}