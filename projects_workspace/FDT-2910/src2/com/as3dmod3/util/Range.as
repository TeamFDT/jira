package com.as3dmod3.util {
	/**
	 * Диапазон чисел.
	 * @author bartekd
	 */
	public class Range {
		private var _start : Number;
		private var _end : Number;

		/**
		 * Создает новый экземпляр класса Range.
		 * @param	s	начало диапазона чисел.
		 * @param	e	конец диапазона чисел.
		 */
		public function Range(s : Number = 0, e : Number = 1) {
			_start = s;
			_end = e;
		}

		/** Начало диапазона чисел. */
		public function get start() : Number {
			return _start;
		}

		/** Конец диапазона чисел. */
		public function get end() : Number {
			return _end;
		}

		/** Размер диапазона чисел. */
		public function get size() : Number {
			return _end - _start;
		}

		/**
		 * Смещает диапазон чисел на указанную величину.
		 * @param	amount  величина смещения диапазона чисел.
		 */
		public function move(amount : Number) : void {
			_start += amount;
			_end += amount;
		}

		/**
		 * Проверяет находится ли переданное в метод число в рамках текущего диапазона чисел.
		 * @param	n	число.
		 * @return		true, если переданное в метод число находится в рамках текущего диапазона чисел, иначе false.
		 */
		public function isIn(n : Number) : Boolean {
			return n >= _start && n <= _end;
		}

		/**
		 * Находит отношение числа n к текущему диапазону чисел. Полученное значение лежит в диапазоне от 0.0 до 1.0. 
		 * @param	n	число.
		 * @return		отношение числа n к указанному диапазону чисел.
		 */
		public function normalize(n : Number) : Number {
			return XMath.normalize(_start, _end, n);
		}

		/**
		 * Возвращает число из указанного диапазона чисел.
		 * @param	n	0.0 - начало диапазона, 1.0 - конец диапазона чисел.
		 * @return		результат работы метода.
		 */
		public function toRange(n : Number) : Number {
			return XMath.toRange(_start, _end, n);
		}

		/**
		 * Проверяет находится ли переданное в метод число в рамках текущего диапазона чисел.
		 * @param	n	число.
		 * @return		результат работы метода.
		 */
		public function trim(n : Number) : Number {
			return XMath.trim(_start, _end, n);
		}

		/**
		 * Находит отношение числа n к указанному диапазону чисел. Полученное значение лежит в диапазоне от 0.0 до 1.0. 
		 * Затем в текущем диапазоне чисел метод ищет число, имеющее такое же отношение к текущему диапазону чисел, как и
		 * число n к диапазону r.
		 * @param	n	число.
		 * @param	r   диапазон чисел.
		 * @return		результат работы метода.
		 */
		public function interpolate(n : Number, r : Range) : Number {
			return toRange(r.normalize(n));
		}

		/**
		 * Возвращает строковое представление текущего диапазона чисел.
		 * @return	  строковое представление текущего диапазона чисел.
		 */
		public function toString() : String {
			return "[" + start + " - " + end + "]";
		}
	}
}