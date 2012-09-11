package com.kurst.visuals.events {
	import flash.events.Event;

	/**
	 * @author karim
	 */
	public class ParticleControllerEvent extends Event {
		public static const PARTICLES_DETACHED : String = "ParticleControllerEvent_PARTICLES_DETACHED";
		public static const PARTICLES_ATTACHED : String = "ParticleControllerEvent_PARTICLES_ATTACHED";

		public function ParticleControllerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
