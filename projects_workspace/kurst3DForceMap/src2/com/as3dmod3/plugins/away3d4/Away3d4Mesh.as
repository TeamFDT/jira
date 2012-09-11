package com.as3dmod3.plugins.away3d4 {
	import away3d.core.base.data.Vertex;
	import away3d.entities.Mesh;

	import com.as3dmod3.core.FaceProxy;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;

	import flash.utils.Dictionary;

	/** Меш движка Away3D 4.0. */
	public class Away3d4Mesh extends MeshProxy {
		private var awm : Mesh;
		private var v : Vector.<Number>;

		/** Создает новый экземпляр класса Away3d4Mesh. */
		public function Away3d4Mesh() {
		}

		/** @inheritDoc */
		override public function setMesh(mesh : *) : void {
			awm = mesh as Mesh;

			if (!awm.geometry || !awm.geometry.subGeometries.length) throw "No geometry in the mesh!";

			var i : int;
			var sl : int = awm.geometry.subGeometries.length;
			for (var n : int = 0;  n < sl; n++) {
				var vs : Vector.<Number> = awm.geometry.subGeometries[n].vertexData;
				var vc : int = vs.length;
				var vi : Vector.<uint> = awm.geometry.subGeometries[n].indexData;
				var vt : int = vi.length;

				for (i = 0; i < vc; i += 3) {
					var nv : Away3d4Vertex = new Away3d4Vertex();
					nv.setVertex(new Vertex(vs[i], vs[i + 1], vs[i + 2]));
					vertices.push(nv);
				}

				for (i = 0; i < vt; i += 3) {
					var nt : FaceProxy = new FaceProxy();
					nt.addVertex(vertices[vi[ i ]]);
					nt.addVertex(vertices[vi[i + 1]]);
					nt.addVertex(vertices[vi[i + 2]]);
					faces.push(nt);
				}
			}
		}

		/** @inheritDoc */
		override public function updateVertices() : void {
			v ||= new Vector.<Number>();

			v.length = 0;

			var vs : Vector.<VertexProxy> = getVertices();
			var vc : int = vs.length - 1;

			var vl : int = awm.geometry.subGeometries[vn].vertexData.length;
			var vn : int = 0;
			for (var i : int = 0; i <= vc; i++) {
				v.push(vs[i].x, vs[i].y, vs[i].z);
				if (v.length == vl && i != vc) {
					awm.geometry.subGeometries[vn++].updateVertexData(v.splice(0, v.length));
					vl = awm.geometry.subGeometries[vn].vertexData.length;
				}
			}

			awm.geometry.subGeometries[vn].updateVertexData(v);
		}

		/** @inheritDoc */
		override public function updateMeshPosition(p : Vector3) : void {
			awm.x += p.x;
			awm.y += p.y;
			awm.z += p.z;
		}
	}
}