package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Matrix4;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.util.Range;

	/**
	 * <b>Модификатор Break.</b> Ломает меш.
	 * <br>
	 * <p>Это первая версия модификатора, он содержит некоторые жестко прописанные значения,
	 * которые делают его непригодным для использования в большинстве случаев.</p>
	 * 
	 * @version 0
	 * @author Bartek Drozdz
	 */
	public class Break extends Modifier implements IModifier {
		private var bv : Vector3 = new Vector3(0, 1, 0);
		private var _offset : Number;
		/** Угол поворота меша. */
		public var angle : Number;
		/** Диапазон чисел. */
		public var range : Range = new Range(0, 1);

		/**
		 * Создает новый экземпляр класса Break.
		 * @param	o	смещение места ломки меша.
		 * @param	a	угол поворота меша.
		 */
		public function Break(o : Number = 0, a : Number = 0) {
			this.angle = a;
			this._offset = o;
		}

		/**
		 *  Смещение места ломки меша.
		 *  Это значение может лежать в диапазоне от 0 до 1, где 1 является самым левым краем меша, а 0 - самым правым.
		 *  Ломка меша будет происходить в месте, в зависимости от значения, которое имеет это свойство.
		 *  По умолчанию, это свойство имеет значение 0.5, что означает что ломка будет происходить в середине меша.
		 */
		public function get offset() : Number {
			return _offset;
		}

		public function set offset(offset : Number) : void {
			_offset = offset;
		}

		/** @inheritDoc */
		public function apply() : void {
			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;
			var pv : Vector3 = new Vector3(0, 0, -(mod.minZ + mod.depth * offset));

			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = vs[i];
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
	}
}