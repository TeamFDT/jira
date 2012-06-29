package {
	import flash.events.Event;
	import flash.display.Sprite;

	public class Main extends Sprite {
		public function Main() {
			stage.addEventListener(Event.ENTER_FRAME, listener);
		}

		private function listener(event : Event) : void {
			graphics.beginFill(Math.random() * 0xff102160, Math.random() * 1);
			graphics.drawCircle(mouseX, mouseY, Math.random() * 100);
			graphics.endFill();
			trace('mouseX: ' + (mouseX));
		}
	}
}
