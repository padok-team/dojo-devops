// k8s-hello is a web server meant to be deployed inside a Kubernetes cluster
// in order to showcase basic Kubernetes features.
package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"time"
)

// Command-line arguments.
var (
	version      = ""
	httpAddr     = flag.String("http", ":8080", "Listen address")
	k8sNamespace = flag.String("namespace", getEnv("K8S_NAMESPACE", "unknown"), "Namespace inside which the server is deployed")
	k8sNode      = flag.String("node", getEnv("K8S_NODE", "unknown"), "Name of node on which server is running")
	k8sPod       = flag.String("pod", getEnv("K8S_POD", "unknown"), "Name of pod in which server is running")
)

func main() {
	flag.Parse()

	http.HandleFunc("/", k8sInfo(version, *k8sNamespace, *k8sNode, *k8sPod))
	http.HandleFunc("/healthz", healthcheck)
	http.HandleFunc("/load", loadTesting)
	http.HandleFunc("/panic", failure)

	log.Println("Listing for requests...")
	if err := http.ListenAndServe(*httpAddr, nil); err != nil {
		log.Fatal(err)
	}
}

// k8sInfo provides basic information about the server's deployment.
func k8sInfo(version, namespace, node, pod string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Version: %s\n", version)
		fmt.Fprintf(w, "Kubernetes:\n")
		fmt.Fprintf(w, "  Namespace: %s\n", namespace)
		fmt.Fprintf(w, "  Node:      %s\n", node)
		fmt.Fprintf(w, "  Pod:       %s\n", pod)

		log.Printf("Received request on %s", r.URL.Path)
	}
}

func load() {
	f, err := os.Open(os.DevNull)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	n := runtime.NumCPU()
	runtime.GOMAXPROCS(n)

	for i := 0; i < n; i++ {
		go func() {
			for {
				fmt.Fprintf(f, ".")
			}
		}()
	}

	time.Sleep(1 * time.Second)
}

func loadTesting(w http.ResponseWriter, r *http.Request) {
	load()

	// The server is always healthy.
	log.Printf("Received request on %s", r.URL.Path)
}

func failure(w http.ResponseWriter, r *http.Request) {
	log.Printf("Received a panic request ...")

	os.Exit(1)
}

// healthcheck reports on the server's health.
func healthcheck(w http.ResponseWriter, r *http.Request) {
	// The server is always healthy.
	log.Printf("Received request on %s", r.URL.Path)
}

func getEnv(name, fallback string) string {
	value := os.Getenv(name)
	if value != "" {
		return value
	}
	return fallback
}
