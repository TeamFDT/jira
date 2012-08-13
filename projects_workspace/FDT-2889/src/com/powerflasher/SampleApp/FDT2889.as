package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2889 extends Sprite {
		public function FDT2889() {
			{
			(function() : void {
				for (var i : int = 0; i < 128; i++) {
					trace(i);
				}
			}());
			}
		}
		
		public function test() : void {
			// but here it works
			(function() : void {
				for (var i : int = 0; i < 128; i++) {
					trace(i);
				}
			}());
		}
	}
}
