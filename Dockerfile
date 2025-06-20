FROM debian:bookworm-slim

ARG UID=1030
ARG GID=100

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN (addgroup --gid $GID ankigrp || true) && \
	adduser --disabled-password --comment "anki" \
	--home /home/anki \
	--uid $UID --gid $GID \
	anki && \
	echo "[with]: $UID:$GID" && \
	apt update -y && \
	apt install -y --auto-remove python3 \
	python3-venv && \
	apt clean -y && \
	uv venv /etc/syncserver && \
 	bash -c "source /etc/syncserver/bin/activate && uv pip install --pre anki"

USER anki

ENV SYNC_PORT=${SYNC_PORT:-"8080"}

EXPOSE ${SYNC_PORT}

CMD ["/etc/syncserver/bin/python3", "-m", "anki.syncserver"]
