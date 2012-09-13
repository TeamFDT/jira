package triga.shapes {
	import away3d.core.base.data.Face;
	import away3d.core.base.data.Vertex;
	import away3d.core.math.Plane3D;
	import away3d.core.math.PlaneClassification;

	import flash.geom.Vector3D;

	import triga.utils.PlaneUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	final public class TrigaFace extends Face {
		public var plane : TrigaPlane;
		private var _centroid : Vector3D;
		public var i0 : uint, i1 : uint, i2 : uint;
		public var _vertices : Vector.<Number>;
		public var _v0 : Vector3D, _v1 : Vector3D, _v2 : Vector3D;

		public function TrigaFace(vertices : Vector.<Number>, i0 : uint, i1 : uint, i2 : uint) {
			this.i0 = i0;
			this.i1 = i1;
			this.i2 = i2;

			super(Vector.<Number>([vertices[ i0 * 3 ], vertices[ i0 * 3 + 1 ], vertices[ i0 * 3 + 2 ], vertices[ i1 * 3 ], vertices[ i1 * 3 + 1 ], vertices[ i1 * 3 + 2 ], vertices[ i2 * 3 ], vertices[ i2 * 3 + 1 ], vertices[ i2 * 3 + 2 ]]), null);

			plane = PlaneUtils.compute(v0x, v0y, v0z, v1x, v1y, v1z, v2x, v2y, v2z);
		}

		public function buildVector3D() : void {
			_v0 = new Vector3D(v0x, v0y, v0z);
			_v1 = new Vector3D(v1x, v1y, v1z);
			_v2 = new Vector3D(v2x, v2y, v2z);
		}

		public function isFacing(v : Vector3D) : Boolean {
			return plane.determinantVector3D(v) > 0;
		}

		public function isFaceCoplanar(f : TrigaFace) : Boolean {
			return plane.isFaceCoplanar(f);
		}

		public function isPointCoplanar(p : Vector3D) : Boolean {
			return plane.isPointCoplanar(p);
		}

		public function flip(uv : Vector.<Number> = null) : TrigaFace {
			var i : uint = i0;
			i0 = i1;
			i1 = i;
			if ( uv != null ) {
				var u : Number = uv[0];
				var v : Number = uv[1];
				uv[0] = uv[2];
				uv[1] = uv[3];
				uv[2] = u;
				uv[3] = v;
			}
			return this;
		}

		public function get centroid() : Vector3D {
			if ( _centroid == null ) {
				_centroid = new Vector3D(( v0x + v1x + v2x ) / 3, ( v0y + v1y + v2y ) / 3, ( v0z + v1z + v2z ) / 3);
			}
			return _centroid;
		}

		public function equals(f : TrigaFace) : Boolean {
			return ( ( i0 == f.i0 && i1 == f.i1 && i2 == f.i2 )	);
		}

		public function isPairOrEqual(f : TrigaFace) : Boolean {
			if ( 		( i0 == f.i0 && i1 == f.i1 && i2 == f.i2 ) || ( i0 == f.i1 && i1 == f.i2 && i2 == f.i0 ) || ( i0 == f.i2 && i1 == f.i0 && i2 == f.i1 )	) return true;

			if ( 		( i0 == f.i0 && i1 == f.i2 && i2 == f.i1 ) || ( i0 == f.i2 && i1 == f.i1 && i2 == f.i0 ) || ( i0 == f.i1 && i1 == f.i0 && i2 == f.i2 )	) return true;

			return false;
		}

		public function shareEdge(f : TrigaFace) : Array {
			if ( i0 == f.i0 && i1 == f.i1 ) return [i0, i1];
			if ( i0 == f.i0 && i1 == f.i2 ) return [i0, i1];

			if ( i0 == f.i1 && i1 == f.i0 ) return [i0, i1];
			if ( i0 == f.i1 && i1 == f.i2 ) return [i0, i1];

			if ( i0 == f.i2 && i1 == f.i1 ) return [i0, i1];
			if ( i0 == f.i2 && i1 == f.i0 ) return [i0, i1];

			if ( i1 == f.i0 && i2 == f.i1 ) return [i1, i2];
			if ( i1 == f.i0 && i2 == f.i2 ) return [i1, i2];

			if ( i1 == f.i1 && i2 == f.i0 ) return [i1, i2];
			if ( i1 == f.i1 && i2 == f.i2 ) return [i1, i2];

			if ( i1 == f.i2 && i2 == f.i1 ) return [i1, i2];
			if ( i1 == f.i2 && i2 == f.i0 ) return [i1, i2];

			if ( i2 == f.i0 && i0 == f.i1 ) return [i2, i0];
			if ( i2 == f.i0 && i0 == f.i2 ) return [i2, i0];

			if ( i2 == f.i1 && i0 == f.i0 ) return [i2, i0];
			if ( i2 == f.i1 && i0 == f.i2 ) return [i2, i0];

			if ( i2 == f.i2 && i0 == f.i1 ) return [i2, i0];
			if ( i2 == f.i2 && i0 == f.i0 ) return [i2, i0];

			return null;
		}
	}
}