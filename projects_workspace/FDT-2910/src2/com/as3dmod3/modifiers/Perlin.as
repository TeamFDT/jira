package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.util.bitmap.PerlinNoise;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;

	/**
	 * 	<b>Модификатор Perlin.</b>
	 *  Cмещает вершины меша основываясь на значении цвета каждого пикселя из изображения с шумом Перлина.
	 * 
	 *  @version 2.0
	 * 	@author Bartek Drozdz
	 * 	
	 * 	Изменения:
	 * 	2.0 - Класс переписан, расширяет BitmapDisplacement, использует класс PerlinNoise, 
	 *  	  свойство inverse удалено, свойство falloff временно удалено.
	 */
	public class Perlin extends BitmapDisplacement implements IModifier {
		/** Значение смещения октав по оси x. */
		public var speedX : Number = 1;
		/** Значение смещения октав по оси y. */
		public var speedY : Number = 1;
		/** Изображение с шумом Перлина. */
		public var source : PerlinNoise;
		/** Должны ли значения смещения октав изменяться автоматически? */
		public var autoRun : Boolean;
		/** Цвет заливки изображения. */
		public static const GREY : uint = 0x80808080;

		/**
		 * Создает новый экземпляр класса Perlin.
		 * @param	f	сила воздействия модификатора на меш.
		 * @param	n	изображение с шумом Перлина.
		 * @param	a	должны ли значения смещения октав изменяться автоматически?
		 */
		public function Perlin(f : Number = 1, n : PerlinNoise = null, a : Boolean = true) {
			if (n == null) {
				source = new PerlinNoise(25, 25);
				source.channels = BitmapDataChannel.BLUE;
				source.octaves = 2;
				source.baseX = 50;
				source.baseY = 50;
			} else {
				source = n;
			}

			autoRun = a;
			if (autoRun) speedY = 0;

			super(new BitmapData(source.width, source.height, true, GREY), f);
		}

		/** @inheritDoc */
		override public function apply() : void {
			if (autoRun) source.move(speedX, speedY);
			bitmap.fillRect(bitmap.rect, GREY);
			if (source.channels & 1) bitmap.copyChannel(source, source.rect, new Point(), 1, 1);
			if (source.channels & 2) bitmap.copyChannel(source, source.rect, new Point(), 2, 2);
			if (source.channels & 4) bitmap.copyChannel(source, source.rect, new Point(), 4, 4);
			super.apply();
		}
	}
}