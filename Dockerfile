FROM registry.ci.openshift.org/open-cluster-management/builder:go1.17-linux AS builder
WORKDIR /go/src/github.com/open-cluster-management/placement
COPY . .
ENV GO_PACKAGE github.com/open-cluster-management/placement

RUN make build --warn-undefined-variables
RUN make build-e2e --warn-undefined-variables

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
ENV USER_UID=10001

COPY --from=builder /go/src/github.com/open-cluster-management/placement/placement /
COPY --from=builder /go/src/github.com/open-cluster-management/placement/e2e.test /
RUN microdnf update && microdnf clean all

USER ${USER_UID}
