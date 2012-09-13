package triga.spline.shapes.path {
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Helix {
		private var turns : Number = 1;
		private var height : Number = 0;
		private var radiusTop : Number = 1;
		private var radiusBottom : Number = 1;
		private var sides : uint = 12;
		private var _path : Vector.<Vector3D> = new Vector.<Vector3D>();
		private var upAxis : Vector3D;

		public function Helix(turns : Number = 1, height : Number = 0, radiusBottom : Number = 1, radiusTop : Number = 1, sides : uint = 12, upAxis : Vector3D = null) {
			this.turns = turns;
			this.height = height;
			this.radiusBottom = radiusBottom;
			this.radiusTop = radiusTop;
			this.sides = sides;
			this.upAxis = upAxis || Vector3D.Y_AXIS;

			reset();
		}

		private function reset() : void {
			path.length = 0;
			var v : Vector3D;
			var i : Number = 0;
			var step : Number = ( Math.PI * 2 ) / ( sides * turns );
			var total : Number = ( Math.PI * 2 ) * turns + step;
			for ( i = 0; i < total; i += step ) {
				var n : Number = i / total;
				var radius : Number = ( radiusBottom * ( 1 - n ) + radiusTop * n );

				if ( upAxis == Vector3D.X_AXIS ) v = new Vector3D(height * n, Math.cos(i) * radius, Math.sin(i) * radius);
				if ( upAxis == Vector3D.Y_AXIS ) v = new Vector3D(Math.cos(i) * radius, height * n, Math.sin(i) * radius);
				if ( upAxis == Vector3D.Z_AXIS ) v = new Vector3D(Math.cos(i) * radius, Math.sin(i) * radius, height * n);

				path.push(v);
			}
		}

		public function get path() : Vector.<Vector3D> {
			return _path;
		}

		public function set path(value : Vector.<Vector3D>) : void {
			_path = value;
		}
	}
}