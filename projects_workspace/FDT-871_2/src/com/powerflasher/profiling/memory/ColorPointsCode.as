package com.powerflasher.profiling.memory {
	import mx.containers.Box;
	import mx.controls.sliderClasses.Slider;
	import mx.core.Application;

	/**
	 * @author Meinhard Gredig
	 */
	public class ColorPointsCode extends Application {
		public var imageBox:Box;
		public var alphaSlider:Slider;
		
		protected function onClick():void {
			imageBox.removeAllChildren();
			for (var i : int = 0; i < 5; i++) {

				var r:uint = (Math.random() * 0x99) << 16;
				var g:uint = (Math.random() * 0x99) << 8;
				var b:uint = (Math.random() * 0x99);
				
				var rgb:uint = (r | g | b);
				trace('rgb: ' + (rgb));
				
				var dot:Dot = new Dot();
				dot.color = rgb;
				dot.radius = 20;
				alphaSlider.value = 1;
				dot.alphaSlider = alphaSlider;
				imageBox.addChild(dot);
			}
		}
	}
}
