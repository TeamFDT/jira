package net.adventmedia.profile {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Profiling extends Sprite {
		private var circles:Array = [];

		public function Profiling() {
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, start_circles);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stop_circles);
		}

		private function start_circles(event:MouseEvent):void {
			this.addEventListener(Event.ENTER_FRAME, draw_circles);
			trace("adding circles");
		}

		private function stop_circles(event:MouseEvent):void {
			this.removeEventListener(Event.ENTER_FRAME, draw_circles);
			trace("removing", circles.length, "circles");
			while (circles[0]) {
				this.removeChild(circles.pop());
			}
		}

		private function draw_circles(event:Event):void {
			// with no referece this won't be garbage collected
			addChild(create_circle());
			// hold a referce in array so it can be removed from stage
			// and garbage collected
			circles.unshift(create_circle());
			addChild(circles[0]);
		}

		private function create_circle():Circle {
			var circle:Circle = new Circle();
			circle.x = this.stage.stageWidth * Math.random();
			circle.y = this.stage.stageHeight * Math.random();
			return  circle;
		}
	}
}
