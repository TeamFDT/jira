package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.VertexProxy;

	import flash.display.BitmapData;

	/**
	 * 	<b>Модификатор BitmapDisplacement.</b> Смещает вершины геометрии меша основываясь на RGB значениях пикселей.
	 * 	<br>
	 * 	<p>Создание модификатора BitmapDisplacement навеяно встроенным AS3 фильтром: DisplacementMapFilter. 
	 *  Используя этот модификатор, вы можете заставить вершины геометрии меша смещаться, основываясь на значениях
	 *  цвета каждого канала в растровом изображении.</p>
	 * 	
	 * 	<p>При этом, по оси X вершины смещаются основываясь на красном канале растрового изображения, по оси Y основываясь на зеленом канале, а по оси
	 * 	Z вершины смещаются основываясь на синем канале растрового изображения.</p>
	 * 	
	 * 	@version 1.0
	 * 	@author Bartek Drozdz
	 */
	public class BitmapDisplacement extends Modifier implements IModifier {
		/** @private */
		protected var _force : Number;
		/** @private */
		protected var _bitmap : BitmapData;
		/** @private */
		protected var _axes : int = 7;
		/** @private */
		protected var offset : Number = 0x80;

		/**
		 * Создает новый экземпляр класса BitmapDisplacement.
		 * @param	b 	экземпляр класса BitmapData, на основе RGB значений пикселей которого будут смещаться вершины геометрии меша.
		 * @param	f	сила воздействия модификатора на геометрию меша.
		 */
		public function BitmapDisplacement(b : BitmapData, f : Number = 1) {
			_bitmap = b;
			_force = f;
		}

		/** Cила воздействия модификатора на геометрию меша. */
		public function get force() : Number {
			return _force;
		}

		public function set force(force : Number) : void {
			_force = force;
		}

		/** Оси координат, вдоль которых разрешено смещать вершины геометрии меша. */
		public function get axes() : int {
			return _axes;
		}

		public function set axes(axes : int) : void {
			_axes = axes;
		}

		/** Экземпляр класса BitmapData, на основе RGB значений пикселей которого смещаются вершины геометрии меша.*/
		public function get bitmap() : BitmapData {
			return _bitmap;
		}

		/**
		 * Возвращает цвет пикселя, который находится в указанной позиции на растровом изображениии.
		 * @param	u	координата по горизонтали, в диапазоне от 0 до 1.
		 * @param	v	координата по вертикали, в диапазоне от 0 до 1.
		 * @return		цвет пикселя, который находится в указанной позиции на растровом изображениии.
		 */
		public function getUVPixel(u : Number, v : Number) : uint {
			var x : int = (_bitmap.width - 1) * u;
			var y : int = (_bitmap.height - 1) * v;
			return _bitmap.getPixel32((_bitmap.width - 1) - x, (_bitmap.height - 1) - y);
		}

		/** @inheritDoc */
		public function apply() : void {
			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;

			for (var i : int = 0;i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;

				var uv : Number = getUVPixel(v.ratioX, v.ratioZ);

				if (axes & 1) v.x += ((uv >> 16 & 0xff) - offset) * _force;
				if (axes & 2) v.y += ((uv >> 8 & 0xff) - offset) * _force;
				if (axes & 4) v.z += ((uv & 0xff) - offset) * _force;
			}
		}
	}
}