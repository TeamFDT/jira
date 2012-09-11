package com.as3dmod.util {
	public class XMath {
		public static const PI : Number = 3.1415;

		public static function normalize(start : Number, end : Number, val : Number) : Number {
			var range : Number = end - start;
			var normal : Number;

			if (range == 0) {
				normal = 1;
			} else {
				normal = trim(0, 1, (val - start) / end);
			}

			return normal;
		}

		public static function toRange(start : Number, end : Number, normalized : Number) : Number {
			var range : Number = end - start;
			var val : Number;

			if (range == 0) {
				val = 0;
			} else {
				val = start + (end - start) * normalized;
			}

			return val;
		}

		public static function inInRange(start : Number, end : Number, value : Number, excluding : Boolean = false) : Boolean {
			if (excluding) return value >= start && value <= end;
			else return value > start && value < end;
		}

		public static function sign(val : Number, ifZero : Number = 0) : Number {
			if (val == 0) return ifZero;
			else return (val > 0) ? 1 : -1;
		}

		public static function trim(start : Number, end : Number, value : Number) : Number {
			return Math.min(end, Math.max(start, value));
		}

		public static function wrap(start : Number, end : Number, value : Number) : Number {
			if (value < start) return value + (end - start);
			else if (value >= end) return value - (end - start);
			else return value;
		}

		public static function degToRad(deg : Number) : Number {
			return deg / 180 * Math.PI;
		}

		public static function radToDeg(rad : Number) : Number {
			return rad / Math.PI * 180;
		}

		public static function presicion(number : Number, precision : Number) : Number {
			var r : Number = Math.pow(10, precision);
			return Math.round(number * r) / r;
		}

		public static function uceil(val : Number) : Number {
			return (val < 0) ? Math.floor(val) : Math.ceil(val);
		}
	}
}
