package com.kurst.video.tracking.renderer {
	import com.kurst.video.tracking.data.Tracker;

	/**
	 * @author karimbeyrouti
	 */
	public interface IRenderer {
		function init(timelineData : Tracker) : void ;

		function render(frame : int) : void ;

		function destroy() : void ;

		function updateData(timelineData : Tracker) : void ;
	}
}
