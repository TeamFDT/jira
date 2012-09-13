package com.as3dmod3.plugins.alternativa3d {
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.plugins.Library3d;

	/** Движок Alternativa3d. */
	public class LibraryAlternativa3d extends Library3d {
		/** Создает новый экземпляр класса LibraryAlternativa3d. */
		public function LibraryAlternativa3d() {
			var m : MeshProxy = new Alternativa3dMesh();
			var v : VertexProxy = new Alternativa3dVertex();
		}

		/** @inheritDoc */
		override public function get id() : String {
			return "alternativa3d";
		}

		/** @inheritDoc */
		override public function get meshClass() : String {
			return "com.as3dmod.plugins.alternativa3d.Alternativa3dMesh";
		}

		/** @inheritDoc */
		override public function get vertexClass() : String {
			return "com.as3dmod.plugins.alternativa3d.Alternativa3dVertex";
		}
	}
}