package editor.module.hair 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class ModuleHairMassPoint// extends Sprite
	{
		//public var oriPos : Point = new Point();
		public var lastPos : Point = new Point();
		public var pos : Point = new Point();
		public var preMassPoint : ModuleHairMassPoint;
		//public var prepreMassPoint : MassPoint;
		
		public var radian : Number;
		public var springLength : Number;
		//public var rootLength : Number;
		
		//public var preRadian : Number;
		//public var preSpringLength : Number;
		
		
		public function init(/*rootPt : Point*/):void
		{
			var _x : Number = pos.x - preMassPoint.pos.x;
			var _y : Number = pos.y - preMassPoint.pos.y;
			
			radian = Math.atan2(_y, _x);
			springLength = Math.sqrt(_y * _y + _x * _x);
			
			//if (rootPt)
			//{
			//	_x = pos.x - rootPt.x;
			//	_y = pos.y - rootPt.y;
			//	rootLength = Math.sqrt(_y * _y + _x * _x);
			//}
			
		}
		/*
		public function MassPoint() 
		{
			graphics.beginFill(0);
			graphics.drawCircle(0, 0, 10);
		}*/
		
		
		
	}

}