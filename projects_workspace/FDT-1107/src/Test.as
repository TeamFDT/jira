package {
	public class Test {
		private var _onMetaData : Function;

		public function get onMetaData() : Function {
			return _onMetaData;
		}

		private function test() : void {
			onMetaData(someArgument);
		}
	}
}

