package com.powerflasher.SampleApp {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	public class FDT2921 extends Sprite {
		public function FDT2921() {
			// include this line in the selection and Extract method will fail
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
		}

		private function onKeyPressed(event : KeyboardEvent) : void {
		}
	}
}
