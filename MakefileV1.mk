# Const
#===============================================================
gcp_project    := {gcp_project}
image_repo     := asia.gcr.io/$(gcp_project)/test/foo-app
tag            := $(shell date +'%Y-%m-%dT%H%M%S')

# Task
#===============================================================
plain-deploy: docker-build docker-push helm-apply

helm-apply:
	helm upgrade --install \
	  --set image.tag=$(tag) \
	  foo-app charts/app

docker-build:
	docker build -t $(image_repo):$(tag) .
	docker tag $(image_repo):$(tag) $(image_repo):latest

docker-push:
ifneq ($(ENV),local)
	docker push $(image_repo):$(tag)
	docker push $(image_repo):latest
endif
