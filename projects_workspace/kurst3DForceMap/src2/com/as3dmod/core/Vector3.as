package com.as3dmod.core {
	/**
	 * Based on C++ example in "3D Math Primer", Chapter 6.
	 * 
	 * @author bartekd
	 */
	public final class Vector3 {
		public var x : Number;
		public var y : Number;
		public var z : Number;
		public static var ZERO : Vector3 = new Vector3(0, 0, 0);

		public function Vector3(x : Number, y : Number, z : Number) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

		/**
		 *  Member functions
		 */
		public function clone() : Vector3 {
			return new Vector3(x, y, z);
		}

		public function equals(v : Vector3) : Boolean {
			return x == v.x && y == v.y && z == v.z;
		}

		public function zero() : void {
			x = y = z = 0;
		}

		public function negate() : Vector3 {
			return new Vector3(-x, -y, -z);
		}

		public function add(v : Vector3) : Vector3 {
			return new Vector3(x + v.x, y + v.y, z + v.z);
		}

		public function subtract(v : Vector3) : Vector3 {
			return new Vector3(x - v.x, y - v.y, z - v.z);
		}

		public function multiplyScalar(s : Number) : Vector3 {
			return new Vector3(x * s, y * s, z * s);
		}

		public function multiply(v : Vector3) : Vector3 {
			return new Vector3(x * v.x, y * v.y, z * v.z);
		}

		public function divide(s : Number) : Vector3 {
			var os : Number = 1 / s;
			return new Vector3(x * os, y * os, z * os);
		}

		public function normalize() : void {
			var m : Number = x * x + y * y + z * z;
			if (m > 0) {
				var n : Number = 1 / Math.sqrt(m);
				x *= n;
				y *= n;
				z *= n;
			}
		}

		public function get magnitude() : Number {
			return Math.sqrt(x * x + y * y + z * z);
		}

		public function set magnitude(m : Number) : void {
			normalize();
			x *= m;
			y *= m;
			z *= m;
		}

		public function toString() : String {
			return "[" + x + " , " + y + " , " + z + "]";
		}

		/**
		 *  Static functions
		 */
		public static function sum(a : Vector3, b : Vector3) : Vector3 {
			return a.add(b);
		}

		public static function dot(a : Vector3, b : Vector3) : Number {
			return a.x * b.x + a.y * b.y + a.z * b.z;
		}

		public static function cross(a : Vector3, b : Vector3) : Vector3 {
			return new Vector3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
		}

		public static function distance(a : Vector3, b : Vector3) : Number {
			var dx : Number = a.x - b.x;
			var dy : Number = a.y - b.y;
			var dz : Number = a.z - b.z;
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
		}
	}
}






