package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2813 extends Sprite {
		public function FDT2813() {
		}

		private function zoomIn() : void {
			const MAX_SCALE : Number = 1.6; 	// should be 'convert local const to a field'
			trace('MAX_SCALE: ' + (MAX_SCALE));
		}
	}
}
