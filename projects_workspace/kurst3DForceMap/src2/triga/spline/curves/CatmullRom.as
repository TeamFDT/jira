package triga.spline.curves {
	import flash.geom.Vector3D;

	/** 
	 * Catmull-Rom spline through N vertices.
	 * @author makc
	 * @license WTFPLv2, http://sam.zoy.org/wtfpl/
	 */
	public class CatmullRom implements ICurve3D {
		private var _precision : Number = .1;
		private var _loop : Boolean = false;

		public function CatmullRom(precision : Number = .1, loop : Boolean = false) {
			_precision = precision;
			_loop = loop;
		}

		static public function compute(vertices : Vector.<Vector3D>, precision : Number = .1, loop : Boolean = false, target : Vector.<Vector3D> = null) : Vector.<Vector3D> {
			precision = Math.max(.01, Math.min(.99, precision));

			var i : int, t : Number;
			var p0 : Vector3D, p1 : Vector3D, p2 : Vector3D, p3 : Vector3D;

			target ||= new Vector.<Vector3D>();
			target.length = 0;
			target.push(vertices[0]);
			for (i = 0; i < vertices.length - ( loop ? 0 : 1 ); i++) {
				p0 = vertices [(i - 1 + vertices.length) % vertices.length];
				p1 = vertices [i];
				p2 = vertices [(i + 1 + vertices.length) % vertices.length];
				p3 = vertices [(i + 2 + vertices.length) % vertices.length];

				for ( t = precision; t < 1; t += precision ) {
					target.push(new Vector3D(0.5 * ((          2 * p1.x) + t * (( -p0.x + p2.x) + t * ((2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) + t * (  -p0.x + 3 * p1.x - 3 * p2.x + p3.x)))), 0.5 * ((          2 * p1.y) + t * (( -p0.y + p2.y) + t * ((2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) + t * (  -p0.y + 3 * p1.y - 3 * p2.y + p3.y)))), 0.5 * ((          2 * p1.z) + t * (( -p0.z + p2.z) + t * ((2 * p0.z - 5 * p1.z + 4 * p2.z - p3.z) + t * (  -p0.z + 3 * p1.z - 3 * p2.z + p3.z))))));
				}
			}
			if ( loop ) {
				target.push(target[0]);
			} else {
				target.push(vertices[vertices.length - 1 ]);
			}
			return target;
		}

		/* INTERFACE triga.curves.shapes.ICurve3D */
		public function set precision(value : Number) : void {
			_precision = value;
		}

		public function get precision() : Number {
			return _precision;
		}

		public function set loop(value : Boolean) : void {
			_loop = value;
		}

		public function get loop() : Boolean {
			return _loop;
		}

		public function compute(vertices : Vector.<Vector3D>, target : Vector.<Vector3D> = null) : Vector.<Vector3D> {
			return CatmullRom.compute(vertices, precision, loop, target);
		}
	}
}