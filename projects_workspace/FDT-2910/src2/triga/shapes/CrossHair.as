package triga.shapes {
	import away3d.primitives.CylinderGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;

	import flash.geom.Vector3D;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class CrossHair extends Mesh {
		private var v0 : Vector3D, v1 : Vector3D, v2 : Vector3D;
		private var width : Number;
		private var height : Number;
		private var depth : Number;

		public function CrossHair(width : Number = 1, height : Number = NaN, depth : Number = NaN) {
			super(null);

			if ( isNaN(height) ) height = width;
			if ( isNaN(depth) ) depth = width;

			this.depth = depth;
			this.height = height;
			this.width = width;

			var cyl : Mesh;
			var sm : SubMesh;

			cyl = new Mesh(new CylinderGeometry(1, 1, width, 3, 1, false), null);
			// new Cylinder( null, 1, 1, width, 3, 1, false );
			cyl.rotationZ = 90;
			cyl.x = width * .5;
			cyl.bakeTransformations();
			geometry.addSubGeometry(cyl.geometry.subGeometries[ 0 ]);
			sm = getSubMeshForSubGeometry(geometry.subGeometries[0]);
			sm.material = new ColorMaterial(0xFF0000)

			cyl = new Mesh(new CylinderGeometry(1, 1, height, 3, 1, false), null)
			cyl.y = height * .5;
			cyl.bakeTransformations();
			geometry.addSubGeometry(cyl.geometry.subGeometries[ 0 ]);
			sm = getSubMeshForSubGeometry(geometry.subGeometries[ 1 ]);
			sm.material = new ColorMaterial(0x00FF00)

			cyl = new Mesh(new CylinderGeometry(1, 1, depth, 3, 1, false), null);
			// new Cylinder( null, 1, 1, depth, 3, 1, false );
			cyl.rotationX = 90;
			cyl.z = depth * .5;
			cyl.bakeTransformations();
			geometry.addSubGeometry(cyl.geometry.subGeometries[ 0 ]);
			sm = getSubMeshForSubGeometry(geometry.subGeometries[ 2 ]);
			sm.material = new ColorMaterial(0x0000FF);
		}

		public function getNormal() : Vector3D {
			v0 = new Vector3D(x + width, 0, 0);
			v1 = new Vector3D(0, y + height, 0);
			v2 = new Vector3D(0, 0, z + depth);

			var d0 : Vector3D = v1.subtract(v0);
			var d1 : Vector3D = v2.subtract(v0);
			var normal : Vector3D = d0.crossProduct(d1);
			normal.normalize();
			return normal;
		}
	}
}