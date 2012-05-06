/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package macros {

	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class DisplayFadeChopDown extends Macro {
		
		/**
		 * 
		 */
		private var filter:Filter;
		
		/**
		 * 
		 */
		override public function keyDown():void {
			
			filter = PluginManager.createFilter('ECHO') as Filter;
			filter.setParameterValue('feedBlend', 'darken');
			filter.setParameterValue('feedAlpha', .7);
			Display.addFilter(filter);
			
		}
		
		override public function keyUp():void {
			Display.removeFilter(filter);
			filter = null;
		}
	}
}