package triga.spline.curves {
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 */
	public class Cubic implements ICurve3D {
		private var _precision : Number = .1;
		private var _loop : Boolean = false;

		public function Cubic(precision : Number = .1, loop : Boolean = false) {
			_precision = precision;
			_loop = loop;
		}

		static public function compute(vertices : Vector.<Vector3D>, precision : Number = .1, loop : Boolean = false, target : Vector.<Vector3D> = null) : Vector.<Vector3D> {
			precision = Math.max(.01, Math.min(1, precision));

			// output values
			target ||= new Vector.<Vector3D>();
			target.length = 0;

			var p0 : Vector3D = new Vector3D();
			var p1 : Vector3D = new Vector3D();
			var p2 : Vector3D = new Vector3D();

			var i : int = 0;
			var j : Number, t : Number, t2 : Number, t3 : Number, t4 : Number;
			var X : Number, Y : Number, Z : Number;

			while ( i < vertices.length ) {
				// p0
				if ( i == 0 ) {
					if ( loop == true ) {
						p0.x = (vertices[vertices.length - 1].x + vertices[i].x) / 2;
						p0.y = (vertices[vertices.length - 1].y + vertices[i].y) / 2;
						p0.z = (vertices[vertices.length - 1].z + vertices[i].z) / 2;
					} else {
						p0.x = vertices[ i ].x;
						p0.y = vertices[ i ].y;
						p0.z = vertices[ i ].z;
					}
				} else {
					p0.x = ( vertices[ i - 1 ].x + vertices[ i ].x ) / 2;
					p0.y = ( vertices[ i - 1 ].y + vertices[ i ].y ) / 2;
					p0.z = ( vertices[ i - 1 ].z + vertices[ i ].z ) / 2;
				}
				// p1
				p1.x = vertices[ i ].x;
				p1.y = vertices[ i ].y;
				p1.z = vertices[ i ].z;

				// p2
				if ( i == vertices.length - 1 ) {
					if (loop == true) {
						p2.x = (vertices[i].x + vertices[0].x) / 2;
						p2.y = (vertices[i].y + vertices[0].y) / 2;
						p2.z = (vertices[i].z + vertices[0].z) / 2;
					} else {
						p2.x = vertices[ i ].x;
						p2.y = vertices[ i ].y;
						p2.z = vertices[ i ].z;
					}
				} else {
					p2.x = ( vertices[ i + 1 ].x + vertices[ i ].x ) / 2;
					p2.y = ( vertices[ i + 1 ].y + vertices[ i ].y ) / 2;
					p2.z = ( vertices[ i + 1 ].z + vertices[ i ].z ) / 2;
				}

				j = 0;
				while ( j < 1 ) {
					t = 1 - j;
					t2 = t * t;
					t3 = 2 * j * t;
					t4 = j * j;

					X = t2 * p0.x + t3 * p1.x + t4 * p2.x;
					Y = t2 * p0.y + t3 * p1.y + t4 * p2.y;
					Z = t2 * p0.z + t3 * p1.z + t4 * p2.z;

					target.push(new Vector3D(X, Y, Z));
					j += precision;
				}
				i++;
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
			return Cubic.compute(vertices, precision, loop, target);
		}
	}
}