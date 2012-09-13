package triga.utils {
	import flash.geom.Vector3D;

	import triga.shapes.TrigaPlane;
	import triga.shapes.TrigaRay;
	import triga.shapes.TrigaSphere;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class TrigaSphereUtils {
		static private var plane : TrigaPlane = new TrigaPlane();

		public function TrigaSphereUtils() {
		}

		static public function contains(sphere : TrigaSphere, v : Vector3D) : Boolean {
			var dx : Number = ( sphere.x - v.x );
			var dy : Number = ( sphere.y - v.y );
			var dz : Number = ( sphere.z - v.z );
			return ( dx * dx + dy * dy + dz * dz ) < ( sphere.radius * sphere.radius );
		}

		static public function sphereIntersectSphere(sphere : TrigaSphere, target : TrigaSphere, intersection : Vector3D = null) : Vector3D {
			var d : Number = Vector3D.distance(sphere, target);
			if ( d >= ( sphere.radius + target.radius ) ) {
				if ( intersection != null ) {
					intersection.x = sphere.x + ( target.x - sphere.x ) * .5;
					intersection.y = sphere.y + ( target.y - sphere.y ) * .5;
					intersection.z = sphere.z + ( target.z - sphere.z ) * .5;
					return intersection;
				} else {
					return new Vector3D(sphere.x + ( target.x - sphere.x ) * .5, sphere.y + ( target.y - sphere.y ) * .5, sphere.z + ( target.z - sphere.z ) * .5);
				}
			}
			return null;
		}

		static public function lineIntersectSphere(sphere : TrigaSphere, ray : TrigaRay) : Vector3D {
			var q : Vector3D = sphere.subtract(ray.v0);
			var c : Number = q.length;
			var v : Number = q.dotProduct(ray.v1);
			var d : Number = ( sphere.radius * sphere.radius ) - ( c * c - v * v );
			if ( d < 0.0 ) return null;

			var result : Vector3D = ray.v0.subtract(ray.v1);
			result.normalize();
			result.scaleBy(v - Math.sqrt(d));
			return result.add(ray.v0);
		}

		static public function rayIntersectSphere(sphere : TrigaSphere, ray : TrigaRay) : TrigaRay {
			var x : Number = sphere.x;
			var y : Number = sphere.y;
			var z : Number = sphere.z;
			var radius : Number = sphere.radius;

			var a : Number, b : Number, c : Number, i : Number, mu : Number;
			var l1 : Vector3D = ray.v0;
			var l2 : Vector3D = ray.v1;

			a = (l2.x - l1.x) * (l2.x - l1.x) + (l2.y - l1.y) * (l2.y - l1.y) + (l2.z - l1.z) * (l2.z - l1.z);
			b = 2 * ((l2.x - l1.x) * (l1.x - x) + (l2.y - l1.y) * (l1.y - y) + (l2.z - l1.z) * (l1.z - z))
			c = ( x * x + y * y + z * z + l1.x * l1.x + l1.y * l1.y + l1.z * l1.z - 2.0 * (x * l1.x + y * l1.y + z * l1.z) - radius * radius)

			i = b * b - 4 * a * c

			var result : TrigaRay = new TrigaRay();
			if ( i < 0 ) {
				return null;
			} else if ( i == 0 ) {
				mu = -b / (2 * a);
				result.v0 = result.v1 = new Vector3D(l1.x + mu * (l2.x - l1.x), l1.y + mu * (l2.y - l1.y), l1.z + mu * (l2.z - l1.z));
			} else if ( i > 0 ) {
				mu = ( -b + Math.sqrt(i)) / (2 * a);
				result.v0 = new Vector3D(l1.x + mu * (l2.x - l1.x), l1.y + mu * (l2.y - l1.y), l1.z + mu * (l2.z - l1.z));

				mu = ( -b - Math.sqrt(i)) / (2 * a);
				result.v1 = new Vector3D(l1.x + mu * (l2.x - l1.x), l1.y + mu * (l2.y - l1.y), l1.z + mu * (l2.z - l1.z));
				return result;
			}
			return null;
		}

		// http://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
		// static public function circumSphere( a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, sphere:TrigaSphere = null ):TrigaSphere
		static public function circumSphere(ax : Number, ay : Number, az : Number, bx : Number, by : Number, bz : Number, cx : Number, cy : Number, cz : Number, dx : Number, dy : Number, dz : Number, sphere : TrigaSphere = null) : TrigaSphere {
			// temp vars
			var xba : Number, yba : Number, zba : Number, xca : Number, yca : Number, zca : Number, xda : Number, yda : Number, zda : Number;
			var balength : Number, calength : Number, dalength : Number;
			var xcrosscd : Number, ycrosscd : Number, zcrosscd : Number;
			var xcrossdb : Number, ycrossdb : Number, zcrossdb : Number;
			var xcrossbc : Number, ycrossbc : Number, zcrossbc : Number;
			var denominator : Number;

			// Use coordinates relative to point `a' of the tetrahedron.
			xba = bx - ax;
			yba = by - ay;
			zba = bz - az;

			xca = cx - ax;
			yca = cy - ay;
			zca = cz - az;

			xda = dx - ax;
			yda = dy - ay;
			zda = dz - az;

			// Squares of lengths of the edges incident to `a'.
			balength = xba * xba + yba * yba + zba * zba;
			calength = xca * xca + yca * yca + zca * zca;
			dalength = xda * xda + yda * yda + zda * zda;

			// Cross products of these edges.
			xcrosscd = yca * zda - yda * zca;
			ycrosscd = zca * xda - zda * xca;
			zcrosscd = xca * yda - xda * yca;

			xcrossdb = yda * zba - yba * zda;
			ycrossdb = zda * xba - zba * xda;
			zcrossdb = xda * yba - xba * yda;

			xcrossbc = yba * zca - yca * zba;
			ycrossbc = zba * xca - zca * xba;
			zcrossbc = xba * yca - xca * yba;

			// Calculate the denominator of the formulae.
			denominator = 0.5 / (xba * xcrosscd + yba * ycrosscd + zba * zcrosscd);

			if ( sphere == null ) sphere = new TrigaSphere();

			// Calculate offset (from `a') of circumcenter.
			sphere.x = ax + (balength * xcrosscd + calength * xcrossdb + dalength * xcrossbc) * denominator;
			sphere.y = ay + (balength * ycrosscd + calength * ycrossdb + dalength * ycrossbc) * denominator;
			sphere.z = az + (balength * zcrosscd + calength * zcrossdb + dalength * zcrossbc) * denominator;

			// circumRadius
			sphere.radius = Vector3D.distance(sphere, new Vector3D(ax, ay, az));

			return sphere;
		}

		static public function inSphere(a : Vector3D, b : Vector3D, c : Vector3D, d : Vector3D, sphere : TrigaSphere = null) : TrigaSphere {
			/*		
			Let a, b, c, d be the areas of the faces opposite to vertices
			A, B, C, D of the tetrahedron $ABCD$ and let O be the
			tetrahedron's incenter.  Then we have:
			O = (a/t) A + (b/t) B +  (c/t) C + (d/t) D,
			where t = a + b + c + d is the tetrahedron's surface area.
			 */

			var aa : Number = PlaneUtils.area(b, c, d);
			var ab : Number = PlaneUtils.area(c, d, a);
			var ac : Number = PlaneUtils.area(d, a, b);
			var ad : Number = PlaneUtils.area(a, b, c);

			var t : Number = aa + ab + ac + ad;

			aa /= t;
			ab /= t;
			ac /= t;
			ad /= t;

			if ( sphere == null ) sphere = new TrigaSphere();

			// inCenter
			sphere.x = a.x * aa + b.x * ab + c.x * ac + d.x * ad;
			sphere.y = a.y * aa + b.y * ab + c.y * ac + d.y * ad;
			sphere.z = a.z * aa + b.z * ab + c.z * ac + d.z * ad;

			// inRadius
			plane = PlaneUtils.computeFromVector3D(a, b, c);
			sphere.radius = PlaneUtils.distanceToPoint(plane, sphere);

			return sphere;
		}
	}
}