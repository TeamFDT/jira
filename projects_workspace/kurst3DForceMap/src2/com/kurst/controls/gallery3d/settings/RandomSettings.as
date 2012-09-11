/******************************************************************************************************************************************************************************** *  * Class Name  	: com.kurst.controls.gallery3d.settings.GridSettings * Version 	  	: 1 * Description 	: Grid Settings Class *  ******************************************************************************************************************************************************************************** *  * Author 		: Kb * Date 			: 27/05/09 *  ******************************************************************************************************************************************************************************** * *		 ********************************************************************************************************************************************************************************* **********************************************************************************************************************************************************************************/package com.kurst.controls.gallery3d.settings {	import com.greensock.easing.Quad;	import com.greensock.easing.Quart	public class RandomSettings {		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// Random Settings		public var scale : Number = .4;		public var radius : Number = 2000;		public var animationCameraSpeed : Number = 3;		public var animationSameGroupCameraSpeed : Number = 1.5		// 2.5		public var animationSelectTime : Number = .5;		public var animationHideTime : Number = 2		public var thumbnailQuality : Number = 5		public var distanceFromSelectedImage : Number = 350;		public var animationEasingFunction : Function = Quad.easeInOut;		public var groupItemSpacing : Number = 200;		public var groupItemSpacingMin : Number = 200;		public var groupItemSpacingMax : Number = 300;		public var groupSpacingRadius : Number = 190;		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// CONSTRUCTOR		public function RandomSettings() : void {		}	}}