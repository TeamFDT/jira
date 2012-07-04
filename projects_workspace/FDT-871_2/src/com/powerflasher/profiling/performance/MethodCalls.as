package com.powerflasher.profiling.performance {
	import flash.display.Sprite;

	/**
	 * @author Meinhard Gredig
	 */
	public class MethodCalls extends Sprite {
		public function MethodCalls() {
			start();
		}
		
		private function start() : void {
			one();
			two();
			three();
			one();
			trace("DONE");
		}

		private function one() : void {
			oneA();
			var x:int = 0;
			for (var i : int = 0; i < 20000; i++) {
				x += 5;
				x /= 2;
			}
			oneB();
		}
		
		private function oneA() : void {
				oneB();
			var x:int = 0;
			for (var i : int = 0; i < 200000; i++) {
				x += 5;
				x /= 2;
			}
				oneB();
		}

		private function oneB() : void {
			var x:int = 0;
			for (var i : int = 0; i < 400000; i++) {
				x += 5;
				x /= 2;
			}
		}

		private function two() : void {
			var x:int = 0;
			for (var i : int = 0; i < 200000; i++) {
				x += 5;
				x /= 2;
			}
		}

		private function three() : void {
			var x:int = 0;
			for (var i : int = 0; i < 300000; i++) {
				x += 5;
				x /= 2;
			}
		}
	}
}
