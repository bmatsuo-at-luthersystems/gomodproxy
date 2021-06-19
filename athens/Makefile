
GOSU_VERSION=1.12

TARGET_ARCH=amd64

GOSU_RELEASE_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}

GOSU_BUILD=_build/gosu-${GOSU_VERSION}
GOSU_BIN=${GOSU_BUILD}/gosu-${TARGET_ARCH}
GOSU_ASC=${GOSU_BUILD}/gosu-${TARGET_ARCH}.asc
GOSU_VERIFIED=${GOSU_BUILD}-${TARGET_ARCH}.verified

.PHONY: default
default:
	@

.PHONY: start
start: gosu
	GOSU_PATH=${PWD}/${GOSU_BIN} ./run-athens.sh

.PHONY: stop
stop:
	docker stop athens-proxy
	docker container rm athens-proxy

.PHONY: logs
logs:
	docker logs -f athens-proxy

.PHONY: clean
clean:
	rm -rf _build

.PHONY: gosu
default: gosu
gosu:  gosu-download gosu-verify

.PHONY: gosu-download
gosu-download: ${GOSU_BUILD}

.PHONY: gosu-unverify
gosu-unverify:
	rm -rf ${GOSU_VERIFIED}

.PHONY: gosu-verify
gosu-verify: ${GOSU_VERIFIED}

.PHONY: gosu-reverify
gosu-reverify: gosu-unverify gosu-verify

${GOSU_VERIFIED}: ${GOSU_BUILD}
	gpg --batch --verify "${GOSU_ASC}" "${GOSU_BIN}" | tee  ${GOSU_VERIFIED}

${GOSU_BUILD}: ${GOSU_ASC} ${GOSU_BIN}
	chmod +x ${GOSU_BIN}

${GOSU_BUILD}/gosu-%:
	mkdir -p "${GOSU_BUILD}"
	wget "${GOSU_RELEASE_URL}/${notdir $@}" -O "$@"
