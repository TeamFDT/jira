package triga.shapes {
	import away3d.core.base.data.Vertex;

	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public final class TrigaPlane extends Vector3D {
		static public var EPSILON : Number = .0001;
		public var a : Number, b : Number, c : Number, d : Number, abc : Number;

		public function TrigaPlane(a : Number = 0, b : Number = 0, c : Number = 0, d : Number = 0) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
		}

		public function normalizePlane() : void {
			var len : Number = 1 / Math.sqrt(a * a + b * b + c * c);
			a *= len;
			b *= len;
			c *= len;
			d *= len;
		}

		public function determinant(_x : Number, _y : Number, _z : Number) : Number {
			return ( a * _x + b * _y + c * _z - d );
		}

		public function determinantVertex(v : Vertex) : Number {
			return ( a * v.x + b * v.y + c * v.z - d );
		}

		public function determinantVector3D(v : Vector3D) : Number {
			return ( a * v.x + b * v.y + c * v.z - d );
		}

		public function isFaceCoplanar(f : TrigaFace) : Boolean {
			if ( a == f.plane.a && b == f.plane.b && c == f.plane.c && d == f.plane.d ) return true;

			if ( a == -f.plane.a && b == -f.plane.b && c == -f.plane.c && d == -f.plane.d ) return true;

			if ( isPointCoplanar(f.plane) ) return true;

			return false;
		}

		public function isPointCoplanar(p : Vector3D) : Boolean {
			var det : Number = a * p.x + b * p.y + c * p.z - d;
			return ( det >= -EPSILON && det <= EPSILON );
		}
	}
}