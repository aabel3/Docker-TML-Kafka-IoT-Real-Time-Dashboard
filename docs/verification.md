# ✅ Verification

Each check below lists the command, the expected output (taken from the project screenshots) and the matching screenshot. The captures are from 4 July 2025.

---

## Docker Hub

After `docker push`, the repository `<dockerhub-username>/seneca-iot-tml-kafka-amd64` appears on Docker Hub with a `latest` tag (about 4.2 GB). The terminal shows each layer as `Pushed` or `Mounted from library/python`, ending with the image digest.

Screenshot: [Docker Hub repository and push](../screenshots/01-docker-hub-repository-and-push.png)

---

## Dashboard

Browse to the dashboard URL and press **START STREAMING**. The dashboard shows:

- Average failure risk (28.7% in the capture)
- Total Kafka messages processed (7368)
- Potential failure issues found (24)
- A real-time failure risk map and a table of the latest records

The terminal beside it shows the container starting MariaDB.

Screenshot: [Dashboard](../screenshots/02-dashboard-streaming-in-browser.png)

---

## Running the container

```bash
sudo docker run -p 9005:9005 <dockerhub-username>/seneca-iot-tml-kafka-amd64
```

```
Stopping MariaDB database server: mariadbd.
Starting MariaDB database server: mariadbd.
```

Screenshot: [docker run](../screenshots/03-docker-run-container-mariadb-start.png)

---

## `docker ps`

```bash
docker ps
```

The container is `Up`, running `/bin/bash -c 'while…'`, with the ports `0.0.0.0:9005->9005/tcp, :::9005->9005/tcp`.

Screenshot: [docker ps](../screenshots/04-docker-ps-running-container.png)

---

## Inside the container

```bash
docker exec -it <container-id> bash
ls
```

```
Hpde         Kafka  Viper-preprocess   Viperviz  boot  dev  home  lib64  mnt  proc  run  srv  tmp  usr
IotSolution  Viper-preprocess2  Viper-produce  bin  deploy  etc  lib  media  opt  root  sbin  sys  tmux  var
```

Screenshot: [docker exec and ls](../screenshots/05-docker-exec-container-ls.png)

---

## tmux sessions

```bash
tmux ls
```

```
kafka: 1 windows
preprocess-data-python-8001: 1 windows
preprocess-data-viper-8001: 1 windows
preprocess2-data-python-8002: 1 windows
preprocess2-data-viper-8002: 1 windows
produce-iot-data-python-8000: 1 windows
produce-iot-data-viper-8000: 1 windows
visualization-viperviz-9005: 1 windows
zookeeper: 1 windows
```

Screenshot: [tmux ls](../screenshots/06-tmux-ls-sessions.png)

---

## Attach to the visualization session

```bash
tmux a -t visualization-viperviz-9005
```

The window shows the Viperviz log: Kafka consumer lines for the `iot-preprocess` and `iot-preprocess2` topics, `Success reading message(s)`, and the status bar `visualization:viperviz-linux-amd64`.

Screenshot: [Viperviz session](../screenshots/07-tmux-attach-viperviz-9005.png)

---

## Detach and exit

Press `Ctrl+b`, then `d`:

```
[detached (from session visualization-viperviz-9005)]
```

Then leave the container:

```
root@<container-id>:/# exit
exit
```

Screenshots: [Detach](../screenshots/08-tmux-detach-session.png) · [Exit container](../screenshots/09-exit-container.png)

> The exit capture was taken on a later container run (`docker container ls` shows a different container ID than the earlier captures), which is expected because the ID changes on every `docker run`.
