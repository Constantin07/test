var express = require('express');
var exphbs  = require('express-handlebars');
var app = express();
var os = require("os");
var morgan  = require('morgan');
var router = express.Router();

const fs = require('fs');

app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.set('view engine', 'handlebars');
app.use(express.static('static'));
app.use(morgan('combined'));

// Vault
const kubernetesCaCert = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/ca.crt', 'utf8');
const servicAccountSecretToken = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/token', 'utf8');

var vault_role = process.env.VAULT_ROLE;
var vault_secret_path = process.env.VAULT_SECRET_PATH;
var vault = require("node-vault")();
var creds;

process.env.VAULT_SKIP_VERIFY = 'true';
vault.write('auth/kubernetes/login', { ca_cert: kubernetesCaCert, jwt: servicAccountSecretToken, role: vault_role})
  .then((result) => {
  vault.token = result.auth.client_token;
  vault.read(vault_secret_path)
  .then((res) => creds = res.data)
  .catch((err) => console.error(err.message));
});

// Configuration
var port = process.env.PORT || 8080;
var message = process.env.MESSAGE || "Hello world!";
//var creds = JSON.parse(fs.readFileSync('/secrets/creds.json'));

app.get('/', function (req, res) {
    res.render('home', {
	message: message,
	platform: os.type(),
	release: os.release(),
	hostName: os.hostname(),
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
