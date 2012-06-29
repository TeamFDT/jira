package {
	import flash.display.Sprite;

	public class Main extends Sprite {
		public function Main() {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xff0000, 1);
			s.graphics.drawRect(0, 0, 100, 100);
			s.graphics.endFill();
			addChild(s);
			
		}

		private function createArray(...args = null) : void // compiller error: syntax error: expecting rightparen before assign.
		{
		}
	}
}
