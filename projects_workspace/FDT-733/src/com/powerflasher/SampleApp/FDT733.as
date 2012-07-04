package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT733 extends Sprite {
		public function FDT733() {
			trace('FDT733: ' + (FDT733));
			
			var xml:XML = <TestClass xmlns="XAMLTesting" 
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 
xmlns:sys="clr-namespace:System;assembly=mscorlib">
<TestClass.mapVariable><x:String x:Key="Hallo">Hallo</x:String>
</TestClass.mapVariable></TestClass>;
		}
	}
}
