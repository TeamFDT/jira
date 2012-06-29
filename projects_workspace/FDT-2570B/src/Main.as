package 
{
	import flash.events.Event;
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		public function Main()
		{
			stage.addEventListener(Event.ENTER_FRAME, listener);
		}

		private function listener(event : Event) : void {
			addChild(new Ball());
		}
	}
}
