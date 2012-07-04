package com.powerflasher.profiling.type {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	public class TypeSafe extends Sprite {
		private var p1 : Object;
		private var p2;
		private var p3 : Point;
		public function TypeSafe() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

		private function handleAddedToStage(event : Event) : void {
			p1 = {x:10, y:10};
			p2 = new Point(10,10);
			p3 = new Point(10,10);
			
			setTimeout(iterateObject, 100);
		}

		private function iterateObject() : void {
			for (var i : int = 0; i < 1000000; i++) {
				var a : * = p1.x;
			}
			setTimeout(iterateUntyped, 100);
		}

		private function iterateUntyped() : void {
			for (var i : int = 0; i < 1000000; i++) {
				var a : * = p2.x;
			}
			setTimeout(iterateCasted, 100);
		}

		private function iterateCasted() : void {
			for (var i : int = 0; i < 1000000; i++) {
				var a : * = Point(p2).x;
			}
			setTimeout(iterateTyped, 100);
		}

		private function iterateTyped() : void {
			for (var i : int = 0; i < 1000000; i++) {
				var a : * = p3["x"];
			}
			setTimeout(finish, 100);
		}

		private function finish() : void {
			trace("DONE");
		}
	}
}
