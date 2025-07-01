.PHONY: help setup
.DEFAULT_GOAL = help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Setup all k8s components
	@echo "\nSetting up MongoDB Components...\n"
	@kubectl apply -f mongo-secrets.yaml
	@kubectl apply -f mongo.yaml
	@echo "\nSetting up MongoExpress Components...\n"
	@kubectl apply -f mongo_express-configMap.yaml
	@kubectl apply -f mongo_express.yaml



destroy: ## Setup all k8s components
	@echo "\nDeleting MongoDB Components...\n"
	@kubectl delete -f mongo.yaml
	@kubectl delete -f mongo-secrets.yaml
	@echo "\nDeleting MongoExpress Components...\n"
	@kubectl delete -f mongo_express.yaml
	@kubectl delete -f mongo_express-configMap.yaml