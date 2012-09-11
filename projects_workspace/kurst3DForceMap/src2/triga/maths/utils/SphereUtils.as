package triga.maths.utils {
	import flash.geom.Vector3D;

	import triga.maths.shapes.Plane;
	import triga.maths.shapes.Sphere3D;
	import triga.maths.shapes.Line;
	import triga.maths.shapes.Triangle;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class SphereUtils {
		static private var plane : Plane = new Plane();

		public function SphereUtils() {
		}

		static public function contains(sphere : Sphere3D, v : Vector3D) : Boolean {
			var dx : Number = ( sphere.x - v.x );
			var dy : Number = ( sphere.y - v.y );
			var dz : Number = ( sphere.z - v.z );
			return ( dx * dx + dy * dy + dz * dz ) < ( sphere.radius * sphere.radius );
		}

		static public function sphereIntersectSphere(sphere : Sphere3D, target : Sphere3D, intersection : Vector3D = null) : Vector3D {
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

		static public function lineIntersectSphere(sphere : Sphere3D, line : Line, result : Line = null) : Line {
			var x : Number = sphere.x;
			var y : Number = sphere.y;
			var z : Number = sphere.z;
			var radius : Number = sphere.radius;

			var a : Number, b : Number, c : Number, i : Number, mu : Number;
			var l1 : Vector3D = line.v0;
			var l2 : Vector3D = line.v1;

			var dx : Number = l2.x - l1.x;
			var dy : Number = l2.y - l1.y;
			var dz : Number = l2.z - l1.z;

			a = dx * dx + dy * dy + dz * dz;
			b = 2 * ( dx * (l1.x - x) + dy * (l1.y - y) + dz * (l1.z - z))
			c = ( x * x + y * y + z * z + l1.x * l1.x + l1.y * l1.y + l1.z * l1.z - 2.0 * (x * l1.x + y * l1.y + z * l1.z) - radius * radius)

			i = b * b - 4 * a * c

			if ( i < 0 ) {
				return null;
			} else if ( i == 0 ) {
				result ||= new Line();
				mu = -b / (2 * a);
				result.v0 = result.v1 = new Vector3D(l1.x + mu * (l2.x - l1.x), l1.y + mu * (l2.y - l1.y), l1.z + mu * (l2.z - l1.z));
			} else if ( i > 0 ) {
				result ||= new Line();
				mu = ( -b - Math.sqrt(i)) / (2 * a);
				result.v0 = new Vector3D(l1.x + mu * (l2.x - l1.x), l1.y + mu * (l2.y - l1.y), l1.z + mu * (l2.z - l1.z));
				mu = ( -b + Math.sqrt(i)) / (2 * a);
				result.v1 = new Vector3D(l1.x + mu * (l2.x - l1.x), l1.y + mu * (l2.y - l1.y), l1.z + mu * (l2.z - l1.z));

				return result;
			}
			return null;
		}

		static public function circumSphere(a : Vector3D, b : Vector3D, c : Vector3D, d : Vector3D, sphere : Sphere3D = null) : Sphere3D {
			// Use coordinates relative to point `a' of the tetrahedron.
			var ba : Vector3D = b.subtract(a);
			var ca : Vector3D = c.subtract(a);
			var da : Vector3D = d.subtract(a);

			// Squares of lengths of the edges incident to `a'.
			var balength : Number = ba.x * ba.x + ba.y * ba.y + ba.z * ba.z;
			var calength : Number = ca.x * ca.x + ca.y * ca.y + ca.z * ca.z;
			var dalength : Number = da.x * da.x + da.y * da.y + da.z * da.z;

			// Cross products of these edges.
			var cross_cada : Vector3D = ca.crossProduct(da);
			var cross_bada : Vector3D = ba.crossProduct(da);
			var cross_baca : Vector3D = ba.crossProduct(ca);

			// Calculate the denominator of the formulae.
			var denominator : Number = 0.5 / ( ba.x * cross_cada.x + ba.y * cross_cada.y + ba.z * cross_cada.z );

			sphere ||= new Sphere3D();

			// Calculate offset (from 'a') of circumcenter.
			sphere.x = a.x + (balength * cross_cada.x + calength * cross_bada.x + dalength * cross_baca.x ) * denominator;
			sphere.y = a.y + (balength * cross_cada.y + calength * cross_bada.y + dalength * cross_baca.y ) * denominator;
			sphere.z = a.z + (balength * cross_cada.z + calength * cross_bada.z + dalength * cross_baca.z ) * denominator;

			// circumRadius
			sphere.radius = Vector3D.distance(sphere, a);

			return sphere;
		}

		/*
		 * using raw values
		 **/
		/*
		// http://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
		
		static public function circumSphere( 	ax:Number, ay:Number, az:Number, 
		bx:Number, by:Number, bz:Number, 
		cx:Number, cy:Number, cz:Number, 
		dx:Number, dy:Number, dz:Number, 
		sphere:Sphere3D = null ):Sphere3D
		{
			
		// temp vars
		var xba:Number, yba:Number, zba:Number, xca:Number, yca:Number, zca:Number, xda:Number, yda:Number, zda:Number;
		var balength:Number, calength:Number, dalength:Number;
		var xcrosscd:Number, ycrosscd:Number, zcrosscd:Number;
		var xcrossdb:Number, ycrossdb:Number, zcrossdb:Number;
		var xcrossbc:Number, ycrossbc:Number, zcrossbc:Number;
		var denominator:Number;
			
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
			
		sphere ||= new Sphere3D();
			
		// Calculate offset (from `a') of circumcenter.
		sphere.x = ax + (balength * xcrosscd + calength * xcrossdb + dalength * xcrossbc) * denominator;
		sphere.y = ay + (balength * ycrosscd + calength * ycrossdb + dalength * ycrossbc) * denominator;
		sphere.z = az + (balength * zcrosscd + calength * zcrossdb + dalength * zcrossbc) * denominator;
			
		// circumRadius
		sphere.radius = Vector3D.distance( sphere, new Vector3D( ax, ay, az ) );
			
		return sphere;
			
		}
		// */
		/*		
		Let a, b, c, d be the areas of the faces opposite to vertices
		A, B, C, D of the tetrahedron $ABCD$ and let O be the
		tetrahedron's incenter.  Then we have:
		O = (a/t) A + (b/t) B +  (c/t) C + (d/t) D,
		where t = a + b + c + d is the tetrahedron's surface area.
		 */
		static public function inSphere(a : Vector3D, b : Vector3D, c : Vector3D, d : Vector3D, sphere : Sphere3D = null) : Sphere3D {
			var aa : Number = Triangle.area(b, c, d);
			var ab : Number = Triangle.area(c, d, a);
			var ac : Number = Triangle.area(d, a, b);
			var ad : Number = Triangle.area(a, b, c);

			var t : Number = aa + ab + ac + ad;

			aa /= t;
			ab /= t;
			ac /= t;
			ad /= t;

			if ( sphere == null ) sphere = new Sphere3D();

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