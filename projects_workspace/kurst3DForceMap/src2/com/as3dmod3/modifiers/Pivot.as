package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;

	/**
	 * 	<b>Модификатор Pivot.</b> Позволяет переместить точку привязки (пивот) меша.
	 * 	<br>
	 * 	<br>Пивот будет перемещен на величину, указанную в векторе pivot.
	 * 	<br>В общих случаях этот модификатор используется так. В стек модификаторов добавляется модификатор
	 *  Pivot с нужными параметрами, применяется к мешу и удаляется из стека модификаторов (метод collapse) после этого.
	 * 	Таким образом, пивот меша будет перемещен, а модификатор будет удален из стека. Этот же самый стек после этого 
	 *  может быть использован для хранения других модификаторов. 
	 * 
	 * 	@version 1.0
	 * 	@author Bartek Drozdz
	 */
	public class Pivot extends Modifier implements IModifier {
		/** Вектор с значениями смещения пивота меша по каждой из оси координат. */
		public var pivot : Vector3;

		/**
		 * Создает новый экземпляр класса Pivot.
		 * @param	x 	значение смещения пивота меша по оси X.
		 * @param	y	значение смещения пивота меша по оси Y.
		 * @param	z	значение смещения пивота меша по оси Z.
		 */
		public function Pivot(x : Number = 0, y : Number = 0, z : Number = 0) {
			this.pivot = new Vector3(x, y, z);
		}

		/** Возвращает пивот меша в позицию центра меша. */
		public function setMeshCenter() : void {
			var vx : Number = -(mod.minX + mod.width / 2);
			var vy : Number = -(mod.minY + mod.height / 2);
			var vz : Number = -(mod.minZ + mod.depth / 2);
			pivot = new Vector3(vx, vy, vz);
		}

		/** @inheritDoc */
		public function apply() : void {
			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;

			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;
				v.vector = v.vector.add(pivot);
			}

			var npivot : Vector3 = pivot.clone();
			mod.updateMeshPosition(npivot.negate());
		}
	}
}