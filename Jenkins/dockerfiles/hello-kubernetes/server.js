var express = require('express');
var exphbs  = require('express-handlebars');
var app = express();
var os = require("os");
var sleep = require('sleep');
var morgan  = require('morgan');
var router = express.Router();

app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.set('view engine', 'handlebars');
app.use(express.static('static'));
app.use(morgan('combined'));


function retry(maxRetries, fn) {
  return fn().catch(function(err) {
    if (maxRetries <= 0) {
      throw err;
    }
    console.error(err.message)
    sleep.sleep(3)
    return retry(maxRetries - 1, fn);
  });
}

// Vault
const fs = require('fs');
const kubernetesCaCert = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/ca.crt', 'utf8');
const serviceAccountSecretToken = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/token', 'utf8');

var vault_role = process.env.VAULT_ROLE;
var vault_secret_path = process.env.VAULT_SECRET_PATH;
var vault = require("node-vault")();
var creds;

// switch on debug mode
//process.env.DEBUG = 'node-vault';

process.env.VAULT_SKIP_VERIFY = 'true';
vault.kubernetesLogin({role: vault_role, jwt: serviceAccountSecretToken, ca_cert: kubernetesCaCert})
.then((result) => {
  //console.log(result);
  vault.token = result.auth.client_token;
  vault.read(vault_secret_path)
    .then((res) => {
      creds = res.data
    })
})
.catch((err) => console.error(err.message));

// Configuration
var port = process.env.PORT || 8080;
var message = process.env.MESSAGE || "Hello world!";
//var creds = JSON.parse(fs.readFileSync('/secrets/creds.json'));

app.get('/', function (req, res) {
    // Get client IP
    var x_forwarded_for = req.get('X-Forwarded-For') || 'Header not set';

    res.render('home', {
	message: message,
	platform: os.type(),
	release: os.release(),
	hostName: os.hostname(),
	vaultRole: vault_role,
	xForwardedFor: x_forwarded_for,
	creds: JSON.stringify(creds)
	//creds: JSON.stringify(creds['data'])
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
