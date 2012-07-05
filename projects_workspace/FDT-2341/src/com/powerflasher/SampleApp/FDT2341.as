package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2341 extends Sprite {
		private var _selectedItem : Object;
		
		public function FDT2341() {
			this.selectedItem();
		}

		public function get selectedItem() : Object {
			return _selectedItem;
		}
	}
}
