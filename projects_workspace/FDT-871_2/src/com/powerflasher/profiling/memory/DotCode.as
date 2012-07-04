package com.powerflasher.profiling.memory {
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.sliderClasses.Slider;
	import mx.core.UIComponent;
	import mx.events.SliderEvent;

	public class DotCode extends VBox {
		
		public var colorLabel : Label;
		
		public var radius : uint;
		public var color : uint;
		public var alphaSlider:Slider;
		
		private var _uic : UIComponent;

		protected function draw() : void {
			_uic = new UIComponent();
			_uic.graphics.beginFill(color);
			_uic.graphics.drawCircle(colorLabel.width*0.5, radius, radius);
			_uic.graphics.endFill();
			addChild(_uic);
			
			colorLabel.text = color.toString(16);
			
			alphaSlider.addEventListener(SliderEvent.THUMB_DRAG, onAlphaChange); // strong reference
//			alphaSlider.addEventListener(SliderEvent.THUMB_DRAG, onAlphaChange, false, 0, true);	// weak reference
		}

		private function onAlphaChange(event : SliderEvent) : void {
			_uic.alpha = event.value;
		}
	}
}
