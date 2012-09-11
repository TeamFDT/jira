package com.as3dmod3.util {
	/** Класс XMath содержит вспомогательные математические функции, в которых нуждаются некоторые модификаторы. */
	public class XMath {
		/** Математическая константа — отношение длины окружности к диаметру.  */
		public static const PI : Number = 3.1415;

		/**
		 * Находит отношение числа val к указанному диапазону чисел. Полученное значение лежит в диапазоне от 0.0 до 1.0. 
		 * @param	start	начало диапазона.
		 * @param	end		конец диапазона.
		 * @param	val		число.
		 * @return			отношение числа val к указанному диапазону чисел.
		 */
		public static function normalize(start : Number, end : Number, val : Number) : Number {
			var range : Number = end - start;
			var normal : Number;

			if (range == 0) {
				normal = 1;
			} else {
				normal = trim(0, 1, (val - start) / end);
			}

			return normal;
		}

		/**
		 * Возвращает число из указанного диапазона чисел.
		 * @param	start		начало диапазона.
		 * @param	end			конец диапазона.
		 * @param	normalized  0.0 - начало диапазона, 1.0 - конец диапазона чисел.
		 * @return				результат работы метода.
		 */
		public static function toRange(start : Number, end : Number, normalized : Number) : Number {
			var range : Number = end - start;
			var val : Number;

			if (range == 0) {
				val = 0;
			} else {
				val = start + (end - start) * normalized;
			}

			return val;
		}

		/**
		 * Проверяет находится ли переданное в метод число в рамках указанного диапазона чисел.
		 * @param	start		начало диапазона.
		 * @param	end			конец диапазона.
		 * @param	value		число.
		 * @param	excluding	если true, то первое и последнее числа из указанного диапазона чисел также будет учитываться,
		 * 						если false, то такие числа учитываться не будут.
		 * @return				true, если переданное в метод число находится в рамках указанного диапазона чисел, иначе false.
		 */
		public static function inInRange(start : Number, end : Number, value : Number, excluding : Boolean = false) : Boolean {
			if (excluding) return value >= start && value <= end;
			else return value > start && value < end;
		}

		/**
		 * Возвращает 1 если указанное число положительное.
		 * Возвращает -1 если указанное число отрицательное.
		 * Возвращает ifZero если указанное число равно 0.
		 * @param	val		число.
		 * @param	ifZero	значение, которое будет возвращено из метода, если указанное число равно 0.
		 * @return			результат работы метода.
		 */
		public static function sign(val : Number, ifZero : Number = 0) : Number {
			if (val == 0) return ifZero;
			else return (val > 0) ? 1 : -1;
		}

		/**
		 * Проверяет находится ли переданное в метод число в рамках указанного диапазона чисел.
		 * Если переданное в метод число не находится в рамках указанного диапазона чисел, то метод возвращает
		 * ближайшее число которое входит в этот диапазон чисел.
		 * @param	start	начало диапазона.
		 * @param	end		конец диапазона.
		 * @param	value	число.
		 * @return			результат работы метода.
		 */
		public static function trim(start : Number, end : Number, value : Number) : Number {
			return Math.min(end, Math.max(start, value));
		}

		/**
		 * Проверяет находится ли переданное в метод число в рамках указанного диапазона чисел.
		 * Если переданное в метод число не находится в рамках указанного диапазона чисел и оно меньше первого числа
		 * из диапазона чисел, то к этому числу прибавляется разница последнего и первого числа указанного диапазона чисел.
		 * Если переданное в метод число не находится в рамках указанного диапазона чисел и оно больше последнего числа
		 * из диапазона чисел, то из этого числа вычитается разница последнего и первого числа из указанного диапазона чисел.
		 * @param	start	начало диапазона.
		 * @param	end		конец диапазона.
		 * @param	value	число.
		 * @return			результат работы метода.
		 */
		public static function wrap(start : Number, end : Number, value : Number) : Number {
			if (value < start) return value + (end - start);
			else if (value >= end) return value - (end - start);
			else return value;
		}

		/**
		 * Конвертирует число в градусах в число в радианах.
		 * @param	deg	число в градусах.
		 * @return		число в радианах.
		 */
		public static function degToRad(deg : Number) : Number {
			return deg / 180 * Math.PI;
		}

		/**
		 * Конвертирует число в радианах в число в градусах.
		 * @param	rad	число в радианах.
		 * @return		число в градусах.
		 */
		public static function radToDeg(rad : Number) : Number {
			return rad / Math.PI * 180;
		}

		/**
		 * Округляет число до указанного знака после запятой.
		 * @param	number		число.
		 * @param	precision	количество цифр после запятой.
		 * @return				число, округленное до указанного знака после запятой.
		 */
		public static function presicion(number : Number, precision : Number) : Number {
			var r : Number = Math.pow(10, precision);
			return Math.round(number * r) / r;
		}

		/**
		 * Возвращает максимальное или минимальное значение указанного числа в зависимости от знака числа.
		 * @param	val	число.
		 * @return		если число отрицательное, то метод возвратит минимальное значение указанного числа.
		 * 				Если число положительное, то метод возвратит максимальное значение указанного числа.
		 */
		public static function uceil(val : Number) : Number {
			return (val < 0) ? Math.floor(val) : Math.ceil(val);
		}
	}
}