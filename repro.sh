#!/bin/bash

# Clean up previous execution
docker-compose down

# Write Prometheus config
cat > prometheus.yml <<EOF
scrape_configs:
  - job_name: "consul"
    consul_sd_configs:
    - server: "consul:8500"
      allow_stale: true
EOF

docker-compose up -d

echo "Waiting 30 seconds"
sleep 30

# Add tag to consul_sd_config
cat > prometheus.yml <<EOF
scrape_configs:
  - job_name: "consul"
    consul_sd_configs:
    - server: "consul:8500"
      allow_stale: true
      tags:
      - missing
EOF

# Reload prometheus config
docker-compose kill -s SIGHUP prometheus
