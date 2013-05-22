package editor.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenuBuiltInItems;
	
	public class EdtRotationAxis extends Sprite
	{
		private var radius:int = 50;
		private var radius2:int = 10;
		
		private var xShape:Sprite;
		private var yShape:Sprite;
		private var zShape:Sprite;
		private var sectorShape:Shape;
		private var downAxis:String;
		
		//private var oldAngle:Number;			//弧度
		private var endAngle:Number = 0;
		private var startAngle:Number = 0;
		
		public var xStartValue:Number = 0;
		public var yStartValue:Number = 0;
		public var zStartValue:Number = 0;
		
		public var xValue:Number = 0;
		public var yValue:Number = 0;
		public var zValue:Number = 0;
		public var onUpdate:Function;
		
		private var isDown:Boolean;
		
		private function clearStatus():void
		{
			xShape.alpha =
			yShape.alpha =
			zShape.alpha = 0.5;
		}
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
			
			
			drawCircle();
				
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			clearStatus();
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
		private function getAxisValue() : Number
		{
			var tempAng:Number = getAngleByPoint(0,0, mouseX, mouseY);
			return tempAng;
			/*
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
			return dAng;
			*/
		}
		
		

		protected function onMoveHandler(event:MouseEvent):void
		{
			if (!isDown)
			{	
				
				clearStatus();
			
				var opt : String = getOperateXYZ();
				if (opt)
					this[opt + "Shape"].alpha = 0.8;
				
				return;
			}
			
			
			
			if(downAxis)
			{
				///this[downAxis+"Value"] += dAng;
				var oldV : Number = this[downAxis + "Value"];
				var newV : Number  = getAxisValue();
				
				//trace(oldV , newV)
				
				var off : Number = Math.abs(oldV - newV);
				var _2PI : Number = Math.PI * 2;
				var _2PI_99 : Number = _2PI * 0.9;
				
				if ( off > _2PI_99)
				{
					var newOff : Number;
					newOff = Math.abs(oldV - (newV + _2PI));
					if (newOff < off)
					{
						for (;; )
						{	
							
							newV += _2PI;
							newOff = Math.abs(oldV - newV);
							
							if (newOff < _2PI_99)
								break;
						}
					}
					else {
						newOff = Math.abs(oldV - (newV - _2PI));
						if (newOff < off)
						{
							for (;; )
							{	
								
								newV -= _2PI;
								newOff = Math.abs(oldV - newV);
								
								if (newOff < _2PI_99)
									break;
							}
						}
					}
				}
				
				this[downAxis + "Value"] = newV;
				
				//trace(this[downAxis + "Value"] , this[downAxis + "StartValue"]);
				
//				trace(R2D(xValue), R2D(yValue), R2D(zValue));
				
				if(onUpdate!=null)
					onUpdate(xValue - xStartValue, yValue - yStartValue, zValue - zStartValue , false );
					
				endAngle = this[downAxis + "Value"];
				//oldAngle = this[downAxis + "StartValue"];
			
				drawSector();
			}
			
			
			
			
			//endAngle += dAng;
			//oldAngle = tempAng;
			
			
		}
		private function getOperateXYZ():String
		{
			var xP:Object = oval2(0,0,mouseX,mouseY,10,50);
			var yP:Object = oval2(0,0,mouseX,mouseY,50,10);
			var zP:Object = oval(0,0,radius,radius, Math.atan2(mouseY , mouseX));
			
			
			
			var dx:Number = getDistance(mouseX, mouseY, xP.x, xP.y);
			var dy:Number = getDistance(mouseX, mouseY, yP.x, yP.y);
			var dz:Number = getDistance(mouseX, mouseY, zP.x, zP.y);
			
			//trace(xP , yP , zP , dx , dy , dz)
			
			if (dx > 15 && dy > 15 && dz > 15 )
				return null;
			
			
				
				
			if(dx<=dy && dx<=dz)
			{
				return "x";
			}
			else if(dz < dy && dz < dx)
			{
				return "z";
			}
			else
			{
				return "y";
			}
			
			
		}
		
		protected function onDownHandler(event:MouseEvent):void
		{
			if(getDistance(0,0,mouseX,mouseY)>radius+10)return;
			
			isDown = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			clearStatus();
			
			endAngle = startAngle = getAngleByPoint(0,0, mouseX, mouseY);
			xValue = yValue = zValue = xStartValue = yStartValue = zStartValue = 0;
			
			var opt : String = getOperateXYZ();
			
			if (!opt )
			{
				downAxis = null;
				return;
			}
			
			//var distance:Number = 0;
			
			if(opt == "x")
			{
				//distance = dx;
				downAxis = "x";
				xStartValue = startAngle;
				xShape.alpha = 1;
				
			}
			else if(opt == "z")
			{
				//distance = dz;
				downAxis = "z";
				zStartValue = startAngle;
				zShape.alpha = 1;
			} 
			else if(opt == "y")
			{
				//distance = dy;
				downAxis = "y";
				yStartValue = startAngle;
				yShape.alpha = 1;
			}
		}
		
		
		
		protected function onUpHandler(event:MouseEvent):void
		{
			clearStatus();
			
			
			if(isDown)
			{
				isDown = false;
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
				
				sectorShape.graphics.clear();
				
				if(onUpdate!=null)
					onUpdate(xValue - xStartValue, yValue - yStartValue, zValue - zStartValue , true );
			}
		}	
		
		
		
		
		
		
		
		
		/**
		 * 画扇形
		 * 
		 */		
		protected function drawSector():void
		{
			//var ang1:Number = startAngle;
			
			
			
			var objStart:Object = new Object();
			var objEnd:Object = new Object();
			
			
			var _color : uint;
			sectorShape.graphics.clear();
			if(downAxis=="x")
			{
				_color = 0xFF0000;
			}
			else if(downAxis=="y")
			{
				_color = 0x00FF00;
			}
			else if(downAxis=="z")
			{
				_color = 0x0000FF;
			}
			
			
			//trace("起始角度" + int(R2D(startAngle)) + " 结束角度" + int(R2D(endAngle)) );
			
			var _loop : int = 1;
			var totalAngel : Number = endAngle - startAngle;
			
			//trace("总角度" + int(R2D(totalAngel)) );
			
			var _2PI : Number = Math.PI * 2;
			if (totalAngel > 0)
			{
				while (totalAngel >  _2PI)
				{
					totalAngel -= _2PI;
					_loop++;
				}
			} else {
				while (totalAngel < -_2PI)
				{
					totalAngel += _2PI;
					_loop ++;
				}
			}
			
			
			
			
				
			var angle : Number;
			const dAng:Number = 1;

			
			while (_loop)
			{
				
				var startDegress : int = R2D(startAngle);
				var endDegress : int = R2D(startAngle);
				
				
				if (_loop == 1)
					endDegress = R2D(totalAngel + startAngle) ;
				else
					endDegress = 360 + startDegress ;
				
				sectorShape.graphics.beginFill(_color, 0.4);
				sectorShape.graphics.moveTo(0,0);
				
				var _dDegree : int;
				if (endDegress > startDegress)
				{	

					for (_dDegree = startDegress ;_dDegree <= endDegress; _dDegree++) 
					{
						if(downAxis=="x")
							objEnd = oval3(0,0,10,50,D2R(_dDegree));
						else if(downAxis=="y")
							objEnd = oval3(0,0,50,10,D2R(_dDegree));
						else if(downAxis=="z")
							objEnd = oval(0,0,radius,radius,D2R(_dDegree));
						
						sectorShape.graphics.lineTo(objEnd.x,objEnd.y);
					}
				}
				else
				{	
					for (_dDegree = startDegress ;_dDegree >= endDegress; _dDegree--) 
					{
						if(downAxis=="x")
							objEnd = oval3(0,0,10,50,D2R(_dDegree));
						else if(downAxis=="y")
							objEnd = oval3(0,0,50,10,D2R(_dDegree));
						else if(downAxis=="z")
							objEnd = oval(0,0,radius,radius,D2R(_dDegree));
						
						sectorShape.graphics.lineTo(objEnd.x,objEnd.y);
					}
				}
				
				sectorShape.graphics.lineTo(0, 0);
				sectorShape.graphics.endFill();
				
				_loop--;
			}
		
			
			
			
			
			
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
		
		protected function D2R(degress:Number):Number
		{
			return degress / 180 * Math.PI;
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