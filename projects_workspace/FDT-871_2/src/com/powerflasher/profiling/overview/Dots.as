package com.powerflasher.profiling.overview {
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(backgroundColor="#111111", frameRate="31", width="640", height="480")]

	public class Dots extends Sprite {
		private static const MAX_WIDTH : uint = 550;
		private static const MAX_HEIGHT : uint = 500;
		private static const MAX_RADIUS : uint = 30;
		private static const MAX_COUNTER : uint = 100;
		
		private var counter : int;

		public function Dots() {
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function handleEnterFrame(event : Event) : void {
			var dot : Dot;
			if(counter > MAX_COUNTER) {
				dot = Dot(getChildAt(0));
				trace(dot);
				removeChild(dot);
			}
			
			dot = new Dot(0xffcc00);
			dot.x = Math.random() * MAX_WIDTH;
			dot.y = Math.random() * MAX_HEIGHT;
			var radius : Number = Math.random() * MAX_RADIUS + 5;
			dot.width = radius;
			dot.height = radius;
			addChild(dot);
			counter++;
		}
	}
}
