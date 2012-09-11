package triga.lathe {
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Profile {
		private var _path : Vector.<Vector3D>;

		public function Profile(path : Vector.<Vector3D> = null) {
			this.path = path || new Vector.<Vector3D>();
		}

		public function fromPoints(points : Vector.<Point>) : void {
			this.path = new Vector.<Vector3D>();
			for each ( var p:Point in points ) {
				path.push(new Vector3D(p.x, p.y, 0));
			}
		}

		public function offset(vector : Vector3D) : void {
			var tmp : Vector.<Vector3D> = new Vector.<Vector3D>();
			for each ( var v:Vector3D in path ) {
				tmp.push(v.add(vector));
			}
			path = path.concat(tmp.concat().reverse());
		}

		public function get path() : Vector.<Vector3D> {
			return _path;
		}

		public function set path(value : Vector.<Vector3D>) : void {
			_path = value;
		}
	}
}