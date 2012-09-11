package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Modifier;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * <b>Модификатор с пользовательским поведением.</b>
	 * Позволяет пользователям создавать модификаторы на лету, без необходимости написания специализированных классов.
	 * 
	 * @example В приведенном ниже примере показано, как используя модификатор UserDefined
	 * можно перемещать объекты на 10 единиц по оси X:
	 * <listing>
	 * var modifier:UserDefined = new UserDefined;
	 * modifier.addEventListener (Event.CHANGE, onVerticesCoordsChange);
	 * stack.addModifier (modifier);
	 * ...
	 * private function onVerticesCoordsChange (evt:Event):void {
	 * 	var modifier:UserDefined = UserDefined (evt.target);
	 * 	var vertices:Vector.&lt;VertexProxy&gt; = modifier.getVertices ();
	 * 	for each (var vertex:VertexProxy in vertices) {
	 * 		vertex.x += 10;
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @author makc
	 */
	public class UserDefined extends Modifier implements IModifier, IEventDispatcher {
		private var dispatcher : EventDispatcher;

		/** Создает новый экземпляр класса UserDefined. */
		public function UserDefined() {
			dispatcher = new EventDispatcher(this);
		}

		/** @inheritDoc */
		public function apply() : void {
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * Регистрирует объект прослушивателя события на объекте EventDispatcher для получения прослушивателем
		 * уведомления о событии. Можно регистрировать прослушиватели событий в любом узле из списка 
		 * отображения для каждого типа события, фазы и приоритета.
		 * @param	type				тип события.
		 * @param	listener			функция прослушивателя, обрабатывающая событие.
		 * @param	useCapture			определяет, работает ли прослушиватель в фазе захвата или в целевой фазе и в фазе восходящей цепочки.
		 * @param	priority			уровень приоритета прослушивателя событий.
		 * @param	useWeakReference	определяет, является ли ссылка на прослушиватель «сильной» или «слабой».
		 */
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}

		/**
		 * Посылает событие в поток событий. Адресатом события является объект EventDispatcher, 
		 * в котором вызывается dispatchEvent().
		 * @param	evt  	объект события, переданный в поток событий.
		 * @return 			значение равно true до тех пор, пока preventDefault() не будет вызван для события;
		 * 					в этом случае возвращается значение false.
		 */
		public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}

		/**
		 * Проверяет, имеет ли объект EventDispatcher прослушиватели, зарегистрированные для определенного 
		 * типа события. Это позволяет определить, где объект EventDispatcher изменил обработку типа события
		 * в иерархии потока событий. Для определения, действительно ли определенный тип события запускает 
		 * прослушиватель события, следует использовать IEventDispatcher.willTrigger().
		 * @param	type	тип события.
		 * @return 			значение true, если прослушиватель указанного типа зарегистрирован; 
		 * 					в противном случае – false.
		 */
		public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}

		/**
		 * Удаляет прослушиватель из объекта EventDispatcher. При отсутствии прослушивателя, 
		 * зарегистрированного с объектом EventDispatcher, вызов этого метода не оказывает эффекта.
		 * @param	type		тип события.
		 * @param	listener 	удаляемый объект прослушивателя.
		 * @param	useCapture	указывает, был ли слушатель зарегистрирован для фазы захвата или целевой фазы и фазы восходящей цепочки.
		 */
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * Проверяет, зарегистрирован ли прослушиватель события для указанного типа события с данным 
		 * объектом EventDispatcher или любым его предшественником. Этот метод возвращает значение true,
		 * если прослушиватель события запускается в течение любой фазы потока событий, когда событие
		 * указанного типа передается объекту EventDispatcher или любому из его нижестоящих элементов.
		 * @param	type	 тип события.
		 * @return			 значение равно true при запуске прослушивателя указанного типа; 
		 * 					 в противном случае значение равно false.
		 */
		public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}