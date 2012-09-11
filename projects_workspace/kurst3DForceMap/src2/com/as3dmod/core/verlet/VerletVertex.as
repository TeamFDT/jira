package com.as3dmod.core.verlet {
	import com.as3dmod3.core.VertexProxy;

	public class VerletVertex {
		private var _v : VertexProxy;
		private var _x : Number;
		private var _y : Number;
		private var _z : Number;
		private var _oldX : Number;
		private var _oldY : Number;
		private var _oldZ : Number;
		public var mobileX : Boolean = true;
		public var mobileY : Boolean = true;
		public var mobileZ : Boolean = true;

		public function VerletVertex(vertexProxy : VertexProxy) {
			_v = vertexProxy;
			setPosition(_v.x, _v.y, _v.z);
		}

		public function setPosition(x : Number, y : Number, z : Number) : void {
			_x = _oldX = x;
			_y = _oldY = y;
			_z = _oldZ = z;

			_v.x = x;
			_v.y = y;
			_v.z = z;
		}

		public function update() : void {
			var oldX : Number,
			oldY : Number,
			oldZ : Number;

			if (mobileX) {
				oldX = x;
				x += velocityX;
				_oldX = oldX;
			}
			if (mobileY) {
				oldY = y;
				y += velocityY;
				_oldY = oldY;
			}
			if (mobileZ) {
				oldZ = z;
				z += velocityZ;
				_oldZ = oldZ;
			}
		}

		public function get x() : Number {
			return _x;
		}

		public function set x(value : Number) : void {
			_x = value;
			if (!mobileX) _oldX = value;
			_v.x = value;
		}

		public function get y() : Number {
			return _y;
		}

		public function set y(value : Number) : void {
			_y = value;
			if (!mobileY) _oldY = value;
			_v.y = value;
		}

		public function get z() : Number {
			return _z;
		}

		public function set z(value : Number) : void {
			_z = value;
			if (!mobileZ) _oldZ = value;
			_v.z = value;
		}

		public function get velocityX() : Number {
			return _x - _oldX;
		}

		public function set velocityX(value : Number) : void {
			_oldX = _x - value;
		}

		public function get velocityY() : Number {
			return _y - _oldY;
		}

		public function set velocityY(value : Number) : void {
			_oldY = _y - value;
		}

		public function get velocityZ() : Number {
			return _z - _oldZ;
		}

		public function set velocityZ(value : Number) : void {
			_oldZ = _z - value;
		}

		public function distanceTo(v : VerletVertex) : Number {
			return Math.sqrt((x - v.x) * (x - v.x) + (y - v.y) * (y - v.y) + (z - v.z) * (z - v.z));
		}
	}
}