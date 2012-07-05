package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT1209 extends Sprite {
		private var zippy : int;
		private var dippy : int;

		public function FDT1209() {
			method(1,2);
		}

		private function method(zippy : int, dippy : int) : void {
			this.dippy = dippy;
			this.zippy = zippy;
		}
	}
}
