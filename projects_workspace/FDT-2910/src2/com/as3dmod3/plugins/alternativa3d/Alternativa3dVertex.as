package com.as3dmod3.plugins.alternativa3d {
	import com.as3dmod3.core.VertexProxy;

	/** Вершина меша движка Alternativa3D. */
	public class Alternativa3dVertex extends VertexProxy {
		private var vx : Vertex;

		/** Создает новый экземпляр класса Alternativa3dVertex. */
		public function Alternativa3dVertex() {
		}

		/** @inheritDoc */
		override public function setVertex(vertex : *) : void {
			vx = vertex as Vertex;
			ox = vx.x;
			oy = vx.y;
			oz = vx.z;
		}

		/** @inheritDoc */
		override public function get x() : Number {
			return vx.x;
		}

		/** @inheritDoc */
		override public function get y() : Number {
			return vx.y;
		}

		/** @inheritDoc */
		override public function get z() : Number {
			return vx.z;
		}

		/** @inheritDoc */
		override public function set x(v : Number) : void {
			vx.x = v;
		}

		/** @inheritDoc */
		override public function set y(v : Number) : void {
			vx.y = v;
		}

		/** @inheritDoc */
		override public function set z(v : Number) : void {
			vx.z = v;
		}
	}
}