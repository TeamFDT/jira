package com.powerflasher.SampleApp {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class FDT2826 extends Sprite {
		public function FDT2826() {
			this.stage.addEventListener(MouseEvent.CLICK, doClick);
		}
		private function doClick(event : MouseEvent) : void {
			trace('event: ' + (event));
			var party:Sprite;
			addChild(party);
		}
	}
}
