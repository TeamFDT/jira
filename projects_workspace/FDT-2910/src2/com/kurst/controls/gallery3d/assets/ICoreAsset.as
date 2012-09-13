package com.kurst.controls.gallery3d.assets {
	import org.papervision3d.materials.MovieMaterial

	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	/**
	 * @author karimbeyrouti
	 */
	public interface ICoreAsset {
		function addImage(bm : Bitmap) : void

		function destroy() : void

		function unSelect() : void

		function get data() : Object

		function set data(data : Object) : void

		function get isSelected() : Boolean

		function set isSelected(isSelected : Boolean) : void

		function get movieMaterial() : MovieMaterial

		function set movieMaterial(movieMaterial : MovieMaterial) : void

		function MouseRollOver() : void

		function MouseRollOut() : void

		function MouseDown(e : MouseEvent = null) : void

		function MouseUpEvent(e : MouseEvent = null) : void

		function get bitmap() : Bitmap
	}
}
