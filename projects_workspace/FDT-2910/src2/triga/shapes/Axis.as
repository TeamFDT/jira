package triga.shapes {
	import away3d.primitives.CylinderGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;

	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Axis extends Mesh {
		private var _origin : Vector3D;
		private var _direction : Vector3D;

		public function Axis(origin : Vector3D, direction : Vector3D, radius : Number = 1, material : MaterialBase = null) {
			super(material ||= new ColorMaterial(0xFFFFFF, 1));
			_direction = direction;
			_origin = origin;

			var length : Number = Vector3D.distance(origin, direction);

			var cyl : CylinderGeometry = new CylinderGeometry(null, radius, radius, length, 3, 1, false);
			var mesh : Mesh = new Mesh(cyl, material)
			mesh.y += length * .5;
			mesh.bakeTransformations();
			geometry.addSubGeometry(mesh.geometry.subGeometries[ 0 ]);

			transform.appendTranslation(origin.x, origin.y, origin.z);
			transform.pointAt(direction, Vector3D.Y_AXIS);
		}

		public function get origin() : Vector3D {
			return _origin;
		}

		public function set origin(value : Vector3D) : void {
			_origin = value;
			transform.identity();
			transform.appendTranslation(origin.x, origin.y, origin.z);
			transform.pointAt(direction, Vector3D.Y_AXIS);
		}

		public function get direction() : Vector3D {
			return _direction;
		}

		public function set direction(value : Vector3D) : void {
			_direction = value;
			transform.identity();
			transform.appendTranslation(origin.x, origin.y, origin.z);
			transform.pointAt(direction, Vector3D.Y_AXIS);
		}
	}
}