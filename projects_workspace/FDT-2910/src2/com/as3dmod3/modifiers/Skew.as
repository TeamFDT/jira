package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.util.ModConstant;
	import com.as3dmod3.util.XMath;

	/**
	 *  <b>Модификатор Skew (скос, склон, наклон).</b> Наклоняет меш не меняя его высоты.
	 *  @author Bartek Drozdz
	 */
	public class Skew extends Modifier implements IModifier {
		private var _force : Number;
		private var _skewAxis : int;
		private var _offset : Number = 0.5;
		private var _constraint : int = ModConstant.NONE;
		private var _power : Number = 1;
		private var _falloff : Number = 1;
		private var _inverseFalloff : Boolean = false;
		private var _oneSide : Boolean = false;
		private var _swapAxes : Boolean = false;

		/**
		 * Создает новый экземпляр класса Skew.
		 * @param	f	cтепень уклона.
		 */
		public function Skew(f : Number = 0) {
			_force = f;
		}

		/** @inheritDoc */
		override public function setModifiable(mod : MeshProxy) : void {
			super.setModifiable(mod);
			_skewAxis = _skewAxis || mod.maxAxis;
		}

		/** Cтепень уклона. */
		public function set force(f : Number) : void {
			_force = f;
		}

		public function get force() : Number {
			return _force;
		}

		/**
		 * 	Ограничение наклона.
		 *  <p>Можно указать один из трех вариантов:</p> 
		 * 	<ul>
		 *  	<li>ModConstraint.NONE (по умолчанию) - вершины меша наклоняются по обеим сторонам от точки смещения.</li>
		 *  	<li>ModConstraint.LEFT - вершины меша наклоняются с левой стороны относительно точки смещения.</li>
		 *  	<li>ModConstraint.RIGHT - вершины меша наклоняются с правой стороны относительно точки смещения.</li>
		 *  </ul>
		 */
		public function get constraint() : int {
			return _constraint;
		}

		public function set constraint(c : int) : void {
			_constraint = c;
		}

		/**
		 * Смещение места наклона.
		 * Это значение может лежать в диапазоне от 0 до 1, где 1 является самым левым краем меша, а 0 - самым правым.
		 * Наклон меша будет происходить в месте, в зависимости от значения, которое имеет это свойство.
		 * По умолчанию, это свойство имеет значение 0.5, что означает что наклон будет происходить в середине меша.
		 */
		public function get offset() : Number {
			return _offset;
		}

		public function set offset(o : Number) : void {
			_offset = XMath.trim(0, 1, o);
		}

		/** Мощность воздействия модификатора. */
		public function get power() : Number {
			return _power;
		}

		public function set power(power : Number) : void {
			_power = Math.max(1, power);
		}

		/** Определяет участок меша на который модификатор не действует. */
		public function get falloff() : Number {
			return _falloff;
		}

		public function set falloff(falloff : Number) : void {
			_falloff = XMath.trim(0, 1, falloff);
		}

		/** Если true, то модификатор наклоняет только стороны меша. */
		public function get oneSide() : Boolean {
			return _oneSide;
		}

		public function set oneSide(oneSide : Boolean) : void {
			_oneSide = oneSide;
		}

		/** Оси, вдоль которых выполняется наклон меша. */
		public function get skewAxis() : int {
			return _skewAxis;
		}

		public function set skewAxis(skewAxis : int) : void {
			_skewAxis = skewAxis;
		}

		/** Меняет местами оси, вдоль которых выполняется наклон меша. */
		public function get swapAxes() : Boolean {
			return _swapAxes;
		}

		public function set swapAxes(spawAxes : Boolean) : void {
			_swapAxes = spawAxes;
		}

		/** Переносит участок на который модификатор не действует на противоположную сторону меша. */
		public function get inverseFalloff() : Boolean {
			return _inverseFalloff;
		}

		public function set inverseFalloff(inverseFalloff : Boolean) : void {
			_inverseFalloff = inverseFalloff;
		}

		/**
		 * Отладочная информация о модификаторе.
		 * @return	информация о модификаторе.
		 */
		public function debug() : String {
			var debugInfo : String = "Skew.debug:\n";
			debugInfo += "_force: " + _force + "\n";
			debugInfo += "_skewAxis: " + _skewAxis + "\n";
			debugInfo += "_offset: " + _offset + "\n";
			debugInfo += "_constraint: " + _constraint + "\n";
			debugInfo += "_power: " + _power + "\n";
			debugInfo += "_falloff: " + _falloff + "\n";
			debugInfo += "_inverseFalloff: " + _inverseFalloff + "\n";
			debugInfo += "_oneSide: " + _oneSide + "\n";
			debugInfo += "_swapAxes: " + _swapAxes + "\n";
			debugInfo += "displaceAxis: " + displaceAxis + "\n";
			return debugInfo;
		}

		/** @inheritDoc */
		public function apply() : void {
			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;

			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;

				if (_constraint == ModConstant.LEFT && v.getRatio(_skewAxis) <= _offset) continue;
				if (_constraint == ModConstant.RIGHT && v.getRatio(_skewAxis) > _offset) continue;

				var r : Number = v.getRatio(_skewAxis) - _offset;
				if (_oneSide) r = Math.abs(r);

				var dr : Number = v.getRatio(displaceAxis);

				if (_inverseFalloff) dr = 1 - dr;

				var f : Number = _falloff + dr * (1 - _falloff);

				var p : Number = Math.pow(Math.abs(r), _power) * XMath.sign(r, 1);
				var vl : Number = v.getValue(displaceAxis) + force * p * f;
				v.setValue(displaceAxis, vl);
			}
		}

		/** Определяет оси, вдоль которых следует выполнять наклон меша. */
		private function get displaceAxis() : int {
			switch(_skewAxis) {
				case ModConstant.X:
					return (_swapAxes) ? ModConstant.Z : ModConstant.Y;
				case ModConstant.Y:
					return (_swapAxes) ? ModConstant.Z : ModConstant.X;
				case ModConstant.Z:
					return (_swapAxes) ? ModConstant.Y : ModConstant.X;
				default:
					return 0;
			}
		}
	}
}