var express = require('express');
var exphbs  = require('express-handlebars');
var app = express();
var os = require("os");
var morgan = require('morgan');
var router = express.Router();

app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.set('view engine', 'handlebars');
app.use(express.static('static'));
app.use(morgan('combined'));

var vault_secret_path = process.env.VAULT_SECRET_PATH;
var options = { token: ''};
var vault = require("node-vault")(options);
var creds;

// switch on debug mode
//process.env.DEBUG = 'node-vault';

console.log('Reading Vault secrets');
setTimeout(function() {
  vault.read(vault_secret_path)
  .then((result) => {
    creds = result.data
  })
  .catch((err) => console.error(err.message));
}, 5000);

// Configuration
var port = process.env.PORT || 8080;
var message = process.env.MESSAGE || "Hello world!";

app.get('/', function (req, res) {
    // Get client IP
    var x_forwarded_for = req.get('X-Forwarded-For') || 'Header not set';

    res.render('home', {
	message: message,
	platform: os.type(),
	release: os.release(),
	hostName: os.hostname(),
	xForwardedFor: x_forwarded_for,
	creds: JSON.stringify(creds)
    });
});

// Health check
router.get('/', function (req, res, next) {
    res.json({status: 'UP'});
});

app.use("/health", router);

// Set up listener
app.listen(port, function () {
    console.log("Listening on: http://%s:%s", os.hostname(), port);
});
