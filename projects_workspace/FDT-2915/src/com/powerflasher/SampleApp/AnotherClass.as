package com.powerflasher.SampleApp {
	/**
	 * @author OSX
	 */
	public class AnotherClass extends AClass{
		ns function foo(param1 : String, param2 : Number) : void // FDT Error : Different parameter count as super function.
		{
			trace('param2: ' + ( param2 ));
			foo(param1);
		}
	}
}
