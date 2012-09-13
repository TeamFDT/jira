package com.as3dmod.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Matrix4;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.util.Range;

	/**
	 * <b>Break.</b> Allow to break a mesh.
	 * <br>
	 * <p>This is the inital version of the class, it contains some 
	 * hardcoded values that would make it unusable in most situations. 
	 * 
	 * <p>Updates coming soon.
	 * 
	 * @version 0
	 * @author Bartek Drozdz
	 */
	public class Break extends Modifier implements IModifier {
		// private var bv:Vector3 = new Vector3(0, 0, 1);
		private var bv : Vector3 = new Vector3(0, 1, 0);
		public var _offset : Number;
		public var angle : Number;
		public var range : Range = new Range(0, 1);

		public function Break(o : Number = 0, a : Number = 0) {
			this.angle = a;
			this._offset = o;
		}

		public function apply() : void {
			var vs : Array = mod.getVertices();
			var vc : int = vs.length;

			// var pv:Vector3 = new Vector3(-(mod.minX + mod.width / 2), -(mod.minY + mod.height * offset), 0);
			var pv : Vector3 = new Vector3(0, 0, -(mod.minZ + mod.depth * offset));

			for (var i : int = 0;i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;
				var c : Vector3 = v.vector;
				c = c.add(pv);

				if (c.z >= 0 && range.isIn(v.ratioY)) {
					var ta : Number = angle;

					var rm : Matrix4 = Matrix4.rotationMatrix(bv.x, bv.y, bv.z, ta);
					Matrix4.multiplyVector(rm, c);
				}

				var npv : Vector3 = pv.negate();
				c = c.add(npv);

				v.x = c.x;
				v.y = c.y;
				v.z = c.z;
			}
		}

		public function get offset() : Number {
			return _offset;
		}

		public function set offset(offset : Number) : void {
			_offset = offset;
		}
	}
}
