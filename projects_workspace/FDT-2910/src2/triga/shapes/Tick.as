package triga.shapes {
	import away3d.primitives.CylinderGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;

	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Tick extends Mesh {
		private var size : Number;

		public function Tick(position : Vector3D = null, size : Number = 1, material : MaterialBase = null) {
			super(material || new ColorMaterial(0xFFFFFF, 1));

			this.size = size;

			var cyl : Mesh;

			cyl = new Mesh(new CylinderGeometry(1, 1, size, 3, 1, false), material);
			cyl.rotationZ = 90;
			cyl.bakeTransformations();
			geometry.addSubGeometry(cyl.geometry.subGeometries[ 0 ]);

			cyl = new Mesh(new CylinderGeometry(1, 1, size, 3, 1, false), material);
			cyl.bakeTransformations();
			geometry.addSubGeometry(cyl.geometry.subGeometries[ 0 ]);

			cyl = new Mesh(new CylinderGeometry(1, 1, size, 3, 1, false), material);
			cyl.rotationX = 90;
			cyl.bakeTransformations();
			geometry.addSubGeometry(cyl.geometry.subGeometries[ 0 ]);

			this.position = position || new Vector3D();
		}
	}
}