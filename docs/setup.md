# ⚙️ Setup Guide

Step-by-step instructions to rebuild the Docker TML dashboard lab.

> Components and ports are in [architecture.md](architecture.md). Every step has a matching helper in [`scripts/`](../scripts/).

---

## 1. Prepare the VM and accounts

1. Create an Ubuntu 22.04 VM (VMware Workstation) with internet access.
2. Create a free [Docker Hub](https://hub.docker.com/) account. Its ID is used as `<dockerhub-username>` below.

---

## 2. Install Docker

Helper: [`scripts/install-docker.bash`](../scripts/install-docker.bash)

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo chmod 666 /var/run/docker.sock
docker run hello-world
```

If `hello-world` prints its welcome message, Docker is set up correctly. If a later `docker pull` fails with an error such as `no such file or directory` for a path under `/var/lib/docker/tmp`, restart the service:

```bash
sudo systemctl restart docker
```

---

## 3. Run the pre-built TML solution

Helper: [`scripts/run-tml-dashboard.bash`](../scripts/run-tml-dashboard.bash)

```bash
docker pull maadsdocker/seneca-iot-tml-kafka-amd64
docker run -p 9005:9005 maadsdocker/seneca-iot-tml-kafka-amd64
```

`-p 9005:9005` forwards host port 9005 to container port 9005. MariaDB starts first:

```
Stopping MariaDB database server: mariadbd.
Starting MariaDB database server: mariadbd.
```

Open the dashboard in Firefox or Chrome on the VM, then press **START STREAMING**:

```
http://localhost:9005/iot-failure-seneca.html?topic=iot-preprocess2,iotpreprocess&offset=-1&groupid=&rollbackoffset=500&topictype=prediction&append=0&secure=1
```

Wait a few minutes for data to populate. Stop the container with `Ctrl+C` before building your own.

---

## 4. Create your own container and dashboard

Helper: [`scripts/build-container.bash`](../scripts/build-container.bash)

1. Create a free GitHub account.
2. Create an empty repository called `raspberrypi` (do not add a README).
3. Use **Import code from another repository** with `https://github.com/smaurice101/raspberrypi.git`, then press **Begin Import**.
4. Start the Docker engine on the VM.
5. Copy the [Dockerfile](https://github.com/smaurice101/raspberrypi/blob/main/docker/Dockerfile) into an empty folder on the VM.
6. Build, replacing `maadsdocker` with your Docker Hub ID.

   **Normal build** (from scratch, about 20 minutes):

   ```bash
   docker build -t <dockerhub-username>/seneca-iot-tml-kafka-amd64 \
     --build-arg CHIP=AMD64 --no-cache --network=host .
   ```

   **Faster build** (after a normal build, about 5 minutes):

   ```bash
   docker build -t <dockerhub-username>/seneca-iot-tml-kafka-amd64 \
     --build-arg CHIP=AMD64 --build-arg CACHEBUST=$(date +%s) --network=host .
   ```

7. Log in and push the image to Docker Hub:

   ```bash
   docker login
   docker push <dockerhub-username>/seneca-iot-tml-kafka-amd64:latest
   ```

8. Confirm the repository appears on Docker Hub and shows the `latest` tag.
9. Run your image and open the dashboard URL from step 3:

   ```bash
   docker run -p 9005:9005 <dockerhub-username>/seneca-iot-tml-kafka-amd64
   ```

---

## 5. Inspect the running container

Open a second terminal while the container runs.

```bash
docker ps                                   # note the CONTAINER ID
docker exec -it <container-id> bash         # shell inside the container
ls                                          # Hpde, IotSolution, Kafka, Viper-*, Viperviz, ...
tmux ls                                     # nine tmux sessions
tmux a -t visualization-viperviz-9005       # attach to the dashboard session
```

Detach with `Ctrl+b`, then `d`. The prompt prints `[detached (from session visualization-viperviz-9005)]`. Leave the container shell with:

```bash
exit
```

---

## 6. Verify

[`scripts/verify-container.bash`](../scripts/verify-container.bash) checks the container, the published port, the dashboard page and the tmux sessions. Expected output for every check is in [verification.md](verification.md).
