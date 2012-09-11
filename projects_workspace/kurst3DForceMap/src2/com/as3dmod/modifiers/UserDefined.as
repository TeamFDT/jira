package com.as3dmod.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Modifier;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * <b>Modifier with user-defined behavior.</b>
	 * 
	 * Allows users to create modifiers on the fly without creating dedicated class.
	 * 
	 * @example The following example demonstrates how to use UserDefined modifier
	 * to shift objects by 10 units along X axis:
	 * <listing>
	 * var modifier:UserDefined = new UserDefined;
	 * modifier.addEventListener (Event.CHANGE, onVerticesCoordsChange);
	 * stack.addModifier (modifier);
	 * ...
	 * private function onVerticesCoordsChange (evt:Event):void {
	 * 	var modifier:UserDefined = UserDefined (evt.target);
	 * 	var vertices:Array = modifier.getVertices ();
	 * 	for each (var vertex:VertexProxy in vertices) {
	 * 		vertex.x += 10;
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @author makc
	 */
	public class UserDefined extends Modifier implements IModifier, IEventDispatcher {
		private var dispatcher : EventDispatcher;

		/**
		 * @private no parameters to document
		 */
		public function UserDefined() {
			dispatcher = new EventDispatcher(this);
		}

		/**
		 * @inheritDoc
		 */
		public function apply() : void {
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}

		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}