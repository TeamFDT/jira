package com.powerflasher.SampleApp
{
	import flash.display.Sprite;
	
	public class Test extends Sprite
	{
		public function Test()
		{
			var a:A = new A();
			
			
			var sprite : DisplayObject = a.b.c.test();
			addChild(sprite);
		}
	}
}
