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
package onyx.net {

	import onyx.core.IDisposable;
	import onyx.core.PluginBase;
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base class for external files
	 */
	public final class Plugin {
		
		/**
		 * 	Stores the name for the plug-in
		 */
		public var name:String;
		
		/**
		 * 	Class definition for the object
		 */
		onyx_ns var _definition:Class;
		
		/**
		 * 	Stores the description for the plug-in (for use in UI)
		 */
		public var description:String;
		
		/**
		 * 
		 */
		public var type:Class;
		
		/**
		 * 	@constructor
		 */
		public function Plugin(name:String, definition:Class, description:String):void {
			this.name = name;
			_definition = definition;
			this.description = description;
		}
		
		public function getDefinition():Object {
			var obj:PluginBase = new _definition() as PluginBase;
			obj._name = name;
			
			return obj;
		}

	}
}