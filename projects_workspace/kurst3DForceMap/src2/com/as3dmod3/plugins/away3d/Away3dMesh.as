package com.as3dmod3.plugins.away3d {
	import com.as3dmod3.core.FaceProxy;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Vector3;

	import flash.utils.Dictionary;

	/** Меш движка Away3D. */
	public class Away3dMesh extends MeshProxy {
		private var awm : Mesh;

		/** Создает новый экземпляр класса Away3dMesh. */
		public function Away3dMesh() {
		}

		/** @inheritDoc */
		override public function setMesh(mesh : *) : void {
			awm = mesh as Mesh;

			var lookUp : Dictionary = new Dictionary(true);
			var vs : Array = awm.vertices;
			var vc : int = vs.length;
			var ts : Array = awm.faces;
			var tc : int = ts.length;

			for (var i : int = 0; i < vc; i++) {
				var nv : Away3dVertex = new Away3dVertex();
				nv.setVertex(vs[i] as Vertex);
				vertices.push(nv);
				lookUp[vs[i]] = nv;
			}

			for (i = 0; i < tc; i++) {
				var nt : FaceProxy = new FaceProxy();
				nt.addVertex(lookUp[ts[i].v0]);
				nt.addVertex(lookUp[ts[i].v1]);
				nt.addVertex(lookUp[ts[i].v2]);
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