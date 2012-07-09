package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class BBTest extends Sprite {
		public function BBTest() {
			
			trace('BBTest: ' + (BBTest));
			this.graphics.beginFill(0xff);
			this.graphics.drawCircle(50, 50, 200)
			
		}
	}
}
