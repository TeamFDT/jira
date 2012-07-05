package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2672 extends Sprite {
		public function FDT2672() {
			var sprites : Vector.<Sprite> = new Vector.<Sprite>();
			var id : String = sprites.name;
			// Access of possibly undefined property name through a reference with static type __AS3__.vec:Vector.<flash.display.Sprite>.

			// obvious mistake that maby be done inside loop
			for (var i : uint = 0; i < sprites.length; i++) {
				var id : String = sprites.name;
				// Access of possibly undefined property name through a reference with static type __AS3__.vec:Vector.<flash.display.Sprite>.
			}
		}
	}
}
