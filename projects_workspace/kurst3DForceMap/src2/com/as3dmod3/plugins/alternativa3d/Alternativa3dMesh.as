package com.as3dmod3.plugins.alternativa3d {
	import com.as3dmod3.core.FaceProxy;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Vector3;

	import flash.utils.Dictionary;

	/** Меш движка Alternativa3D. */
	public class Alternativa3dMesh extends MeshProxy {
		private var awm : Mesh;

		/** Создает новый экземпляр класса Alternativa3dMesh. */
		public function Alternativa3dMesh() {
		}

		/** @inheritDoc */
		override public function setMesh(mesh : *) : void {
			awm = mesh as Mesh;

			var lookUp : Dictionary = new Dictionary(true);
			var v : Vertex, t : Face;
			var vs : Set = awm.vertices.toSet();
			var ts : Set = awm.faces.toSet();

			while (!vs.isEmpty()) {
				var nv : Alternativa3dVertex = new Alternativa3dVertex();
				v = vs.take();
				nv.setVertex(v);
				vertices.push(nv);
				lookUp[v] = nv;
			}

			while (!ts.isEmpty()) {
				var nt : FaceProxy = new FaceProxy();
				t = ts.take();

				for (var i : int = 0; i < t.vertices.length; i++) {
					nt.addVertex(lookUp[t.vertices[i]]);
				}

				faces.push(nt);
			}
		}

		/** @inheritDoc */
		override public function updateMeshPosition(p : Vector3) : void {
			awm.x += p.x;
			awm.y += p.y;
			awm.z += p.z;
		}
	}
}