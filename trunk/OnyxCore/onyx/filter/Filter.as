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
package onyx.filter {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.FileFilter;
	import flash.utils.*;
	
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.core.*;
	import onyx.events.FilterEvent;
	import onyx.layer.IColorObject;
	import onyx.plugin.Plugin;
	
	use namespace onyx_ns;
	
	/**
	 * 	The base Filter class
	 */
	public class Filter extends PluginBase implements IControlObject {
		
		/**
		 * 	Pre-process tells the filter that it is to render before the content renders
		 */
		public static const PRE_PROCESS:int		= 0;
		
		/**
		 * 	Normal process tells the filter that it is to render normally (after content renders)
		 */
		public static const NORMAL_PROCESS:int	= 1;
		
		/**
		 * 	Post process tells the filter that it is to render after all content and filters have been rendered
		 */
		public static const POST_PROCESS:int	= 2;
		
		/**
		 * 	@private
		 * 	Stores definitions
		 */
		private static var _definition:Object	= new Object();
		
		/**
		 * 	@private
		 */
		private static var _filters:Array		= [];
		
		/**
		 * 	Registers a plugin
		 */
		onyx_ns static function registerPlugin(plugin:Plugin):void {
			_definition[plugin.name] = plugin;
			_filters.push(plugin);
		}

		/**
		 * 	Returns a definition
		 */
		public static function getDefinition(name:String):Plugin {
			return _definition[name];
		}
		
		/**
		 * 
		 */
		public static function get filters():Array {
			return _filters.concat();
		}

		/**
		 * 	Stores the layer
		 */
		protected var content:IContent;
		
		/**
		 * 	@private
		 * 	Stores whether the filter is unique or not
		 */
		onyx_ns var _unique:Boolean;
		
		/**
		 * 	@contructor
		 */
		final public function Filter(unique:Boolean, ... controls:Array):void {
			
			super();
			
			_unique = unique;
			
			super.controls.addControl.apply(null, controls);
			
		}
		
		/**
		 * 	Returns the name of the filter
		 */
		final public function get name():String {
			return _name;
		}
		
		/**
		 * 	Gets the index of the filter
		 */
		final public function get index():int {
			return content.getFilterIndex(this);
		}

		/**
		 * 	@private
		 *	Called by layer when a filter is added to it
		 */
		onyx_ns final function setContent(content:IContent):void {
			this.content	= content;
		}
		
		/**
		 * 	Initialized when the filter is added to the object
		 */
		public function initialize():void {
		}
		
		/**
		 * 	Clones the filter
		 */
		final public function clone():Filter {
			var plugin:Plugin = Filter.getDefinition(_name);
			var filter:Filter = plugin.getDefinition() as Filter;
			
			for each (var control:Control in controls) {
				var newControl:Control = filter.controls.getControl(control.name);
				newControl.value = control.value;
			}
			
			return filter;
		}
		
		/**
		 * 	Moves the filter up
		 */
		final public function moveFilter(index:int):void {
			content.moveFilter(this, index);
		}
		
		/**
		 * 
		 */
		final public function removeFilter():void {
			content.removeFilter(this);
		}
		
		/**
		 * 	@private
		 */
		onyx_ns final function cleanContent():void {
			content	= null;
			
			if (super.controls) {
				super.dispose();
			}
		}
	}
}