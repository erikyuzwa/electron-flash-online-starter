package {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
 
     public class NodeSocket {

          private var _socket:Socket;
          private var _beenVerified:Boolean;
 
          private var _serverUrl:String;
          private var _port:int;

          // boolean to track if our socket is connected or not
          public var _isConnected:Boolean;

          // some exposed callback Functions that we can make use
          // of from any calling Object
          public var onConnect:Function;
          public var onDisconnect:Function;
          public var onError:Function;
 
          public function NodeSocket(url:String, port:int):void {
               this._serverUrl = url;
               this._port = port;

               this.onConnect = null;
               this.onDisconnect = null;
               this.onError = null;
          }
 
          public function connect():void {
               cleanUpSocket();
 
               _socket = new Socket();
               _socket.addEventListener(Event.CONNECT, onSocketConnect);
               _socket.addEventListener(Event.CLOSE, onSocketDisconnect);
               _socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
               _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
               _socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
 
               _socket.connect(this._serverUrl, this._port);
          }

          public function disconnect():void {
             
             this.disconnectSocket();

             if (this.onDisconnect) {
               this.onDisconnect();
             }

          }
 
          private function onSocketConnect(e:Event):void {

               this._isConnected = true;

               if (this.onConnect) {
                 this.onConnect();
               }
          }
 
          private function onSocketDisconnect(e:Event):void {

               if (this.onError) {
                 this.onError();
               }

               disconnectSocket();
          }
 
          private function onSecurityError(e:SecurityErrorEvent):void {
               
               if (this.onError) {
                 this.onError();
               }

               disconnectSocket();
          }
 
          private function onIOError(e:IOErrorEvent):void {
               
               if (this.onError) {
                 this.onError();
               }

               disconnectSocket();
          }
 
          private function onSocketData(e:ProgressEvent):void {

               var message:String = this._socket.readUTFBytes(this._socket.bytesAvailable);
 
               //_beenVerified is set so that we don't interpret
               //the Cross Domain response as an actual message
               if (this._beenVerified) {
                    trace(message);
               } else {
                    this._beenVerified = true;
               }
          }
 
          public function writeMessage(message:String):void {

             if (this._isConnected) {
               this._socket.writeUTFBytes(message);
               this._socket.flush();
             }
          }
 
          private function disconnectSocket():void {
               
               cleanUpSocket();
          }
 
          private function cleanUpSocket():void {

               if (this._socket != null) {
                    if (this._socket.connected) {
                         this._socket.close();
                    }
 
                    this._beenVerified = false;
                    this._socket = null;
               }

               this._isConnected = false;
          }
     }

}
