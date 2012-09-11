package com.as3dmod3.plugins.away3d4 {
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.plugins.Library3d;

	/** Движок Away3d 4.0. */
	public class LibraryAway3d4 extends Library3d {
		/** Создает новый экземпляр класса LibraryAway3d4. */
		public function LibraryAway3d4() {
			var m : MeshProxy = new Away3d4Mesh();
			var v : VertexProxy = new Away3d4Vertex();
		}

		/** @inheritDoc */
		override public function get id() : String {
			return "away3d4";
		}

		/** @inheritDoc */
		override public function get meshClass() : String {
			return "com.as3dmod3.plugins.away3d4.Away3d4Mesh";
		}

		/** @inheritDoc */
		override public function get vertexClass() : String {
			return "com.as3dmod3.plugins.away3d4.Away3d4Vertex";
		}
	}
}