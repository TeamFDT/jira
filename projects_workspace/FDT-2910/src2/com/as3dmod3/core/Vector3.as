package com.as3dmod3.core {
	/** Трехмерный вектор. */
	public class Vector3 {
		/** Координата вектора по оси X. */
		public var x : Number;
		/** Координата вектора по оси Y. */
		public var y : Number;
		/** Координата вектора по оси Z. */
		public var z : Number;
		/** Вектор, все элементы которого равны 0. */
		public static var ZERO : Vector3 = new Vector3(0, 0, 0);

		/**
		 * Создает новый экземпляр класса Vector3.
		 * @param	x	координата вектора по оси X.
		 * @param	y	координата вектора по оси Y.
		 * @param	z	координата вектора по оси Z.
		 */
		public function Vector3(x : Number = 0, y : Number = 0, z : Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

		/**
		 * Возвращает копию текущего вектора.
		 * @return	точная копия текущего объекта Vector3.
		 */
		public function clone() : Vector3 {
			return new Vector3(x, y, z);
		}

		/**
		 * Сравнивает переданный в метод вектор с текущим.
		 * @param	v	вектор, участвующий в вычислениях.
		 * @return		true, если переданный вектор равен текущему, иначе false.
		 */
		public function equals(v : Vector3) : Boolean {
			return x == v.x && y == v.y && z == v.z;
		}

		/** Присваивает всем элементами вектора значение 0. */
		public function zero() : void {
			x = y = z = 0;
		}

		/**
		 * Задает обращение текущего объекта Vector3. Инверсный объект считается противоположным исходному объекту. 
		 * Значения свойств x, y и z текущего объекта Vector3 меняются на значения -x, -y и -z.
		 * @return	новый объект Vector3, представляющий собой вектор противоположный текущему.
		 */
		public function negate() : Vector3 {
			return new Vector3(-x, -y, -z);
		}

		/**
		 * Добавляет значения элементов x, y и z текущего объекта Vector3 к значениям 
		 * элементов x,y и z другого объекта Vector3. Метод add() не изменяет текущий
		 * объект Vector3. Вместо этого он возвращает новый объект Vector3 с новыми значениями.
		 * @param	v	объект Vector3, добавляемый к текущему объекту Vector3.
		 * @return		объект Vector3, получающийся в результате добавления текущего объекта 
		 * 				Vector3 к другому объекту Vector3.
		 */
		public function add(v : Vector3) : Vector3 {
			return new Vector3(x + v.x, y + v.y, z + v.z);
		}

		/**
		 * Вычитает значения элементов x, y и z текущего объекта Vector3 из значений 
		 * элементов x,y и z другого объекта Vector3. Метод subtract() не изменяет текущий
		 * объект Vector3. Вместо этого данный метод возвращает новый объект Vector3 с новыми значениями.
		 * @param	v	объект Vector3, вычитаемый из текущего объекта Vector3.
		 * @return		новый объект Vector3, представляющий собой разницу текущего объекта Vector3 и заданного объекта Vector3.
		 */
		public function subtract(v : Vector3) : Vector3 {
			return new Vector3(x - v.x, y - v.y, z - v.z);
		}

		/**
		 * Масштабирует текущий объект Vector3 на скаляр (значение). Элементы x, y и z 
		 * объекта Vector3 умножаются на скалярную величину, заданную в параметре.
		 * @param	s	множитель (скалярная величина), который используется для масштабирования объекта Vector3.
		 * @return		объект Vector3, получающийся в результате умножаются текущего объекта Vector3 на скаляр.
		 */
		public function multiplyScalar(s : Number) : Vector3 {
			return new Vector3(x * s, y * s, z * s);
		}

		/**
		 * Умножает значения элементов x,y и z текущего объекта Vector3 на значения
		 * элементов x,y и z второго объекта Vector3. Метод multiply() не изменяет текущий объект 
		 * Vector3. Вместо этого данный метод возвращает новый объект Vector3 с новыми значениями.
		 * @param	v	объект Vector3, умножаемый на текущий объект Vector3.
		 * @return		новый объект Vector3, представляющий собой произведение текущего объекта Vector3 и заданного объекта Vector3.
		 */
		public function multiply(v : Vector3) : Vector3 {
			return new Vector3(x * v.x, y * v.y, z * v.z);
		}

		/**
		 * Делит значения элементов x,y и z текущего объекта Vector3 на указанное число.
		 * @param	s	число, на которое будут разделены значения элементов x,y и z текущего объекта Vector3.
		 * @return		новый объект Vector3, представляющий собой частность текущего объекта Vector3 и указанного числа.
		 */
		public function divide(s : Number) : Vector3 {
			var os : Number = 1 / s;
			return new Vector3(x * os, y * os, z * os);
		}

		/** Длина вектора. */
		public function get magnitude() : Number {
			return Math.sqrt(x * x + y * y + z * z);
		}

		public function set magnitude(m : Number) : void {
			normalize();
			x *= m;
			y *= m;
			z *= m;
		}

		/** Нормализует вектор. */
		public function normalize() : void {
			var m : Number = x * x + y * y + z * z;
			if (m > 0) {
				var n : Number = 1 / Math.sqrt(m);
				x *= n;
				y *= n;
				z *= n;
			}
		}

		/**
		 * Возвращает строковое представление текущего вектора. В строке содержатся значения свойств x, y и z.
		 * @return	строка, в которой содержатся значения свойств x, y и z.
		 */
		public function toString() : String {
			return "[" + x + " , " + y + " , " + z + "]";
		}

		/**
		 * Складывает два вектора.
		 * @param	a	первый трехмерный вектор участвующий в вычислениях.
		 * @param	b	второй трехмерный вектор участвующий в вычислениях.
		 * @return		вектор, полученный в результате сложения двух векторов.
		 */
		public static function sum(a : Vector3, b : Vector3) : Vector3 {
			return a.add(b);
		}

		/**
		 * Вычисляет скалярное произведение векторов.
		 * @param	v	первый трехмерный вектор участвующий в вычислениях.
		 * @param	w	второй трехмерный вектор участвующий в вычислениях.
		 * @return		значение, которое была получено в результате скалярного произведения двух векторов.
		 */
		public static function dot(a : Vector3, b : Vector3) : Number {
			return a.x * b.x + a.y * b.y + a.z * b.z;
		}

		/**
		 * Возвращает новый объект Vector3, который расположен перпендикулярно (под прямым углом) к первому
		 * и второму объектам Vector3. Если возвращен объект Vector3 с координатами (0,0,0), то два объекта Vector3
		 * расположены параллельно друг к другу.
		 * @param	a	второй объект Vector3.
		 * @param	b	второй объект Vector3.
		 * @return		новый объект Vector3, расположенный перпендикулярно к первому и второму объектам Vector3, заданному в качестве параметра.
		 */
		public static function cross(a : Vector3, b : Vector3) : Vector3 {
			return new Vector3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
		}

		/**
		 * Возвращает расстояние между двумя объектами Vector3. Метод distance() является статическим.
		 * Его можно использовать как метод класса Vector3 напрямую для получения евклидового расстояния
		 * между двумя трехмерными точками.
		 * @param	a	объект Vector3 в виде первой трехмерной точки.
		 * @param	b	объект Vector3 в виде второй трехмерной точки.
		 * @return	 	расстояние между двумя объектами Vector3.
		 */
		public static function distance(a : Vector3, b : Vector3) : Number {
			var dx : Number = a.x - b.x;
			var dy : Number = a.y - b.y;
			var dz : Number = a.z - b.z;
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
		}
	}
}
