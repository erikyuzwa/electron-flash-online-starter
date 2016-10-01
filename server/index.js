
/**
 * a barebones Flash socket server for Flash clients, we need to 
 * respond to the cross-domain policy file request.
 */
var net = require('net');
var hostPort = 8000;

var server = net.createServer(function (socket) {
     
     socket.setEncoding('utf8');
 
     // send the Cross Domain Policy
     socket.write(writeCrossDomainFile() + '\0');

     // the initial connection by the Flash client will request 
     // the cross-domain policy file
     function on_policy_check(data) {
          socket.removeListener('data', on_policy_check);
          socket.on('data', on_data);
 
          try {
               if (data === '<policy-file-request/>\0') {
                  console.log('client requesting cross domain policy file');
                  socket.write(streamCrossDomainFile());
               } else {
                  console.log('[DEBUG] ' + data);
                  socket.write('Echo: ' + data);
               }
          }
          catch (ex) {
               console.log(ex);
          }
     }
 
     function on_data(data) {
          socket.write('Echo: ' + data);
     }
 
     socket.on('data', on_policy_check);
 
     socket.on('error', function (exception) {
          socket.end();
     });
 
     socket.on('timeout', function () {
          socket.end();
     });
 
     socket.on('close', function (had_error) {
          socket.end();
          console.log('[DEBUG] client disconnected');
     });
});

server.listen(hostPort);
console.log('[DEBUG] server listening on *:' + hostPort);
 
function streamCrossDomainFile() {
     
     var xml = '<?xml version="1.0"?>\n<!DOCTYPE cross-domain-policy SYSTEM'
     xml += ' "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">';
     xml += '\n<cross-domain-policy>\n';
     xml += '<allow-access-from domain="*" to-ports="*"/>\n';
     xml += '</cross-domain-policy>\n';
 
     return xml;
}