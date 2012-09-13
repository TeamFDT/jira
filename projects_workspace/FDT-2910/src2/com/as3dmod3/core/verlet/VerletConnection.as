package com.as3dmod3.core.verlet {
	/** Соединение двух вершин.*/
	public class VerletConnection {
		private var _v1 : VerletVertex;
		private var _v2 : VerletVertex;
		private var _strictDistance : Number;
		private var _rigidity : Number = .5;

		/**
		 * Создает новый экземпляр класса VerletConnection.
		 * @param	v1			первая вершина соединения.
		 * @param	v2			вторая вершина соединения.
		 * @param	distance	расстояние между двумя вершинами.
		 * @param	rigidity	жесткость соединения.
		 */
		public function VerletConnection(v1 : VerletVertex, v2 : VerletVertex, distance : Number, rigidity : Number = 0.5) {
			_v1 = v1;
			_v2 = v2;
			_strictDistance = distance;
			_rigidity = rigidity;
		}

		/** Жесткость соединения. */
		public function get rigidity() : Number {
			return _rigidity;
		}

		public function set rigidity(value : Number) : void {
			_rigidity = value;
		}

		/** Обновляет соединение. */
		public function update() : void {
			var x1 : Number = _v1.x,
			x2 : Number = _v2.x,
			y1 : Number = _v1.y,
			y2 : Number = _v2.y,
			z1 : Number = _v1.z,
			z2 : Number = _v2.z,
			dirX : Number = x2 - x1,
			dirY : Number = y2 - y1,
			dirZ : Number = z2 - z1;
			var dist : Number = Math.sqrt(dirX * dirX + dirY * dirY + dirZ * dirZ);
			var ratio : Number,
			diffX : Number,
			diffY : Number,
			diffZ : Number;

			if (dist == _strictDistance) return;

			ratio = (_strictDistance - dist) / dist * _rigidity;

			diffX = ratio * dirX;
			diffY = ratio * dirY;
			diffZ = ratio * dirZ;

			if (!_v1.mobileX || !_v2.mobileX) diffX *= 2;
			if (!_v1.mobileY || !_v2.mobileY) diffY *= 2;
			if (!_v1.mobileZ || !_v2.mobileZ) diffZ *= 2;

			if (_v1.mobileX) _v1.x -= diffX;
			if (_v1.mobileY) _v1.y -= diffY;
			if (_v1.mobileZ) _v1.z -= diffZ;
			if (_v2.mobileX) _v2.x += diffX;
			if (_v2.mobileY) _v2.y += diffY;
			if (_v2.mobileZ) _v2.z += diffZ;
		}
	}
}