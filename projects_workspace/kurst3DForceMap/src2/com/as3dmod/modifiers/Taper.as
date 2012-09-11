package com.as3dmod.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Matrix4;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;

	/**
	 * 	<b>Taper modifier.</b>
	 * 	
	 * 	The taper modifier displaces the vertices on two 
	 * 	axes proportionally to their position on the third axis.
	 * 	
	 * 	@author Bartek Drozdz
	 */
	public class Taper extends Modifier implements IModifier {
		private var frc : Number;
		private var pow : Number;
		private var start : Number = 0;
		private var end : Number = 1;
		private var _vector : Vector3 = new Vector3(1, 0, 1);
		private var _vector2 : Vector3 = new Vector3(0, 1, 0);

		public function Taper(f : Number) {
			frc = f;
			pow = 1;
		}

		public function setFalloff(start : Number = 0, end : Number = 1) : void {
			this.start = start;
			this.end = end;
		}

		public function set force(value : Number) : void {
			frc = value;
		}

		public function get force() : Number {
			return frc;
		}

		public function get power() : Number {
			return pow;
		}

		public function set power(value : Number) : void {
			pow = value;
		}

		public function apply() : void {
			var vs : Array = mod.getVertices();
			var vc : int = vs.length;

			for (var i : int = 0;i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;

				var ar : Vector3 = v.ratioVector.multiply(_vector2);
				var sc : Number = frc * Math.pow(ar.magnitude, pow);

				var m : Matrix4 = Matrix4.scaleMatrix(1 + sc * _vector.x, 1 + sc * _vector.y, 1 + sc * _vector.z);
				var n : Vector3 = v.vector;

				Matrix4.multiplyVector(m, n);
				v.vector = n;
			}
		}
	}
}







