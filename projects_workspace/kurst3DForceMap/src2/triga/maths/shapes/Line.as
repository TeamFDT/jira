package triga.maths.shapes {
	import away3d.entities.Mesh;

	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Line {
		public var v0 : Vector3D;
		public var v1 : Vector3D;

		public function Line(v0 : Vector3D = null, v1 : Vector3D = null) {
			this.v0 = v0;
			this.v1 = v1;
		}
	}
}