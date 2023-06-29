package test

import (
	"crypto/tls"
	"flag"
	"fmt"
	"net"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/stretchr/testify/assert"
)

const (
	k8sResourceName    = "hello-world"   // name of K8s test resource(s)
	maxRetries         = 20              // number of retries
	timeBetweenRetries = 3 * time.Second // seconds between retries
)

var namespace = flag.String("namespace", "default", "Kubernetes namespace to run tests in.")

func TestExternalDNS(t *testing.T) {

	// Path to the Kubernetes resource config we will test.
	kubeResourcePath := "./test_deployment.yaml"

	// Setup the kubectl config and context.
	options := k8s.NewKubectlOptions("", "", *namespace)

	// At the end of the test, clean up any resources that were created.
	defer k8s.KubectlDelete(t, options, kubeResourcePath)

	// Deploy test resources. Fail the test if there are any errors.
	k8s.KubectlApply(t, options, kubeResourcePath)

	// Wait for all pods to be ready.
	k8s.WaitUntilDeploymentAvailable(t, options, k8sResourceName, maxRetries, timeBetweenRetries)

	// Wait for service endpoints to be ready to accept traffic.
	k8s.WaitUntilServiceAvailable(t, options, k8sResourceName, maxRetries, timeBetweenRetries)

	// Wait for ingress resource to have an endpoint provisioned for it.
	k8s.WaitUntilIngressAvailable(t, options, k8sResourceName, maxRetries, timeBetweenRetries)
	ingressHost := k8s.GetIngress(t, options, k8sResourceName).Spec.TLS[0].Hosts[0]
	url := fmt.Sprintf("https://%s", ingressHost)

	retry.DoWithRetry(t, "Wait for FQDN to be resolvable", maxRetries, timeBetweenRetries,
		func() (string, error) {
			_, err := net.LookupIP(ingressHost)
			assert.Nil(t, err)
			return "", err
		},
	)

	// Make an HTTPS request to the URL and make sure it returns a 200 OK.
	tlsConfig := &tls.Config{
		InsecureSkipVerify: true,
	}
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, tlsConfig, maxRetries, timeBetweenRetries,
		func(statusCode int, body string) bool {
			return statusCode == 200
		},
	)
}
