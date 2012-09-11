package com.as3dmod.modifiers {
	import com.as3dmod3.IModifier;
	import com.as3dmod3.core.FaceProxy;
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.core.Modifier;
	import com.as3dmod3.core.VertexProxy;
	import com.as3dmod3.core.verlet.VerletConnection;
	import com.as3dmod3.core.verlet.VerletVertex;
	import com.as3dmod3.util.ModConstant;

	import flash.utils.Dictionary;

	/**
	 * <b>Cloth modifier.</b> Animated the vertices of a 3D mesh so that it appears to be made out of cloth.
	 * <br>
	 * <br>External forces can be applied along the 3 axes, to create effects such as wind or gravity.
	 * Edges of the mesh can be locked, to attach them at a fixed position in space, and bounds can be specified
	 * so the cloth will fold as if resting on the floor or hitting a wall.
	 * <br>All coordinates are in object space!
	 * <br>
	 * <br>Best used with meshes containing flat edges, such as planes or boxes.
	 * <br>
	 * <br>The Cloth modifier should be at the top of the modifier stack.
	 * 
	 * @author David Lenaerts
	 */
	public class Cloth extends Modifier implements IModifier {
		private var _vertices : Array;
		private var _connections : Array;
		private var _forceX : Number = 0;
		private var _forceY : Number = 0;
		private var _forceZ : Number = 0;
		private var _rigidity : Number;
		private var _friction : Number;
		private var _lookUp : Dictionary;
		private var _useBounds : Boolean;
		private var _boundsMinX : Number;
		private var _boundsMaxX : Number;
		private var _boundsMinY : Number;
		private var _boundsMaxY : Number;
		private var _boundsMinZ : Number;
		private var _boundsMaxZ : Number;

		/**
		 * Creates an instance of the Cloth modifier.
		 * 
		 * @param rigidity Determines the rigidity of the cloth. Lower values will make the cloth more stretchable and bouncy. A value between 0 and 1.
		 * @param friction The amount of air friction acting upon the cloth, changing its overall mobility.
		 */
		public function Cloth(rigidity : Number = 1, friction : Number = 0) {
			super();
			_lookUp = new Dictionary(true);
			_rigidity = rigidity;
			this.friction = friction;
		}

		/**
		 * Sets the bounds of the box in which the cloth is contained. This can be used to mimick a floor and/or walls. Coordinates are in object space.
		 * 
		 * @param minX The left wall of the bounding box.
		 * @param maxX The right wall of the bounding box.
		 * @param minY The floor of the bounding box.
		 * @param maxY The ceiling of the bounding box.
		 * @param minZ The near wall of the bounding box.
		 * @param maxZ The far wall of the bounding box.
		 */
		public function setBounds(minX : Number = Number.NEGATIVE_INFINITY, maxX : Number = Number.POSITIVE_INFINITY, minY : Number = Number.NEGATIVE_INFINITY, maxY : Number = Number.POSITIVE_INFINITY, minZ : Number = Number.NEGATIVE_INFINITY, maxZ : Number = Number.POSITIVE_INFINITY) : void {
			_useBounds = true;
			_boundsMinX = minX;
			_boundsMaxX = maxX;
			_boundsMinY = minY;
			_boundsMaxY = maxY;
			_boundsMinZ = minZ;
			_boundsMaxZ = maxZ;
		}

		/**
		 * Clears all bounds.
		 */
		public function clearBounds() : void {
			_useBounds = false;
		}

		/**
		 * The vertices used to calculate the animations. They are different to normal vertices in that they take into account velocity.
		 */
		public function get verletVertices() : Array {
			return _vertices;
		}

		/**
		 * The amount of air friction acting upon the cloth, changing its overall mobility.
		 */
		public function get friction() : Number {
			return (_friction - 1) * 100;
		}

		public function set friction(value : Number) : void {
			if (value < 0) value = 0;

			_friction = value / 100 + 1;
		}

		/**
		 * Determines the rigidity of the cloth. Lower values will make the cloth more stretchable and bouncy. A value between 0 and 1.
		 */
		public function get rigidity() : Number {
			return _rigidity;
		}

		public function set rigidity(value : Number) : void {
			var half : Number;
			var i : int = _connections.length;
			var c : VerletConnection;

			if (value > 1) value = 1;
			else if (value < 0) value = 0;

			_rigidity = value;
			half = value * .5;

			while (c = _connections[--i] as VerletConnection) {
				c.rigidity = half;
			}
		}

		/**
		 * Sets the external forces acting on the vertices along the three axes.
		 * This can be used to immitate natural effects such as gravity or wind.
		 * 
		 * @param x The amount of force along the X axis.
		 * @param y The amount of force along the Y axis.
		 * @param z The amount of force along the Z axis.
		 */
		public function setForce(x : Number, y : Number, z : Number) : void {
			_forceX = x;
			_forceY = y;
			_forceZ = z;
		}

		/**
		 * The amount of external forces acting upon the vertices along the X axis.
		 * This can be used to immitate natural effects such as wind.
		 */
		public function get forceX() : Number {
			return _forceX;
		}

		public function set forceX(value : Number) : void {
			_forceX = value;
		}

		/**
		 * The amount of external forces acting upon the vertices along the Y axis.
		 * This can be used to immitate natural effects such as gravity.
		 */
		public function get forceY() : Number {
			return _forceY;
		}

		public function set forceY(value : Number) : void {
			_forceY = value;
		}

		/**
		 * The amount of external forces acting upon the vertices along the Z axis.
		 * This can be used to immitate natural effects such as wind.
		 */
		public function get forceZ() : Number {
			return _forceZ;
		}

		public function set forceZ(value : Number) : void {
			_forceZ = value;
		}

		/**
		 * Removes all locks placed on the Cloth modifier, and sets all vertices to mobile.
		 */
		public function unlockAll() : void {
			var v : VerletVertex;
			var i : int = _vertices.length;

			while (v = _vertices[--i] as VerletVertex) {
				v.mobileX = true;
				v.mobileY = true;
				v.mobileZ = true;
			}
		}

		/**
		 * Locks all vertices with a given maximum distance to the left boundary into place,
		 * restricting movement along a set of axes.
		 * 
		 * @param tolerance The maximum distance to the boundary for which vertices will be locked.
		 * @param axes The axes along which the movement is restricted. If not provided, no movement is allowed.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockXMin(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.minX, "x", tolerance, axes);
		}

		/**
		 * Locks all vertices with a given maximum distance to the right boundary into place,
		 * restricting movement along a set of axes.
		 * 
		 * @param tolerance The maximum distance to the boundary for which vertices will be locked.
		 * @param axes The axes along which the movement is restricted. If not provided, no movement is allowed.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockXMax(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.maxX, "x", tolerance, axes);
		}

		/**
		 * Locks all vertices with a given maximum distance to the bottom boundary into place,
		 * restricting movement along a set of axes.
		 * 
		 * @param tolerance The maximum distance to the boundary for which vertices will be locked.
		 * @param axes The axes along which the movement is restricted. If not provided, no movement is allowed.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockYMin(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.minY, "y", tolerance, axes);
		}

		/**
		 * Locks all vertices with a given maximum distance to the top boundary into place,
		 * restricting movement along a set of axes.
		 * 
		 * @param tolerance The maximum distance to the boundary for which vertices will be locked.
		 * @param axes The axes along which the movement is restricted. If not provided, no movement is allowed.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockYMax(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.maxY, "y", tolerance, axes);
		}

		/**
		 * Locks all vertices with a given maximum distance to the near boundary into place,
		 * restricting movement along a set of axes.
		 * 
		 * @param tolerance The maximum distance to the boundary for which vertices will be locked.
		 * @param axes The axes along which the movement is restricted. If not provided, no movement is allowed.
		 */
		public function lockZMin(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.minZ, "z", tolerance, axes);
		}

		/**
		 * Locks all vertices with a given maximum distance to the far boundary into place,
		 * restricting movement along a set of axes.
		 * 
		 * @param tolerance The maximum distance to the boundary for which vertices will be locked.
		 * @param axes The axes along which the movement is restricted. If not provided, no movement is allowed.
		 * 
		 * @see com.as3dmod.util.ModConstant
		 */
		public function lockZMax(tolerance : Number = 0, axes : int = 7) : void {
			lockSet(mod.maxZ, "z", tolerance, axes);
		}

		private function lockSet(reference : Number, property : String, tolerance : Number = 0, axes : int = 7) : void {
			var v : VerletVertex;
			var i : int = _vertices.length;

			while (v = _vertices[--i] as VerletVertex) {
				if (Math.abs(v[property] - reference) <= tolerance) {
					if (axes & ModConstant.X) v.mobileX = false;
					if (axes & ModConstant.Y) v.mobileY = false;
					if (axes & ModConstant.Z) v.mobileZ = false;
				}
			}
		}

		override public function setModifiable(mod : MeshProxy) : void {
			super.setModifiable(mod);

			initVerletVertices();
			initVerletConnections();
			rigidity = _rigidity;
		}

		public function apply() : void {
			var i : int;
			var c : VerletConnection;
			var v : VerletVertex;

			i = _connections.length;

			while (c = _connections[--i] as VerletConnection) {
				c.update();
			}

			i = _vertices.length;

			while (v = _vertices[--i] as VerletVertex) {
				if (v.mobileX) v.x += _forceX;
				if (v.mobileY) v.y += _forceY;
				if (v.mobileZ) v.z += _forceZ;

				v.velocityX /= _friction;
				v.velocityY /= _friction;
				v.velocityZ /= _friction;

				if (_useBounds) {
					if (v.x < _boundsMinX) v.x = _boundsMinX;
					else if (v.x > _boundsMaxX) v.x = _boundsMaxX;
					if (v.y < _boundsMinY) v.y = _boundsMinY;
					else if (v.y > _boundsMaxY) v.y = _boundsMaxY;
					if (v.z < _boundsMinZ) v.z = _boundsMinZ;
					else if (v.z > _boundsMaxZ) v.z = _boundsMaxZ;
				}

				v.update();
			}
		}

		private function initVerletVertices() : void {
			var vs : Array = mod.getVertices();
			var vc : int = vs.length;
			var v : VertexProxy;
			var vv : VerletVertex;

			_vertices = [];

			while (v = vs[--vc] as VertexProxy) {
				vv = new VerletVertex(v);
				_vertices.push(vv);
				_lookUp[v] = vv;
			}
		}

		private function initVerletConnections() : void {
			var ts : Array = mod.getFaces();
			var t : FaceProxy;
			var tc : int = ts.length;
			var faceVertices : Array;
			var numVertices : Number;

			_connections = [];

			for (var i : int = 0; i < tc; i++) {
				t = ts[i] as FaceProxy;
				faceVertices = t.vertices;
				numVertices = faceVertices.length;

				for (var j : int = 0; j < numVertices - 1; j++) {
					createConnection(_lookUp[faceVertices[j]], _lookUp[faceVertices[j + 1]]);
					if (j > 1) createConnection(_lookUp[faceVertices[0]], _lookUp[faceVertices[j]]);
				}

				createConnection(_lookUp[faceVertices[numVertices - 1]], _lookUp[faceVertices[0]]);
			}
		}

		private function createConnection(v1 : VerletVertex, v2 : VerletVertex) : void {
			var dist : Number = v1.distanceTo(v2);
			var connection : VerletConnection = new VerletConnection(v1, v2, dist, _rigidity);

			_connections.push(connection);
		}
	}
}