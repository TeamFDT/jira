package {
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author philipp
	 */
	public class Main extends Sprite {
		public function Main() {
			stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
		}

		private function onEnterframe(event : Event) : void {
			addChild(new Ball());
		}
	}
}
