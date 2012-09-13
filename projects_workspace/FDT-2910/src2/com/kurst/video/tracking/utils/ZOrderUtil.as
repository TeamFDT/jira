/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.video.tracking.utils.ZOrderUtil
 * Version 	  	: 1
 * Description 	: zSort tracking containers
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 07/11/11
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	static function addTraker( container : Sprite , data : TimelineDataItem ) : void
 * 	static function removeTraker( data : TimelineDataItem ) : void
 *
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.utils {
	import com.kurst.video.tracking.data.Tracker;
	import com.kurst.video.tracking.data.render.ZOrderDataItem;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class ZOrderUtil {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private static var zOrderItems : Vector.<ZOrderDataItem> = new Vector.<ZOrderDataItem>();

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 *  add a tracker to the depth sort utility, and run depth sort
		 * 
		 * @param container : Sprite 		- track container
		 * @param data : TimelineDataItem 	- Timeline data to add to zSort;
		 *  
		 */
		public static function addTraker(container : Sprite, data : Tracker) : void {
			if ( data.nestChildName == null ) {
				// Screen out nested trackers

				removeTraker(data);

				var item : ZOrderDataItem = new ZOrderDataItem();
				item.container = container;
				item.timelineDataItem = data;
				zOrderItems.push(item);

				depthSortTrackers();
			}
		}

		/**
		 * 
		 * remove a tracker from depth sort utility 
		 * 
		 * @param data : TimelineDataItem - Tracker to remove
		 */
		public static function removeTraker(data : Tracker) : void {
			for ( var c : int = 0 ; c < zOrderItems.length ; c++ ) {
				if ( zOrderItems[c].timelineDataItem == data ) {
					zOrderItems[c].timelineDataItem = null;
					zOrderItems[c].container = null;
					zOrderItems.splice(c, 1);

					return;
				}
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * Depth sort tracking containers using zOrder 
		 * 
		 */
		private static function depthSortTrackers() : void {
			var parent : DisplayObjectContainer;
			var a : Tracker;
			var b : Tracker;
			var ca : Sprite;
			var cb : Sprite;

			for ( var i : int = 0 ; i < zOrderItems.length - 1 ; i++ ) {
				for (var j : int = i + 1 ; j < zOrderItems.length ; j++ ) {
					a = zOrderItems [i].timelineDataItem;
					b = zOrderItems [j].timelineDataItem;
					ca = zOrderItems [i].container;
					cb = zOrderItems [j].container;

					if ( !parent )
						parent = zOrderItems [i].container.parent as DisplayObjectContainer;

					if ( parent.contains(ca) && parent.contains(cb))
						if ( ( a.zOrder > b.zOrder ) != ( parent.getChildIndex(ca) > parent.getChildIndex(cb) ) )
							parent.swapChildren(ca, cb);
				}
			}
		}
	}
}