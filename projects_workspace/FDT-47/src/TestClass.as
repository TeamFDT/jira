package {
	/**
	 * @author philipp
	 */
	public class TestClass {
		private var _someProperty : int;

		public function TestClass() {
		}

		function foo() : Bar {
			if (Math.random() > 0.5) return new Bar();
		}
	}
}
