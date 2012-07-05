package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2291 extends Sprite {
		private var _field : String;

		public function FDT2291() {
		}

		public function get field() : String {
			return _field;
		}

		public function set field(field : String) : void {
			this._field = field;
		}
	}
}
