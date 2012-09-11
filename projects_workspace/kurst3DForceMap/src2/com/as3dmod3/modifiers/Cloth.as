package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.FaceProxy;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.core.verlet.VerletConnection;
	import com.as3dmod3.core.verlet.VerletVertex;
	import com.as3dmod3.util.ModConstant;

	import flash.utils.Dictionary;

	/**
	 * <b>Модификатор Cloth.</b> Анимирует вершины 3D меша таким образом, что создается ощущение что он сделан из ткани.
	 * <br>
	 * <br>Внешние силы могут быть применены вдоль 3 осей, для создания таких эффектов как ветер или гравитация.
	 * Грани меша могут быть заблокированы, для того чтобы зафиксировать их позицию в пространстве. Также могут быть указаны
	 * границы ткани, для того чтобы иметь возможность складывать ткань так, как будто она лежит на полу или ударяется об стену.
	 * <br>Все координаты задаются в локальном пространстве меша!
	 * <br>
	 * <br>Лучше всего использовать модификатор с мешами, имеющих плоские грани, такие как плоскости или боксы.
	 * <br>
	 * <br>Модификатор Cloth, должен быть самым первым в стеке модификаторов.
	 * 
	 * @author David Lenaerts
	 */
	public class Cloth extends Modifier implements IModifier {
		private var _vertices : Vector.<VerletVertex>;
		private var _connections : Vector.<VerletConnection>;
		private var _forceX : Number = 0;
		private var _forceY : Number = 0;
		private var _forceZ : Number = 0;
		private var _rigidity : Number;
		private var _friction : Number;
		private var _lookUp : Dictionary;
		private var _useBounds : Boolean;
		private var _boundsMinX : Number;
		private var _boundsMaxX : Number;
		private var _boundsMinY : Number;
		private var _boundsMaxY : Number;
		private var _boundsMinZ : Number;
		private var _boundsMaxZ : Number;

		/**
		 * Создает новый экземпляр класса Cloth.
		 * @param rigidity жесткость ткани. Меньшие значения делают ткань более растягиваемой и более упругой. Значение должно лежать в диапазоне от 0 до 1.
		 * @param friction значение трения воздуха, поступающего на ткань.
		 */
		public function Cloth(rigidity : Number = 1, friction : Number = 0) {
			super();
			_lookUp = new Dictionary(true);
			_rigidity = rigidity;
			this.friction = friction;
		}

		/**
		 * Определяет границы бокса, в котором должна находится ткань. Эта возможность может быть использована для имитации пола и/или стен. Координаты задаются в пространстве меша.
		 * @param minX левая стенка ограничивающего бокса.
		 * @param maxX правая стенка ограничивающего бокса.
		 * @param minY нижняя стенка ограничивающего бокса.
		 * @param maxY верхняя стенка ограничивающего бокса.
		 * @param minZ ближняя стенка ограничивающего бокса.
		 * @param maxZ дальняя стенка ограничивающего бокса.
		 */
		public function setBounds(minX : Number = Number.NEGATIVE_INFINITY, maxX : Number = Number.POSITIVE_INFINITY, minY : Number = Number.NEGATIVE_INFINITY, maxY : Number = Number.POSITIVE_INFINITY, minZ : Number = Number.NEGATIVE_INFINITY, maxZ : Number = Number.POSITIVE_INFINITY) : void {
			_useBounds = true;
			_boundsMinX = minX;
			_boundsMaxX = maxX;
			_boundsMinY = minY;
			_boundsMaxY = maxY;
			_boundsMinZ = minZ;
			_boundsMaxZ = maxZ;
		}

		/** Удаляет все границы. */
		public function clearBounds() : void {
			_useBounds = false;
		}

		/** Вершины, используемые для расчета анимации. Они отличаются от обычных вершин тем, что они учитывают также скорость. */
		public function get verletVertices() : Vector.<VerletVertex> {
			return _vertices;
		}

		/** Значение трения воздуха, поступающего на ткань. */
		public function get friction() : Number {
			return (_friction - 1) * 100;
		}

		public function set friction(value : Number) : void {
			if (value < 0) value = 0;
			_friction = value / 100 + 1;
		}

		/** Жесткость ткани. Меньшие значения делают ткань более растягиваемой и более упругой. Значение должно лежать в диапазоне от 0 до 1. */
		public function get rigidity() : Number {
			return _rigidity;
		}

		public function set rigidity(value : Number) : void {
			var half : Number;
			var vl : int = _connections.length;

			if (value > 1) value = 1;
			else if (value < 0) value = 0;

			_rigidity = value;
			half = value * .5;

			for (var i : int = 0; i < vl; i++) {
				_connections[i].rigidity = half;
			}
		}

		/**
		 * Определяет значения действия внешних сил на вершины вдоль каждой их трех осей.
		 * Может быть использовано для имитации природных эффектов, таких как гравитация или ветер.
		 * 
		 * @param x значение действия силы вдоль оси X.
		 * @param y значение действия силы вдоль оси Y.
		 * @param z значение действия силы вдоль оси Z.
		 */
		public function setForce(x : Number, y : Number, z : Number) : void {
			_forceX = x;
			_forceY = y;
			_forceZ = z;
		}

		/**
		 * Значение действия внешних сил на вершины вдоль оси X.
		 * Может быть использовано для имитации природных эффектов, таких как, например, ветер.
		 */
		public function get forceX() : Number {
			return _forceX;
		}

		public function set forceX(value : Number) : void {
			_forceX = value;
		}

		/**
		 * Значение действия внешних сил на вершины вдоль оси Y.
		 * Может быть использовано для имитации природных эффектов, таких как, например, гравитация.
		 */
		public function get forceY() : Number {
			return _forceY;
		}

		public function set forceY(value : Number) : void {
			_forceY = value;
		}

		/**
		 * Значение действия внешних сил на вершины вдоль оси Z.
		 * Может быть использовано для имитации природных эффектов, таких как, например, ветер.
		 */
		public function get forceZ() : Number {
			return _forceZ;
		}

		public function set forceZ(value : Number) : void {
			_forceZ = value;
		}

		/** Разблокировывает все вершины модификатора Cloth, делая их опять подвижными. */
		public function unlockAll() : void {
			var v : VerletVertex;
			var vl : int = _vertices.length;

			for (var i : int = 0; i < vl; i++) {
				v = _vertices[i];
				v.mobileX = true;
				v.mobileY = true;
				v.mobileZ = true;
			}
		}

		/**
		 * Блокирует все вершины меша, начиная от левой границы меша до указанной границы, ограничивая их перемещение вдоль указанных осей.
		 * @param tolerance максимальное расстояние до границы, до которой вершины будут заблокированы.
		 * @param axes 		оси, вдоль которых движение ограничено. Если не указаны, не допускается никакого движения.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockXMin(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.minX, "x", tolerance, axes);
		}

		/**
		 * Блокирует все вершины меша, начиная от правой границы меша до указанной границы, ограничивая их перемещение вдоль указанных осей.
		 * @param tolerance максимальное расстояние до границы, до которой вершины будут заблокированы.
		 * @param axes 		оси, вдоль которых движение ограничено. Если не указаны, не допускается никакого движения.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockXMax(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.maxX, "x", tolerance, axes);
		}

		/**
		 * Блокирует все вершины меша, начиная от нижней границы меша до указанной границы, ограничивая их перемещение вдоль указанных осей.
		 * @param tolerance максимальное расстояние до границы, до которой вершины будут заблокированы.
		 * @param axes 		оси, вдоль которых движение ограничено. Если не указаны, не допускается никакого движения.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockYMin(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.minY, "y", tolerance, axes);
		}

		/**
		 * Блокирует все вершины меша, начиная от верхней границы меша до указанной границы, ограничивая их перемещение вдоль указанных осей.
		 * @param tolerance максимальное расстояние до границы, до которой вершины будут заблокированы.
		 * @param axes 		оси, вдоль которых движение ограничено. Если не указаны, не допускается никакого движения.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockYMax(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.maxY, "y", tolerance, axes);
		}

		/**
		 * Блокирует все вершины меша, начиная от ближней границы меша до указанной границы, ограничивая их перемещение вдоль указанных осей.
		 * @param tolerance максимальное расстояние до границы, до которой вершины будут заблокированы.
		 * @param axes 		оси, вдоль которых движение ограничено. Если не указаны, не допускается никакого движения.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockZMin(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.minZ, "z", tolerance, axes);
		}

		/**
		 * Блокирует все вершины меша, начиная от дальней границы меша до указанной границы, ограничивая их перемещение вдоль указанных осей.
		 * @param tolerance максимальное расстояние до границы, до которой вершины будут заблокированы.
		 * @param axes 		оси, вдоль которых движение ограничено. Если не указаны, не допускается никакого движения.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockZMax(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.maxZ, "z", tolerance, axes);
		}

		private function lockSet(reference : Number, property : String, tolerance : Number = 0, axes : int = 7) : void {
			var v : VerletVertex;
			var vl : int = _vertices.length;

			for (var i : int = 0; i < vl; i++) {
				v = _vertices[i];
				if (Math.abs(v[property] - reference) <= tolerance) {
					if (axes & ModConstant.X) v.mobileX = false;
					if (axes & ModConstant.Y) v.mobileY = false;
					if (axes & ModConstant.Z) v.mobileZ = false;
				}
			}
		}

		/** @inheritDoc */
		override public function setModifiable(mod : MeshProxy) : void {
			super.setModifiable(mod);

			initVerletVertices();
			initVerletConnections();
			rigidity = _rigidity;
		}

		/** @inheritDoc */
		public function apply() : void {
			var i : int;
			var c : VerletConnection;
			var v : VerletVertex;

			var vl : int = _connections.length;
			for (i = 0; i < vl; i++) _connections[i].update();

			vl = _vertices.length;

			for (i = 0; i < vl; i++) {
				v = _vertices[i];
				if (v.mobileX) v.x += _forceX;
				if (v.mobileY) v.y += _forceY;
				if (v.mobileZ) v.z += _forceZ;

				v.velocityX /= _friction;
				v.velocityY /= _friction;
				v.velocityZ /= _friction;

				if (_useBounds) {
					if (v.x < _boundsMinX) v.x = _boundsMinX;
					else if (v.x > _boundsMaxX) v.x = _boundsMaxX;
					if (v.y < _boundsMinY) v.y = _boundsMinY;
					else if (v.y > _boundsMaxY) v.y = _boundsMaxY;
					if (v.z < _boundsMinZ) v.z = _boundsMinZ;
					else if (v.z > _boundsMaxZ) v.z = _boundsMaxZ;
				}

				v.update();
			}
		}

		/** Инициализирует вершины. */
		private function initVerletVertices() : void {
			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;
			var v : VertexProxy;
			var vv : VerletVertex;

			_vertices = new Vector.<VerletVertex>();

			for (var i : int = 0; i < vc; i++) {
				v = vs[i];
				vv = new VerletVertex(v);
				_vertices.push(vv);
				_lookUp[v] = vv;
			}
		}

		/** Инициализирует соединения. */
		private function initVerletConnections() : void {
			var ts : Vector.<FaceProxy> = mod.getFaces();
			var t : FaceProxy;
			var tc : int = ts.length;
			var faceVertices : Vector.<VertexProxy>;
			var numVertices : Number;

			_connections = new Vector.<VerletConnection>();

			for (var i : int = 0; i < tc; i++) {
				t = ts[i];
				faceVertices = t.vertices;
				numVertices = faceVertices.length;

				for (var j : int = 0; j < numVertices - 1; j++) {
					createConnection(_lookUp[faceVertices[j]], _lookUp[faceVertices[j + 1]]);
					if (j > 1) createConnection(_lookUp[faceVertices[0]], _lookUp[faceVertices[j]]);
				}

				createConnection(_lookUp[faceVertices[numVertices - 1]], _lookUp[faceVertices[0]]);
			}
		}

		/**
		 * Создает соединение.
		 * @param	v1	первая вершина соединения.
		 * @param	v2	вторая вершина соединения.
		 */
		private function createConnection(v1 : VerletVertex, v2 : VerletVertex) : void {
			var dist : Number = v1.distanceTo(v2);
			var connection : VerletConnection = new VerletConnection(v1, v2, dist, _rigidity);

			_connections.push(connection);
		}
	}
}