package com.as3dmod3.core {
	import com.as3dmod3.IMeshInfo;
	import com.as3dmod3.util.ModConstant;

	/**
	 * Класс MeshProxy является базовым классом для всех классов, представляющих из
	 * себя меш какого-то отдельного 3D-движка. Для каждого 3D-движка, должен 
	 * быть создан подкласс этого класса со своей реализацией некоторых методов, характерных
	 * для этого 3D-движка.
	 */
	public class MeshProxy implements IMeshInfo {
		/** Cписок вершин меша. @private */
		protected var vertices : Vector.<VertexProxy>;
		/** Cписок треугольников меша. @private */
		protected var faces : Vector.<FaceProxy>;
		/** Максимальная граница меша по оси X. @private */
		protected var _maxX : Number;
		/** Максимальная граница меша по оси Y. @private */
		protected var _maxY : Number;
		/** Максимальная граница меша по оси Z. @private */
		protected var _maxZ : Number;
		/** Минимальная граница меша по оси X. @private */
		protected var _minX : Number;
		/** Минимальная граница меша по оси Y. @private */
		protected var _minY : Number;
		/** Минимальная граница меша по оси Z. @private */
		protected var _minZ : Number;
		/** Ось координат, вдоль которой размеры меша максимальные. @private */
		protected var _maxAxis : int;
		/** Ось координат, вдоль которой размеры меша средние. @private */
		protected var _midAxis : int;
		/** Ось координат, вдоль которой размеры меша минимальные. @private */
		protected var _minAxis : int;
		/** Размеры меша по оси X. @private */
		protected var _width : Number;
		/** Размеры меша по оси Y. @private */
		protected var _height : Number;
		/** Размеры меша по оси Z. @private */
		protected var _depth : Number;

		/** Создает новый экземпляр класса MeshProxy. */
		public function MeshProxy() {
			vertices = new Vector.<VertexProxy>();
			faces = new Vector.<FaceProxy>();
		}

		/**
		 * Устанавливает меш, геометрия которого будет изменяться классами-модификаторами.
		 * @param	mesh	меш, геометрия которого будет изменяться классами-модификаторами.
		 */
		public function setMesh(mesh : *) : void {
		}

		/**
		 * Обновляет позицию меша.
		 * @param	p новая позиция меша.
		 */
		public function updateMeshPosition(p : Vector3) : void {
		}

		/**
		 * Возвращает список вершин меша. 
		 * @return	список вершин меша.
		 */
		public function getVertices() : Vector.<VertexProxy> {
			return vertices;
		}

		/**
		 * Возвращает список треугольников меша. 
		 * @return	список треугольников меша. 
		 */
		public function getFaces() : Vector.<FaceProxy> {
			return faces;
		}

		/** Анализирует геометрию меша, вычисляя некоторые значения необходимые классам-модификаторам для работы. */
		public function analyzeGeometry() : void {
			var vc : int = getVertices().length;
			var i : int;
			var v : VertexProxy;

			for (i = 0; i < vc; i++) {
				v = getVertices()[i] as VertexProxy;

				// находим минимальные и максимальные границы меша
				// по каждой из оси координат
				if (i == 0) {
					_minX = _maxX = v.x;
					_minY = _maxY = v.y;
					_minZ = _maxZ = v.z;
				} else {
					_minX = Math.min(_minX, v.x);
					_minY = Math.min(_minY, v.y);
					_minZ = Math.min(_minZ, v.z);

					_maxX = Math.max(_maxX, v.x);
					_maxY = Math.max(_maxY, v.y);
					_maxZ = Math.max(_maxZ, v.z);
				}

				v.setOriginalPosition(v.x, v.y, v.z);
			}

			// вычисляем размеры меша по каждой из оси координат
			_width = _maxX - _minX;
			_height = _maxY - _minY;
			_depth = _maxZ - _minZ;

			var maxe : Number = Math.max(_width, Math.max(_height, _depth));
			var mine : Number = Math.min(_width, Math.min(_height, _depth));

			// вычисляем по каким осям координат размеры меша
			// максимальные и минимальные.
			if (maxe == _width && mine == _height) {
				_minAxis = ModConstant.Y;
				_midAxis = ModConstant.Z;
				_maxAxis = ModConstant.X;
			} else if (maxe == _width && mine == _depth) {
				_minAxis = ModConstant.Z;
				_midAxis = ModConstant.Y;
				_maxAxis = ModConstant.X;
			} else if (maxe == _height && mine == _width) {
				_minAxis = ModConstant.X;
				_midAxis = ModConstant.Z;
				_maxAxis = ModConstant.Y;
			} else if (maxe == _height && mine == _depth) {
				_minAxis = ModConstant.Z;
				_midAxis = ModConstant.X;
				_maxAxis = ModConstant.Y;
			} else if (maxe == _depth && mine == _width) {
				_minAxis = ModConstant.X;
				_midAxis = ModConstant.Y;
				_maxAxis = ModConstant.Z;
			} else if (maxe == _depth && mine == _height) {
				_minAxis = ModConstant.Y;
				_midAxis = ModConstant.X;
				_maxAxis = ModConstant.Z;
			}

			for (i = 0; i < vc; i++) {
				v = getVertices()[i] as VertexProxy;
				v.setRatios((v.x - _minX) / _width, (v.y - _minY) / _height, (v.z - _minZ) / _depth);
			}
		}

		/** Сбрасывает текущее состояние геометрии меша на исходное, которое было до применения модификаторов. */
		public function resetGeometry() : void {
			var vc : int = getVertices().length;
			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = getVertices()[i] as VertexProxy;
				v.reset();
			}
		}

		/** Указывает, что текущее состояние геометрии меша теперь следует считать как исходное. */
		public function collapseGeometry() : void {
			var vc : int = getVertices().length;
			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = getVertices()[i] as VertexProxy;
				v.collapse();
			}
			analyzeGeometry();
		}

		/** @inheritDoc */
		public function get minX() : Number {
			return _minX;
		}

		/** @inheritDoc */
		public function get minY() : Number {
			return _minY;
		}

		/** @inheritDoc */
		public function get minZ() : Number {
			return _minZ;
		}

		/**
		 * Возвращает минимальную границу меша по указанной оси.
		 * @param	axis	название оси координат. 
		 * @return			минимальная граница меша по указанной оси.
		 */
		public function getMin(axis : int) : Number {
			switch(axis) {
				case ModConstant.X:
					return _minX;
				case ModConstant.Y:
					return _minY;
				case ModConstant.Z:
					return _minZ;
			}
			return -1;
		}

		/** @inheritDoc */
		public function get maxX() : Number {
			return _maxX;
		}

		/** @inheritDoc */
		public function get maxY() : Number {
			return _maxY;
		}

		/** @inheritDoc */
		public function get maxZ() : Number {
			return _maxZ;
		}

		/**
		 * Возвращает максимальную границу меша по указанной оси.
		 * @param	axis	название оси координат. 
		 * @return			максимальная граница меша по указанной оси.
		 */
		public function getMax(axis : int) : Number {
			switch(axis) {
				case ModConstant.X:
					return _maxX;
				case ModConstant.Y:
					return _maxY;
				case ModConstant.Z:
					return _maxZ;
			}
			return -1;
		}

		/** Ось координат, вдоль которой размеры меша максимальные. */
		public function get maxAxis() : int {
			return _maxAxis;
		}

		/** Ось координат, вдоль которой размеры меша средние. */
		public function get midAxis() : int {
			return _midAxis;
		}

		/** Ось координат, вдоль которой размеры меша минимальные. */
		public function get minAxis() : int {
			return _minAxis;
		}

		/**
		 * Возвращает размеры меша по указанной оси.
		 * @param	axis	название оси координат. 
		 * @return			размеры меша по указанной оси.
		 */
		public function getSize(axis : int) : Number {
			switch(axis) {
				case ModConstant.X:
					return _width;
				case ModConstant.Y:
					return _height;
				case ModConstant.Z:
					return _depth;
			}
			return -1;
		}

		/** @inheritDoc */
		public function get width() : Number {
			return _width;
		}

		/** @inheritDoc */
		public function get height() : Number {
			return _height;
		}

		/** @inheritDoc */
		public function get depth() : Number {
			return _depth;
		}

		/** Обновляет вершины меша. */
		public function updateVertices() : void {
		}
	}
}