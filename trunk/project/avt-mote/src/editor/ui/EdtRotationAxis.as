package editor.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EdtRotationAxis extends Sprite
	{
		private var radius:int = 50;
		private var radius2:int = 10;
		
		private var xShape:Sprite;
		private var yShape:Sprite;
		private var zShape:Sprite;
		private var sectorShape:Shape;
		private var downAxis:String;
		
		private var oldAngle:Number;			//弧度
		private var endAngle:Number;
		private var startAngle:Number;
		
		
		public var xValue:Number = 0;
		public var yValue:Number = 0;
		public var zValue:Number = 0;
		public var onUpdate:Function;
		
		private var isDown:Boolean;
		
		
		public function EdtRotationAxis()
		{
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0,0,1);
			this.graphics.endFill();
			
			xShape = new Sprite();
			yShape = new Sprite();
			zShape = new Sprite();
			sectorShape = new Shape();
			addChild(xShape);
			addChild(yShape);
			addChild(zShape);
			addChild(sectorShape);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			drawCircle();
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
		}		
		
		public function dispose() : void
		{
			xShape = null;
			yShape = null;
			zShape = null;
			sectorShape = null;
		
			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			if (stage.hasEventListener(MouseEvent.MOUSE_UP))	
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))	
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);	
			
		}
		
		
		protected function onMoveHandler(event:MouseEvent):void
		{
			if(!isDown)return;
			
			var tempAng:Number = getAngleByPoint(0,0, mouseX, mouseY);
			
			var dAng:Number;
			if(tempAng>0 &&oldAngle<0)
			{
				dAng = Math.abs(oldAngle)-tempAng;
			}
			else if(tempAng<0 &&oldAngle>0)
			{
				dAng = oldAngle+tempAng;
			}
			else
			{
				dAng = tempAng - oldAngle;
			}
			
			
			if(downAxis)
			{
				this[downAxis+"Value"] += dAng;
//				trace(R2D(xValue), R2D(yValue), R2D(zValue));
				
				if(onUpdate!=null)
					onUpdate(R2D(xValue), R2D(yValue), R2D(zValue));
			}
			
			
			
			
			endAngle += dAng;
			oldAngle = tempAng;
			
			drawSector();
		}
		
		
		protected function onDownHandler(event:MouseEvent):void
		{
			if(getDistance(0,0,mouseX,mouseY)>radius+10)return;
			
			isDown = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			
			endAngle = startAngle = oldAngle = getAngleByPoint(0,0, mouseX, mouseY);
			
			var xP:Object = oval2(0,0,mouseX,mouseY,10,50);
			var yP:Object = oval2(0,0,mouseX,mouseY,50,10);
			var zP:Object = oval(0,0,radius,radius,startAngle);
			
			
			var distance:Number = 0;
			var dx:Number = getDistance(mouseX, mouseY, xP.x, xP.y);
			var dy:Number = getDistance(mouseX, mouseY, yP.x, yP.y);
			var dz:Number = getDistance(mouseX, mouseY, zP.x, zP.y);
			
			if(dx<=dy)
			{
				distance = dx;
				downAxis = "x";
			}
			else
			{
				distance = dy;
				downAxis = "y";
			}
			
			if(dz<distance)
			{
				distance = dz;
				downAxis = "z";
			}
			
			if(Math.abs(distance)>10)
			{
				downAxis = null;
			}
		}
		
		
		
		protected function onUpHandler(event:MouseEvent):void
		{
			if(isDown)
			{
				isDown = false;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
				
				sectorShape.graphics.clear();
				
//				if(onUpdate!=null)
//					onUpdate(xValue, yValue, zValue);
			}
		}	
		
		
		
		
		
		
		
		
		/**
		 * 画扇形
		 * 
		 */		
		protected function drawSector():void
		{
			var ang1:Number = startAngle;
			
			var dAng:Number = 0.1;
			if(ang1 < endAngle)
				dAng = -0.1;
			
			var objStart:Object = new Object();
			var objEnd:Object = new Object();
			
			
			
			sectorShape.graphics.clear();
			if(downAxis=="x")
			{
				objStart = oval3(0,0,10,50,startAngle);
				sectorShape.graphics.beginFill(0xFF0000, 0.5);
			}
			else if(downAxis=="y")
			{
				objStart = oval3(0,0,50,10,startAngle);
				sectorShape.graphics.beginFill(0x00FF00, 0.5);
			}
			else if(downAxis=="z")
			{
				objStart = oval(0,0,radius,radius,startAngle);
				sectorShape.graphics.beginFill(0x0000FF, 0.5);
			}
			
			
			sectorShape.graphics.moveTo(0,0);
			sectorShape.graphics.lineTo(objStart.x, objStart.y);
			
			
			var leng:int = Math.abs((endAngle-ang1)/dAng);
			for (var i:int = 0; i < leng; i++) 
			{
				ang1 -= dAng;
				if(downAxis=="x")
					objEnd = oval3(0,0,10,50,ang1);
				else if(downAxis=="y")
					objEnd = oval3(0,0,50,10,ang1);
				else if(downAxis=="z")
					objEnd = oval(0,0,radius,radius,ang1);
				
				sectorShape.graphics.lineTo(objEnd.x,objEnd.y);
			}
			sectorShape.graphics.lineTo(0,0);
			sectorShape.graphics.endFill();
			
		}
		
		
		/**
		 * 画圆
		 * 
		 */		
		protected function drawCircle():void
		{
			xShape.graphics.clear();
			xShape.graphics.lineStyle(2,0xff0000, 1);
			xShape.graphics.drawEllipse(-10,-radius,radius2*2, 2*radius);
			xShape.graphics.endFill();
			
			yShape.graphics.clear();
			yShape.graphics.lineStyle(2,0x00ff00, 1);
			yShape.graphics.drawEllipse(-radius,-10, 2*radius ,radius2*2);
			yShape.graphics.endFill();
			
			zShape.graphics.clear();
			zShape.graphics.lineStyle(2,0x0000ff,1);
			zShape.graphics.drawCircle(0,0,radius);
			zShape.graphics.endFill();
		}
		
		
		protected function getAngleByPoint(ox:Number, oy:Number, px:Number, py:Number):Number
		{
			var dx:Number=px - ox;
			var dy:Number=py - oy;
			return Math.atan2(dy, dx);
		}
		
		
		protected function R2D(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		
		protected function oval(centerX:Number, centerY:Number, radiusX:Number, radiusY:Number, angle:Number):Object
		{
			var _x:Number=centerX + Math.cos(angle) * radiusX;
			var _y:Number=centerY + Math.sin(angle) * radiusY;
			return {x: _x, y: _y};
		}
		
		protected function oval2(ox:Number, oy:Number, px:Number, py:Number, a:Number, b:Number):Object
		{
			var angle:Number = getAngleByPoint(ox,oy,px,py);
			return oval3(ox,oy,a,b,angle);
		}
		
		protected function oval3(ox:Number, oy:Number, a:Number, b:Number, angle:Number):Object
		{
			var r:Number = (a*b)/Math.sqrt(a*a*Math.sin(angle)*Math.sin(angle) + b*b*Math.cos(angle)*Math.cos(angle) );
			var _x:Number=ox + Math.cos(angle) * r;
			var _y:Number=ox + Math.sin(angle) * r;
			return {x:_x, y:_y};
		}
		
		
		protected function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number=x2 - x1;
			var dy:Number=y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
	}
}