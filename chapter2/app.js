const http = require('http');
const os = require('os');

console.log("xx server starting...");

var handler = function (request, response) {
    console.log("received request from  " + request.connection.remoteAddress);
    response.writeHead(200);
    response.end("you've hit " + os.hostname() + "\n");
};

var server = http.createServer(handler);
server.listen(8088);
