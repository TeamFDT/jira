package com.powerflasher.profiling.iteration.item {

	/**
	 * @author mg
	 */
	public class Item {
		private var _name : String;
		public var nextItem : Item;

		public function Item(name:String) {
			_name = name;
		}
		

		public function hasNext() : Boolean {
			return nextItem != null;
		}

		public function info() : String {
			return _name;
		}
	}
}
