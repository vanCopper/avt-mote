package player.struct 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Blueshell
	 */
	public class MassPoint// extends Sprite
	{
		public var lastPos : Point = new Point();
		public var pos : Point = new Point();
		public var preMassPoint : MassPoint;
		
		public var radian : Number;
		public var springLength : Number;
		
		
		public function init(/*rootPt : Point*/):void
		{
			var _x : Number = pos.x - preMassPoint.pos.x;
			var _y : Number = pos.y - preMassPoint.pos.y;
			
			radian = Math.atan2(_y, _x);
			springLength = Math.sqrt(_y * _y + _x * _x);
			
			
			
		}
	}

}