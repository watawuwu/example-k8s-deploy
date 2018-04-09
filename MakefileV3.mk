# Option
#===============================================================
ENV := local

# Const
#===============================================================
gcp_project    := {gcp_project}
image_repo     := asia.gcr.io/$(gcp_project)/test/foo-app
context        := docker-for-desktop
tag            := $(shell date +'%Y-%m-%dT%H%M%S')

ifeq ($(ENV),stage)
  context := gke_{gcp_project}_asia-northeast1-a_stage-cluster
endif

# Task
#===============================================================
skaffold-deploy:
	kubectl config use-context $(context)
	skaffold run

plain-deploy: docker-build docker-push helm-apply

helm-apply:
	helm upgrade --install \
	  --set image.tag=$(tag) \
	  --kube-context $(context) \
	  --values charts/app/env/$(ENV).yaml \
	  foo-app charts/app

docker-build:
	docker build -t $(image_repo):$(tag) .
	docker tag $(image_repo):$(tag) $(image_repo):latest

docker-push:
ifneq ($(ENV),local)
	docker push $(image_repo):$(tag)
	docker push $(image_repo):latest
endif
