package com.as3dmod3.plugins.pv3d {
	import com.as3dmod3.core.VertexProxy;

	/** Вершина меша движка Papervision3d. */
	public class Pv3dVertex extends VertexProxy {
		private var vx : Vertex3D;

		/** Создает новый экземпляр класса Pv3dVertex. */
		public function Pv3dVertex() {
		}

		/** @inheritDoc */
		override public function setVertex(vertex : *) : void {
			vx = vertex as Vertex3D;
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