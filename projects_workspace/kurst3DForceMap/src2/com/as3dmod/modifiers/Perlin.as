package com.as3dmod.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.util.bitmap.PerlinNoise;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;

	/**
	 * 	<b>Perlin modifier.</b> Displaces vertices based on a perlin noise bitmap.
	 * 
	 *  Generates a perlin noise bitmap and displaces vertices 
	 *  based on the color value of each pixel of the noise map.
	 *  
	 *  @version 2.0
	 * 	@author Bartek Drozdz
	 * 	
	 * 	Changes:
	 * 	2.0 - Class rewritten, extends BitmapDisplacement, uses PerlinNoise class, inverse removed, falloff removed temporarily
	 */
	public class Perlin extends BitmapDisplacement implements IModifier {
		public var speedX : Number = 1;
		public var speedY : Number = 1;
		public var source : PerlinNoise;
		public var autoRun : Boolean;
		public static const GREY : uint = 0x80808080;

		/**
		 * @param f Force
		 * @param n instance of PerlinNoise class to be used as source for displacement
		 * @param a if set to true the perlin noise will be offseted at each call to 'apply', making the modifier animated automatically.
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