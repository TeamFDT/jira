package com.powerflasher.SampleApp {
	import flash.display.Sprite;

	public class FDT2889 extends Sprite {

		{trace("run 1st");}

		public function FDT2889() {
			test();
			{trace("run 3rd");}
		}
		
		public static function test():void{
			trace("run 2nd");
		}
	}
}
