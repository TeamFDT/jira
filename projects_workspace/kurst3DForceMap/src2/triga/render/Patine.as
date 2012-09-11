package triga.render {
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Patine {
		static public var shape : Shape = new Shape();

		static public function brushedMetal(base : ColorMaterial, mapSize : uint, alpha : Number = .5) : BitmapMaterial {
			var material : BitmapMaterial = cloneMat(base, mapSize);
			var bd : BitmapData = material.bitmapData;

			var noise : BitmapData = bd.clone();
			noise.fillRect(noise.rect, 0);
			noise.noise(Math.random() * 0xFFFFFF, 0, 256, 7, true);

			noise.threshold(noise, noise.rect, new Point(), ">=", 0xFF808080, 0xFFFFFFFF);
			noise.threshold(noise, noise.rect, new Point(), "!=", 0xFFFFFFFF, 0xFF000000);
			noise.applyFilter(noise, noise.rect, new Point(), new BlurFilter(mapSize / 20, 0, 1));

			noise = Tiler.quickTile(noise);

			bd.draw(noise, null, new ColorTransform(1, 1, 1, alpha), BlendMode.MULTIPLY);
			material.specularMap = noise;

			return material;
		}

		static public function hammeredMaetal(base : ColorMaterial, mapSize : uint, noiseSize : Number = 30, alpha : Number = .5, seamless : Boolean = true) : BitmapMaterial {
			var material : BitmapMaterial = cloneMat(base, mapSize);
			var bd : BitmapData = material.bitmapData;

			var rust : BitmapData = bd.clone();
			rust.fillRect(rust.rect, 0);
			rust.perlinNoise(noiseSize, noiseSize, 3, Math.random() * 0xFFFFFF, seamless, true, 7, false);

			rust.threshold(rust, rust.rect, new Point(), ">=", 0xFF808080, 0xFFFFFFFF);
			rust.threshold(rust, rust.rect, new Point(), "!=", 0xFFFFFFFF, 0x00000000);

			if ( seamless ) {
				rust = Tiler.quickTile(rust);
			}

			bd.draw(rust, null, new ColorTransform(1, 1, 1, alpha), BlendMode.MULTIPLY);
			material.gloss = 50;
			material.specularMap = rust;

			return material;
		}

		static public function marble(base : ColorMaterial, mapSize : uint, noiseSize : Number = 30, alpha : Number = .5, seamless : Boolean = true) : BitmapMaterial {
			var material : BitmapMaterial = cloneMat(base, mapSize);
			var bd : BitmapData = material.bitmapData;

			var tmp : BitmapData = bd.clone();
			tmp.fillRect(tmp.rect, 0);
			tmp.perlinNoise(noiseSize, noiseSize, 3, Math.random() * 0xFFFFFF, seamless, true, 7, true);

			var tmp0 : BitmapData = bd.clone();
			tmp0.fillRect(tmp0.rect, 0);

			tmp0.perlinNoise(noiseSize, noiseSize, 3, Math.random() * 0xFFFFFF, seamless, true, 7, true);
			tmp.draw(tmp0, null, null, BlendMode.INVERT);

			tmp0.perlinNoise(noiseSize, noiseSize, 3, Math.random() * 0xFFFFFF, seamless, true, 7, true);
			tmp.draw(tmp0, null, null, BlendMode.SUBTRACT);

			if ( seamless ) {
				tmp = Tiler.quickTile(tmp);
			}

			bd.draw(tmp, null, new ColorTransform(1, 1, 1, alpha), BlendMode.MULTIPLY);
			material.specularMap = tmp;

			return material;
		}

		static public function cardboard(base : ColorMaterial, mapSize : uint, stripeWidth : Number = 10, stripeSpace : Number = 10, stripeNoise : Number = 5, stripeTurbulence : Number = 10) : BitmapMaterial {
			var material : BitmapMaterial = cloneMat(base, mapSize);
			var bd : BitmapData = material.bitmapData;

			material.alpha = 1;
			material.gloss = 0;
			material.specular = .1;

			var originalBg : uint = 0xB58729;
			var originalFg : uint = 0xD9A961;
			bd.fillRect(bd.rect, originalBg);

			var pattern : BitmapData = new BitmapData(stripeWidth + stripeSpace, 1, true, 0x00000000);
			pattern.fillRect(new Rectangle(0, 0, stripeWidth, 1), 0xFF << 24 | originalFg);

			var tmp : BitmapData = new BitmapData(bd.width, bd.height, true, 0x00000000);

			shape.graphics.clear();
			shape.graphics.beginBitmapFill(pattern, new Matrix(1, 0, 0, 1), true);
			shape.graphics.drawRect(0, 0, bd.width, bd.height);
			tmp.draw(shape)

			var noise : BitmapData = bd.clone();
			noise.perlinNoise(stripeNoise, stripeNoise, 3, Math.random() * 0xFFFFFF, true, true, 1 | 2 | 4);
			tmp.applyFilter(tmp, tmp.rect, new Point(), new DisplacementMapFilter(noise, new Point, 1, 2, stripeTurbulence, stripeTurbulence));

			bd.draw(tmp);
			noise.noise(Math.random() * 0xFFFFFF, 0, 256, 7, true);

			bd.draw(noise, null, new ColorTransform(1, 1, 1, .3), BlendMode.MULTIPLY);
			material.bitmapData = bd;

			tmp.dispose();
			noise.dispose();
			pattern.dispose();

			return material;
		}

		static public function rust(base : ColorMaterial, mapSize : uint, noiseSIze : Number = 30, alpha : Number = .5, seamless : Boolean = true) : BitmapMaterial {
			var material : BitmapMaterial = cloneMat(base, mapSize);
			var bd : BitmapData = material.bitmapData;

			var rust : BitmapData = bd.clone();
			rust.fillRect(rust.rect, 0);
			rust.perlinNoise(noiseSIze, noiseSIze, 3, Math.random() * 0xFFFFFF, seamless, true, 7, false);

			rust.threshold(rust, rust.rect, new Point(), ">=", 0xFF808080, 0xFFFFFFFF);
			rust.threshold(rust, rust.rect, new Point(), "!=", 0xFFFFFFFF, 0x00000000);

			if ( seamless ) {
				rust = Tiler.quickTile(rust);
			}

			bd.draw(rust, null, new ColorTransform(1, 1, 1, alpha), BlendMode.MULTIPLY);
			material.specularMap = rust;

			return material;
		}

		static private function cloneMat(base : ColorMaterial, size : uint) : BitmapMaterial {
			var baseColor : uint = base.alpha == 1 ? base.color : ( base.alpha * 0xFF ) << 24 | base.color;

			var bd : BitmapData = new BitmapData(size, size, base.alpha == 1 ? false : true, baseColor);

			var material : BitmapMaterial = new BitmapMaterial(bd);

			material.alpha = base.alpha;
			material.gloss = base.gloss;
			material.ambientColor = base.ambientColor;
			material.ambient = base.ambient;
			material.specularColor = base.specularColor;
			material.specular = base.specular;

			material.smooth = true;
			return material;
		}

		/********************************************************************************************
		
		bitmapdata processing utilities
		
		 ********************************************************************************************/
		static public const BITMAP_FILTER_BRIGHTNESS : String = "brightness";
		static public const BITMAP_FILTER_CONTRAST : String = "contrast";
		static public const BITMAP_FILTER_DESTURATE : String = "destaurate";
		static public const BITMAP_FILTER_NEGATIVE : String = "negative";
		static public const BITMAP_FILTER_OUTLINE : String = "outline";
		static public const BITMAP_FILTER_SKETCH : String = "sketch";

		static public function applyBitmapFilter(material : BitmapMaterial, TYPE : String, value : Number = NaN) : BitmapMaterial {
			var filter : Function;
			switch( TYPE ) {
				case BITMAP_FILTER_BRIGHTNESS:
					filter = brightnessFilter;
					break;
				case BITMAP_FILTER_CONTRAST:
					filter = contrastFilter;
					break;
				case BITMAP_FILTER_DESTURATE:
					filter = grayscaleFilter;
					break;
				case BITMAP_FILTER_NEGATIVE:
					filter = negativeFilter;
					break;
				case BITMAP_FILTER_OUTLINE:
					filter = outlineFilter;
					break;
				case BITMAP_FILTER_SKETCH:
					sketchFilter(material.bitmapData);
					return material;
			}

			material.bitmapData.applyFilter(material.bitmapData, material.bitmapData.rect, new Point(), filter(value));
			return material;
		}

		static private function sketchFilter(src : BitmapData) : void {
			var p : Point = new Point;
			var bd : BitmapData = src.clone();
			// bd.draw( src );

			// desaturation + brightness + contrast
			bd.applyFilter(bd, bd.rect, p, grayscaleFilter(NaN));
			bd.applyFilter(bd, bd.rect, p, brightnessFilter(35));
			bd.applyFilter(bd, bd.rect, p, contrastFilter(45));

			// bloom
			// /*
			var bloom : BitmapData = src.clone();
			bloom.applyFilter(bloom, bloom.rect, p, new BlurFilter(10, 10, 3));
			bloom.applyFilter(bloom, bloom.rect, p, grayscaleFilter(NaN));

			// draws the bloom
			bd.draw(bloom, null, new ColorTransform(1, 1, 1, .999), BlendMode.SCREEN);
			// */

			// creates the outlines
			var outlines : BitmapData = src.clone();
			outlines.applyFilter(outlines, outlines.rect, p, outlineFilter(120));
			outlines.applyFilter(outlines, outlines.rect, p, negativeFilter(NaN));
			outlines.applyFilter(outlines, outlines.rect, p, grayscaleFilter(NaN));
			// outlines.threshold( outlines, outlines.rect, p, '<=', 0xFF707070, 0xFF000000 );

			// draws the outlines into the bd
			bd.draw(outlines, null, new ColorTransform(1, 1, 1, .999), BlendMode.MULTIPLY);

			// creates some additionnal noise
			var noise : BitmapData = bd.clone();
			noise.noise(0, 0, 0x80, 7, true);

			// draws the extra noise
			bd.draw(noise, null, new ColorTransform(1, 1, 1, 0.2), BlendMode.ADD);

			// final contrast pass
			bd.applyFilter(bd, bd.rect, p, contrastFilter(55));

			src.fillRect(src.rect, 0);
			src.draw(bd);
		}

		static private function outlineFilter(value : Number = 80) : ConvolutionFilter {
			var q : Number = value / 4;
			return new ConvolutionFilter(3, 3, [0, q, 0, q, -value, q, 0, q, 0], 10);
		}

		static  private function negativeFilter(value : Number) : ColorMatrixFilter {
			return new ColorMatrixFilter([-1, 0, 0, 0, 0xFF, 0, -1, 0, 0, 0xFF, 0, 0, -1, 0, 0xFF, 0, 0, 0, 1, 0]);
		}

		static private function grayscaleFilter(value : Number) : ColorMatrixFilter {
			return new ColorMatrixFilter([.3086, .6094, .0820, 0, 0, .3086, .6094, .0820, 0, 0, .3086, .6094, .0820, 0, 0, 0, 0, 0, 1, 0]);
		}

		static private function brightnessFilter(value : Number) : ColorMatrixFilter {
			return new ColorMatrixFilter([1, 0, 0, 0, value, 0, 1, 0, 0, value, 0, 0, 1, 0, value, 0, 0, 0, 1, 0]);
		}

		static private function contrastFilter(value : Number) : ColorMatrixFilter {
			var a : Number = ( value * 0.01 + 1 )
			var b : Number = 0x80 * ( 1 - a );
			return new ColorMatrixFilter([a, 0, 0, 0, b, 0, a, 0, 0, b, 0, 0, a, 0, b, 0, 0, 0, 1, 0]);
		}
	}
}