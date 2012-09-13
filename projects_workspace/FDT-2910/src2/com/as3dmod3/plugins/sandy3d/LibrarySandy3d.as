package com.as3dmod3.plugins.sandy3d {
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.plugins.Library3d;

	/** Движок Sandy3d. */
	public class LibrarySandy3d extends Library3d {
		/** Создает новый экземпляр класса LibrarySandy3d. */
		public function LibrarySandy3d() {
			var m : MeshProxy = new Sandy3dMesh();
			var v : VertexProxy = new Sandy3dVertex();
		}

		/** @inheritDoc */
		override public function get id() : String {
			return "sandy3d";
		}

		/** @inheritDoc */
		override public function get meshClass() : String {
			return "com.as3dmod.plugins.sandy3d.Sandy3dMesh";
		}

		/** @inheritDoc */
		override public function get vertexClass() : String {
			return "com.as3dmod.plugins.sandy3d.Sandy3dVertex";
		}
	}
}