package com.powerflasher.profiling.iteration {
	import com.powerflasher.profiling.iteration.item.Item;

	import flash.display.Sprite;
	import flash.utils.setTimeout;

	public class Iterate extends Sprite {
		private static const MAX_ITERATIONS : uint = 3;
		private static const ITEMS_COUNT : uint = 200000;
		private var array : Array = [];
		private var firstItem : *;
		private var functionsToCall : Array;
		private var nextFuncIdx : uint;
		private var iterationCount : uint;

		public function Iterate() {
			functionsToCall = new Array();
			functionsToCall.push(arrayLength);
			functionsToCall.push(arrayLengthCastAs);
			functionsToCall.push(arrayLengthCast);
			functionsToCall.push(arrayLengthAssignCast);
			functionsToCall.push(arrayUint);
			functionsToCall.push(arrayInt);
			functionsToCall.push(arrayUIntAssignCast);
			functionsToCall.push(arrayNumber);
			functionsToCall.push(linkedHasNext);
			functionsToCall.push(linkedNotNull);
			functionsToCall.push(linkedAssignNotNull);
			
			setTimeout(fillArray, 1000);
		}

		private function start() : void {
			var funcIdx : uint = nextFuncIdx % functionsToCall.length;
			if(funcIdx == 0) {
				iterationCount++;
				trace("start iteration: " + iterationCount);
			}
			
			if(iterationCount <= MAX_ITERATIONS) {
				setTimeout(functionsToCall[funcIdx], 500);
				trace(" function: " + funcIdx);
				nextFuncIdx++;
			} else {
				trace("done");
			}
		}

		private function fillArray() : void {
			trace("fill array ...");
			var item : Item = new Item("Item " + 0);
			for (var i : int = 1;i < ITEMS_COUNT;i++) {
				item.nextItem = new Item("Item " + i);
				array.push(item);
				item = item.nextItem;
			}
			firstItem = array[0];
			setTimeout(start, 100);
		}

		private function arrayLength() : void {
			var s : String;
			for (var i : int = 0;i < array.length;i++) {
				s = array[i].info();
			}
			setTimeout(start, 100);
		}

		private function arrayLengthCastAs() : void {
			var s : String;
			for (var i : int = 0;i < array.length;i++) {
				s = (array[i] as Item).info();
			}
			setTimeout(start, 100);
		}

		private function arrayLengthCast() : void {
			var s : String;
			for (var i : int = 0;i < array.length;i++) {
				s = (Item(array[i])).info();
			}
			setTimeout(start, 100);
		}

		private function arrayLengthAssignCast() : void {
			var item : Item;
			var s : String;
			for (var i : int = 0;i < array.length;i++) {
				item = (Item(array[i]));
				s = item.info();
			}
			setTimeout(start, 100);
		}

		private function arrayUint() : void {
			var length : uint = array.length;
			var s : String;
			for (var i : uint = 0;i < length;i++) {
				s = (Item(array[i])).info();
			}
			setTimeout(start, 100);
		}

		private function arrayInt() : void {
			var length : int = array.length;
			var s : String;
			for (var i : int = 0;i < length;i++) {
				s = (Item(array[i])).info();
			}
			setTimeout(start, 100);
		}

		private function arrayNumber() : void {
			var length : Number = array.length;
			var s : String;
			for (var i : Number = 0;i < length;i++) {
				s = (Item(array[i])).info();
			}
			setTimeout(start, 100);
		}

		private function arrayUIntAssignCast() : void {
			var length : uint = array.length;
			var s : String;
			var item : Item;
			for (var i : uint = 0;i < length;i++) {
				item = (Item(array[i]));
				s = item.info();
			}
			setTimeout(start, 100);
		}

		
		private function linkedHasNext() : void {
			var item : Item = firstItem; //array[0];
			var s : String;
			while(item.hasNext()) {
				s = item.info();
				item = item.nextItem;
			}
			setTimeout(start, 100);
		}

		private function linkedNotNull() : void {
			var item : Item = firstItem; //array[0];
			var s : String;
			while(item != null) {
				s = item.info();
				item = item.nextItem;
			}
			setTimeout(start, 100);
		}

		private function linkedAssignNotNull() : void {
			var item : Item = firstItem; //array[0];
			var s : String = item.info();
			while((item = item.nextItem) != null) {
				s = item.info();
			}
			setTimeout(start, 100);
		}
	}
}
