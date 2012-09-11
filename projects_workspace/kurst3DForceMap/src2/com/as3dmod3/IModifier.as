package com.as3dmod3 {
	import com.as3dmod3.core.MeshProxy;

	/** Интерфейс IModifier используется для определения классов-модификаторов. */
	public interface IModifier {
		/**
		 * Определяет меш, геометрия которого будет изменяться текущим модификатором.
		 * @param	mod	 меш, геометрия которого будет изменяться текущим модификатором.
		 */
		function setModifiable(mod : MeshProxy) : void;

		/** Применяет модификатор к геометрии меша. */
		function apply() : void;
	}
}