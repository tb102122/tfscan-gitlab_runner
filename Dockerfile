# Base image
FROM alpine AS builder
# Update package list and install curl and bash
RUN apk update && apk add --no-cache curl bash coreutils
# install tfsec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
# install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
# build layer with Terraform
FROM registry.gitlab.com/gitlab-org/terraform-images/stable:latest
COPY --from=builder /usr/local/bin /usr/local/bin
