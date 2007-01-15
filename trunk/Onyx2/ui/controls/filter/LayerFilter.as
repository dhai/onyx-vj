/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package ui.controls.filter {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import onyx.core.Onyx;
	import onyx.core.onyx_ns;
	import onyx.filter.Filter;
	import onyx.layer.Layer;
	import onyx.plugin.Plugin;
	
	import ui.assets.AssetLayerFilter;
	import ui.controls.ButtonClear;
	import ui.controls.UIControl;
	import ui.core.UIObject;
	import ui.layer.UILayer;
	import ui.text.Style;
	import ui.text.TextField;
	
	use namespace onyx_ns;

	public final class LayerFilter extends UIObject {
		
		public var filter:Filter;
		private var _layer:Layer;

		private var _label:TextField			= new TextField(72,10);
		private var _btnDelete:ButtonClear		= new ButtonClear(9,9);
		private var _bg:AssetLayerFilter		= new AssetLayerFilter();
		
		public function LayerFilter(filter:Filter, layer:Layer):void {
			
			this.filter = filter;
			_layer = layer;
			_draw();
			
			doubleClickEnabled = true;

			_btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, _onDeleteDown, false, -1);
			
		}
		
		/**
		 * 	@private
		 */
		private function _onDeleteDown(event:MouseEvent):void {
			
			if (event.ctrlKey) {
				
				var plugin:Plugin		= Filter.getDefinition(filter.name);
				var filterClass:Class	= plugin._definition;
				var layers:Array		= UILayer.layers;
				
				for each (var layer:UILayer in layers) {
					
					if (layer.layer !== _layer) {
						var filters:Array = layer.layer.filters;
						
						for each (var filter:Filter in filters) {
							if (filter is filterClass) {
								layer.layer.removeFilter(filter);
								break;
							}
						}
					}
				}
			
			}

			_layer.removeFilter(this.filter);
			
			// event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function _draw():void {
			
			_label.text			= filter.name;
			_label.y			= 2;
			_label.x			= 2;
			
			_btnDelete.x 		= 71;
			_btnDelete.y 		= 2;
			
			addChild(_bg);
			addChild(_label);
			addChild(_btnDelete);
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			_btnDelete.removeEventListener(MouseEvent.MOUSE_DOWN,		_onDeleteDown);
			
			filter = null;
			_layer = null;
			
			super.dispose();
		}
		
	}
}