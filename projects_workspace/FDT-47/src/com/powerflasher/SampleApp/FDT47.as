package com.powerflasher.SampleApp {
	import flash.display.FrameLabel;
	import flash.display.Sprite;

	public class FDT47 extends Sprite {
		private var currentLabels : FrameLabel;
		public function FDT47() {
		}

		private function test() : int {
			for each ( var frameLabel : FrameLabel in currentLabels ) {
				if ( frameLabel.name == "something" )
					return frameLabel.frame;
			}
			// An error should be displayed here, cause a return statement is missing.
		}
	}
}
