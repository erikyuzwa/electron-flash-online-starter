
package {

    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.system.Capabilities;

    import net.flashpunk.World;
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Text;

    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;

    public class PlayWorld extends World {

        private var _textLabel:Text;
        private var _textEntity:Entity;
        private var _socket:NodeSocket;

        public function PlayWorld() {

            this._socket = new NodeSocket("127.0.0.1", 8000);

            this._textLabel = new Text("Press [Enter] to connect to server");
            
        }

        override public function begin(): void {

            // our default screen color
            FP.screen.color = 0x332222;

            this._textEntity = new Entity(0, 0, this._textLabel);
            this._textEntity.x = (FP.width / 2) - (this._textLabel.width / 2);
            this._textEntity.y = (FP.height / 2) - (this._textLabel.height / 2);
            this.add(this._textEntity);

            this._socket.onConnect = this.onNetConnect;
            this._socket.onDisconnect = this.onNetDisconnect;
            this._socket.onError = this.onNetError;
          
        }

        override public function update(): void {

            if (Input.check(Key.ENTER)) {
                if (!this._socket._isConnected) {
                  FP.screen.color = 0x338822;
                  this._textLabel.text = "connecting...";
                  this._socket.connect();
                }
            }

            if (Input.check(Key.ESCAPE)) {
              if (this._socket._isConnected) {
                 FP.screen.color = 0x882222;
                 this._textLabel.text = "disconnecting...";
                 this._socket.disconnect();
              }
            }


        }

        public function onNetConnect(): void {

            this._textLabel.text = "connected - Press [ESC] to disconnect";
            FP.screen.color = 0x22ff22;

        }

        public function onNetDisconnect(): void {

            this._textLabel.text = "disconnected";
            FP.screen.color = 0x332222;

        }

        public function onNetError(): void {
           this._textLabel.text = "error connecting to server";
           FP.screen.color = 0x992222;
        }

    }


}
