package triga.spline.curves {
	import flash.geom.Vector3D;

	// forked from makc3d's Cardinal Splines Part 4
	/**
	 * Exploring formula in Jim Armstrong "Cardinal Splines Part 4"
	 * @see http://algorithmist.wordpress.com/2009/10/06/cardinal-splines-part-4/
	 */
	public class Cardinal implements ICurve3D {
		private var _precision : Number = .1;
		private var _tension : Number = 1;
		private var _loop : Boolean = false;

		public function Cardinal(precision : Number = .1, tension : Number = .1, loop : Boolean = false) {
			_precision = precision;
			_tension = tension;
			_loop = loop;
		}

		static public function compute(vertices : Vector.<Vector3D>, precision : Number = .1, tension : Number = 1, loop : Boolean = false, target : Vector.<Vector3D> = null) : Vector.<Vector3D> {
			precision = Math.max(.01, Math.min(1, precision));
			tension = Math.max(-3, Math.min(3, tension));

			target ||= new Vector.<Vector3D>();
			target.length = 0;

			var p0 : Vector3D, p1 : Vector3D, p2 : Vector3D, p3 : Vector3D;
			var i : int, t : Number;

			for (i = 0; i < vertices.length - ( loop ? 0 : 1 ); i++) {
				p0 = (i < 1) ? vertices [vertices.length - 1] : vertices [i - 1];
				p1 = vertices [i];
				p2 = vertices [(i + 1 + vertices.length) % vertices.length];
				p3 = vertices [(i + 2 + vertices.length) % vertices.length];

				for ( t = 0; t < 1; t += precision ) {
					target.push(new Vector3D(// x
					tension * ( -t * t * t + 2 * t * t - t) * p0.x + tension * ( -t * t * t + t * t) * p1.x + (2 * t * t * t - 3 * t * t + 1) * p1.x + tension * (t * t * t - 2 * t * t + t) * p2.x + ( -2 * t * t * t + 3 * t * t) * p2.x + tension * (t * t * t - t * t) * p3.x,
												
					// y 
					tension * ( -t * t * t + 2 * t * t - t) * p0.y + tension * ( -t * t * t + t * t) * p1.y + (2 * t * t * t - 3 * t * t + 1) * p1.y + tension * (t * t * t - 2 * t * t + t) * p2.y + ( -2 * t * t * t + 3 * t * t) * p2.y + tension * (t * t * t - t * t) * p3.y,
												
					// z 
					tension * ( -t * t * t + 2 * t * t - t) * p0.z + tension * ( -t * t * t + t * t) * p1.z + (2 * t * t * t - 3 * t * t + 1) * p1.z + tension * (t * t * t - 2 * t * t + t) * p2.z + ( -2 * t * t * t + 3 * t * t) * p2.z + tension * (t * t * t - t * t) * p3.z));
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

		public function get tension() : Number {
			return _tension;
		}

		public function set tension(value : Number) : void {
			_tension = value;
		}

		public function set loop(value : Boolean) : void {
			_loop = value;
		}

		public function get loop() : Boolean {
			return _loop;
		}

		public function compute(vertices : Vector.<Vector3D>, target : Vector.<Vector3D> = null) : Vector.<Vector3D> {
			return Cardinal.compute(vertices, precision, tension, loop, target);
		}
	}
}