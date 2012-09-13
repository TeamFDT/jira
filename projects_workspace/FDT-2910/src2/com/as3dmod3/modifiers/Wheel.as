package com.as3dmod3.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.Matrix4;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.Vector3;
	import com.as3dmod3.core.VertexProxy;

	/**
	 * 	<b>Модификатор Wheel.</b> Используйте его для колес модели транспортного средства.
	 * 	<br>
	 * 	<p>У 3D колес автомобиля существует известная проблема, если предполагается поворачивать
	 * 	(рулить) и вращать его в одно и тоже время. Например, возьмем этот код:
	 * 	<br>
	 * 	<br><code><pre>
	 * 	wheel.rotationY = 10; // Поворачиваем колесо на 10 градусов влево
	 * 	wheel.rotationZ +- 5; // Вращаем колесо со скоростью 5
	 * 	</pre></code><br>
	 * 	В этом случае колесо будет катиться неправильно.</p>
	 * 	
	 * 	<p>Обычно, эта проблема решается таким способом. Колесо добавляется в другой Mesh, 
	 * 	поворачивается родитель и вращается само колесо, как показано ниже:
	 * 	<br><code><pre>
	 * 	steer.rotationY = 10; // Поворачиваем колесо на 10 градусов влево
	 * 	steer.wheel.rotationZ +- 5; // Вращаем колесо со скоростью 5
	 * 	</pre></code><br>
	 * 	В этом случае, колесо будет вести себя правильно. Но так делать может быть несовсем удобно, особенно при 
	 *  импорте сложных Collada моделей.</p>
	 * 	
	 * 	<p>Модификатор Wheel позволяет решить эту проблему более элегантней. Он использует математику для того чтобы 
	 *  вы имели возможность поворачивать и вращать один меш в одно и тоже время. Единственное, что вам нужно сделать, это указать
	 * 	вектор поворота и вектор вращения колеса - как правило, это будут 2 разные оси. По умолчанию используются такие оси:
	 * 	<ul>
	 * 	<li>поворот  - вокруг оси Y / new Vector3(0, 1, 0)</li>
	 * 	<li>вращение - вокруг оси Z / new Vector3(0, 0, 1)</li>
	 * 	</ul></p>
	 * 	
	 * 	<p>Это должно работать с большинством моделей автомобилей, импортированных из 3D-редакторов, поскольку это естественное положение колес.<br>
	 * 	Обратите внимание, примитивный цилиндр Papervision, который также может быть использован в качестве колеса, потребует уже другие оси
	 * 	(Y - вращение и Z или X - поворот).</p>
	 * 	
	 * 	@version 1.0
	 * 	@author Bartek Drozdz
	 */
	public class Wheel extends Modifier implements IModifier {
		/** Скорость вращения колеса. */
		public var speed : Number;
		/** Угол поворота колеса. */
		public var turn : Number;
		private var roll : Number;
		private var _radius : Number;
		/** Вектор поворота. */
		public var steerVector : Vector3 = new Vector3(0, 1, 0);
		/** Вектор вращения. */
		public var rollVector : Vector3 = new Vector3(0, 0, 1);

		/** Создает новый экземпляр класса Wheel. */
		public function Wheel() {
			speed = 0;
			turn = 0;
			roll = 0;
		}

		/** Величина одного шага вращения колеса. */
		public function get step() : Number {
			return _radius * speed / Math.PI;
		}

		/** Периметр колеса. */
		public function get perimeter() : Number {
			return _radius * 2 * Math.PI;
		}

		/** Радиус колеса. */
		public function get radius() : Number {
			return _radius;
		}

		/** @inheritDoc */
		override public function setModifiable(mod : MeshProxy) : void {
			super.setModifiable(mod);
			_radius = mod.width / 2;
		}

		/** @inheritDoc */
		public function apply() : void {
			roll += speed;

			var vs : Vector.<VertexProxy> = mod.getVertices();
			var vc : int = vs.length;

			var ms : Matrix4;
			if (turn != 0) {
				var mt : Matrix4 = Matrix4.rotationMatrix(steerVector.x, steerVector.y, steerVector.z, turn);
				var rv : Vector3 = rollVector.clone();
				Matrix4.multiplyVector(mt, rv);
				ms = Matrix4.rotationMatrix(rv.x, rv.y, rv.z, roll);
			} else {
				ms = Matrix4.rotationMatrix(rollVector.x, rollVector.y, rollVector.z, roll);
			}

			for (var i : int = 0;i < vc; i++) {
				var v : VertexProxy = vs[i] as VertexProxy;
				var c : Vector3 = v.vector.clone();
				if (turn != 0) Matrix4.multiplyVector(mt, c);
				Matrix4.multiplyVector(ms, c);
				v.x = c.x;
				v.y = c.y;
				v.z = c.z;
			}
		}
	}
}