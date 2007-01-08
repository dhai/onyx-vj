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
package onyx.layer {
	
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import onyx.application.Onyx;
	import onyx.content.IContent;
	import onyx.controls.Control;
	import onyx.controls.ControlValue;
	import onyx.controls.Controls;
	import onyx.core.onyx_internal;
	import onyx.filter.Filter;
	import onyx.net.Plugin;
	
	use namespace onyx_internal;

	/**
	 * 	This class stores settings that can be applied to layers
	 */
	public class LayerSettings extends EventDispatcher {

		public var x:Number				= 0;
		public var y:Number				= 0;
		public var scaleX:Number		= 1;
		public var scaleY:Number		= 1;
		public var rotation:Number		= 0;

		public var alpha:Number			= 1;
		public var brightness:Number	= 0;
		public var contrast:Number		= 0;
		public var saturation:Number	= 1;
		public var tint:Number			= 0;
		public var color:uint			= 0;
		public var threshold:Number		= 0;
		public var blendMode:String		= 'normal';
		
		public var time:Number			= 0;
		public var framerate:Number		= 1;

		public var filters:Array;
		public var controls:Controls;

		public var loopStart:Number		= 0;
		public var loopEnd:Number		= 1;
		public var path:String;
		
		/**
		 * 	@constructor
		 */
		public function LayerSettings():void {
		}
		
		public function load(layer:Layer):void {
			var content:IContent = layer._content;
			
			x			= content.x;
			y			= content.y;
			scaleX		= content.scaleX;
			scaleY		= content.scaleY;
			rotation	= content.rotation;
			
			alpha		= content.alpha;
			brightness	= content.brightness;
			contrast	= content.contrast;
			saturation	= content.saturation;
			color		= content.color;
			tint		= content.tint;
			threshold	= content.threshold;
			blendMode	= content.blendMode;
			
			time		= content.time;
			framerate	= content.framerate;

			loopStart	= content.loopStart;
			loopEnd		= content.loopEnd;
			
			path		= layer.path;
			filters		= content.filters.concat();
			
			if (layer.controls) {
				controls = layer.controls;
			}
		}
		
		/**
		 * 	Loads settings info from xml
		 */
		public function loadFromXML(xml:XML):void {
			
			x			= xml.properties.x;
			y			= xml.properties.x;
			alpha		= xml.properties.alpha;
			scaleX		= xml.properties.scaleX;
			scaleY		= xml.properties.scaleY;
			rotation	= xml.properties.rotation;
			brightness	= xml.properties.brightness;
			contrast	= xml.properties.contrast;
			saturation	= xml.properties.saturation;
			tint		= xml.properties.tint;
			color		= xml.properties.color;
			threshold	= xml.properties.threshold;
			blendMode	= xml.properties.blendMode;
			time		= xml.properties.time;
			framerate	= xml.properties.framerate;
			loopStart	= xml.properties.loopStart;
			loopEnd		= xml.properties.loopEnd;
			path		= xml.@path;
			
			if (xml.controls) {
				
				controls = new Controls(null);
				
				// tbd: add filters and controls
				for each (var controlXML:XML in xml.controls.*) {
					controls.addControl(new ControlValue(controlXML.name(), controlXML));
				}
			}
			
			if (xml.filters) {
				
				filters = [];
				
				for each (var filterXML:XML in xml.filters.*) {
					
					var name:String			= filterXML.@id;
					var plugin:Plugin		= Onyx.getDefinition(name);
					
					if (plugin) {
						
						var filter:Filter = new plugin.definition();
						
						for each (controlXML in filterXML.*) {
							name = controlXML.name();
							filter[name] = _parseBoolean(controlXML);
						}
						
						filters.push(filter);
						
					}
				}
				
			}
		}
		
		/**
		 * 	Converts String 'false' to Boolean 
		 */
		private function _parseBoolean(value:*):* {
			var name:String = value;
			return (name === 'false') ? false : value;
		}
		
		/**
		 * 	Applies values to a layer
		 */
		public function apply(content:IContent):void {
			
			content.x = x;
			content.y = y;
			content.scaleX = scaleX;
			content.scaleY = scaleY;
			content.rotation = rotation;
			
			content.alpha = alpha;
			
			content.brightness = brightness;
			content.contrast = contrast;
			content.saturation = saturation;
			content.color = color;
			content.tint = tint;
			content.threshold = threshold;
			content.blendMode = blendMode;
			
			content.framerate = framerate;
			content.loopStart = loopStart;
			content.loopEnd = loopEnd;
			content.time = time;
			
			// clone filters
			for each (var filter:Filter in filters) {
				content.addFilter(filter.clone());
			}
			
			// apply controls
			if (controls && content.controls) {
				for each (var control:Control in controls) {
					var targetControl:Control = content.controls.getControl(control.name);
					targetControl.value = control.value;
				}
			}
		}
		
		public function toXML():XML {

			var xml:XML =
				<layer path={path}>
					<properties>
						<x>{x}</x>
						<y>{y}</y>
						<scaleX>{scaleX.toFixed(3)}</scaleX>
						<scaleY>{scaleY.toFixed(3)}</scaleY>
						<rotation>{rotation.toFixed(3)}</rotation>
						<alpha>{alpha.toFixed(3)}</alpha>
						<brightness>{brightness.toFixed(3)}</brightness>
						<contrast>{contrast.toFixed(3)}</contrast>
						<saturation>{saturation.toFixed(3)}</saturation>
						<tint>{tint.toFixed(3)}</tint>
						<color>{color}</color>
						<threshold>{threshold.toFixed(3)}</threshold>
						<blendMode>{blendMode}</blendMode>
						<time>{time.toFixed(3)}</time>
						<framerate>{framerate.toFixed(3)}</framerate>
						<loopStart>{loopStart.toFixed(3)}</loopStart>
						<loopEnd>{loopEnd.toFixed(3)}</loopEnd>
					</properties>
				</layer>
				
			if (filters.length) {
				var filterXML:XML = <filters/>
			
				for each (var filter:Filter in filters) {
					
					var prop:XML = _controlsToXML(<filter id={filter.name}/>, filter.controls);
					filterXML.appendChild(prop);
					
				}
				
				xml.appendChild(filterXML);
			}
			
			if (controls) {
				
				var controlXML:XML = <controls/>;
				
				for each (var control:Control in controls) {
					controlXML.appendChild(<{control.name}>{control.value}</{control.name}>);
				}
				
				xml.appendChild(controlXML);
			}
			
			return xml;
			
		}
		
		/**
		 * 
		 */
		private function _controlsToXML(xml:XML, controls:Controls):XML {
			
			var propXML:XML;
			
			for each (var control:Control in controls) {
				var name:String = control.name;
				if (control.value is Number) {
					var value:String = (control.value as Number).toFixed(3);
					propXML = <{name}>{value}</{name}>;
				} else {
					propXML = <{name}>{control.value}</{name}>;
				}
				
				xml.appendChild(propXML);
			}
			
			return xml;
		}
	}
}