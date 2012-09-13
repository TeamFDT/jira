package com.kurst.data {
	import flash.text.TextField;

	/**
	 * @author karim
	 */
	public class TextFieldDataItem {
		public var txt : TextField;
		public var callback : Function;
		public var scope : Object;
		public var overFlag : Boolean;
		public var href : String;

		public function TextFieldDataItem() {
		}
	}
}
