package main

import (
	"bytes"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

type CertState struct {
	DesiredState string `json:"desired_state"`
}
type Payload struct {
	Certname string `json:"certname"`
}
type PurgeNode struct {
	Command string  `json:"command"`
	Version int     `json:"version"`
	Payload Payload `json:"payload"`
}

func main() {
	cert, err := tls.LoadX509KeyPair("/etc/puppetlabs/puppet/ssl/certs/nodripa.purge-node.pem", "/etc/puppetlabs/puppet/ssl/private_keys/nodripa.purge-node.pem")
	if err != nil {
		log.Fatal(err)
	}

	caCert, err := ioutil.ReadFile("/etc/puppetlabs/puppet/ssl/certs/ca.pem")
	if err != nil {
		log.Fatal(err)
	}
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: true,
			Certificates:       []tls.Certificate{cert},
			RootCAs:            caCertPool,
		},
	}

	revoke_data := CertState{
		DesiredState: "revoked",
	}
	revoke_payload, err := json.Marshal(revoke_data)
	if err != nil {
		log.Fatal(err)
	}
	put_body := bytes.NewReader(revoke_payload)

	purge_data := PurgeNode{
		Command: "deactivate node",
		Version: 3,
		Payload: Payload{
			Certname: "${HOSTNAME}",
		},
	}
	purge_payload, err := json.Marshal(purge_data)
	if err != nil {
		log.Fatal(err)
	}
	post_body := bytes.NewReader(purge_payload)

	client := &http.Client{Transport: tr}

	revoke_req, err := http.NewRequest("PUT", os.ExpandEnv("https://${PE_CONSOLE}:8140/puppet-ca/v1/certificate_status/${HOSTNAME}"), put_body)
	if err != nil {
		log.Fatal(err)
	}
	revoke_req.Header.Set("Content-Type", "application/json")

	revoke_resp, err := client.Do(revoke_req)
	if err != nil {
		log.Fatal(err)
	}
	defer revoke_resp.Body.Close()

	revoke_status, err := revoke_resp.Status, nil
	if err != nil {
		log.Fatalln(err)
	}
	log.Printf(revoke_status)

	delete_req, err := http.NewRequest("DELETE", os.ExpandEnv("https://${PE_CONSOLE}:8140/puppet-ca/v1/certificate_status/${HOSTNAME}"), nil)
	if err != nil {
		log.Fatal(err)
	}
	delete_req.Header.Set("Content-Type", "application/json")

	delete_resp, err := client.Do(delete_req)
	if err != nil {
		log.Fatal(err)
	}
	defer delete_resp.Body.Close()

	delete_status, err := delete_resp.Status, nil
	if err != nil {
		log.Fatalln(err)
	}
	log.Printf(delete_status)

	purge_req, err := http.NewRequest("POST", os.ExpandEnv("https://${PE_CONSOLE}:8081/pdb/cmd/v1"), post_body)
	if err != nil {
		log.Fatal(err)
	}
	purge_req.Header.Set("Content-Type", "application/json")

	purge_resp, err := client.Do(purge_req)
	if err != nil {
		log.Fatal(err)
	}
	defer purge_resp.Body.Close()

	purge_status, err := purge_resp.Status, nil
	if err != nil {
		log.Fatalln(err)
	}
	log.Printf(purge_status)
}
