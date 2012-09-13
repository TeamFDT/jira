package com.as3dmod {
	/**
	 * <p><h2>IMeshInfo</h2>
	 * 
	 * <p>Provides basic information about a mesh (size, position) 
	 * 
	 * 	@version 1.0
	 * 	@author Bartek Drozdz
	 */
	public interface IMeshInfo {
		function get minX() : Number;

		function get minY() : Number;

		function get minZ() : Number;

		function get maxX() : Number;

		function get maxY() : Number;

		function get maxZ() : Number;

		function get width() : Number;

		function get height() : Number;

		function get depth() : Number;
	}
}
