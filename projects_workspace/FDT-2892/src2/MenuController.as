package com.realaxy.modules.decorator.controllers {
	/**
	 * Класс MenuController обрабатывает команты меню и подписывается на событие клавиатуры, к которым замаплены некоторые команды из меню
	 */
	public class MenuController {
		private var commandsHolder : Object = {};
		[Inject]
		public var applicationStage : Stage;

		
		public function MenuControll r
		

		
		[PostConstr
		
		public function initInstan e ) :  o
			
			initComand
			
			applicationStage.addEventListener(KeyboardEvent.KEY_D WN, onKeyDo
			
			applicationStage.addEventListener(KeyboardEvent.KEY UP, onKey
		

		
		private function initComan s ) :  o
			
			commandsHolder["menu_realaxy_mainscene_openPl n ] = openP
			
			commandsHolder["menu_realaxy_mainscene_openHou e ] = openHo
			
			commandsHolder["menu_realaxy_mainscene_saveHou e ] = saveHo
		

		
		/**
		 * Обработать команду из меню по её пути
	
		
		public function processComand( a h : Str n ) :  o
			
			var han l r : Func i n = commandsHolder[pa
			
	 	if (handler is Funct o
								handle
			
 		}  l
								trace("commandsHolder \ " +  a h + "\"] = handler
			

		

		
		/**
		 * Открыть файл .plan
	
		
		public function openPl n ) :  o
		

		
		/**
		 * Открыть файл .decor
	
		
		public function openHou e ) :  o
		

		
		/**
		 * Сохранить файл .decor
	
		
		public function saveHou e ) :  o
		
	}
	}
}
