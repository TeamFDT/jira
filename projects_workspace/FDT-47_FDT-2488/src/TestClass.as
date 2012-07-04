package {
	/**
	 * @author philipp
	 */
	public class TestClass {
		private var _someProperty : int;
		private var myNum : Number;

		public function TestClass() {
		}

		function foo() : Bar {
			if (Math.random() > 0.5) return new Bar();
		}
		
		public function get someProperty() : int {
			
			// fails
//			 if(myNum > .5) return 10;
			// fails
			 var myNum : Number = Math.random();
			 if(myNum > .5) return _someProperty;
			//fails
			 if (false) return 10;
			
		}
	}
}
