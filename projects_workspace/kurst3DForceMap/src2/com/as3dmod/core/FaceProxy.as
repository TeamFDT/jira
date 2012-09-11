package com.as3dmod.core {
	public class FaceProxy {
		private var _vertices : Array;

		public function FaceProxy() {
			_vertices = [];
		}

		public function addVertex(v : VertexProxy) : void {
			_vertices.push(v);
		}

		public function get vertices() : Array {
			return _vertices;
		}
	}
}