/**
 * Copyright (c) 2008 Bartek Drozdz (http://www.everydayflash.com)
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Same license applies to every file in this package and its subpackages.  
 */
package com.as3dmod3 {
	import com.as3dmod3.core.MeshProxy;
	import com.as3dmod3.plugins.Library3d;
	import com.as3dmod3.plugins.PluginFactory;

	/**
	 * <p><h2>Стек модификаторов.</h2></p>
	 * <p>Стек модификаторов- это основа библиотеки AS3Dmod. Он содержит ссылку на меш и массив с классами-модификаторами.</p>
	 * 
	 * <p>Автор: <a href="http://www.everydayflash.com">Bartek Drozdz</a></p>
	 * <p>Версия: 0.1</p>
	 */
	public class ModifierStack {
		private var lib3d : Library3d;
		private var baseMesh : MeshProxy;
		private var stack : Vector.<IModifier>;
		private var MeshProxyClass : Class;

		/**
		 * Создает новый экземпляр класса ModifierStack.
		 * @param	lib3d 	экземпляр класса, расширяющего класс com.as3dmod.plugins.Library3d для конкретного 3D-движка.
		 * @param	mesh 	меш, геометрию которого будут изменять модификаторы. 
		 * 			Например: для PV3D вы должны передать в этот параметр экземпляр класса com.as3dmod.plugins.pv3d.Pv3dMesh или одного из его подклассов. 
		 */
		public function ModifierStack(lib3d : Library3d, mesh : *) {
			this.lib3d = lib3d;
			MeshProxyClass = PluginFactory.getMeshProxyClass(lib3d);
			baseMesh = PluginFactory.getMeshProxy(lib3d);
			baseMesh.setMesh(mesh);
			baseMesh.analyzeGeometry();
			stack = new Vector.<IModifier>();
		}

		/**
		 * Меш, геометрию которого будут изменять модификаторы. 
		 * @see	com.as3dmod.core.MeshProxy
		 */
		public function get mesh() : MeshProxy {
			return baseMesh;
		}

		/**
		 * Добавляет модификатор в стек.
		 * @param	mod модификатор. Модификаторы применяются к геометрии меша в порядке их добавления в стек.
		 * 			То есть, первый добавленный модификатор в стек, будет применен к геометрии меша также первым.
		 */
		public function addModifier(mod : IModifier) : void {
			mod.setModifiable(baseMesh);
			stack.push(mod);
		}

		/**
		 *  Применяет все текущие модификаторы находящиеся в стеке к геометрии меша. 
		 *  При каждом вызове метода <code>apply()</code>, все изменения примененные к геометрии меша
		 *  ранее сбрасываются и модификаторы применяются снова к исходной геометрии меша.
		 *  Для того чтобы заменить исходную геометрию меша текущей, вызовите метод <code>collapse()</code>.
		 * 
		 * 	@see #collapse()
		 */
		public function apply() : void {
			baseMesh.resetGeometry();
			for (var i : int = 0; i < stack.length; i++) {
				(stack[i] as IModifier).apply();
			}
			MeshProxyClass(baseMesh).updateVertices();
		}

		/**
		 * 	Разрушает стек. 
		 *  Вызов этого метода приведет к тому, что все текущие модификаторы находящиеся в стеке
		 *  будут применены к геометрии меша, а затем удалены из стека. Исходная геометрия меша
		 *  при этом будет заменена на текущую, полученную в результате применения модификаторов.
		 */
		public function collapse() : void {
			apply();
			baseMesh.collapseGeometry();
			stack = new Vector.<IModifier>();
		}

		/** Очищает стек. Удаляет все модификаторы из стека. */
		public function clear() : void {
			stack = new Vector.<IModifier>();
		}

		/**
		 * Объект, содержащий информацию о модифицированном меше.
		 * @see com.as3dmod.IMeshInfo
		 */
		public function get meshInfo() : IMeshInfo {
			return baseMesh;
		}
	}
}