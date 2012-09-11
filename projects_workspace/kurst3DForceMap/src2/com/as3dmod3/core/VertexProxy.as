package com.as3dmod3.core {
	import com.as3dmod3.util.ModConstant;

	/**
	 * Класс VertexProxy является базовым классом для всех классов, представляющих из
	 * себя вершину меша какого-то отдельного 3D-движка. Для каждого 3D-движка, должен 
	 * быть создан подкласс этого класса со своей реализацией некоторых методов, характерных
	 * для этого 3D-движка.
	 */
	public class VertexProxy {
		/** Cоотношение координаты вершины по оси X к размеру меша по оси X. */
		private var _ratioX : Number;
		/** Cоотношение координаты вершины по оси Y к размеру меша по оси Y. */
		private var _ratioY : Number;
		/** Cоотношение координаты вершины по оси Z к размеру меша по оси Z. */
		private var _ratioZ : Number;
		/** Исходная координата вершины по оси X. @private */
		protected var ox : Number;
		/** Исходная координата вершины по оси Y. @private */
		protected var oy : Number;
		/** Исходная координата вершины по оси Z. @private */
		protected var oz : Number;

		/** Создает новый экземпляр класса VertexProxy.*/
		public function VertexProxy() {
		}

		/**
		 * Копирует значения из переданного объекта в текущий.
		 * @param	vertex	объект, содержащий координаты вершины.
		 */
		public function setVertex(vertex : *) : void {
		}

		/**
		 * Устанавливает значения соотношения координат вершины к размерам меша по каждой из оси координат.
		 * @param	rx	соотношение координаты вершины по оси X к размеру меша по оси X.
		 * @param	ry	соотношение координаты вершины по оси Y к размеру меша по оси Y.
		 * @param	rz	соотношение координаты вершины по оси Z к размеру меша по оси Z.
		 */
		public function setRatios(rx : Number, ry : Number, rz : Number) : void {
			_ratioX = rx;
			_ratioY = ry;
			_ratioZ = rz;
		}

		/**
		 * Устанавливает исходные координаты вершины.
		 * @param	ox	исходная координата вершины по оси X.
		 * @param	oy	исходная координата вершины по оси Y.
		 * @param	oz	исходная координата вершины по оси Z.
		 */
		public function setOriginalPosition(ox : Number, oy : Number, oz : Number) : void {
			this.ox = ox;
			this.oy = oy;
			this.oz = oz;
		}

		/** Текущая координата вершины по оси X. */
		public function get x() : Number {
			return 0;
		}

		public function set x(v : Number) : void {
		}

		/** Текущая координата вершины по оси Y. */
		public function get y() : Number {
			return 0;
		}

		public function set y(v : Number) : void {
		}

		/** Текущая координата вершины по оси Z. */
		public function get z() : Number {
			return 0;
		}

		public function set z(v : Number) : void {
		}

		/**
		 * Возвращает текущую координату вершины по указанной оси.
		 * @param	axis	название оси координат.
		 * @return			текущая координата вершины по указанной оси.
		 */
		public function getValue(axis : int) : Number {
			switch(axis) {
				case ModConstant.X:
					return x;
				case ModConstant.Y:
					return y;
				case ModConstant.Z:
					return z;
			}
			return 0;
		}

		/**
		 * Перезаписывает текущую координату вершины по указанной оси. 
		 * @param	axis	название оси координат.
		 * @param	v		новая текущая координата вершины по указанной оси.
		 */
		public function setValue(axis : int, v : Number) : void {
			switch(axis) {
				case ModConstant.X:
					x = v;
					break;
				case ModConstant.Y:
					y = v;
					break;
				case ModConstant.Z:
					z = v;
					break;
			}
		}

		/** Соотношение координаты вершины по оси X к размеру меша по оси X. Значение лежит в диапазоне от 0 до 1. */
		public function get ratioX() : Number {
			return _ratioX;
		}

		/** Соотношение координаты вершины по оси Y к размеру меша по оси Y. Значение лежит в диапазоне от 0 до 1. */
		public function get ratioY() : Number {
			return _ratioY;
		}

		/** Соотношение координаты вершины по оси Z к размеру меша по оси Z. Значение лежит в диапазоне от 0 до 1. */
		public function get ratioZ() : Number {
			return _ratioZ;
		}

		/**
		 * Возвращает соотношение координаты вершины к размеру меша по указанной оси.
		 * @param	axis	название оси координат.
		 * @return			соотношение координаты вершины к размеру меша по указанной оси. Значение лежит в диапазоне от 0 до 1.
		 */
		public function getRatio(axis : int) : Number {
			switch(axis) {
				case ModConstant.X:
					return _ratioX;
				case ModConstant.Y:
					return _ratioY;
				case ModConstant.Z:
					return _ratioZ;
			}
			return -1;
		}

		/** Исходная координата вершины по оси X. */
		public function get originalX() : Number {
			return ox;
		}

		/** Исходная координата вершины по оси Y. */
		public function get originalY() : Number {
			return oy;
		}

		/** Исходная координата вершины по оси Z. */
		public function get originalZ() : Number {
			return oz;
		}

		/**
		 * Возвращает исходную координату вершины по указанной оси.
		 * @param	axis	название оси координат.
		 * @return			исходная координата вершины по указанной оси.
		 */
		public function getOriginalValue(axis : int) : Number {
			switch(axis) {
				case ModConstant.X:
					return ox;
				case ModConstant.Y:
					return oy;
				case ModConstant.Z:
					return oz;
			}
			return 0;
		}

		/** Сбрасывает текущие координаты вершины на исходные. */
		public function reset() : void {
			x = ox;
			y = oy;
			z = oz;
		}

		/** Перезаписывает исходные координаты вершины текущими координатами. */
		public function collapse() : void {
			ox = x;
			oy = y;
			oz = z;
		}

		/** Вектор с текущими координатами вершины. */
		public function get vector() : Vector3 {
			return new Vector3(x, y, z);
		}

		public function set vector(v : Vector3) : void {
			x = v.x;
			y = v.y;
			z = v.z;
		}

		/** Вектор с значениями соотношения координат вершины к размерам меша по каждой из оси координат. */
		public function get ratioVector() : Vector3 {
			return new Vector3(ratioX, ratioY, ratioZ);
		}
	}
}