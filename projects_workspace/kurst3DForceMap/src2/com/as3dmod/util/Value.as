package com.as3dmod.util {
	/**
	 * @author bartekd
	 */
	public class Value {
		private var _value : Number;
		private var _range : Range;

		public function Value(i : Number = 0, r : Range = null) {
			_value = i;
			_range = (r != null) ? r : new Range();
		}

		public function get isOdd() : Boolean {
			return _value % 2 == 1;
		}

		public function get isEven() : Boolean {
			return _value % 2 == 0;
		}

		public function get normalized() : Number {
			return XMath.normalize(_range.start, _range.end, _value);
		}

		public function get range() : Range {
			return _range;
		}

		public function get value() : Number {
			return _value;
		}

		public function valueOf() : Number {
			return _value;
		}

		public function toString() : String {
			return _value + " " + _range.toString();
		}

		public function setRange(nr : Range, interpolateValue : Boolean = false) : void {
			if (interpolateValue) _value = XMath.toRange(nr.start, nr.end, normalized);
			_range = nr;
		}

		public function trim() : void {
			_value = XMath.trim(_range.start, _range.end, _value);
		}

		public function inRange(r : Range = null) : Boolean {
			if (r == null) r = _range;
			return _range.isIn(_value);
		}

		public function isFirst() : Boolean {
			return _value == _range.start;
		}

		public function isLast() : Boolean {
			return _value == _range.end;
		}

		public function isPolar() : Boolean {
			return isFirst() || isLast();
		}

		public function set value(value : Number) : void {
			_value = value;
		}

		public function set range(range : Range) : void {
			_range = range;
		}
	}
}
