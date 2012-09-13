package away3d.materials.passes
{
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.ShadingMethodEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightProbe;
	import away3d.lights.PointLight;
	import away3d.materials.LightSources;
	import away3d.materials.MaterialBase;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.materials.methods.BasicSpecularMethod;
	import away3d.materials.methods.ColorTransformMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.MethodVO;
	import away3d.materials.methods.ShadingMethodBase;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.utils.ShaderRegisterCache;
	import away3d.materials.utils.ShaderRegisterElement;
	import away3d.textures.Texture2DBase;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;

	use namespace arcane;

	/**
	 * DefaultScreenPass is a shader pass that uses shader methods to compile a complete program.
	 *
	 * @see away3d.materials.methods.ShadingMethodBase
	 */

	// TODO: Remove compilation from this class, gets messy. Only perform rendering here.
	public class DefaultScreenPass extends MaterialPassBase
	{
//		private var _cameraPositionData : Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
//		private var _lightData : Vector.<Number>;
//		private var _uvTransformData : Vector.<Number>;

		// todo: create something similar for diffuse: useOnlyProbesDiffuse - ignoring normal lights?
		// or: for both, provide mode: LightSourceMode.LIGHTS = 0x01, LightSourceMode.PROBES = 0x02, LightSourceMode.ALL = 0x03
		private var _specularLightSources : uint = 0x01;
		private var _diffuseLightSources : uint = 0x03;
		private var _combinedLightSources : uint;

		private var _colorTransformMethod : ColorTransformMethod;
		private var _colorTransformMethodVO : MethodVO;
		private var _normalMethod : BasicNormalMethod;
		private var _normalMethodVO : MethodVO;
		private var _ambientMethod : BasicAmbientMethod;
		private var _ambientMethodVO : MethodVO;
		private var _shadowMethod : ShadowMapMethodBase;
		private var _shadowMethodVO : MethodVO;
		private var _diffuseMethod : BasicDiffuseMethod;
		private var _diffuseMethodVO : MethodVO;
		private var _specularMethod : BasicSpecularMethod;
		private var _specularMethodVO : MethodVO;
		private var _methods : Vector.<MethodSet>;
		private var _registerCache : ShaderRegisterCache;
		private var _vertexCode : String;
		private var _fragmentCode : String;
		private var _projectionDependencies : uint;
		private var _normalDependencies : uint;
		private var _viewDirDependencies : uint;
		private var _uvDependencies : uint;
		private var _secondaryUVDependencies : uint;
		private var _globalPosDependencies : uint;

		// registers
		protected var _uvBufferIndex : int;
		protected var _secondaryUVBufferIndex : int;
		protected var _normalBufferIndex : int;
		protected var _tangentBufferIndex : int;
		protected var _sceneMatrixIndex : int;
		protected var _sceneNormalMatrixIndex : int;
		protected var _lightDataIndex : int;
		protected var _cameraPositionIndex : int;
		protected var _uvTransformIndex : int;

		private var _projectionFragmentReg : ShaderRegisterElement;
		private var _normalFragmentReg : ShaderRegisterElement;
		private var _viewDirFragmentReg : ShaderRegisterElement;
		private var _lightInputIndices : Vector.<uint>;
		private var _lightProbeDiffuseIndices : Vector.<uint>;
		private var _lightProbeSpecularIndices : Vector.<uint>;

		private var _normalVarying : ShaderRegisterElement;
		private var _tangentVarying : ShaderRegisterElement;
		private var _bitangentVarying : ShaderRegisterElement;
		private var _uvVaryingReg : ShaderRegisterElement;
		private var _secondaryUVVaryingReg : ShaderRegisterElement;
		private var _viewDirVaryingReg : ShaderRegisterElement;

		private var _shadedTargetReg : ShaderRegisterElement;
		private var _globalPositionVertexReg : ShaderRegisterElement;
		private var _globalPositionVaryingReg : ShaderRegisterElement;
		private var _localPositionRegister : ShaderRegisterElement;
		private var _positionMatrixRegs : Vector.<ShaderRegisterElement>;
		private var _normalInput : ShaderRegisterElement;
		private var _tangentInput : ShaderRegisterElement;
		private var _animatedNormalReg : ShaderRegisterElement;
		private var _animatedTangentReg : ShaderRegisterElement;
		private var _commonsReg : ShaderRegisterElement;
		private var _commonsDataIndex : int;

//		private var _commonsData : Vector.<Number> = Vector.<Number>([.5, 0, 0, 1]);
		private var _vertexConstantIndex : uint;
		private var _vertexConstantData : Vector.<Number> = new Vector.<Number>();
		private var _fragmentConstantData : Vector.<Number> = new Vector.<Number>();

		arcane var _passes : Vector.<MaterialPassBase>;
		arcane var _passesDirty : Boolean;
		private var _animateUVs : Boolean;

		private var _numLights : int;
		private var _lightDataLength : int;

		private var _pointLightRegisters : Vector.<ShaderRegisterElement>;
		private var _dirLightRegisters : Vector.<ShaderRegisterElement>;
		private var _diffuseLightIndex : int;
		private var _specularLightIndex : int;
		private var _probeWeightsIndex : int;
		private var _numProbeRegisters : uint;
		private var _usingSpecularMethod : Boolean;
		private var _usesGlobalPosFragment : Boolean = true;
		private var _tangentDependencies : int;

		private var _ambientLightR : Number;
		private var _ambientLightG : Number;
		private var _ambientLightB : Number;
		
		private var _projectedTargetRegister : String;



		/**
		 * Creates a new DefaultScreenPass objects.
		 */
		public function DefaultScreenPass(material : MaterialBase)
		{
			super();
			_material = material;

			init();
		}

		private function init() : void
		{
			_methods = new Vector.<MethodSet>();
			_normalMethod = new BasicNormalMethod();
			_ambientMethod = new BasicAmbientMethod();
			_diffuseMethod = new BasicDiffuseMethod();
			_specularMethod = new BasicSpecularMethod();
			_normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_normalMethodVO = _normalMethod.createMethodVO();
			_ambientMethodVO = _ambientMethod.createMethodVO();
			_diffuseMethodVO = _diffuseMethod.createMethodVO();
			_specularMethodVO = _specularMethod.createMethodVO();
		}

		public function get animateUVs() : Boolean
		{
			return _animateUVs;
		}

		public function set animateUVs(value : Boolean) : void
		{
			_animateUVs = value;
			if ((value && !_animateUVs) || (!value && _animateUVs)) invalidateShaderProgram();
		}

		/**
		 * @inheritDoc
		 */
		override public function set mipmap(value : Boolean) : void
		{
			if (_mipmap == value) return;
			super.mipmap = value;
		}

		public function get specularLightSources() : uint
		{
			return _specularLightSources;
		}

		public function set specularLightSources(value : uint) : void
		{
			_specularLightSources = value;
		}

		public function get diffuseLightSources() : uint
		{
			return _diffuseLightSources;
		}

		public function set diffuseLightSources(value : uint) : void
		{
			_diffuseLightSources = value;
		}

		/**
		 * The ColorTransform object to transform the colour of the material with.
		 */
		public function get colorTransform() : ColorTransform
		{
			return _colorTransformMethod ? _colorTransformMethod.colorTransform : null;
		}

		public function set colorTransform(value : ColorTransform) : void
		{
			if (value) {
				colorTransformMethod ||= new ColorTransformMethod();
				_colorTransformMethod.colorTransform = value;
			}
			else if (!value) {
				if (_colorTransformMethod)
					colorTransformMethod = null;
				colorTransformMethod = _colorTransformMethod = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose() : void
		{
			super.dispose();

			_normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_normalMethod.dispose();
			_diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_diffuseMethod.dispose();
			if (_shadowMethod) {
				_diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_shadowMethod.dispose();
			}
			_ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_ambientMethod.dispose();
			if (_specularMethod) {
				_ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_specularMethod.dispose();
			}
			if (_colorTransformMethod) {
				_colorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_colorTransformMethod.dispose();
			}
			for (var i : int = 0; i < _methods.length; ++i) {
				_methods[i].method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_methods[i].method.dispose();
			}

			_methods = null;
		}

		/**
		 * Adds a method to change the material after all lighting is performed.
		 * @param method The method to be added.
		 */
		public function addMethod(method : EffectMethodBase) : void
		{
			_methods.push(new MethodSet(method));
			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			invalidateShaderProgram();
		}

		public function hasMethod(method : EffectMethodBase) : Boolean
		{
			return getMethodSetForMethod(method) != null;
		}

		/**
		 * Inserts a method to change the material after all lighting is performed at the given index.
		 * @param method The method to be added.
		 * @param index The index of the method's occurrence
		 */
		public function addMethodAt(method : EffectMethodBase, index : int) : void
		{
			_methods.splice(index, 0, new MethodSet(method));
			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			invalidateShaderProgram();
		}

		public function getMethodAt(index : int) : EffectMethodBase
		{
			return EffectMethodBase(_methods[index].method);
		}

		public function get numMethods() : int
		{
			return _methods.length;
		}

		/**
		 * Removes a method from the pass.
		 * @param method The method to be removed.
		 */
		public function removeMethod(method : EffectMethodBase) : void
		{
			var methodSet : MethodSet = getMethodSetForMethod(method);
			if (methodSet != null) {
				var index : int = _methods.indexOf(methodSet);
				_methods.splice(index, 1);
				method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				invalidateShaderProgram();
			}
		}

		/**
		 * The tangent space normal map to influence the direction of the surface for each texel.
		 */
		public function get normalMap() : Texture2DBase
		{
			return _normalMethod.normalMap;
		}

		public function set normalMap(value : Texture2DBase) : void
		{
			_normalMethod.normalMap = value;
		}

		/**
		 * @inheritDoc
		 */

		public function get normalMethod() : BasicNormalMethod
		{
			return _normalMethod;
		}

		public function set normalMethod(value : BasicNormalMethod) : void
		{
			_normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			value.copyFrom(_normalMethod);
			_normalMethod = value;
			_normalMethodVO = _normalMethod.createMethodVO();
			_normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			invalidateShaderProgram();
		}

		public function get ambientMethod() : BasicAmbientMethod
		{
			return _ambientMethod;
		}

		public function set ambientMethod(value : BasicAmbientMethod) : void
		{
			_ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			value.copyFrom(_ambientMethod);
			_ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_ambientMethod = value;
			_ambientMethodVO = _ambientMethod.createMethodVO();
			invalidateShaderProgram();
		}

		public function get shadowMethod() : ShadowMapMethodBase
		{
			return _shadowMethod;
		}

		public function set shadowMethod(value : ShadowMapMethodBase) : void
		{
			if (_shadowMethod) _shadowMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_shadowMethod = value;
			if (_shadowMethod) {
				_shadowMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_shadowMethodVO = _shadowMethod.createMethodVO();
			}
			else
				_shadowMethodVO = null;
			invalidateShaderProgram();
		}

		/**
		 * The method to perform diffuse shading.
		 */
		public function get diffuseMethod() : BasicDiffuseMethod
		{
			return _diffuseMethod;
		}

		public function set diffuseMethod(value : BasicDiffuseMethod) : void
		{
			_diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			value.copyFrom(_diffuseMethod);
			_diffuseMethod = value;
			_diffuseMethodVO = _diffuseMethod.createMethodVO();
			_diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			invalidateShaderProgram();
		}

		/**
		 * The method to perform specular shading.
		 */
		public function get specularMethod() : BasicSpecularMethod
		{
			return _specularMethod;
		}

		public function set specularMethod(value : BasicSpecularMethod) : void
		{
			if (_specularMethod) {
				_specularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value) value.copyFrom(_specularMethod);
			}

			_specularMethod = value;
			if (_specularMethod) {
				_specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_specularMethodVO = _specularMethod.createMethodVO();
			}
			else _specularMethodVO = null;

			invalidateShaderProgram();
		}



		/**
		 * @private
		 */
		arcane function get colorTransformMethod() : ColorTransformMethod
		{
			return _colorTransformMethod;
		}

		arcane function set colorTransformMethod(value : ColorTransformMethod) : void
		{
			if (_colorTransformMethod == value) return;
			if (_colorTransformMethod) _colorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			if (!_colorTransformMethod || !value) invalidateShaderProgram();

			_colorTransformMethod = value;
			if (_colorTransformMethod) {
				_colorTransformMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				_colorTransformMethodVO = _colorTransformMethod.createMethodVO();
			}
			else _colorTransformMethodVO = null;
		}

		arcane override function set numPointLights(value : uint) : void
		{
			super.numPointLights = value;
			invalidateShaderProgram();
		}

		arcane override function set numDirectionalLights(value : uint) : void
		{
			super.numDirectionalLights = value;
			invalidateShaderProgram();
		}

		arcane override function set numLightProbes(value : uint) : void
		{
			super.numLightProbes = value;
			invalidateShaderProgram();
		}

		/**
		 * @inheritDoc
		 */
		arcane override function getVertexCode(animatorCode : String) : String
		{
			var normal : String = _animationTargetRegisters.length > 1? _animationTargetRegisters[1] : null;
			var projectionVertexCode : String = getProjectionCode(_animationTargetRegisters[0], _projectedTargetRegister, normal);
			_vertexCode = animatorCode + projectionVertexCode + _vertexCode;
			return _vertexCode;
		}

		private function getProjectionCode(positionRegister : String, projectionRegister : String, normalRegister : String) : String
		{
			var code : String = "";
			var pos : String = positionRegister;

			// if we need projection somewhere
			if (projectionRegister) {
				code += "m44 "+projectionRegister+", " + pos + ", vc0		\n" +
						"mov vt7, " + projectionRegister + "\n" +
						"mul op, vt7, vc4\n";
			}
			else {
				code += "m44 vt7, "+pos+", vc0		\n" +
						"mul op, vt7, vc4\n";	// 4x4 matrix transform from stream 0 to output clipspace
			}
			return code;
		}

		/**
		 * @inheritDoc
		 */
		arcane override function getFragmentCode() : String
		{
			return _fragmentCode;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(stage3DProxy : Stage3DProxy, camera : Camera3D, textureRatioX : Number, textureRatioY : Number) : void
		{
			var context : Context3D = stage3DProxy._context3D;
			var len : uint = _methods.length;

			super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);

			if (_normalDependencies > 0 && _normalMethod.hasOutput) _normalMethod.activate(_normalMethodVO, stage3DProxy);
			_ambientMethod.activate(_ambientMethodVO, stage3DProxy);
			if (_shadowMethod) _shadowMethod.activate(_shadowMethodVO, stage3DProxy);
			_diffuseMethod.activate(_diffuseMethodVO, stage3DProxy);
			if (_usingSpecularMethod) _specularMethod.activate(_specularMethodVO, stage3DProxy);
			if (_colorTransformMethod) _colorTransformMethod.activate(_colorTransformMethodVO, stage3DProxy);

			for (var i : int = 0; i < len; ++i) {
				var set : MethodSet = _methods[i];
				set.method.activate(set.data, stage3DProxy);
			}

			if (_cameraPositionIndex >= 0) {
				var pos : Vector3D = camera.scenePosition;
				_vertexConstantData[_cameraPositionIndex] = pos.x;
				_vertexConstantData[_cameraPositionIndex + 1] = pos.y;
				_vertexConstantData[_cameraPositionIndex + 2] = pos.z;
			}
		}

		/**
		 * @inheritDoc
		 */
		arcane override function deactivate(stage3DProxy : Stage3DProxy) : void
		{
			super.deactivate(stage3DProxy);
			var len : uint = _methods.length;

			if (_normalDependencies > 0 && _normalMethod.hasOutput) _normalMethod.deactivate(_normalMethodVO, stage3DProxy);
			_ambientMethod.deactivate(_ambientMethodVO, stage3DProxy);
			if (_shadowMethod) _shadowMethod.deactivate(_shadowMethodVO, stage3DProxy);
			_diffuseMethod.deactivate(_diffuseMethodVO, stage3DProxy);
			if (_usingSpecularMethod) _specularMethod.deactivate(_specularMethodVO, stage3DProxy);
			if (_colorTransformMethod) _colorTransformMethod.deactivate(_colorTransformMethodVO, stage3DProxy);

			var set : MethodSet;
			for (var i : uint = 0; i < len; ++i) {
				set = _methods[i];
				set.method.deactivate(set.data, stage3DProxy);
			}
		}

		/**
		 * @inheritDoc
		 */
		arcane override function render(renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D, lightPicker : LightPickerBase) : void
		{
			var i : uint;
			var context : Context3D = stage3DProxy._context3D;
			if (_uvBufferIndex >= 0) stage3DProxy.setSimpleVertexBuffer(_uvBufferIndex, renderable.getUVBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_2, renderable.UVBufferOffset);
			if (_secondaryUVBufferIndex >= 0) stage3DProxy.setSimpleVertexBuffer(_secondaryUVBufferIndex, renderable.getSecondaryUVBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_2, renderable.secondaryUVBufferOffset);
			if (_normalBufferIndex >= 0) stage3DProxy.setSimpleVertexBuffer(_normalBufferIndex, renderable.getVertexNormalBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, renderable.normalBufferOffset);
			if (_tangentBufferIndex >= 0) stage3DProxy.setSimpleVertexBuffer(_tangentBufferIndex, renderable.getVertexTangentBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, renderable.tangentBufferOffset);

			var uvTransform : Matrix;
			if (_animateUVs) {
				uvTransform = renderable.uvTransform;
				if (uvTransform) {
					_vertexConstantData[_uvTransformIndex] = uvTransform.a;
					_vertexConstantData[_uvTransformIndex+1] = uvTransform.b;
					_vertexConstantData[_uvTransformIndex+3] = uvTransform.tx;
					_vertexConstantData[_uvTransformIndex+4] = uvTransform.c;
					_vertexConstantData[_uvTransformIndex+5] = uvTransform.d;
					_vertexConstantData[_uvTransformIndex+7] = uvTransform.ty;
				}
				else {
					trace("Warning: animateUVs is set to true with an IRenderable without a uvTransform. Identity matrix assumed.");
					_vertexConstantData[_uvTransformIndex] = 1;
					_vertexConstantData[_uvTransformIndex+1] = 0;
					_vertexConstantData[_uvTransformIndex+3] = 0;
					_vertexConstantData[_uvTransformIndex+4] = 0;
					_vertexConstantData[_uvTransformIndex+5] = 1;
					_vertexConstantData[_uvTransformIndex+7] = 0;
				}
			}

			if (_numLights > 0 && (_combinedLightSources & LightSources.LIGHTS))
				updateLights(lightPicker.directionalLights, lightPicker.pointLights, stage3DProxy);

			if (_numLightProbes > 0 && (_combinedLightSources & LightSources.PROBES))
				updateProbes(lightPicker.lightProbes, lightPicker.lightProbeWeights, stage3DProxy);

			if (_sceneMatrixIndex >= 0)
				renderable.sceneTransform.copyRawDataTo(_vertexConstantData, _sceneMatrixIndex, true);

			if (_sceneNormalMatrixIndex >= 0)
				renderable.inverseSceneTransform.copyRawDataTo(_vertexConstantData, _sceneNormalMatrixIndex, false);

			if (_normalDependencies > 0 && _normalMethod.hasOutput)
				_normalMethod.setRenderState(_normalMethodVO, renderable, stage3DProxy, camera);

			_ambientMethod.setRenderState(_ambientMethodVO, renderable, stage3DProxy, camera);
			_ambientMethod._lightAmbientR = _ambientLightR;
			_ambientMethod._lightAmbientG = _ambientLightG;
			_ambientMethod._lightAmbientB = _ambientLightB;

			if (_shadowMethod) _shadowMethod.setRenderState(_shadowMethodVO, renderable, stage3DProxy, camera);
			_diffuseMethod.setRenderState(_diffuseMethodVO, renderable, stage3DProxy, camera);
			if (_usingSpecularMethod) _specularMethod.setRenderState(_specularMethodVO, renderable, stage3DProxy, camera);
			if (_colorTransformMethod) _colorTransformMethod.setRenderState(_colorTransformMethodVO, renderable, stage3DProxy, camera);

			var len : uint = _methods.length;
			for (i = 0; i < len; ++i) {
				var set : MethodSet = _methods[i];
				set.method.setRenderState(set.data, renderable, stage3DProxy, camera);
			}

			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, _vertexConstantIndex, _vertexConstantData, _numUsedVertexConstants-_vertexConstantIndex);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _fragmentConstantData, _numUsedFragmentConstants);

			super.render(renderable, stage3DProxy, camera, lightPicker);
		}


		/**
		 * Marks the shader program as invalid, so it will be recompiled before the next render.
		 */
		arcane override function invalidateShaderProgram(updateMaterial : Boolean = true) : void
		{
			super.invalidateShaderProgram(updateMaterial);
			_passesDirty = true;

			_passes = new Vector.<MaterialPassBase>();
			if (_normalMethod.hasOutput) addPasses(_normalMethod.passes);
			addPasses(_ambientMethod.passes);
			if (_shadowMethod) addPasses(_shadowMethod.passes);
			addPasses(_diffuseMethod.passes);
			if (_specularMethod) addPasses(_specularMethod.passes);
			if (_colorTransformMethod) addPasses(_colorTransformMethod.passes);

			for (var i : uint = 0; i < _methods.length; ++i) {
				addPasses(_methods[i].method.passes);
			}
		}

		/**
		 * @inheritDoc
		 */
		override arcane function updateProgram(stage3DProxy : Stage3DProxy) : void
		{
			reset();

			super.updateProgram(stage3DProxy);
		}

		/**
		 * Resets the compilation state.
		 */
		private function reset() : void
		{
			_numLights = _numPointLights + _numDirectionalLights;
			_numProbeRegisters = Math.ceil(_numLightProbes/4);

			if (_specularMethod)
				_combinedLightSources = _specularLightSources | _diffuseLightSources;
			else
				_combinedLightSources = _diffuseLightSources;

			_usingSpecularMethod = 	_specularMethod && (
									(_numLights > 0 && (_specularLightSources & LightSources.LIGHTS)) ||
									(_numLightProbes > 0 && (_specularLightSources & LightSources.PROBES)));

			_uvTransformIndex = -1;
			_cameraPositionIndex = -1;
			_commonsDataIndex = -1;
			_uvBufferIndex = -1;
			_secondaryUVBufferIndex = -1;
			_normalBufferIndex = -1;
			_tangentBufferIndex = -1;
			_lightDataIndex = -1;
			_sceneMatrixIndex = -1;
			_sceneNormalMatrixIndex = -1;
			_probeWeightsIndex = -1;

			_pointLightRegisters = new Vector.<ShaderRegisterElement>(_numPointLights*3, true);
			_dirLightRegisters = new Vector.<ShaderRegisterElement>(_numDirectionalLights*3, true);
			_lightDataLength = _numLights*3;

			_registerCache = new ShaderRegisterCache();
			_vertexConstantIndex = _registerCache.vertexConstantOffset = 5;
			_registerCache.vertexAttributesOffset = 1;
			_registerCache.reset();

			_lightInputIndices = new Vector.<uint>(_numLights, true);

			_commonsReg = null;
			_numUsedVertexConstants = 0;
			_numUsedStreams = 1;

			_animatableAttributes = ["va0"];
			_animationTargetRegisters = ["vt0"];
			_vertexCode = "";
			_fragmentCode = "";
			_projectedTargetRegister = null;

			_localPositionRegister = _registerCache.getFreeVertexVectorTemp();
			_registerCache.addVertexTempUsages(_localPositionRegister, 1);

			compile();

			_numUsedVertexConstants = _registerCache.numUsedVertexConstants;
			_numUsedFragmentConstants = _registerCache.numUsedFragmentConstants;
			_numUsedStreams = _registerCache.numUsedStreams;
			_numUsedTextures = _registerCache.numUsedTextures;
			_vertexConstantData.length = (_numUsedVertexConstants-_vertexConstantIndex)*4;
			_fragmentConstantData.length = _numUsedFragmentConstants*4;

			initCommonsData();
			if (_uvTransformIndex >= 0)
				initUVTransformData();
			if (_cameraPositionIndex >= 0)
				_vertexConstantData[_cameraPositionIndex + 3] = 1;

			updateMethodConstants();
			cleanUp();
		}

		private function updateMethodConstants() : void
		{
			if (_normalMethod) _normalMethod.initConstants(_normalMethodVO);
			if (_diffuseMethod) _diffuseMethod.initConstants(_diffuseMethodVO);
			if (_ambientMethod) _ambientMethod.initConstants(_ambientMethodVO);
			if (_specularMethod) _specularMethod.initConstants(_specularMethodVO);
			if (_shadowMethod) _shadowMethod.initConstants(_shadowMethodVO);
			if (_colorTransformMethod) _colorTransformMethod.initConstants(_colorTransformMethodVO);

			var len : uint = _methods.length;
			for (var i : uint = 0; i < len; ++i) {
				_methods[i].method.initConstants(_methods[i].data);
			}
		}

		private function initUVTransformData() : void
		{
			_vertexConstantData[_uvTransformIndex] = 1;
			_vertexConstantData[_uvTransformIndex+1] = 0;
			_vertexConstantData[_uvTransformIndex+2] = 0;
			_vertexConstantData[_uvTransformIndex+3] = 0;
			_vertexConstantData[_uvTransformIndex+4] = 0;
			_vertexConstantData[_uvTransformIndex+5] = 1;
			_vertexConstantData[_uvTransformIndex+6] = 0;
			_vertexConstantData[_uvTransformIndex+7] = 0;
		}

		private function initCommonsData() : void
		{
			_fragmentConstantData[_commonsDataIndex] = .5;
			_fragmentConstantData[_commonsDataIndex + 1] = 0;
			_fragmentConstantData[_commonsDataIndex + 2] = 1/255;
			_fragmentConstantData[_commonsDataIndex + 3] = 1;
		}

		private function cleanUp() : void
		{
			nullifyCompilationData();
			cleanUpMethods();
		}

		private function nullifyCompilationData() : void
		{
			_pointLightRegisters = null;
			_dirLightRegisters = null;

			_projectionFragmentReg = null;
			_viewDirFragmentReg = null;

			_normalVarying = null;
			_tangentVarying = null;
			_bitangentVarying = null;
			_uvVaryingReg = null;
			_secondaryUVVaryingReg = null;
			_viewDirVaryingReg = null;

			_shadedTargetReg = null;
			_globalPositionVertexReg = null;
			_globalPositionVaryingReg = null;
			_localPositionRegister = null;
			_positionMatrixRegs = null;
			_normalInput = null;
			_tangentInput = null;
			_animatedNormalReg = null;
			_animatedTangentReg = null;
			_commonsReg = null;

			_registerCache.dispose();
			_registerCache = null;
		}

		private function cleanUpMethods() : void
		{
			if (_normalMethod) _normalMethod.cleanCompilationData();
			if (_diffuseMethod) _diffuseMethod.cleanCompilationData();
			if (_ambientMethod) _ambientMethod.cleanCompilationData();
			if (_specularMethod) _specularMethod.cleanCompilationData();
			if (_shadowMethod) _shadowMethod.cleanCompilationData();
			if (_colorTransformMethod) _colorTransformMethod.cleanCompilationData();

			var len : uint = _methods.length;
			for (var i : uint = 0; i < len; ++i) {
				_methods[i].method.cleanCompilationData();
			}
		}

		/**
		 * Compiles the actual shader code.
		 */
		private function compile() : void
		{
			createCommons();
			calculateDependencies();

			if (_projectionDependencies > 0) compileProjCode();
			if (_uvDependencies > 0) compileUVCode();
			if (_secondaryUVDependencies > 0) compileSecondaryUVCode();
			if (_globalPosDependencies > 0) compileGlobalPositionCode();

			updateMethodRegisters(_normalMethod);
			if (_normalDependencies > 0) {
				// needs to be created before view
				_animatedNormalReg = _registerCache.getFreeVertexVectorTemp();
				_registerCache.addVertexTempUsages(_animatedNormalReg, 1);
				if (_normalDependencies > 0) compileNormalCode();
			}
			if (_viewDirDependencies > 0) compileViewDirCode();


			updateMethodRegisters(_diffuseMethod);
			if (_shadowMethod) updateMethodRegisters(_shadowMethod);
			updateMethodRegisters(_ambientMethod);
			if (_specularMethod) updateMethodRegisters(_specularMethod);
			if (_colorTransformMethod) updateMethodRegisters(_colorTransformMethod);

			for (var i : uint = 0; i < _methods.length; ++i)
				updateMethodRegisters(_methods[i].method);

			_shadedTargetReg = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(_shadedTargetReg, 1);

			compileLightingCode();
			compileMethods();

			_fragmentCode += "mov " + _registerCache.fragmentOutputRegister + ", " + _shadedTargetReg + "\n";

			_registerCache.removeFragmentTempUsage(_shadedTargetReg);
		}

		private function compileProjCode() : void
		{
			_projectionFragmentReg = _registerCache.getFreeVarying();
			_projectedTargetRegister = _registerCache.getFreeVertexVectorTemp().toString();

			_vertexCode += "mov " + _projectionFragmentReg + ", " + _projectedTargetRegister + "\n";
		}

		private function updateMethodRegisters(method : ShadingMethodBase) : void
		{
			method.globalPosReg = _globalPositionVaryingReg;
			method.normalFragmentReg = _normalFragmentReg;
			method.projectionReg = _projectionFragmentReg;
			method.UVFragmentReg = _uvVaryingReg;
			method.tangentVaryingReg = _tangentVarying;
			method.secondaryUVFragmentReg = _secondaryUVVaryingReg;
			method.viewDirFragmentReg = _viewDirFragmentReg;
			method.viewDirVaryingReg = _viewDirVaryingReg;
		}

		/**
		 * Adds passes to the list.
		 */
		private function addPasses(passes : Vector.<MaterialPassBase>) : void
		{
			if (!passes) return;

			var len : uint = passes.length;

			for (var i : uint = 0; i < len; ++i) {
				passes[i].material = material;
				_passes.push(passes[i]);
			}
		}

		/**
		 * Calculates register dependencies for commonly used data.
		 */
		private function calculateDependencies() : void
		{
			var len : uint;

			_normalDependencies = 0;
			_viewDirDependencies = 0;
			_uvDependencies = 0;
			_secondaryUVDependencies = 0;
			_globalPosDependencies = 0;

			setupAndCountMethodDependencies(_diffuseMethod, _diffuseMethodVO);
			if (_shadowMethod) setupAndCountMethodDependencies(_shadowMethod, _shadowMethodVO);
			setupAndCountMethodDependencies(_ambientMethod, _ambientMethodVO);
			if (_usingSpecularMethod) setupAndCountMethodDependencies(_specularMethod, _specularMethodVO);
			if (_colorTransformMethod) setupAndCountMethodDependencies(_colorTransformMethod, _colorTransformMethodVO);

			len = _methods.length;
			for (var i : uint = 0; i < len; ++i)
				setupAndCountMethodDependencies(_methods[i].method, _methods[i].data);

			if (_normalDependencies > 0 && _normalMethod.hasOutput) setupAndCountMethodDependencies(_normalMethod, _normalMethodVO);
			if (_viewDirDependencies > 0) ++_globalPosDependencies;

			// todo: add spotlight check
			if (_numPointLights > 0 && (_combinedLightSources & LightSources.LIGHTS)) {
				++_globalPosDependencies;
				_usesGlobalPosFragment = true;
			}
		}

		private function setupAndCountMethodDependencies(method : ShadingMethodBase, methodVO : MethodVO) : void
		{
			setupMethod(method, methodVO);
			countDependencies(methodVO);
		}

		private function countDependencies(methodVO : MethodVO) : void
		{
			if (methodVO.needsProjection) ++_projectionDependencies;
			if (methodVO.needsGlobalPos) {
				++_globalPosDependencies;
				_usesGlobalPosFragment = true;
			}
			if (methodVO.needsNormals) ++_normalDependencies;
			if (methodVO.needsTangents) ++_tangentDependencies;
			if (methodVO.needsView) ++_viewDirDependencies;
			if (methodVO.needsUV) ++_uvDependencies;
			if (methodVO.needsSecondaryUV) ++_secondaryUVDependencies;
		}

		private function setupMethod(method : ShadingMethodBase, methodVO : MethodVO) : void
		{
			method.reset();
			methodVO.reset();
			methodVO.vertexData = _vertexConstantData;
			methodVO.fragmentData = _fragmentConstantData;
			methodVO.vertexConstantsOffset = _vertexConstantIndex;
			methodVO.useSmoothTextures = _smooth;
			methodVO.repeatTextures = _repeat;
			methodVO.useMipmapping = _mipmap;
			methodVO.numLights = _numLights + _numLightProbes;
			method.initVO(methodVO);
		}

		private function compileGlobalPositionCode() : void
		{
			_globalPositionVertexReg = _registerCache.getFreeVertexVectorTemp();
			_registerCache.addVertexTempUsages(_globalPositionVertexReg, _globalPosDependencies);

			_positionMatrixRegs = new Vector.<ShaderRegisterElement>();
			_positionMatrixRegs[0] = _registerCache.getFreeVertexConstant();
			_positionMatrixRegs[1] = _registerCache.getFreeVertexConstant();
			_positionMatrixRegs[2] = _registerCache.getFreeVertexConstant();
			_registerCache.getFreeVertexConstant();
			_sceneMatrixIndex = (_positionMatrixRegs[0].index - _vertexConstantIndex)*4;

			_vertexCode += 	"m44 " + _globalPositionVertexReg + ".xyz, " + _localPositionRegister.toString() + ", " + _positionMatrixRegs[0].toString() + "\n" +
							"mov " + _globalPositionVertexReg + ".w, " + _localPositionRegister + ".w     \n";
//			_registerCache.removeVertexTempUsage(_localPositionRegister);

			// todo: add spotlight check as well
			if (_usesGlobalPosFragment) {
				_globalPositionVaryingReg = _registerCache.getFreeVarying();
				_vertexCode += "mov " + _globalPositionVaryingReg + ", " + _globalPositionVertexReg + "\n";
//				_registerCache.removeVertexTempUsage(_globalPositionVertexReg);
			}
		}

		private function compileUVCode() : void
		{
			var uvAttributeReg : ShaderRegisterElement = _registerCache.getFreeVertexAttribute();

			_uvVaryingReg = _registerCache.getFreeVarying();
			_uvBufferIndex = uvAttributeReg.index;

			if (_animateUVs) {
				// a, b, 0, tx
				// c, d, 0, ty
				var uvTransform1 : ShaderRegisterElement = _registerCache.getFreeVertexConstant();
				var uvTransform2 : ShaderRegisterElement = _registerCache.getFreeVertexConstant();
				_uvTransformIndex = (uvTransform1.index - _vertexConstantIndex)*4;

				_vertexCode += 	"dp4 " + _uvVaryingReg + ".x, " + uvAttributeReg + ", " + uvTransform1 + "\n" +
								"dp4 " + _uvVaryingReg + ".y, " + uvAttributeReg + ", " + uvTransform2 + "\n" +
								"mov " + _uvVaryingReg + ".zw, " + uvAttributeReg + ".zw \n";
			}
			else {
				_vertexCode += "mov " + _uvVaryingReg + ", " + uvAttributeReg + "\n";
			}
		}

		private function compileSecondaryUVCode() : void
		{
			var uvAttributeReg : ShaderRegisterElement = _registerCache.getFreeVertexAttribute();

			_secondaryUVVaryingReg = _registerCache.getFreeVarying();
			_secondaryUVBufferIndex = uvAttributeReg.index;

			_vertexCode += "mov " + _secondaryUVVaryingReg + ", " + uvAttributeReg + "\n";
		}

		private function compileNormalCode() : void
		{
			var normalMatrix : Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(3, true);

			_normalFragmentReg = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(_normalFragmentReg, _normalDependencies);

			if (_normalMethod.hasOutput && !_normalMethod.tangentSpace) {
				_vertexCode += _normalMethod.getVertexCode(_normalMethodVO, _registerCache);
				_fragmentCode += _normalMethod.getFragmentCode(_normalMethodVO, _registerCache, _normalFragmentReg);
				return;
			}

			_normalInput = _registerCache.getFreeVertexAttribute();
			_normalBufferIndex = _normalInput.index;

			_normalVarying = _registerCache.getFreeVarying();

			_animatableAttributes.push(_normalInput.toString());
			_animationTargetRegisters.push(_animatedNormalReg.toString());

			normalMatrix[0] = _registerCache.getFreeVertexConstant();
			normalMatrix[1] = _registerCache.getFreeVertexConstant();
			normalMatrix[2] = _registerCache.getFreeVertexConstant();
			_registerCache.getFreeVertexConstant();
			_sceneNormalMatrixIndex = (normalMatrix[0].index-_vertexConstantIndex)*4;

			if (_normalMethod.hasOutput) {
				// tangent stream required
				compileTangentVertexCode(normalMatrix);
				compileTangentNormalMapFragmentCode();
			}
			else {
				_vertexCode += "m33 " + _normalVarying + ".xyz, " + _animatedNormalReg + ".xyz, " + normalMatrix[0] + "\n" +
								"mov " + _normalVarying + ".w, " + _animatedNormalReg + ".w	\n";

				_fragmentCode += "nrm " + _normalFragmentReg + ".xyz, " + _normalVarying + ".xyz	\n" +
								"mov " + _normalFragmentReg + ".w, " + _normalVarying + ".w		\n";


				if (_tangentDependencies > 0) {
					_tangentInput = _registerCache.getFreeVertexAttribute();
					_tangentBufferIndex = _tangentInput.index;
					_tangentVarying = _registerCache.getFreeVarying();
					_vertexCode += "mov " + _tangentVarying + ", " + _tangentInput + "\n";
				}
			}

			_registerCache.removeVertexTempUsage(_animatedNormalReg);
		}

		private function compileTangentVertexCode(matrix : Vector.<ShaderRegisterElement>) : void
		{
			var normalTemp : ShaderRegisterElement;
			var tanTemp : ShaderRegisterElement;
			var bitanTemp1 : ShaderRegisterElement;
			var bitanTemp2 : ShaderRegisterElement;

			_tangentVarying = _registerCache.getFreeVarying();
			_bitangentVarying = _registerCache.getFreeVarying();

			_tangentInput = _registerCache.getFreeVertexAttribute();
			_tangentBufferIndex = _tangentInput.index;

			_animatedTangentReg = _registerCache.getFreeVertexVectorTemp();
			_registerCache.addVertexTempUsages(_animatedTangentReg, 1);
			_animatableAttributes.push(_tangentInput.toString());
			_animationTargetRegisters.push(_animatedTangentReg.toString());

			normalTemp = _registerCache.getFreeVertexVectorTemp();
			_registerCache.addVertexTempUsages(normalTemp, 1);

			_vertexCode += 	"m33 " + normalTemp + ".xyz, " + _animatedNormalReg + ".xyz, " + matrix[0].toString() + "\n" +
							"nrm " + normalTemp + ".xyz, " + normalTemp + ".xyz	\n";

			tanTemp = _registerCache.getFreeVertexVectorTemp();
			_registerCache.addVertexTempUsages(tanTemp, 1);

			_vertexCode += 	"m33 " + tanTemp + ".xyz, " + _animatedTangentReg + ".xyz, " + matrix[0].toString() + "\n" +
							"nrm " + tanTemp + ".xyz, " + tanTemp + ".xyz	\n";

			bitanTemp1 = _registerCache.getFreeVertexVectorTemp();
			_registerCache.addVertexTempUsages(bitanTemp1, 1);
			bitanTemp2 = _registerCache.getFreeVertexVectorTemp();

			_vertexCode += "mul " + bitanTemp1 + ".xyz, " + normalTemp + ".yzx, " + tanTemp + ".zxy	\n" +
					"mul " + bitanTemp2 + ".xyz, " + normalTemp + ".zxy, " + tanTemp + ".yzx	\n" +
					"sub " + bitanTemp2 + ".xyz, " + bitanTemp1 + ".xyz, " + bitanTemp2 + ".xyz	\n" +

					"mov " + _tangentVarying + ".x, " + tanTemp + ".x	\n" +
					"mov " + _tangentVarying + ".y, " + bitanTemp2 + ".x	\n" +
					"mov " + _tangentVarying + ".z, " + normalTemp + ".x	\n" +
					"mov " + _tangentVarying + ".w, " + _normalInput + ".w	\n" +
					"mov " + _bitangentVarying + ".x, " + tanTemp + ".y	\n" +
					"mov " + _bitangentVarying + ".y, " + bitanTemp2 + ".y	\n" +
					"mov " + _bitangentVarying + ".z, " + normalTemp + ".y	\n" +
					"mov " + _bitangentVarying + ".w, " + _normalInput + ".w	\n" +
					"mov " + _normalVarying + ".x, " + tanTemp + ".z	\n" +
					"mov " + _normalVarying + ".y, " + bitanTemp2 + ".z	\n" +
					"mov " + _normalVarying + ".z, " + normalTemp + ".z	\n" +
					"mov " + _normalVarying + ".w, " + _normalInput + ".w	\n";

			_registerCache.removeVertexTempUsage(normalTemp);
			_registerCache.removeVertexTempUsage(tanTemp);
			_registerCache.removeVertexTempUsage(bitanTemp1);
			_registerCache.removeVertexTempUsage(_animatedTangentReg);
		}

		private function compileTangentNormalMapFragmentCode() : void
		{
			var t : ShaderRegisterElement;
			var b : ShaderRegisterElement;
			var n : ShaderRegisterElement;

			t = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(t, 1);
			b = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(b, 1);
			n = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(n, 1);

			_fragmentCode += 	"nrm " + t + ".xyz, " + _tangentVarying + ".xyz	\n" +
								"mov " + t + ".w, " + _tangentVarying + ".w	\n" +
								"nrm " + b + ".xyz, " + _bitangentVarying + ".xyz	\n" +
								"nrm " + n + ".xyz, " + _normalVarying + ".xyz	\n";

			var temp : ShaderRegisterElement = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(temp, 1);
			_fragmentCode += _normalMethod.getFragmentCode(_normalMethodVO, _registerCache, temp) +
							"sub " + temp + ".xyz, " + temp + ".xyz, " + _commonsReg + ".xxx	\n" +
							"nrm " + temp + ".xyz, " + temp + ".xyz							\n" +
							"m33 " + _normalFragmentReg + ".xyz, " + temp + ".xyz, " + t + "	\n" +
							"mov " + _normalFragmentReg + ".w,   " + _normalVarying + ".w			\n";

			_registerCache.removeFragmentTempUsage(temp);

			if (_normalMethodVO.needsView) _registerCache.removeFragmentTempUsage(_viewDirFragmentReg);
			if (_normalMethodVO.needsGlobalPos) _registerCache.removeVertexTempUsage(_globalPositionVertexReg);
			_registerCache.removeFragmentTempUsage(b);
			_registerCache.removeFragmentTempUsage(t);
			_registerCache.removeFragmentTempUsage(n);
		}

		private function createCommons() : void
		{
			_commonsReg = _registerCache.getFreeFragmentConstant();
			_commonsDataIndex = _commonsReg.index*4;
		}

		private function compileViewDirCode() : void
		{
			var cameraPositionReg : ShaderRegisterElement = _registerCache.getFreeVertexConstant();
			_viewDirVaryingReg = _registerCache.getFreeVarying();
			_viewDirFragmentReg = _registerCache.getFreeFragmentVectorTemp();
			_registerCache.addFragmentTempUsages(_viewDirFragmentReg, _viewDirDependencies);

			_cameraPositionIndex = (cameraPositionReg.index-_vertexConstantIndex)*4;

			_vertexCode += "sub " + _viewDirVaryingReg + ", " + cameraPositionReg + ", " + _globalPositionVertexReg + "\n";
			_fragmentCode += 	"nrm " + _viewDirFragmentReg + ".xyz, " + _viewDirVaryingReg + ".xyz		\n" +
								"mov " + _viewDirFragmentReg + ".w,   " + _viewDirVaryingReg + ".w 		\n";

			_registerCache.removeVertexTempUsage(_globalPositionVertexReg);
		}

		private function compileLightingCode() : void
		{
			var shadowReg : ShaderRegisterElement;

			initLightRegisters();

			_vertexCode += _diffuseMethod.getVertexCode(_diffuseMethodVO, _registerCache);
			_fragmentCode += _diffuseMethod.getFragmentPreLightingCode(_diffuseMethodVO, _registerCache);

			if (_usingSpecularMethod) {
				_vertexCode += _specularMethod.getVertexCode(_specularMethodVO, _registerCache);
				_fragmentCode += _specularMethod.getFragmentPreLightingCode(_specularMethodVO, _registerCache);
			}

			_diffuseLightIndex = 0;
			_specularLightIndex = 0;

			if (_numLights > 0 && (_combinedLightSources & LightSources.LIGHTS)) {
				compileDirectionalLightCode();
				compilePointLightCode();
			}
			if (_numLightProbes > 0  && (_combinedLightSources & LightSources.PROBES))
				compileLightProbeCode();

			_vertexCode += _ambientMethod.getVertexCode(_ambientMethodVO, _registerCache);
			_fragmentCode += _ambientMethod.getFragmentCode(_ambientMethodVO, _registerCache, _shadedTargetReg);
			if (_ambientMethodVO.needsNormals) _registerCache.removeFragmentTempUsage(_normalFragmentReg);
			if (_ambientMethodVO.needsView) _registerCache.removeFragmentTempUsage(_viewDirFragmentReg);


			if (_shadowMethod) {
				_vertexCode += _shadowMethod.getVertexCode(_shadowMethodVO, _registerCache);
				// using normal to contain shadow data if available is perhaps risky :s
				// todo: improve compilation with lifetime analysis so this isn't necessary?
				if (_normalDependencies == 0) {
					shadowReg = _registerCache.getFreeFragmentVectorTemp();
					_registerCache.addFragmentTempUsages(shadowReg, 1);
				}
				else
					shadowReg = _normalFragmentReg;

				_diffuseMethod.shadowRegister = shadowReg;
				_fragmentCode += _shadowMethod.getFragmentCode(_shadowMethodVO, _registerCache, shadowReg);
			}
			_fragmentCode += _diffuseMethod.getFragmentPostLightingCode(_diffuseMethodVO, _registerCache, _shadedTargetReg);

			if (_alphaPremultiplied) {
				_fragmentCode += "add " + _shadedTargetReg + ".w, " + _shadedTargetReg + ".w, " + _commonsReg + ".z\n" +
								 "div " + _shadedTargetReg + ".xyz, " + _shadedTargetReg + ".xyz, " + _shadedTargetReg + ".w\n" +
								 "sub " + _shadedTargetReg + ".w, " + _shadedTargetReg + ".w, " + _commonsReg + ".z\n"
								 "sat " + _shadedTargetReg + ".xyz, " + _shadedTargetReg + ".xyz\n";
			}

			// resolve other dependencies as well?
			if (_diffuseMethodVO.needsNormals) _registerCache.removeFragmentTempUsage(_normalFragmentReg);
			if (_diffuseMethodVO.needsView) _registerCache.removeFragmentTempUsage(_viewDirFragmentReg);

			if (_usingSpecularMethod) {
				_specularMethod.shadowRegister = shadowReg;
				_fragmentCode += _specularMethod.getFragmentPostLightingCode(_specularMethodVO, _registerCache, _shadedTargetReg);
				if (_specularMethodVO.needsNormals) _registerCache.removeFragmentTempUsage(_normalFragmentReg);
				if (_specularMethodVO.needsView) _registerCache.removeFragmentTempUsage(_viewDirFragmentReg);
			}
		}

		private function initLightRegisters() : void
		{
			// init these first so we're sure they're in sequence
			var i : uint, len : uint;

			len = _dirLightRegisters.length;
			for (i = 0; i < len; ++i) {
				_dirLightRegisters[i] = _registerCache.getFreeFragmentConstant();
				if (_lightDataIndex == -1) _lightDataIndex = _dirLightRegisters[i].index*4;
			}

			len = _pointLightRegisters.length;
			for (i = 0; i < len; ++i) {
				_pointLightRegisters[i] = _registerCache.getFreeFragmentConstant();
				if (_lightDataIndex == -1) _lightDataIndex = _pointLightRegisters[i].index*4;
			}
		}

		private function compileDirectionalLightCode() : void
		{
			var diffuseColorReg : ShaderRegisterElement;
			var specularColorReg : ShaderRegisterElement;
			var lightDirReg : ShaderRegisterElement;
			var regIndex : int;
			var addSpec : Boolean = _usingSpecularMethod && ((_specularLightSources & LightSources.LIGHTS) != 0);
			var addDiff : Boolean = (_diffuseLightSources & LightSources.LIGHTS) != 0;

			if (!(addSpec || addDiff)) return;

			for (var i : uint = 0; i < _numDirectionalLights; ++i) {
				lightDirReg = _dirLightRegisters[regIndex++];
				diffuseColorReg = _dirLightRegisters[regIndex++];
				specularColorReg = _dirLightRegisters[regIndex++];
				if (addDiff) {
					_fragmentCode += _diffuseMethod.getFragmentCodePerLight(_diffuseMethodVO, _diffuseLightIndex, lightDirReg, diffuseColorReg, _registerCache);
					++_diffuseLightIndex;
				}
				if (addSpec) {
					_fragmentCode += _specularMethod.getFragmentCodePerLight(_specularMethodVO, _specularLightIndex, lightDirReg, specularColorReg, _registerCache);
					++_specularLightIndex;
				}

			}
		}

		private function compilePointLightCode() : void
		{
			var diffuseColorReg : ShaderRegisterElement;
			var specularColorReg : ShaderRegisterElement;
			var lightPosReg : ShaderRegisterElement;
			var lightDirReg : ShaderRegisterElement;
			var regIndex : int;
			var addSpec : Boolean = _usingSpecularMethod && ((_specularLightSources & LightSources.LIGHTS) != 0);
			var addDiff : Boolean = (_diffuseLightSources & LightSources.LIGHTS) != 0;

			if (!(addSpec || addDiff)) return;

			for (var i : uint = 0; i < _numPointLights; ++i) {
				lightPosReg = _pointLightRegisters[regIndex++];
				diffuseColorReg = _pointLightRegisters[regIndex++];
				specularColorReg = _pointLightRegisters[regIndex++];
				lightDirReg = _registerCache.getFreeFragmentVectorTemp();
				_registerCache.addFragmentTempUsages(lightDirReg, 1);

				// calculate direction
				_fragmentCode += "sub " + lightDirReg + ", " + lightPosReg + ", " + _globalPositionVaryingReg + "\n" +
				// attenuate
								"dp3 " + lightDirReg + ".w, " + lightDirReg + ".xyz, " + lightDirReg + ".xyz\n" +
								"sqt " + lightDirReg + ".w, " + lightDirReg + ".w\n" +
							// w = d - radis
								"sub " + lightDirReg + ".w, " + lightDirReg + ".w, " + diffuseColorReg + ".w\n" +
							// w = (d - radius)/(max-min)
								"mul " + lightDirReg + ".w, " + lightDirReg + ".w, " + specularColorReg + ".w\n" +
							// w = clamp(w, 0, 1)
								"sat " + lightDirReg + ".w, " + lightDirReg + ".w\n" +
							// w = 1-w
								"sub " + lightDirReg + ".w, " + lightPosReg + ".w, " + lightDirReg + ".w\n" +
				// normalize
								"nrm " + lightDirReg + ".xyz, " + lightDirReg + ".xyz	\n";

				if (_lightDataIndex == -1) _lightDataIndex = lightPosReg.index*4;
				if (addDiff) {
					// TODO: vo can contain register data
					_fragmentCode += _diffuseMethod.getFragmentCodePerLight(_diffuseMethodVO, _diffuseLightIndex, lightDirReg, diffuseColorReg, _registerCache);
					++_diffuseLightIndex;
				}
				if (addSpec) {
					_fragmentCode += _specularMethod.getFragmentCodePerLight(_specularMethodVO, _specularLightIndex, lightDirReg, specularColorReg, _registerCache);
					++_specularLightIndex;
				}

				_registerCache.removeFragmentTempUsage(lightDirReg);
			}
		}

		private function compileLightProbeCode() : void
		{
			var weightReg : String;
			var weightComponents : Array = [ ".x", ".y", ".z", ".w" ];
			var weightRegisters : Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>();
			var i : uint;
			var texReg : ShaderRegisterElement;
			var addSpec : Boolean = _usingSpecularMethod && ((_specularLightSources & LightSources.PROBES) != 0);
			var addDiff : Boolean = (_diffuseLightSources & LightSources.PROBES) != 0;

			if (!(addSpec || addDiff)) return;

			if (addDiff)
				_lightProbeDiffuseIndices = new Vector.<uint>();
			if (addSpec)
				_lightProbeSpecularIndices = new Vector.<uint>();

			for (i = 0; i < _numProbeRegisters; ++i) {
				weightRegisters[i] = _registerCache.getFreeFragmentConstant();
				if (i == 0) _probeWeightsIndex = weightRegisters[i].index*4;
			}

			for (i = 0; i < _numLightProbes; ++i) {
				weightReg = weightRegisters[Math.floor(i/4)].toString() + weightComponents[i % 4];

				if (addDiff) {
					texReg = _registerCache.getFreeTextureReg();
					_lightProbeDiffuseIndices[i] = texReg.index;
					_fragmentCode += _diffuseMethod.getFragmentCodePerProbe(_diffuseMethodVO, _diffuseLightIndex, texReg, weightReg, _registerCache);
					++_diffuseLightIndex;
				}

				if (addSpec) {
					texReg = _registerCache.getFreeTextureReg();
					_lightProbeSpecularIndices[i] = texReg.index;
					_fragmentCode += _specularMethod.getFragmentCodePerProbe(_specularMethodVO, _specularLightIndex, texReg, weightReg, _registerCache);
					++_specularLightIndex;
				}
			}
		}

		private function compileMethods() : void
		{
			var numMethods : uint = _methods.length;
			var method : EffectMethodBase;
			var data : MethodVO;

			for (var i : uint = 0; i < numMethods; ++i) {
				method = _methods[i].method;
				data = _methods[i].data;
				_vertexCode += method.getVertexCode(data, _registerCache);
				if (data.needsGlobalPos) _registerCache.removeVertexTempUsage(_globalPositionVertexReg);

				_fragmentCode += method.getFragmentCode(data, _registerCache, _shadedTargetReg);
				if (data.needsNormals) _registerCache.removeFragmentTempUsage(_normalFragmentReg);
				if (data.needsView) _registerCache.removeFragmentTempUsage(_viewDirFragmentReg);
			}

			if (_colorTransformMethod) {
				_vertexCode += _colorTransformMethod.getVertexCode(_colorTransformMethodVO, _registerCache);
				_fragmentCode += _colorTransformMethod.getFragmentCode(_colorTransformMethodVO, _registerCache, _shadedTargetReg);
			}
		}

		/**
		 * Updates the lights data for the render state.
		 * @param lights The lights selected to shade the current object.
		 * @param numLights The amount of lights available.
		 * @param maxLights The maximum amount of lights supported.
		 */
		private function updateLights(directionalLights : Vector.<DirectionalLight>, pointLights : Vector.<PointLight>, stage3DProxy : Stage3DProxy) : void
		{
			// first dirs, then points
			var dirLight : DirectionalLight;
			var pointLight : PointLight;
			var i : uint, k : uint;
			var len : int;
			var dirPos : Vector3D;

			_ambientLightR = _ambientLightG = _ambientLightB = 0;

			len = directionalLights.length;
			k = _lightDataIndex;
			for (i = 0; i < len; ++i) {
				dirLight = directionalLights[i];
				dirPos = dirLight.sceneDirection;

				_ambientLightR += dirLight._ambientR;
				_ambientLightG += dirLight._ambientG;
				_ambientLightB += dirLight._ambientB;

				_fragmentConstantData[k++] = -dirPos.x;
				_fragmentConstantData[k++] = -dirPos.y;
				_fragmentConstantData[k++] = -dirPos.z;
				_fragmentConstantData[k++] = 1;

				_fragmentConstantData[k++] = dirLight._diffuseR;
				_fragmentConstantData[k++] = dirLight._diffuseG;
				_fragmentConstantData[k++] = dirLight._diffuseB;
				_fragmentConstantData[k++] = 1;

				_fragmentConstantData[k++] = dirLight._specularR;
				_fragmentConstantData[k++] = dirLight._specularG;
				_fragmentConstantData[k++] = dirLight._specularB;
				_fragmentConstantData[k++] = 1;
			}

			// more directional supported than currently picked, need to clamp all to 0
			if (_numDirectionalLights > len) {
				i = k + (_numDirectionalLights - len) * 12;
				while (k < i)
					_fragmentConstantData[k++] = 0;
			}

			len = pointLights.length;
			for (i = 0; i < len; ++i) {
				pointLight = pointLights[i];
				dirPos = pointLight.scenePosition;

				_ambientLightR += pointLight._ambientR;
				_ambientLightG += pointLight._ambientG;
				_ambientLightB += pointLight._ambientB;

				_fragmentConstantData[k++] = dirPos.x;
				_fragmentConstantData[k++] = dirPos.y;
				_fragmentConstantData[k++] = dirPos.z;
				_fragmentConstantData[k++] = 1;

				_fragmentConstantData[k++] = pointLight._diffuseR;
				_fragmentConstantData[k++] = pointLight._diffuseG;
				_fragmentConstantData[k++] = pointLight._diffuseB;
				_fragmentConstantData[k++] = pointLight._radius;

				_fragmentConstantData[k++] = pointLight._specularR;
				_fragmentConstantData[k++] = pointLight._specularG;
				_fragmentConstantData[k++] = pointLight._specularB;
				_fragmentConstantData[k++] = pointLight._fallOffFactor;
			}

			// more directional supported than currently picked, need to clamp all to 0
			if (_numPointLights > len) {
				i = k + (len - _numPointLights) * 12;
				for (; k < i; ++k)
					_fragmentConstantData[k] = 0;
			}
		}

		private function updateProbes(lightProbes : Vector.<LightProbe>, weights : Vector.<Number>, stage3DProxy : Stage3DProxy) : void
		{
			var probe : LightProbe;
			var len : int = lightProbes.length;
			var addDiff : Boolean = _diffuseMethod && ((_diffuseLightSources & LightSources.PROBES) != 0);
			var addSpec : Boolean = _specularMethod && ((_specularLightSources & LightSources.PROBES) != 0);

			if (!(addDiff || addSpec)) return;

			for (var i : uint = 0; i < len; ++i) {
				probe = lightProbes[i];

				if (addDiff)
					stage3DProxy.setTextureAt(_lightProbeDiffuseIndices[i], probe.diffuseMap.getTextureForStage3D(stage3DProxy));
				if (addSpec)
					stage3DProxy.setTextureAt(_lightProbeSpecularIndices[i], probe.specularMap.getTextureForStage3D(stage3DProxy));
			}

			_fragmentConstantData[_probeWeightsIndex] = weights[0];
			_fragmentConstantData[_probeWeightsIndex + 1] = weights[1];
			_fragmentConstantData[_probeWeightsIndex + 2] = weights[2];
			_fragmentConstantData[_probeWeightsIndex + 3] = weights[3];
		}

		private function getMethodSetForMethod(method : EffectMethodBase) : MethodSet
		{
			var len : int = _methods.length;
			for (var i : int = 0; i < len; ++i)
				if (_methods[i].method == method) return _methods[i];

			return null;
		}

		private function onShaderInvalidated(event : ShadingMethodEvent) : void
		{
			invalidateShaderProgram();
		}
	}
}

import away3d.arcane;
import away3d.materials.methods.EffectMethodBase;
import away3d.materials.methods.MethodVO;

class MethodSet
{
	use namespace  arcane;

	public var method : EffectMethodBase;
	public var data : MethodVO;

	public function MethodSet(method : EffectMethodBase)
	{
		this.method = method;
		data = method.createMethodVO();
	}
}