# High-Availability Web Architecture with HAProxy and Keepalived

This project demonstrates a highly available, multi-tier web application architecture using Docker and Docker Compose. It is designed to be resilient to failures at both the web server and load balancer levels.

The architecture is composed of two main tiers:
*   **Tier 1: High-Availability Load Balancers:** A cluster of three HAProxy load balancers (one master, two backups) configured with Keepalived. They share a single Virtual IP (VIP) to provide a consistent entry point for all user traffic. If the master node fails, a backup node automatically takes over, ensuring seamless service continuity.
*   **Tier 2: Web Servers:** A pool of identical Node.js web servers that run the application logic. The HAProxy tier distributes incoming requests across these servers.

 
<img width="1400" alt="Project Architecture Diagram" src="https://user-images.githubusercontent.com/10108698/229329438-1a88b3a3-3a81-43e0-94cf-78931b794a3a.png" />


---

## Features

*   **High Availability:** Keepalived ensures that if the master load balancer fails, a backup instance automatically takes over the Virtual IP, providing seamless failover with no downtime.
*   **Scalability:** The multi-tier design allows for independent scaling of the web server and load balancing layers.
*   **Load Balancing:**
    *   HAProxy uses the `leastconn` (least connections) algorithm to distribute traffic, sending new requests to the web server with the fewest active connections.
*   **Containerized:** The entire stack is defined in `docker-compose.yml` for easy setup and deployment.
*   **Monitoring:** Each HAProxy instance exposes a statistics page for real-time monitoring of traffic and server health.

---

## Project Structure

```text
├── haproxy-master/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── haproxy.cfg
│   └── keepalived.conf      
├── haproxy-backup-1/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── haproxy.cfg
│   └── keepalived.conf      
├── haproxy-backup-2/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── haproxy.cfg
│   └── keepalived.conf      
├── web-servers/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js            # Simple Node.js/Express app
├── docker-compose.yml       # Defines and orchestrates all services
├── Dockerfile
├── entrypoint.sh
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
    *   **Master LB:** `http://localhost/haproxy?stats` (Username: `admin`, Password: `123`)
    *   **Backup LB 1:** `http://localhost:8080/haproxy?stats` (Username: `admin`, Password: `123`)
    *   **Backup LB 2:** `http://localhost:8081/haproxy?stats` (Username: `admin`, Password: `123`)

---

## Testing High Availability

You can test the failover mechanism by stopping the master load balancer.

1.  **Stop the master container:**
    ```sh
    docker stop haproxy-master
    ```

2.  **Check the application:**
    Refresh your browser at `http://localhost`. The application should still be accessible without any interruption. One of the backup containers has now taken over the Virtual IP and is routing traffic.

3.  **Verify with logs:**
    You can check the logs of the backup container to see the state transition from `BACKUP` to `MASTER`.
    ```sh
    docker logs haproxy-tier1-backup
    ```

4.  **Restart the master:**
    When you restart the original master, it will reclaim its `MASTER` role, and the backup will transition back to `BACKUP` state.
    ```sh
    docker start haproxy-master
    ```
    
