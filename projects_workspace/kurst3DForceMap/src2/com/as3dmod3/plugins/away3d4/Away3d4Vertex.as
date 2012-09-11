package com.as3dmod3.plugins.away3d4 {
	import away3d.core.base.data.Vertex;

	import com.as3dmod3.core.VertexProxy;

	/** Вершина меша движка Away3D 4.0. */
	public class Away3d4Vertex extends VertexProxy {
		private var vx : Vertex;

		/** Создает новый экземпляр класса Away3d4Vertex. */
		public function Away3d4Vertex() {
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