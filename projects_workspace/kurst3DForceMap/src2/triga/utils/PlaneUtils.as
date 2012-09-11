package triga.utils {
	import flash.geom.Vector3D;

	import triga.shapes.TrigaPlane;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class PlaneUtils {
		// utils for area computation
		static private var pq : Vector3D = new Vector3D();
		static private var pr : Vector3D = new Vector3D();

		public function PlaneUtils() {
		}

		static public function compute(v0x : Number, v0y : Number, v0z : Number, v1x : Number, v1y : Number, v1z : Number, v2x : Number, v2y : Number, v2z : Number) : TrigaPlane {
			var a : Number, b : Number, c : Number, d : Number, abc : Number;

			a = v0y * (v1z - v2z) + v1y * (v2z - v0z) + v2y * (v0z - v1z);
			b = v0z * (v1x - v2x) + v1z * (v2x - v0x) + v2z * (v0x - v1x);
			c = v0x * (v1y - v2y) + v1x * (v2y - v0y) + v2x * (v0y - v1y);
			d = a * v0x + b * v0y + c * v0z;

			var plane : TrigaPlane = new TrigaPlane(a, b, c, d);

			abc = a * a + b * b + c * c;

			plane.abc = abc;

			plane.x = ( a * d ) / abc;
			plane.y = ( b * d ) / abc;
			plane.z = ( c * d ) / abc;

			return plane;
		}

		static public function computeFromVector3D(v0 : Vector3D, v1 : Vector3D, v2 : Vector3D) : TrigaPlane {
			var a : Number, b : Number, c : Number, d : Number, abc : Number;

			a = v0.y * (v1.z - v2.z) + v1.y * (v2.z - v0.z) + v2.y * (v0.z - v1.z);
			b = v0.z * (v1.x - v2.x) + v1.z * (v2.x - v0.x) + v2.z * (v0.x - v1.x);
			c = v0.x * (v1.y - v2.y) + v1.x * (v2.y - v0.y) + v2.x * (v0.y - v1.y);
			d = a * v0.x + b * v0.y + c * v0.z;

			var plane : TrigaPlane = new TrigaPlane(a, b, c, d);

			abc = plane.abc = a * a + b * b + c * c;

			plane.x = ( a * d ) / abc;
			plane.y = ( b * d ) / abc;
			plane.z = ( c * d ) / abc;

			return plane;
		}

		static public function lineIntersect(plane : TrigaPlane, v0 : Vector3D, v1 : Vector3D, asSegment : Boolean = false) : Vector3D {
			var dx : Number = ( v1.x - v0.x );
			var dy : Number = ( v1.y - v0.y );
			var dz : Number = ( v1.z - v0.z );

			var u : Number = -( plane.a * v0.x + plane.b * v0.y + plane.c * v0.z - plane.d ) / ( plane.a * dx + plane.b * dy + plane.c * dz );

			if ( asSegment ) {
				if ( u < 0 || u > 1 ) return null;
			}

			if ( u == 0 ) return v0;
			if ( u == 1 ) return v1;

			return new Vector3D(v0.x + u * dx, v0.y + u * dy, v0.z + u * dz);
		}

		static public function pointInTriangle(v : Vector3D, v0 : Vector3D, v1 : Vector3D, v2 : Vector3D) : Boolean {
			var a : int = doubleArea(v, v0, v1);
			var b : int = doubleArea(v, v1, v2);
			var c : int = doubleArea(v, v2, v0);
			var d : int = doubleArea(v0, v1, v2);

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

		static public function isFacing(plane : TrigaPlane, v : Vector3D) : Boolean {
			return plane.determinantVector3D(v) > 0;
		}

		static public function projectPoint(plane : TrigaPlane, v : Vector3D) : Vector3D {
			var div : Number = ( plane.a * v.x + plane.b * v.y + plane.c * v.z ) / plane.abc;

			return new Vector3D(plane.x + v.x - plane.a * div, plane.y + v.y - plane.b * div, plane.z + v.z - plane.c * div);
		}

		static public function distanceToPoint(plane : TrigaPlane, v : Vector3D) : Number {
			return Vector3D.distance(v, projectPoint(plane, v));
		}

		public function vectorAngle(v0 : Vector3D, v1 : Vector3D) : Number {
			var length1 : Number = v0.length;
			var length2 : Number = v1.length;
			if ( length1 == 0 || length2 == 0 ) return 0;
			return Math.acos(v0.dotProduct(v1) / ( length1 * length2 ));
		}
	}
}