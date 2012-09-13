package com.as3dmod3.plugins.pv3d {
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.plugins.Library3d;

	/** Движок Papervision3d. */
	public class LibraryPv3d extends Library3d {
		/** Создает новый экземпляр класса LibraryPv3d. */
		public function LibraryPv3d() {
			var m : MeshProxy = new Pv3dMesh();
			var v : VertexProxy = new Pv3dVertex();
		}

		/** @inheritDoc */
		override public function get id() : String {
			return "pv3d";
		}

		/** @inheritDoc */
		override public function get meshClass() : String {
			return "com.as3dmod.plugins.pv3d.Pv3dMesh";
		}

		/** @inheritDoc */
		override public function get vertexClass() : String {
			return "com.as3dmod.plugins.pv3d.Pv3dVertex";
		}
	}
}