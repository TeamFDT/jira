package triga.spline.shapes.path {
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Knot {
		private var _P : Number;
		private var _Q : Number;
		private var _radius : Number;
		private var _sides : uint;
		private var _path : Vector.<Vector3D> = new Vector.<Vector3D>();
		private var upAxis : Vector3D;

		public function Knot(P : uint = 3, Q : uint = 2, radius : Number = 1, sides : uint = 32) {
			_P = P;
			_Q = Q;
			_radius = radius;
			_sides = sides;
			reset();
		}

		private function reset() : void {
			path.length = 0;
			var sides : uint = this.sides * P * Q;
			var i : Number = 0;
			var step : Number = ( Math.PI * 2 ) / sides;
			var total : Number = ( Math.PI * 2 ) + step;
			for ( i = 0; i < total; i += step ) {
				var r : Number = radius * ( 2 + Math.sin(Q * i) );
				path.push(new Vector3D(r * Math.cos(P * i), r * Math.cos(Q * i), r * Math.sin(P * i)));
			}
		}

		public function get path() : Vector.<Vector3D> {
			return _path;
		}

		public function get P() : Number {
			return _P;
		}

		public function set P(value : Number) : void {
			_P = value;
			reset();
		}

		public function get Q() : Number {
			return _Q;
		}

		public function set Q(value : Number) : void {
			_Q = value;
			reset();
		}

		public function get radius() : Number {
			return _radius;
		}

		public function set radius(value : Number) : void {
			_radius = value;
			reset();
		}

		public function get sides() : uint {
			return _sides;
		}

		public function set sides(value : uint) : void {
			_sides = value;
			reset();
		}
	}
}