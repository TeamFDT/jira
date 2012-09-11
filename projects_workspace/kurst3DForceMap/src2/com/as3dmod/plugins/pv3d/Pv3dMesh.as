package com.as3dmod.plugins.pv3d {
	import com.as3dmod3.core.FaceProxy;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Vector3;

	import flash.utils.Dictionary;

	public class Pv3dMesh extends MeshProxy {
		private var do3d : DisplayObject3D;

		override public function setMesh(mesh : *) : void {
			do3d = mesh as DisplayObject3D;

			var lookUp : Dictionary = new Dictionary(true);
			var vs : Array = do3d.geometry.vertices;
			var ts : Array = do3d.geometry.faces;
			var vc : int = vs.length;
			var tc : int = ts.length;

			for (var i : int = 0; i < vc; i++) {
				var nv : Pv3dVertex = new Pv3dVertex();
				nv.setVertex(vs[i] as Vertex3D);
				vertices.push(nv);
				lookUp[vs[i]] = nv;
			}

			for (i = 0; i < tc; i++) {
				var nt : FaceProxy = new FaceProxy();
				nt.addVertex(lookUp[ts[i].vertices[0]]);
				nt.addVertex(lookUp[ts[i].vertices[1]]);
				nt.addVertex(lookUp[ts[i].vertices[2]]);
				faces.push(nt);
			}
		}

		override public function postApply() : void {
			// Commented out bacause it was causing a bug with Pv3d. Investigation underway :)
			// for (var i:int = 0; i < do3d.geometry.faces.length; i++) {
			// do3d.geometry.faces[i].createNormal();
			// }
			//			
			// do3d.geometry.ready = true;
		}

		override public function updateMeshPosition(p : Vector3) : void {
			do3d.x += p.x;
			do3d.y += p.y;
			do3d.z += p.z;
		}
	}
}