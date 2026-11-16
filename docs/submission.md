# 📝 Submission Summary

## Overview

This project runs a Transactional Machine Learning (TML) solution in Docker on an Ubuntu VM. A single container holds Apache Kafka, MariaDB, Python scripts and the TML binaries, runs each service in a tmux session, and serves a real-time IoT failure-prediction dashboard through a forwarded port.

## Expectations

- Install Docker on a new Ubuntu VM and confirm it with `hello-world`
- Pull and run the pre-built TML image with host port 9005 forwarded to container port 9005
- Open the dashboard and start streaming
- Build your own image from the upstream project, tag it with your Docker Hub ID and push it
- Show the Docker Hub repository, the running dashboard and the running container
- Go inside the container, list the tmux sessions, attach to the visualization session, then detach and exit

## Approach

1. Install Docker and test it.
2. Run the pre-built image and view the dashboard.
3. Import the upstream repository, then build and push your own image.
4. Run your image and confirm the dashboard.
5. Inspect the container with `docker ps`, `docker exec` and `tmux`.

## Deliverables

| Deliverable | Location |
|-------------|----------|
| Docker pull and run commands | [`docs/setup.md`](setup.md), [`scripts/run-tml-dashboard.bash`](../scripts/run-tml-dashboard.bash) |
| Build and push commands | [`docs/setup.md`](setup.md), [`scripts/build-container.bash`](../scripts/build-container.bash) |
| Container in Docker Hub | [`screenshots/01`](../screenshots/01-docker-hub-repository-and-push.png) |
| Dashboard running in the VM | [`screenshots/02`](../screenshots/02-dashboard-streaming-in-browser.png) |
| Running container and `docker ps` | [`screenshots/03`](../screenshots/03-docker-run-container-mariadb-start.png), [`screenshots/04`](../screenshots/04-docker-ps-running-container.png) |
| Inside the container, `tmux ls` | [`screenshots/05`](../screenshots/05-docker-exec-container-ls.png), [`screenshots/06`](../screenshots/06-tmux-ls-sessions.png) |
| Viperviz session, detach and exit | [`screenshots/07`](../screenshots/07-tmux-attach-viperviz-9005.png) – [`screenshots/09`](../screenshots/09-exit-container.png) |

## Conclusion

Docker was installed on an Ubuntu VM, the pre-built TML container was run with port forwarding, and a custom image was built, pushed to Docker Hub and run. The dashboard showed device performance and failure prediction in real time, and the container's tmux sessions were inspected from the inside. The project gave hands-on practice with Docker images, port forwarding, Docker Hub and multi-service containers.

## References

- [Docker Hub](https://hub.docker.com/)
- [smaurice101/raspberrypi – docker folder](https://github.com/smaurice101/raspberrypi/tree/main/docker)
- [smaurice101/raspberrypi – repository](https://github.com/smaurice101/raspberrypi)
- [smaurice101/raspberrypi – Dockerfile](https://github.com/smaurice101/raspberrypi/blob/main/docker/Dockerfile)
