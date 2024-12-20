# Base image
FROM alpine AS builder
# Update package list and install curl and bash
RUN apk update && apk add --no-cache curl bash coreutils
# install tfsec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
# install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
# install trivy to replace tfsec
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
RUN wget https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/junit.tpl
RUN cp junit.tpl /usr/local/bin/junit.tpl
RUN chmod +x /usr/local/bin/junit.tpl
# build layer with Terraform
FROM registry.gitlab.com/noemix/shared-resources/terraform-images/stable:latest
COPY --from=builder /usr/local/bin /usr/local/bin
