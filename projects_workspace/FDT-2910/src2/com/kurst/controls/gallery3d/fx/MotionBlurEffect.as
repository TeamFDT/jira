package com.kurst.controls.gallery3d.fx {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter
	import flash.filters.BitmapFilterQuality
	import flash.geom.Point;
	import flash.geom.ColorTransform

	import org.papervision3d.view.layer.BitmapEffectLayer;
	import org.papervision3d.core.effects.AbstractEffect

	public class MotionBlurEffect extends AbstractEffect {
		private var layer : BitmapEffectLayer;
		private var filter : BitmapFilter;
		private var color : uint;
		private var fadeTransform : ColorTransform;
		private var bf : BlurFilter;
		public var blurLevel : Number = 0.4

		public function MotionBlurEffect() {
			var fadeAmount : Number = .35
			fadeTransform = new ColorTransform(blurLevel, blurLevel, blurLevel, blurLevel);
		}

		public override function attachEffect(layer : BitmapEffectLayer) : void {
			this.layer = BitmapEffectLayer(layer);
			var WIDTH : int = layer.width;
			var HEIGHT : int = layer.height;
		}

		public override function preRender() : void {
		}

		public override function postRender() : void {
			layer.canvas.colorTransform(layer.canvas.rect, fadeTransform);

			layer.canvas.draw(layer.drawLayer, layer.getTranslationMatrix());
		}
	}
}
