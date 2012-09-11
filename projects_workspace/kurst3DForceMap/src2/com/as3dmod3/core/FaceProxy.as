package com.as3dmod3.core {
	/** Класс FaceProxy представляет собой один треугольник геометрии меша. */
	public class FaceProxy {
		private var _vertices : Vector.<VertexProxy>;

		/** Создает новый экземпляр класса FaceProxy. */
		public function FaceProxy() {
			_vertices = new Vector.<VertexProxy>();
		}

		/**
		 * Добавляет вершину к треугольнику.
		 * @param	v	вершина, которая должна быть добавлена к треугольнику.
		 */
		public function addVertex(v : VertexProxy) : void {
			_vertices.push(v);
		}

		/** Список вершин, из которых состоит треугольник. */
		public function get vertices() : Vector.<VertexProxy> {
			return _vertices;
		}
	}
}