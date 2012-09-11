package triga.maths.utils {
	import flash.geom.Vector3D;

	import triga.maths.MathConstants;
	import triga.maths.shapes.Line;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class LineUtils {
		static public function project(line : Line, v : Vector3D) : Vector3D {
			var dir : Vector3D = line.v1.subtract(line.v0);
			var pos : Vector3D = v.subtract(line.v0);

			dir.normalize();
			dir.scaleBy(dir.dotProduct(pos));

			return line.v0.add(dir);
		}

		static public function angle(line : Line, v : Vector3D) : Number {
			var length1 : Number = v.length;
			if ( length1 == 0 ) return 0;

			var _v : Vector3D = line.v0.subtract(line.v1);
			var length2 : Number = _v.length;
			if ( length2 == 0 ) return 0;

			return Math.acos(v.dotProduct(_v) / ( length1 * length2 ));
		}

		static public function shortestLine(line0 : Line, line1 : Line, asSegment : Boolean = false) : Line {
			var p0 : Vector3D = line0.v0;
			var p1 : Vector3D = line0.v1;
			var p2 : Vector3D = line1.v0;
			var p3 : Vector3D = line1.v1;

			var a : Vector3D = p0.subtract(p2);
			var b : Vector3D = p3.subtract(p2);

			if ( Math.abs(b.x) < MathConstants.EPSILON && Math.abs(b.y) < MathConstants.EPSILON && Math.abs(b.z) < MathConstants.EPSILON) return null;

			var c : Vector3D = p1.subtract(p0);

			if (Math.abs(c.x) < MathConstants.EPSILON && Math.abs(c.y) < MathConstants.EPSILON && Math.abs(c.z) < MathConstants.EPSILON) return null;

			var dp1 : Number = a.dotProduct(b);
			var dp2 : Number = b.dotProduct(c);
			var dp3 : Number = a.dotProduct(c);

			var length1 : Number = b.length;
			var length2 : Number = c.length;

			var denom : Number = length2 * length1 - dp2 * dp2;

			if (Math.abs(denom) < MathConstants.EPSILON ) return null;

			var numer : Number = dp1 * dp2 - dp3 * length1;

			var mua : Number = numer / denom;
			var mub : Number = (dp1 + dp2 * ( mua ) ) / length1;

			if ( asSegment ) {
				if ( mua < 0 ) mua = 0;
				else if ( mua > 1 ) mua = 1;

				if ( mub < 0 ) mub = 0;
				else if ( mub > 1 ) mub = 1;
			}

			c.scaleBy(mua);
			b.scaleBy(mub);

			return new Line(p0.add(c), p2.add(b));
		}
	}
}