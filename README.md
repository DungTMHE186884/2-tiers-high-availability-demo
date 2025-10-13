# 3-Tier High-Availability Web Architecture with HAProxy and Keepalived

This project demonstrates a highly available, multi-tier web application architecture using Docker and Docker Compose. It is designed to be resilient to failures at both the web server and load balancer levels.

The architecture is composed of three tiers:
*   **Tier 1: High-Availability Load Balancers:** A pair of HAProxy load balancers (master and backup) configured with Keepalived for automatic failover using a Virtual IP (VIP). This is the single entry point for all user traffic.
*   **Tier 2: Application Load Balancers:** A second layer of HAProxy instances that distribute traffic across the web servers. This layer allows for scaling the application tier independently.
*   **Tier 3: Web Servers:** A cluster of simple Node.js web servers that represent the application backend.

 
*(Note: You can create and link to an architecture diagram here for better visualization.)*

---

## Features

*   **High Availability:** Keepalived ensures that if the master Tier-1 load balancer fails, the backup instance automatically takes over the Virtual IP, providing seamless failover with no downtime.
*   **Scalability:** The multi-tier design allows for independent scaling of the web server and load balancing layers.
*   **Load Balancing:**
    *   Tier 1 uses a `round-robin` strategy to distribute traffic between the Tier 2 load balancers.
    *   Tier 2 uses a `least-connections` strategy to send requests to the least busy web server.
*   **Containerized:** The entire stack is defined in `docker-compose.yml` for easy setup and deployment.
*   **Monitoring:** Each HAProxy instance exposes a statistics page for real-time monitoring of traffic and server health.

---

## Project Structure

```
├── haproxy-tier1-backup/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── haproxy.cfg
│   └── keepalived.conf      # Configures the BACKUP Keepalived node
├── haproxy-tier1-master/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── haproxy.cfg
│   └── keepalived.conf      # Configures the MASTER Keepalived node
├── haproxy-tier2-1/
│   ├── Dockerfile
│   └── haproxy.cfg
├── haproxy-tier2-2/
│   ├── Dockerfile
│   └── haproxy.cfg
├── web-servers/
│   ├── Dockerfile
│   └── server.js            # Simple Node.js/Express app
├── docker-compose.yml       # Defines and orchestrates all services
└── README.md                # This file
```

---

## Prerequisites

*   Docker
*   Docker Compose

## How to Run

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/DungTMHE186884/2-tiers-high-availability-demo.git
    cd 2-tiers-high-availability-demo
    ```

2.  **Start the services:**
    Use Docker Compose to build and run all the containers in detached mode.
    ```sh
    docker-compose up --build -d
    ```

3.  **Access the application:**
    Open your web browser and navigate to the main application entry point. You should see a "Hello from..." message from one of the web servers.
    *   **URL:** `http://localhost`

4.  **View HAProxy Statistics:**
    You can monitor the status of each load balancer via their statistics pages.
    *   **Tier 1 (Master):** `http://localhost/haproxy?stats` (Username: `admin`, Password: `123`)
    *   **Tier 1 (Backup):** `http://localhost:8080/haproxy?stats` (Username: `admin`, Password: `123`)
    *   **Tier 2 (Instance 1):** `http://localhost:8081/haproxy?stats`
    *   **Tier 2 (Instance 2):** `http://localhost:8082/haproxy?stats`

---

## Testing High Availability

You can test the failover mechanism by stopping the master Tier-1 load balancer.

1.  **Stop the master container:**
    ```sh
    docker stop haproxy-tier1-master
    ```

2.  **Check the application:**
    Refresh your browser at `http://localhost`. The application should still be accessible without any interruption. The `haproxy-tier1-backup` container has now taken over the Virtual IP and is routing traffic.

3.  **Verify with logs:**
    You can check the logs of the backup container to see the state transition from `BACKUP` to `MASTER`.
    ```sh
    docker logs haproxy-tier1-backup
    ```

4.  **Bring the master back online:**
    When you restart the original master, it will reclaim its `MASTER` role, and the backup will transition back to `BACKUP` state.
    ```sh
    docker start haproxy-tier1-master

    ```
