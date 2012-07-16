package net.adventmedia.profile {
	import flash.display.Sprite;

	/**
	 * @author andrew
	 */
	public class Circle extends Sprite {
		public function Circle() {
			this.graphics.beginFill(0xffffff * Math.random());
			this.graphics.drawCircle(0, 0, 20 * Math.random());
		}
	}
}
