package triga.render {
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.ColorMatrixMethod;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FresnelSpecularMethod;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class MaterialHelper {
		static public var MAT_BRASS : ColorMaterial = initMaterial(0.329412, 0.223529, 0.027451, 0.780392, 0.568627, 0.113725, 0.992157, 0.941176, 0.807843, 1, 27.8974);
		static public var MAT_BRONZE : ColorMaterial = initMaterial(0.2125, 0.1275, 0.054, 0.714, 0.4284, 0.18144, 0.393548, 0.271906, 0.166721, 1, 25.6);
		static public var MAT_POLISHED_BRONZE : ColorMaterial = initMaterial(0.25, 0.148, 0.06475, 0.4, 0.2368, 0.1036, 0.774597, 0.458561, 0.200621, 1, 76.8, true);
		static public var MAT_CHROME : ColorMaterial = initMaterial(0.25, 0.25, 0.25, 0.4, 0.4, 0.4, 0.774597, 0.774597, 0.774597, 1, 76.8);
		static public var MAT_COPPER : ColorMaterial = initMaterial(0.19125, 0.0735, 0.0225, 0.7038, 0.27048, 0.0828, 0.256777, 0.137622, 0.086014, 1, 12.8);
		static public var MAT_POLISHED_COPPER : ColorMaterial = initMaterial(0.2295, 0.08825, 0.0275, 0.5508, 0.2118, 0.066, 0.580594, 0.223257, 0.0695701, 1, 51.2, true);
		static public var MAT_GOLD : ColorMaterial = initMaterial(0.24725, 0.1995, 0.0745, 0.75164, 0.60648, 0.22648, 0.628281, 0.555802, 0.366065, 1, 51.2);
		static public var MAT_POLISHED_GOLD : ColorMaterial = initMaterial(0.24725, 0.2245, 0.0645, 0.34615, 0.3143, 0.0903, 0.797357, 0.723991, 0.208006, 1, 83.2, true);
		static public var MAT_PEWTER : ColorMaterial = initMaterial(0.105882, 0.058824, 0.113725, 0.427451, 0.470588, 0.541176, 0.333333, 0.333333, 0.521569, 1, 9.84615, true);
		static public var MAT_SILVER : ColorMaterial = initMaterial(0.19225, 0.19225, 0.19225, 0.50754, 0.50754, 0.50754, 0.508273, 0.508273, 0.508273, 1, 51.2);
		static public var MAT_POLISHED_SILVER : ColorMaterial = initMaterial(0.23125, 0.23125, 0.23125, 0.2775, 0.2775, 0.2775, 0.773911, 0.773911, 0.773911, 1, 89.6, true);
		static public var MAT_EMERALD : ColorMaterial = initMaterial(0.0215, 0.1745, 0.0215, 0.07568, 0.61424, 0.07568, 0.633, 0.727811, 0.633, 0.55, 76.8);
		static public var MAT_JADE : ColorMaterial = initMaterial(0.135, 0.2225, 0.1575, 0.54, 0.89, 0.63, 0.316228, 0.316228, 0.316228, 0.95, 12.8);
		static public var MAT_OBSIDIAN : ColorMaterial = initMaterial(0.05375, 0.05, 0.06625, 0.18275, 0.17, 0.22525, 0.332741, 0.328634, 0.346435, 0.82, 38.4);
		static public var MAT_PEARL : ColorMaterial = initMaterial(0.25, 0.20725, 0.20725, 1, 0.829, 0.829, 0.296648, 0.296648, 0.296648, 0.922, 11.264);
		static public var MAT_RUBY : ColorMaterial = initMaterial(0.1745, 0.01175, 0.01175, 0.61424, 0.04136, 0.04136, 0.727811, 0.626959, 0.626959, 0.55, 76.8);
		static public var MAT_TURQUOISE : ColorMaterial = initMaterial(0.1, 0.18725, 0.1745, 0.396, 0.74151, 0.69102, 0.297254, 0.30829, 0.306678, 0.8, 12.8, true);
		static public var MAT_RUBBER_BLACK : ColorMaterial = initMaterial(0.02, 0.02, 0.02, 0.01, 0.01, 0.01, 0.4, 0.4, 0.4, 1, 10);
		static public const MAT_LIST : Vector.<ColorMaterial> = Vector.<ColorMaterial>([MAT_BRASS, MAT_BRONZE, MAT_POLISHED_BRONZE, MAT_CHROME, MAT_COPPER, MAT_POLISHED_COPPER, MAT_GOLD, MAT_POLISHED_GOLD, MAT_PEWTER, MAT_SILVER, MAT_POLISHED_SILVER, MAT_EMERALD, MAT_JADE, MAT_OBSIDIAN, MAT_PEARL, MAT_RUBY, MAT_RUBBER_BLACK, MAT_TURQUOISE]);

		static private function initMaterial(ar : Number, ag : Number, ab : Number, dr : Number, dg : Number, db : Number, sr : Number, sg : Number, sb : Number, alpha : Number, shininess : Number, polished : Boolean = false) : ColorMaterial {
			var material : ColorMaterial = new ColorMaterial(( dr * 0xFF ) << 16 | ( dg * 0xFF ) << 8 | ( db * 0xFF ), alpha);

			material.ambientColor = ( ar * 0xFF ) << 16 | ( ag * 0xFF ) << 8 | ( ab * 0xFF );

			material.specularColor = ( sr * 0xFF ) << 16 | ( sg * 0xFF ) << 8 | ( sb * 0xFF );

			material.gloss = shininess;

			if ( polished ) material.specularMethod = new FresnelSpecularMethod(true);

			return material;
		}

		static public function bitmapAssetMaterial(bitmapData : BitmapData, transparent : Boolean = true, smooth : Boolean = false) : BitmapMaterial {
			var material : BitmapMaterial = new BitmapMaterial(bitmapData, smooth, false, true);
			material.alphaBlending = transparent;
			return material;
		}

		static public function noise(size : int = 256, grayscale : Boolean = true, transparent : Boolean = true, smooth : Boolean = false) : BitmapMaterial {
			var bitmapData : BitmapData = new BitmapData(size, size, transparent, 0);
			bitmapData.noise(Math.random() * 0xFFFFFFFF, 0, 0xFF, ( transparent ? 1 | 2 | 4 | 8 : 1 | 2 | 4 ), grayscale);

			var material : BitmapMaterial = new BitmapMaterial(bitmapData, false, false, true);
			material.alphaBlending = transparent;

			return material;
		}

		static public function perlinNoise(size : int = 256, baseX : Number = 64, baseY : Number = 64, octaves : int = 3, transparent : Boolean = true, grayscale : Boolean = false, smooth : Boolean = false) : BitmapMaterial {
			var bitmapData : BitmapData = new BitmapData(size, size, transparent, 0);
			bitmapData.perlinNoise(baseX, baseY, octaves, Math.random() * 0xFFFFFFFF, true, true, ( transparent ? 1 | 2 | 4 | 8 : 1 | 2 | 4 ), grayscale);

			var material : BitmapMaterial = new BitmapMaterial(bitmapData, smooth, false, true);
			material.alphaBlending = transparent;

			return material;
		}

		static public function verticalGradient(size : uint, colors : Array) : BitmapMaterial {
			var tmp : BitmapData = new BitmapData(1, colors.length, true, 0);

			for ( var i : int = 0; i < colors.length; i++ ) {
				tmp.setPixel32(0, i, colors[ i ]);
			}

			var bd : BitmapData = new BitmapData(size, size, true, 0);
			bd.draw(tmp, new Matrix(size, 0, 0, 1 / ( colors.length / size )), null, null, null, true);

			return bitmapAssetMaterial(bd, true, true);
		}

		static public function horizontalGradient(size : uint, colors : Array) : BitmapMaterial {
			var tmp : BitmapData = new BitmapData(colors.length, 1, true, 0);
			for ( var i : int = 0; i < colors.length; i++ ) tmp.setPixel32(i, 0, colors[ i ]);

			var bd : BitmapData = new BitmapData(size, size, true, 0);
			bd.draw(tmp, new Matrix(1 / ( colors.length / size ), 0, 0, size), null, null, null, true);

			return bitmapAssetMaterial(bd, true, true);
		}

		static public function createEnvrionmentMap(material : DefaultMaterialBase, bitmapData : BitmapData, specularMaterial : Number = NaN, environmentAlpha : Number = NaN, fresnelSpecular : Boolean = true) : DefaultMaterialBase {
			material.gloss = 90;
			if ( fresnelSpecular ) material.specularMethod = new FresnelSpecularMethod(true);
			if ( !isNaN(specularMaterial) ) material.specular = specularMaterial;
			material.addMethod(new EnvMapMethod(CubeMapUtils.createCubeMap(bitmapData), !isNaN(environmentAlpha) ? environmentAlpha : .1));
			material.ambient = .5;
			return material;
		}
	}
}