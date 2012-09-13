package com.as3dmod.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Matrix4;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;

	/**
	 * <b>Twist modifier.</b>
	 * 
	 * Adapted from the Twist modifier for PV3D. 
	 * More info here: <a href="http://blog.zupko.info/?p=140" target="_blank">http://blog.zupko.info/?p=140</a>.
	 */
	public class Twist extends Modifier implements IModifier {
		private var _vector : Vector3 = new Vector3(0, 1, 0);
		private var _angle : Number;
		public var center : Vector3 = Vector3.ZERO;

		public function Twist(a : Number = 0) {
			_angle = a;
		}

		public function get angle() : Number {
			return _angle;
		}

		public function set angle(value : Number) : void {
			_angle = value;
		}

		public function get vector() : Vector3 {
			return _vector;
		}

		public function set vector(value : Vector3) : void {
			_vector = value;
		}

		public function apply() : void {
			_vector.normalize();

			var dv : Vector3 = new Vector3(mod.maxX / 2, mod.maxY / 2, mod.maxZ / 2);
			var d : Number = -Vector3.dot(_vector, center);

			for (var i : int = 0;i < mod.getVertices().length; i++) {
				var vertex : VertexProxy = mod.getVertices()[i];
				var dd : Number = Vector3.dot(new Vector3(vertex.x, vertex.y, vertex.z), _vector) + d;
				twistPoint(vertex, (dd / dv.magnitude) * _angle);
			}
		}

		private function twistPoint(v : VertexProxy, a : Number) : void {
			var mat : Matrix4 = Matrix4.translationMatrix(v.x, v.y, v.z);
			mat = Matrix4.multiply(Matrix4.rotationMatrix(_vector.x, _vector.y, _vector.z, a), mat);
			v.x = mat.n14;
			v.y = mat.n24;
			v.z = mat.n34;
		}
	}
}