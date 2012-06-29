package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2551 extends Sprite {
		public function FDT2551() {
			var movieClips : Vector.<Sprite> = new Vector.<Sprite>();
			var title : String = "aaa";

			// FDT ok
			// complier error: Comparison between a value with static type __AS3__.vec:Vector.<flash.display:Sprite> and a possibly unrelated type String.
			if (movieClips == title) {
			}
		}
	}
}