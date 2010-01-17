/** 
 * This is a generated sub-class of _VideoPong.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 **/

package services.videopong
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import onyx.core.Console;
	
	[Event(name="loggedin", type="flash.events.TextEvent")]
	
	public class VideoPong extends EventDispatcher
	{
		/**
		 * 	@private
		 */
		private static var _username:String;
		private static var _pwd:String;
		private var _folders:XML;
		private var _assets:XML;
		private var _folderResponse:uint;
		private var _loginResponse:uint;
		private var _sessiontoken:String;
		private var _fullUserName:String;
		
		/**
		 * 	VideoPong class instance
		 */
		private static const vpInstance:VideoPong = new VideoPong();
		
		/**
		 * 	Returns the VideoPong instance (singleton)
		 *  to avoid multiple instances
		 */
		
		public static function getInstance():VideoPong {
			return vpInstance;
		}
		
		// Constructor
		public function VideoPong()
		{
			_username = 'username';
			_pwd = 'password';
			
			super();
		}
		
		/**
		 * Login
		 */
		public function vpLogin():void 
		{
			
			//Call videopong webservice
			var request:URLRequest = new URLRequest( 'http://www.videopong.net' );
			request.method = URLRequestMethod.POST;
			
			var reqData:Object = new Object();
			reqData.action = 'onyxapi';
			reqData.method = 'login';
			reqData.user = username;
			reqData.pass = pwd;
			reqData.passhashed = 0;
			request.data = reqData;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loginHandler );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, faultHandler ); 
			loader.load( request );
			
		}		
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:Event ):void {
			
			var result:String =	event.currentTarget.toString();
			var res:XML = XML(result);
			
			if (event is ErrorEvent) 
			{
				Console.output( 'Videopong login error: ' + (event as IOErrorEvent).text );
			}
			else
			{ 
				
			}
			loginResponse = res..ResponseCode;//0 if ok 1 if not then it is a guest
			sessiontoken = res..SessionToken;
			fullUserName = res..UserName;
			var tEvent:TextEvent = new TextEvent("loggedin");
			tEvent.text = fullUserName;
			dispatchEvent(tEvent);
			
			Console.output( "VideopongWindow, loginHandler, response: " + loginResponse );  
			// ask for folders tree
			//vpFoldersResponder = new CallResponder();
			// addEventListener for response
			//vpFoldersResponder.addEventListener( ResultEvent.RESULT, foldersTreeHandler );
			//vpFoldersResponder.addEventListener( FaultEvent.FAULT, faultHandler );
			//vp.operations
			//vpFoldersResponder.token = getfolderstreeassets( "onyxapi", "getfolderstreeassets", sessiontoken, "1" );
			
		}		
		public function foldersTreeHandler( event:Event ):void {
			
			var result:String =	event.currentTarget.toString();
			folders = XML(result);
			
			folderResponse = folders..ResponseCode;//0 if ok
			Console.output( "VideopongWindow, foldersTreeHandler, ResponseCode: " + folderResponse );  
			//if ( folderResponse == 0 ) retrieveAssets();
			
		}
		
		/**
		 * getAssets based on folderId
		 */
		public function vpGetAssets( folderId:String ):XMLList {
			var assetsList:XMLList;
			assetsList = assets.asset.(@folderid == folderId);
			return assetsList;
		}		
		public function faultHandler( event:Event ):void {
			
			var faultString:String = event.currentTarget.toString();
			
			Console.output("VideopongWindow, faultHandler, faultString: "+faultString);  
			
		}	
		public function get folders():XML
		{
			return _folders;
		}
		
		public function set folders(value:XML):void
		{
			_folders = value;
		}
		
		public function get sessionToken():String
		{
			return sessiontoken;
		}
		
		public function set sessionToken(value:String):void
		{
			sessiontoken = value;
		}
		
		public function get pwd():String
		{
			return _pwd;
		}
		
		public function set pwd(value:String):void
		{
			_pwd = value;
		}
		public function get fullUserName():String
		{
			return _fullUserName;
		}
		
		public function set fullUserName(value:String):void
		{
			_fullUserName = value;
		}
		public function get username():String
		{
			return _username;
		}
		
		public function set username(value:String):void
		{
			_username = value;
		}
		
		public function get folderResponse():uint
		{
			return _folderResponse;
		}
		
		public function set folderResponse(value:uint):void
		{
			_folderResponse = value;
		}
		
		public function get loginResponse():uint
		{
			return _loginResponse;
		}
		
		public function set loginResponse(value:uint):void
		{
			_loginResponse = value;
		}
		
		public function get sessiontoken():String
		{
			return _sessiontoken;
		}
		
		public function set sessiontoken(value:String):void
		{
			_sessiontoken = value;
		}
		
		public function get assets():XML
		{
			return _assets;
		}
		
		public function set assets(value:XML):void
		{
			_assets = value;
		}
		/**
		 * 	@public
		 */
		public function dispose():void {
			
			
		}
		
		
	}
}
