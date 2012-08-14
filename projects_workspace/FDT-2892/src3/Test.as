package {
	import flash.display.Sprite;

	/**
	 * @author OSX
	 */
	public class Test extends Sprite {
		public var zippy : Object;
		public var zippy1 : Object;
		[inject]
		public var zippy2 : Object;

		public function Test() {
		}

		[postconstruct]
		public function Test2() {
			
		}

		public function Test3() {
		}
	}
}
