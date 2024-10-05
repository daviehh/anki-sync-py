FROM debian:bookworm-slim

ARG UID=1030
ARG GID=100

RUN (addgroup --gid $GID ankigrp || true) && \
	adduser --disabled-password --comment "anki" \
	--home /home/anki \
	--uid $UID --gid $GID \
	anki && \
	echo "[with]: $UID:$GID" && \
	apt update -y && \
	apt install -y --auto-remove python3 \
	python3-pip python3-venv && \
	apt clean -y && \
	python3 -m venv /etc/syncserver && \
	/etc/syncserver/bin/pip install --pre anki

USER anki

ENV SYNC_PORT=${SYNC_PORT:-"8080"}

EXPOSE ${SYNC_PORT}

CMD ["/etc/syncserver/bin/python", "-m", "anki.syncserver"]
