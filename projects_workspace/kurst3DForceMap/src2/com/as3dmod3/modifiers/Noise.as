package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.util.ModConstant;

	/**
	 * 	<b>Модификатор Noise.</b>
	 *  В случайном порядке смещает вершины меша по всем трем осям координат (или только по некоторым, 
	 *  если вы установите их с помощью свойства constraintAxes).
	 */
	public class Noise extends Modifier implements IModifier {
		private var frc : Number;
		private var axc : int = ModConstant.NONE;
		private var start : Number = 0;
		private var end : Number = 0;

		/**
		 * Создает новый экземпляр класса Noise.
		 * @param	f	сила воздействия модификатора.
		 */
		public function Noise(f : Number = 0) {
			this.force = f;
		}

		/** Сила воздействия модификатора на меш. */
		public function set force(f : Number) : void {
			frc = f;
		}

		public function get force() : Number {
			return frc;
		}

		/** Оси координат, вдоль которых смещаются вершины меша. */
		public function set constraintAxes(c : int) : void {
			this.axc = c;
		}

		public function get constraintAxes() : int {
			return axc;
		}

		/**
		 * Определяет участок меша на котором сила воздействия модификатора плавно уменьшается до 0.
		 * @param	start	начало затухания силы действия модификатора.
		 * @param	end		конец затухания силы действия модификатора.
		 */
		public function setFalloff(start : Number = 0, end : Number = 1) : void {
			this.start = start;
			this.end = end;
		}

		/** Начало затухания силы действия модификатора. */
		public function set falloffStart(start : Number) : void {
			this.start = start;
		}

		public function get falloffStart() : Number {
			return start;
		}

		/** Конец затухания силы действия модификатора. */
		public function set falloffEnd(end : Number) : void {
			this.end = end;
		}

		public function get falloffEnd() : Number {
			return end;
		}

		/** @inheritDoc */
		public function apply() : void {
			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;

			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;
				var r : Number = (Math.random() * force) - (force / 2);

				var p : Number = v.getRatio(mod.maxAxis);
				if (start < end) {
					if (p < start) p = 0;
					if (p > end) p = 1;
				} else if (start > end) {
					p = 1 - p;
					if (p > start) p = 0;
					if (p < end) p = 1;
				} else {
					p = 1;
				}

				if (!(axc & 1)) v.x += r * p;
				if (!(axc >> 1 & 1)) v.y += r * p;
				if (!(axc >> 2 & 1)) v.z += r * p;
			}
		}
	}
}