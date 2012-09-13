package com.as3dmod3.util {
	/**
	 * Число.
	 * @author bartekd
	 */
	public class Value {
		private var _value : Number;
		private var _range : Range;

		/**
		 * Создает новый экземпляр класса Value.
		 * @param	i  число.
		 * @param	r  диапазон чисел.
		 */
		public function Value(i : Number = 0, r : Range = null) {
			_value = i;
			_range = (r != null) ? r : new Range();
		}

		/** Нечетное ли число? */
		public function get isOdd() : Boolean {
			return _value % 2 == 1;
		}

		/** Четное ли число? */
		public function get isEven() : Boolean {
			return _value % 2 == 0;
		}

		/** Отношение числа к диапазону чисел. Значение лежит в диапазоне от 0.0 до 1.0.  */
		public function get normalized() : Number {
			return XMath.normalize(_range.start, _range.end, _value);
		}

		/** Диапазон чисел. */
		public function get range() : Range {
			return _range;
		}

		public function set range(range : Range) : void {
			_range = range;
		}

		/** Число. */
		public function get value() : Number {
			return _value;
		}

		public function set value(value : Number) : void {
			_value = value;
		}

		/**
		 * Возвращает элементарное значение текущего объекта.
		 * @return	  элементарное значение текущего объекта.
		 */
		public function valueOf() : Number {
			return _value;
		}

		/**
		 * Возвращает строковое представление текущего объекта.
		 * @return	  строковое представление текущего объекта.
		 */
		public function toString() : String {
			return _value + " " + _range.toString();
		}

		/**
		 * Определяет диапазон чисел.
		 * @param	nr					диапазон чисел.
		 * @param	interpolateValue	если true, число также будет заменено другим, чтобы соответствовать новому диапазону чисел.
		 */
		public function setRange(nr : Range, interpolateValue : Boolean = false) : void {
			if (interpolateValue) _value = XMath.toRange(nr.start, nr.end, normalized);
			_range = nr;
		}

		/** Проверяет находится ли число в рамках диапазона чисел. */
		public function trim() : void {
			_value = XMath.trim(_range.start, _range.end, _value);
		}

		/**
		 * Проверяет находится ли число в рамках указанного диапазона чисел.
		 * @param	r	диапазон чисел.
		 * @return		true, если число находится в рамках указнного диапазона чисел, иначе false.
		 */
		public function inRange(r : Range = null) : Boolean {
			if (r == null) r = _range;
			return _range.isIn(_value);
		}

		/**
		 * Число является первым в диапазоне чисел?
		 * @return true -- да, false -- нет.
		 */
		public function isFirst() : Boolean {
			return _value == _range.start;
		}

		/**
		 * Число является последним в диапазоне чисел?
		 * @return true -- да, false -- нет.
		 */
		public function isLast() : Boolean {
			return _value == _range.end;
		}

		/**
		 * Число является первым или последним в диапазоне чисел?
		 * @return true -- да, false -- нет.
		 */
		public function isPolar() : Boolean {
			return isFirst() || isLast();
		}
	}
}
