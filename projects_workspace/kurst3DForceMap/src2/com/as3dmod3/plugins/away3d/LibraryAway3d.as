package com.as3dmod3.plugins.away3d {
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.plugins.Library3d;

	/** Движок Away3d. */
	public class LibraryAway3d extends Library3d {
		/** Создает новый экземпляр класса LibraryAway3d. */
		public function LibraryAway3d() {
			var m : MeshProxy = new Away3dMesh();
			var v : VertexProxy = new Away3dVertex();
		}

		/** @inheritDoc */
		override public function get id() : String {
			return "away3d";
		}

		/** @inheritDoc */
		override public function get meshClass() : String {
			return "com.as3dmod.plugins.away3d.Away3dMesh";
		}

		/** @inheritDoc */
		override public function get vertexClass() : String {
			return "com.as3dmod.plugins.away3d.Away3dVertex";
		}
	}
}