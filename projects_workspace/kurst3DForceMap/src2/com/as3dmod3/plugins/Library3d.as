package com.as3dmod3.plugins {
	/**
	 *  Класс Library3d представляет из себя абстрактный 3D-движок с которым взаимодействует
	 *  библиотека AS3Dmod. Этот класс должен быть расширен для каждого конкретного 3D-движка,
	 *  для того чтобы он возвращал корректные значения с которыми будет оперировать AS3Dmod.
	 * 
	 * 	@see com.as3dmod.ModifierStack
	 */
	public class Library3d {
		/** Создает новый экземпляр класса Library3d. */
		public function Library3d() {
		}

		/** Идентификатор 3D-движка. Как правило, это просто имя движка: Papervision3d, Away3d и т.д. */
		public function get id() : String {
			return "";
		}

		/**	Полное имя класса, представляющего из себя меш 3D-движка. */
		public function get meshClass() : String {
			return "";
		}

		/**	Полное имя класса, представляющего из себя одну вершину меша 3D-движка. */
		public function get vertexClass() : String {
			return "";
		}
	}
}