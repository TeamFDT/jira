package 
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite
	{
		public function Main()
		{
			if (stage) { this.init(); }
			else { this.addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init():void
		{
		    someFunction(stage);
		}
	}
}
