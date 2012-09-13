package com.kurst.ai.data {
	import com.kurst.utils.NumberUtils;

	import soulwire.ai.AwayBoid;

	import flash.geom.Vector3D;

	public class BoidProp {
		public function BoidProp() {
		}

		public var boundsCentre 		: Vector3D = new Vector3D(0, 0, 0);
		public var minForce 			: Number = 2.0;
		public var maxForce 			: Number = 6.0;
		public var minSpeed 			: Number = 6.0;
		public var maxSpeed 			: Number = 16.0;
		public var minWanderDistance 	: Number = 10.0;
		public var maxWanderDistance 	: Number = 100.0;
		public var minWanderRadius 		: Number = 500.0;
		public var maxWanderRadius 		: Number = 1100.0;
		public var minWanderStep 		: Number = 0.1;
		public var maxWanderStep 		: Number = 2;
		public var boundsRadius 		: Number = 500;
		public var radius 				: Number = 3;
		public var initPos 				: Vector3D = new Vector3D(NumberUtils.randomRange(-100, 100), NumberUtils.randomRange(-100, 100), NumberUtils.randomRange(-100, 100));
		public var velocity 			: Vector3D = new Vector3D(NumberUtils.randomRange(-.1, .1), NumberUtils.randomRange(-.1, .1), NumberUtils.randomRange(-.1, .1));
		public var edgeBehavior 		: String = AwayBoid.EDGE_WRAP;
	}
}
