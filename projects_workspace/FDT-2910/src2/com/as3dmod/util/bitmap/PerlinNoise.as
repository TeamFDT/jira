package com.as3dmod.util.bitmap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * @author bartekd
	 */
	public class PerlinNoise extends BitmapData {
		public var baseX : Number;
		public var baseY : Number;
		public var seed : int;
		public var stitch : Boolean;
		public var fractal : Boolean;
		public var channels : uint;
		public var greyScale : Boolean;
		private var _octaves : uint;
		private var offsets : Array;
		private var _bitmap : Bitmap;
		private var _density : Number;

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

		public function set density(d : Number) : void {
			_density = d;
			baseX = width / d;
			baseY = height / d;
		}

		public function get density() : Number {
			return _density;
		}

		public function move(x : Number, y : Number, octave : int = -1) : void {
			if (octave > -1 && octave < _octaves) {
				moveOctave(octave, x, y);
			} else if (octave == -1) {
				for (var i : int = 0;i < _octaves; i++) moveOctave(i, x, y);
			}
			render();
		}

		public function render() : void {
			perlinNoise(baseX, baseY, octaves, seed, stitch, fractal, channels, greyScale, offsets);
		}

		private function moveOctave(oc : int, x : Number, y : Number) : void {
			offsets[oc] = Point(offsets[oc]).add(new Point(x, y));
		}

		public function get octaves() : uint {
			return _octaves;
		}

		public function set octaves(o : uint) : void {
			_octaves = o;
			offsets = new Array();
			for (var i : int = 0;i < _octaves; i++) offsets.push(new Point());
		}

		public function get bitmap() : Bitmap {
			return _bitmap;
		}
	}
}
