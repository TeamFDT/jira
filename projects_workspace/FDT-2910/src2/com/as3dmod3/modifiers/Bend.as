package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.util.ModConstant;

	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 	<b>Модификатор Bend.</b> Cгибает меш вдоль одной из оси координат.
	 * 	@version 2.1
	 * 	@author Bartek Drozdz
	 * 	
	 * 	Изменения:
	 * 	2.1 - Параметры вращения теперь используют класс Matrix.
	 * 	2.0 - Добавлен параметр angle, задающий угол изгиба.
	 */
	public class Bend extends Modifier implements IModifier {
		private var _force : Number;
		private var _offset : Number;
		private var _angle : Number;
		private var _diagAngle : Number;
		private var _constraint : int = ModConstant.NONE;
		private var max : int;
		private var min : int;
		private var mid : int;
		private var width : Number;
		private var height : Number;
		private var origin : Number;
		private var m1 : Matrix;
		private var m2 : Matrix;
		private var _switchAxes : Boolean = false;

		/**
		 * Создает новый экземпляр класса Bend.
		 * @param	f 	сила воздействия модификатора на меш.
		 * @param	o 	смещение места сгиба.
		 * @param	a	угол изгиба относительно вертикальной плоскости.
		 */
		public function Bend(f : Number = 0, o : Number = 0.5, a : Number = 0) {
			_force = f;
			_offset = o;
			angle = a;
		}

		/** @inheritDoc */
		override public function setModifiable(mod : MeshProxy) : void {
			super.setModifiable(mod);
			switchAxes = _switchAxes;
		}

		/** Переключает ось вдоль которой осуществляется сгиб.*/
		public function get switchAxes() : Boolean {
			return _switchAxes;
		}

		public function set switchAxes(value : Boolean) : void {
			max = value ? mod.midAxis : mod.maxAxis;
			min = mod.minAxis;
			mid = value ? mod.maxAxis : mod.midAxis;

			width = mod.getSize(max);
			height = mod.getSize(mid);
			origin = mod.getMin(max);

			_diagAngle = Math.atan(width / height);

			_switchAxes = value;
		}

		/**
		 *  Сила воздействия модификатора на меш.
		 *  0 = нет воздействия, 1 = 180 градусов, 2 = 360 градусов и т.д.
		 *  Отрицательные значения также могут использоваться.
		 */
		public function set force(f : Number) : void {
			_force = f;
		}

		public function get force() : Number {
			return _force;
		}

		/**
		 *  Смещение места сгиба.
		 *  Это значение может лежать в диапазоне от 0 до 1, где 1 является самым левым краем меша, а 0 - самым правым.
		 *  Сгиб меша будет происходить в месте, в зависимости от значения, которое имеет это свойство.
		 *  По умолчанию, это свойство имеет значение 0.5, что означает что сгиб будет происходить в середине меша.
		 */
		public function get offset() : Number {
			return _offset;
		}

		public function set offset(offset : Number) : void {
			_offset = offset;
		}

		/**
		 * 	Ограничение сгиба.
		 *  <p>Можно указать один из трех вариантов:</p> 
		 * 	<ul>
		 *  	<li>ModConstraint.NONE (по умолчанию) - вершины меша сгибаются по обеим сторонам от точки смещения.</li>
		 *  	<li>ModConstraint.LEFT - вершины меша сгибаются с левой стороны относительно точки смещения.</li>
		 *  	<li>ModConstraint.RIGHT - вершины меша сгибаются с правой стороны относительно точки смещения.</li>
		 *  </ul>
		 */
		public function set constraint(c : int) : void {
			_constraint = c;
		}

		public function get constraint() : int {
			return _constraint;
		}

		/** Угол диагонали меша. */
		public function get diagAngle() : Number {
			return _diagAngle;
		}

		/** Угол изгиба относительно вертикальной плоскости. Задается в радианах. */
		public function get angle() : Number {
			return _angle;
		}

		public function set angle(a : Number) : void {
			_angle = a;
			m1 = new Matrix();
			m1.rotate(_angle);
			m2 = new Matrix();
			m2.rotate(-_angle);
		}

		/** @inheritDoc */
		public function apply() : void {
			if (force == 0) return;

			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;

			var distance : Number = origin + width * offset;
			var radius : Number = width / Math.PI / force;
			var bendAngle : Number = Math.PI * 2 * (width / (radius * Math.PI * 2));

			for (var i : int = 0; i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;

				var vmax : Number = v.getValue(max);
				var vmid : Number = v.getValue(mid);
				var vmin : Number = v.getValue(min);

				var np : Point = m1.transformPoint(new Point(vmax, vmid));
				vmax = np.x;
				vmid = np.y;

				var p : Number = (vmax - origin) / width;

				if ((constraint == ModConstant.LEFT && p <= offset) || (constraint == ModConstant.RIGHT && p >= offset)) {
				} else {
					var fa : Number = ((Math.PI / 2) - bendAngle * offset) + (bendAngle * p);
					var op : Number = Math.sin(fa) * (radius + vmin);
					var ow : Number = Math.cos(fa) * (radius + vmin);
					vmin = op - radius;
					vmax = distance - ow;
				}

				var np2 : Point = m2.transformPoint(new Point(vmax, vmid));
				vmax = np2.x;
				vmid = np2.y;

				v.setValue(max, vmax);
				v.setValue(mid, vmid);
				v.setValue(min, vmin);
			}
		}
	}
}