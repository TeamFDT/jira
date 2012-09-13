package triga.maths.shapes {
	import flash.geom.Vector3D;

	import triga.maths.utils.PlaneUtils;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Triangle {
		static public var pq : Vector3D = new Vector3D();
		static public var pr : Vector3D = new Vector3D();
		public var plane : Plane;
		public var v0 : Vector3D, v1 : Vector3D, v2 : Vector3D, _centroid : Vector3D;
		public var indices : Vector3D = new Vector3D();

		public function Triangle(v0 : Vector3D, v1 : Vector3D, v2 : Vector3D) {
			this.v0 = v0;
			this.v1 = v1;
			this.v2 = v2;

			plane = PlaneUtils.computeFromVector3D(v0, v1, v2);
		}

		static public function fromVertexBuffer(buffer : Vector.<Number>, i0 : uint, i1 : uint, i2 : uint) : Triangle {
			var t : Triangle = new Triangle(new Vector3D(buffer[ i0 * 3 ], buffer[ i0 * 3 + 1 ], buffer[ i0 * 3 + 2 ]), new Vector3D(buffer[ i1 * 3 ], buffer[ i1 * 3 + 1 ], buffer[ i1 * 3 + 2 ]), new Vector3D(buffer[ i2 * 3 ], buffer[ i2 * 3 + 1 ], buffer[ i2 * 3 + 2 ]));
			t.indices = new Vector3D(i0, i1, i2);
			return t;
		}

		public function flip() : void {
			var i0 : uint = indices.x;
			indices.x = indices.y;
			indices.y = i0;
			var v : Vector3D = v0.clone();
			v0 = v1;
			v1 = v;
		}

		public function isFacing(v : Vector3D) : Boolean {
			return plane.determinant(v.x, v.y, v.z) > 0;
		}

		public function isCoplanar(t : Triangle) : Boolean {
			return plane.isCoplanar(t.plane);
		}

		public function isPointCoplanar(p : Vector3D) : Boolean {
			return plane.isPointCoplanar(p);
		}

		public function get centroid() : Vector3D {
			_centroid = new Vector3D(( v0.x + v1.x + v2.x ) / 3, ( v0.y + v1.y + v2.y ) / 3, ( v0.z + v1.z + v2.z ) / 3);
			return _centroid;
		}

		public function equals(t : Triangle) : Boolean {
			return ( v0.equals(t.v0) && v1.equals(t.v1) && v2.equals(t.v2) );
		}

		public function isPairOrEqual(t : Triangle) : Boolean {
			if ( 		( v0.equals(t.v0) && v1.equals(t.v1) && v2.equals(t.v2) ) || ( v0.equals(t.v1) && v1.equals(t.v2) && v2.equals(t.v0) ) || ( v0.equals(t.v2) && v1.equals(t.v0) && v2.equals(t.v1) )	) return true;

			if ( 		( v0.equals(t.v0) && v1.equals(t.v2) && v2.equals(t.v1) ) || ( v0.equals(t.v2) && v1.equals(t.v1) && v2.equals(t.v0) ) || ( v0.equals(t.v1) && v1.equals(t.v0) && v2.equals(t.v2) )	) return true;

			return false;
		}

		static public function pointInTriangle(v : Vector3D, triangle : Triangle) : Boolean {
			var a : Number = doubleArea(v, triangle.v0, triangle.v1);
			var b : Number = doubleArea(v, triangle.v1, triangle.v2);
			var c : Number = doubleArea(v, triangle.v2, triangle.v0);
			var d : Number = doubleArea(triangle.v0, triangle.v1, triangle.v2);

			var e : Number = ( a + b + c ) / d;
			if ( e > .999 && e <= 1.0001 ) return true
			else return false;
		}

		static public function doubleArea(v0 : Vector3D, v1 : Vector3D, v2 : Vector3D) : Number {
			pq = v1.subtract(v0);
			pr = v2.subtract(v0);
			return pq.crossProduct(pr).length;
		}

		static public function area(v0 : Vector3D, v1 : Vector3D, v2 : Vector3D) : Number {
			return .5 * doubleArea(v0, v1, v2);
		}
	}
}