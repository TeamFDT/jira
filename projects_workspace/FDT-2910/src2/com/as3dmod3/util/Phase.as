package com.as3dmod3.util {
	/** Класс Phase может быть использован для реализации анимации модификаторов. */
	public class Phase {
		private var v : Number;

		/**
		 * Создает новый экземпляр класса Phase. 
		 * @param	v	число на основе которого будет вычислено число в методе phasedValue.
		 */
		public function Phase(v : Number = 0) {
			this.v = v;
		}

		/** Число на основе которого будет вычислено число в методе phasedValue. */
		public function get value() : Number {
			return v;
		}

		public function set value(v : Number) : void {
			this.v = v;
		}

		/** Возвращает число в диапазоне от -1 до 1. */
		public function get phasedValue() : Number {
			return Math.sin(v);
		}

		/** Возвращает абсолютное значение числа вычисленного в методе phasedValue. */
		public function get absPhasedValue() : Number {
			return Math.abs(phasedValue);
		}

		/** Возвращает нормализованное значение числа вычисленного в методе phasedValue. */
		public function get normValue() : Number {
			return (phasedValue + 1) / 2;
		}
	}
}