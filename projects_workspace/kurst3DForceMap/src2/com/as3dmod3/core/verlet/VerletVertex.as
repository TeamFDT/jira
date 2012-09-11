package com.as3dmod3.core.verlet {
	import com.as3dmod3.core.VertexProxy;

	/** Вершина. */
	public class VerletVertex {
		private var _v : VertexProxy;
		private var _x : Number;
		private var _y : Number;
		private var _z : Number;
		private var _oldX : Number;
		private var _oldY : Number;
		private var _oldZ : Number;
		/** Перемещение вершины по оси X разрешено? */
		public var mobileX : Boolean = true;
		/** Перемещение вершины по оси Y разрешено? */
		public var mobileY : Boolean = true;
		/** Перемещение вершины по оси Z разрешено? */
		public var mobileZ : Boolean = true;

		/**
		 * Создает новый экземпляр класса VerletVertex.
		 * @param	vertexProxy объект VertexProxy, из которого будут браться данные о координатах вершины.
		 */
		public function VerletVertex(vertexProxy : VertexProxy) {
			_v = vertexProxy;
			setPosition(_v.x, _v.y, _v.z);
		}

		/**
		 * Устанавливает новую позицию вершины.
		 * @param	x	новая позиция вершины по оси X.
		 * @param	y	новая позиция вершины по оси Y.
		 * @param	z	новая позиция вершины по оси Z.
		 */
		public function setPosition(x : Number, y : Number, z : Number) : void {
			_x = _oldX = x;
			_y = _oldY = y;
			_z = _oldZ = z;

			_v.x = x;
			_v.y = y;
			_v.z = z;
		}

		/** Обновляет вершину. */
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

		/** Позиция вершины по оси X. */
		public function get x() : Number {
			return _x;
		}

		public function set x(value : Number) : void {
			_x = value;
			if (!mobileX) _oldX = value;
			_v.x = value;
		}

		/** Позиция вершины по оси Y. */
		public function get y() : Number {
			return _y;
		}

		public function set y(value : Number) : void {
			_y = value;
			if (!mobileY) _oldY = value;
			_v.y = value;
		}

		/** Позиция вершины по оси Z. */
		public function get z() : Number {
			return _z;
		}

		public function set z(value : Number) : void {
			_z = value;
			if (!mobileZ) _oldZ = value;
			_v.z = value;
		}

		/** Скорость по оси X. */
		public function get velocityX() : Number {
			return _x - _oldX;
		}

		public function set velocityX(value : Number) : void {
			_oldX = _x - value;
		}

		/** Скорость по оси Y. */
		public function get velocityY() : Number {
			return _y - _oldY;
		}

		public function set velocityY(value : Number) : void {
			_oldY = _y - value;
		}

		/** Скорость по оси Z. */
		public function get velocityZ() : Number {
			return _z - _oldZ;
		}

		public function set velocityZ(value : Number) : void {
			_oldZ = _z - value;
		}

		/**
		 * Находит расстояние между двумя вершинами.
		 * @param	v 	вершина, расстояние до которой требуется найти.
		 * @return		расстояние между двумя вершинами.
		 */
		public function distanceTo(v : VerletVertex) : Number {
			return Math.sqrt((x - v.x) * (x - v.x) + (y - v.y) * (y - v.y) + (z - v.z) * (z - v.z));
		}
	}
}