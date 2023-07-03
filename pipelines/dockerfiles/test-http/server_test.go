package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestHTTPServerResponse(t *testing.T) {
	request, _ := http.NewRequest(http.MethodGet, "/", nil)
	response := httptest.NewRecorder()

	getRoot(response, request)

	t.Run("Return status", func(t *testing.T) {
		resp := response.Body.String()
		expt := "UP"
		if !(strings.Contains(resp, "UP")) {
			t.Errorf("Got %q but expected %q", resp, expt)
		}
	})
}
