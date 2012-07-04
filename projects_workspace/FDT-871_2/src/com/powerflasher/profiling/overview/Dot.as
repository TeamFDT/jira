package com.powerflasher.profiling.overview {
	import flash.display.Sprite;

	/**
	 * @author mg
	 */
	public class Dot extends Sprite {
		public function Dot(color : uint) {
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, 14);
			graphics.endFill();
		}
	}
}
