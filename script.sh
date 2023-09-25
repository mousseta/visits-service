docker rm db || true
            docker rm -f clair || true
            docker run -d --name db arminc/clair-db
            sleep 15 
            docker run -p 6060:6060 --link db:postgres -d --name clair arminc/clair-local-scan
            sleep 1
            DOCKER_GATEWAY=$(docker network inspect bridge --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}")
            wget -qO clair-scanner https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64 && chmod +x clair-scanner
            ./clair-scanner --ip="$DOCKER_GATEWAY" -c "http://registry.dev.svc.cluster.local:6060" registry.dev.svc.cluster.local:5000/nginx:latest || exit 0
