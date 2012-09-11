package triga.maths.utils {
	import flash.geom.Vector3D;

	import triga.maths.MathConstants;
	import triga.maths.shapes.Plane;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class PlaneUtils {
		// utils for area computation
		static private var pq : Vector3D = new Vector3D();
		static private var pr : Vector3D = new Vector3D();

		static public function compute(v0x : Number, v0y : Number, v0z : Number, v1x : Number, v1y : Number, v1z : Number, v2x : Number, v2y : Number, v2z : Number) : Plane {
			var a : Number, b : Number, c : Number, d : Number, abc : Number;

			a = v0y * (v1z - v2z) + v1y * (v2z - v0z) + v2y * (v0z - v1z);
			b = v0z * (v1x - v2x) + v1z * (v2x - v0x) + v2z * (v0x - v1x);
			c = v0x * (v1y - v2y) + v1x * (v2y - v0y) + v2x * (v0y - v1y);
			d = a * v0x + b * v0y + c * v0z;

			return new Plane(a, b, c, d);
		}

		static public function computeFromVector3D(v0 : Vector3D, v1 : Vector3D, v2 : Vector3D) : Plane {
			return compute(v0.x, v0.y, v0.z, v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
		}

		static public function lineIntersect(plane : Plane, v0 : Vector3D, v1 : Vector3D, asSegment : Boolean = false) : Vector3D {
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

		static public function isFacing(plane : Plane, v : Vector3D) : Boolean {
			return plane.determinant(v.x, v.y, v.z) >= 0;
		}

		static public function projectPoint(plane : Plane, v : Vector3D) : Vector3D {
			var div : Number = ( plane.a * v.x + plane.b * v.y + plane.c * v.z ) / plane.abc;

			return new Vector3D(v.x - plane.a * div, v.y - plane.b * div, v.z - plane.c * div);
		}

		static public function distanceToPoint(plane : Plane, v : Vector3D) : Number {
			return Vector3D.distance(v, projectPoint(plane, v));
		}
		/*
		static public function planeIntersect( p0:Plane, p1:Plane ):Vector3D
		{
		// Compute direction of intersection line
		var d:Vector3D = p1.normal.dotProduct( p2.normal );
			
		if ( d.dotProduct( d ) < MathConstants.EPSILON ) return null;
			
		var d11:Number = p1.normal.dotProduct( p1.normal);
		var d12:Number = p1.normal.dotProduct( p2.normal);
		var d22:Number = p2.normal.dotProduct( p2.normal);
		var denom:Number = d11 * d22 - d12 * d12;
			
		var k0:Number = (p1.d * d22 - p2.d * d12) / denom;
		var k1:Number = (p2.d * d11 - p1.d * d12) / denom;
			
		var n0:Vector3D = p0.normal.clone();
		n0.scaleBy( k0 );
			
		var n1:Vector3D = p1.normal.clone();
		n1.scaleBy( k1 );
			
		return n0.add( n1 );
			
		}
		
		static public function planesIntersect( p0:Plane, p1:Plane, p2:Plane ):Vector3D
		{
		var u:Vector3D = p1.normal.crossProduct( p2 );
		var denom:Number = p1.normal.dotProduct( u );
		if ( Math.abs( denom ) < MathConstants.EPSILON ) return null; // Planes do not intersect in a point
			
		var m1:Vector3D = new Vector3D( p1.normal.x, p2.normal.x, p3.normal.x );
		var m2:Vector3D = new Vector3D( p1.normal.y, p2.normal.y, p3.normal.y );
		var m3:Vector3D = new Vector3D( p1.normal.z, p2.normal.z, p3.normal.z );
		
		var d:Vector3D = new Vector3D( p1.d, p2.d, p3.d );
		var v:Vector3D = m1.crossProduct( d );
			
		var ood:Number = 1 / denom;
			
		var p:Vector3D = new Vector3D( 	d.dotProduct( u ) * ood,
		m3.dotProduct( v ) * ood,
		-m2.dotProduct( v ) * ood );
			
		return p;
		}
		
		 */
	}
}