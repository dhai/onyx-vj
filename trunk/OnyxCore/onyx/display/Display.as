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
package onyx.display {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.ApplicationEvent;
	import onyx.events.LayerEvent;
	import onyx.jobs.LoadONXJob;
	import onyx.layer.Layer;
	import onyx.layer.LayerProperties;
	import onyx.layer.LayerSettings;
	import onyx.transition.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	
	 */
	public class Display extends Sprite implements IControlObject {
		
		/** @private **/
		private var _backgroundColor:uint		= 0x000000;

		/** @private **/
		private var _background:BitmapData		= new BitmapData(320, 240, false, _backgroundColor);
		
		/** @private **/
		private var __x:Control					= new ControlInt('x', 'x', 0, 2000, 640);
		private var __y:Control					= new ControlInt('y', 'y', 0, 2000, 480);
		private var	_size:DisplaySize			= DisplaySize.SIZES[0];
		
		// add the controls that we can bind to
		private var _controls:Controls;
		
		private var _layers:Array		= [];
		
		public function Display():void {
			
			_controls = new Controls(this,
				new ControlProxy(
					'position', 'position',
					__x,
					__y,
					{ invert:true }
				),
				new ControlColor(
					'backgroundColor', 'backgroundColor'
				)
			);
			
			addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			
			mouseChildren = false;
			addChild(new Bitmap(_background));

		}
		
		/**
		 * 	@private
		 */
		private function _onMouseOver(event:MouseEvent):void {
			Mouse.hide();
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseOut(event:MouseEvent):void {
			Mouse.show();
		}
		
		/**
		 * 	Returns the number of layers
		 */
		public function get numLayers():int {
			return _layers.length;
		}
		
		/**
		 * 	Creates a specified number of layers
		 */
		public function createLayers(numLayers:uint, local:Boolean = true):void {
			
			while (numLayers-- ) {
				
				// create a new layer and set it's index
				var layer:Layer = new Layer();
				_layers.push(layer);
				
				// listen for move events, etc
				layer.addEventListener(LayerEvent.LAYER_COPY_LAYER,	_onLayerCopy);
				
				// add the layer to this display object
				addChildAt(layer, 1);
				
				// dispatch
				var event:LayerEvent = new LayerEvent(LayerEvent.LAYER_CREATED, layer);
				
				// dispatch a layer create
				var dispatcher:EventDispatcher = Onyx.getInstance();
				dispatcher.dispatchEvent(event);
			}
		}
		
		/**
		 * 	@private
		 * 	Copies a layer
		 */
		private function _onLayerCopy(event:LayerEvent):void {
			copyLayer(event.layer, event.layer.index + 1);
		}
		
		/**
		 * 	Returns the layers
		 */
		public function get layers():Array {
			return _layers.concat();
		}
		
		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(layer:Layer, index:int):void {
			
			var fromIndex:int = layer.index;
			var toLayer:Layer = _layers[index];
			
			if (toLayer) {
				
				var numLayers:int = _layers.length;
				
				var fromChildIndex:int = getChildIndex(layer);
				var toChildIndex:int = getChildIndex(toLayer);
				
				setChildIndex(layer, toChildIndex);
				setChildIndex(toLayer, fromChildIndex);
				
				_layers[fromIndex] = toLayer;
				_layers[index] = layer;
				
				setChildIndex(layer, toChildIndex);
				setChildIndex(toLayer, fromChildIndex);
				
				layer.dispatch(new LayerEvent(LayerEvent.LAYER_MOVE, layer));
				toLayer.dispatch(new LayerEvent(LayerEvent.LAYER_MOVE, toLayer));
				
			}
		}
		
		/**
		 * 	Gets the display index
		 */
		public function get index():int {
			return Onyx._displays.indexOf(this);
		}
		
		/**
		 * 	Gets the controls related to the display
		 */
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Copies a layer
		 */
		public function copyLayer(layer:Layer, index:int):void {
			
			var layerindex:int = layer.index;
			var copylayer:Layer = _layers[index];
			
			if (copylayer) {
				
				var settings:LayerSettings = new LayerSettings();
				settings.load(layer);
				copylayer.load(new URLRequest(layer.path), settings);
				
			}
		}
		
		/**
		 * 
		 */
		public function indexOf(layer:Layer):int {
			return _layers.indexOf(layer);
		}
		
		/**
		 * 	Returns the display as xml
		 */
		public function toXML():XML {
			var xml:XML = <display/>
			
			for each (var layer:Layer in _layers) {
				if (layer.path) {
					var settings:LayerSettings = new LayerSettings();
					settings.load(layer);
					xml.appendChild(settings.toXML());
				}
			}
			
			return xml;
		}
		
		/**
		 * 	Loads a mix file into the layers
		 */
		public function load(request:URLRequest, origin:Layer, transition:Transition):void {
			
			var job:LoadONXJob = new LoadONXJob(request, origin, transition);
			
		}
		
		/**
		 * 
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			_background.fillRect(_background.rect, _backgroundColor);
		}
		
		/**
		 * 
		 */
		override public function set x(value:Number):void {
			super.x = __x.setValue(value);
		}
		
		/**
		 * 
		 */
		override public function set y(value:Number):void {
			super.y = __y.setValue(value);
		}
		
		/**
		 * 
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		/**
		 * 
		 */
		public function set size(value:DisplaySize):void {
			_size	= value;
			scaleX	= value.scale;
			scaleY	= value.scale;
		}
		
		/**
		 * 
		 */
		public function get size():DisplaySize {
			return _size;
		}
		
		/**
		 * 
		 */
		public function dispose():void {
		}
	}
}