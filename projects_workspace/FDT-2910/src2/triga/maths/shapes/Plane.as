package triga.maths.shapes {
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Plane {
		static public var EPSILON : Number = .0001;
		public var a : Number, b : Number, c : Number, d : Number, abc : Number, sqr_abc : Number;
		private var _normal : Vector3D;

		public function Plane(a : Number = 0, b : Number = 0, c : Number = 0, d : Number = 0) {
			normal = new Vector3D(a, b, c);

			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;

			abc = a * a + b * b + c * c;
			sqr_abc = Math.sqrt(abc);

			// x = ( a * d ) / abc;
			// y = ( b * d ) / abc;
			// z = ( c * d ) / abc;
		}

		public function normalizePlane() : void {
			var len : Number = 1 / sqr_abc;
			a *= len;
			b *= len;
			c *= len;
			d *= len;
		}

		public function determinant(_x : Number, _y : Number, _z : Number) : Number {
			return ( a * _x + b * _y + c * _z - d );
		}

		public function isCoplanar(plane : Plane) : Boolean {
			return ( 	a * ( plane.a * plane.d ) + b * ( plane.b * plane.d ) + c * ( plane.c * plane.d ) - d ) == 0;
		}

		public function isPointCoplanar(p : Vector3D) : Boolean {
			var det : Number = a * p.x + b * p.y + c * p.z - d;
			return ( det >= -EPSILON && det <= EPSILON );
		}

		public function get normal() : Vector3D {
			return _normal;
		}

		public function set normal(value : Vector3D) : void {
			_normal = value;
		}
	}
}