package com.kurst.controls.gallery3d.data {
	import com.gskinner.utils.Rndm;
	import com.lextalkington.util.CircumferencePointGenerator;

	import org.papervision3d.objects.DisplayObject3D;

	/**
	 * @author karim
	 */
	public class RandomGroupData {
		public var id : Number
		public var do3d : DisplayObject3D;
		public var groupName : String;
		public var planes : Array = new Array();
		public var initFirst : Boolean;
		public var counter : Number = 0;
		public var points : Array		;

		public function generatePoint(centerx : Number, centery : Number, circleradius : Number, totalpoints : Number) : void {
			points = CircumferencePointGenerator.getPoints(centerx, centery, circleradius, totalpoints, Rndm.integer(0, 360), 360, CircumferencePointGenerator.CLOCKWISE, false);
		}
	}
}
