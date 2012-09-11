package triga.spline.curves {
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public interface ICurve3D {
		function set precision(value : Number) : void;

		function get precision() : Number;

		function set loop(value : Boolean) : void;

		function get loop() : Boolean;

		function compute(vertices : Vector.<Vector3D>, target : Vector.<Vector3D> = null) : Vector.<Vector3D>;
	}
}