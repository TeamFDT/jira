package triga.maths.shapes {
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Sphere3D extends Vector3D {
		private var _radius : Number;

		public function Sphere3D(x : Number = 0, y : Number = 0, z : Number = 0, radius : Number = 1) {
			super(x, y, z);
			this._radius = radius;
		}

		public function get radius() : Number {
			return _radius;
		}

		public function set radius(value : Number) : void {
			_radius = value;
		}
	}
}