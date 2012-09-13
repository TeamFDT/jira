package com.as3dmod.util {
	/**
	 * @author bartekd
	 */
	public class Range {
		private var _start : Number;
		private var _end : Number;

		public function Range(s : Number = 0, e : Number = 1) {
			_start = s;
			_end = e;
		}

		public function get start() : Number {
			return _start;
		}

		public function get end() : Number {
			return _end;
		}

		public function get size() : Number {
			return _end - _start;
		}

		public function move(amount : Number) : void {
			_start += amount;
			_end += amount;
		}

		public function isIn(n : Number) : Boolean {
			return n >= _start && n <= _end;
		}

		public function normalize(n : Number) : Number {
			return XMath.normalize(_start, _end, n);
		}

		public function toRange(n : Number) : Number {
			return XMath.toRange(_start, _end, n);
		}

		public function trim(n : Number) : Number {
			return XMath.trim(_start, _end, n);
		}

		public function interpolate(n : Number, r : Range) : Number {
			return toRange(r.normalize(n));
		}

		public function toString() : String {
			return "[" + start + " - " + end + "]";
		}
	}
}
