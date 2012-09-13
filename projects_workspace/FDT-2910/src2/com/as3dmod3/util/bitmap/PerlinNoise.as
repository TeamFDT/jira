package com.as3dmod3.util.bitmap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * Изображение с шумом Перлина.
	 * Алгоритм создания шума Перлина интерполирует и объединяет отдельные функции случайного шума (называемые октавами)
	 * в одну функцию, создающую более естественный случайный шум. Как и в музыкальных октавах, каждая функция октавы
	 * удваивает частоту предыдущей. Шум Перлина описывается как «фрактальная сумма шума», так как он объединяет несколько
	 * наборов шумовых данных с разным уровнем детализации.
	 * @author bartekd
	 */
	public class PerlinNoise extends BitmapData {
		/**  
		 * Частота, используемая по оси x. Например, чтобы создать объект
		 * с шумом для изображения размером 64 x 128, передайте 64 для значения baseX.
		 */
		public var baseX : Number;
		/**
		 * Частота для использования по оси y. Например, чтобы создать объект
		 * с шумом для изображения размером 64 x 128, передайте 128 для значения baseY.
		 */
		public var baseY : Number;
		/** Начальное значение, используемое для создания случайных чисел. */
		public var seed : int;
		/**
		 * Логическое значение. При значении true метод пытается сгладить края 
		 * перехода изображения, чтобы создать бесшовную текстуру для мозаичной заливки растровым изображением.
		 */
		public var stitch : Boolean;
		/**
		 * Логическое значение. При значении true метод создает фрактальный шум, 
		 * в противном случае создается турбулентность.
		 */
		public var fractal : Boolean;
		/**
		 * Число, которое может представлять собой любую комбинацию значений четырех каналов цвета 
		 * (BitmapDataChannel.RED, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN и BitmapDataChannel.ALPHA).
		 * Можно использовать логический оператор ИЛИ (|) для комбинирования значений каналов.
		 */
		public var channels : uint;
		/**
		 * Логическое значение. При значении true создается изображение с использованием серой шкалы путем присвоения
		 * каналам красного, зеленого и синего цветов идентичных значений. Значение альфа-канала остается без изменений,
		 * если данному параметру задано значение true.
		 */
		public var greyScale : Boolean;
		private var _octaves : uint;
		private var offsets : Array;
		private var _bitmap : Bitmap;
		private var _density : Number;

		/**
		 * Создает новый экземпляр класса PerlinNoise.
		 * @param	width	ширина изображения с шумом Перлина.
		 * @param	height	высота изображения с шумом Перлина.
		 */
		public function PerlinNoise(width : int, height : int) {
			super(width, height, true, 0x80808080);

			_bitmap = new Bitmap(this);

			baseX = width;
			baseY = height;
			octaves = 1;
			seed = Math.random() * 10000;
			stitch = false;
			fractal = true;
			channels = 7;
			greyScale = false;

			move(0, 0);
		}

		/** Плотность шума. */
		public function get density() : Number {
			return _density;
		}

		public function set density(d : Number) : void {
			_density = d;
			baseX = width / d;
			baseY = height / d;
		}

		/**
		 * Изменяет смещение для одной октавы или для всех сразу.  
		 * @param	x		смещение октавы по оси x.
		 * @param	y		смещение октавы по оси y.
		 * @param	octave	порядковый номер октавы.
		 */
		public function move(x : Number, y : Number, octave : int = -1) : void {
			if (octave > -1 && octave < _octaves) {
				moveOctave(octave, x, y);
			} else if (octave == -1) {
				for (var i : int = 0;i < _octaves; i++) moveOctave(i, x, y);
			}
			render();
		}

		/** Рендерит изображение с шумом Перлина. */
		public function render() : void {
			perlinNoise(baseX, baseY, octaves, seed, stitch, fractal, channels, greyScale, offsets);
		}

		/**
		 * Изменяет смещение для одной октавы или для всех сразу.  
		 * @param	oc	порядковый номер октавы.
		 * @param	x	смещение октавы по оси x.
		 * @param	y	смещение октавы по оси y.
		 */
		private function moveOctave(oc : int, x : Number, y : Number) : void {
			offsets[oc] = Point(offsets[oc]).add(new Point(x, y));
		}

		/**
		 * Количество октав или индивидуальных функций шума, которые необходимо объединить с 
		 * целью создания шума. Чем больше октав, тем более детальное изображение создается.
		 * Также чем больше октав, тем больше времени требуется на обработку.
		 */
		public function get octaves() : uint {
			return _octaves;
		}

		public function set octaves(o : uint) : void {
			_octaves = o;
			offsets = new Array();
			for (var i : int = 0;i < _octaves; i++) offsets.push(new Point());
		}

		/** Изображение с шумом Перлина. */
		public function get bitmap() : Bitmap {
			return _bitmap;
		}
	}
}