package com.as3dmod3 {
	/**
	 * <p><h2>IMeshInfo</h2></p>
	 * 
	 * <p>Содержит основную информацию о меше (размер, позицию).</p>
	 * 
	 * 	@version 1.0
	 * 	@author Bartek Drozdz
	 */
	public interface IMeshInfo {
		/** Минимальная граница меша по оси X. */
		function get minX() : Number;

		/** Минимальная граница меша по оси Y. */
		function get minY() : Number;

		/** Минимальная граница меша по оси Z. */
		function get minZ() : Number;

		/** Максимальная граница меша по оси X. */
		function get maxX() : Number;

		/** Максимальная граница меша по оси Y. */
		function get maxY() : Number;

		/** Максимальная граница меша по оси Z. */
		function get maxZ() : Number;

		/** Размеры меша по оси X. */
		function get width() : Number;

		/** Размеры меша по оси Y. */
		function get height() : Number;

		/** Размеры меша по оси Z. */
		function get depth() : Number;
	}
}