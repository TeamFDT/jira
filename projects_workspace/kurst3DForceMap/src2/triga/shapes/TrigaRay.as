package triga.shapes {
	import flash.display.Graphics;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public final class TrigaRay {
		public var v0 : Vector3D;
		public var v1 : Vector3D;

		public function TrigaRay(v0 : Vector3D = null, v1 : Vector3D = null) {
			this.v0 = v0;
			this.v1 = v1;
		}
	}
}