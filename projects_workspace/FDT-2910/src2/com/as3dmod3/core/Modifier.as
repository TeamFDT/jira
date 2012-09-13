package com.as3dmod3.core {
	/** Класс Modifier является базовым классом для всех классов-модификаторов. */
	public class Modifier {
		/** Меш, геометрия которого изменяется текущим модификатором. @private */
		protected var mod : MeshProxy;

		/** Создает новый экземпляр класса Modifier. */
		public function Modifier() {
		}

		/**
		 * Определяет меш, геометрия которого будет изменяться текущим модификатором.
		 * @param	mod	 меш, геометрия которого будет изменяться текущим модификатором.
		 */
		public function setModifiable(mod : MeshProxy) : void {
			this.mod = mod;
		}

		/**
		 * Возвращает список вершин меша. 
		 * @return	список вершин меша.
		 */
		public function getVertices() : Vector.<VertexProxy> {
			return mod.getVertices();
		}
	}
}