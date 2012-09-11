package com.as3dmod.core {
	import com.as3dmod3.IMeshInfo;
	import com.as3dmod3.util.ModConstant;

	/**
	 * @author bartekd
	 */
	public class MeshProxy implements IMeshInfo {
		protected var vertices : Array;
		protected var faces : Array;
		protected var _maxX : Number;
		protected var _maxY : Number;
		protected var _maxZ : Number;
		protected var _minX : Number;
		protected var _minY : Number;
		protected var _minZ : Number;
		protected var _maxAxis : int;
		protected var _midAxis : int;
		protected var _minAxis : int;
		protected var _width : Number;
		protected var _height : Number;
		protected var _depth : Number;

		public function MeshProxy() {
			vertices = new Array();
			faces = new Array()
		}

		public function setMesh(mesh : *) : void {
		}

		public function updateMeshPosition(p : Vector3) : void {
		}

		public function getVertices() : Array {
			return vertices;
		}

		public function getFaces() : Array {
			return faces;
		}

		public function analyzeGeometry() : void {
			var vc : int = getVertices().length;
			var i : int;
			var v : VertexProxy;

			for (i = 0; i < vc; i++) {
				v = getVertices()[i] as VertexProxy;

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

			_width = _maxX - _minX;
			_height = _maxY - _minY;
			_depth = _maxZ - _minZ;

			var maxe : Number = Math.max(_width, Math.max(_height, _depth));
			var mine : Number = Math.min(_width, Math.min(_height, _depth));

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

		public function resetGeometry() : void {
			var vc : int = getVertices().length;
			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = getVertices()[i] as VertexProxy;
				v.reset();
			}
		}

		public function collapseGeometry() : void {
			var vc : int = getVertices().length;
			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = getVertices()[i] as VertexProxy;
				v.collapse();
			}
			analyzeGeometry();
		}

		public function get minX() : Number {
			return _minX;
		}

		public function get minY() : Number {
			return _minY;
		}

		public function get minZ() : Number {
			return _minZ;
		}

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

		public function get maxX() : Number {
			return _maxX;
		}

		public function get maxY() : Number {
			return _maxY;
		}

		public function get maxZ() : Number {
			return _maxZ;
		}

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

		public function get maxAxis() : int {
			return _maxAxis;
		}

		public function get midAxis() : int {
			return _midAxis;
		}

		public function get minAxis() : int {
			return _minAxis;
		}

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

		public function get width() : Number {
			return _width;
		}

		public function get height() : Number {
			return _height;
		}

		public function get depth() : Number {
			return _depth;
		}

		public function postApply() : void {
		}
	}
}