package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2813 extends Sprite {
		private const NUMBER : Number = 1.6;
		public function FDT2813() {
			trace('FDT2813: ' + (FDT2813));
			zoomIn();
		}

		private function zoomIn() : void {
			const MAX_SCALE : Number = NUMBER;			
			trace('MAX_SCALE: ' + (MAX_SCALE));
			// should be 'convert local const to a field'
		}
	}
}
