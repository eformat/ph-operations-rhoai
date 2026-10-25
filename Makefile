PORT ?= 8887
DOCS_DIR := $(shell pwd)
SITE_DIR := $(DOCS_DIR)/www

# Showroom deployer (workshop UI deployment via the zt-showroom-deployer chart)
SLUG        ?= rhoai-operations
NAMESPACE   ?= showroom-$(SLUG)
RELEASE     ?= showroom
VALUES      ?= automation/showroom-deployer/values-$(SLUG).yaml
# Published chart ref; override CHART=~/git/zt-showroom-deployer for local source.
CHART_REPO_NAME ?= eformat
CHART_REPO  ?= https://eformat.github.io/helm-charts
CHART       ?= $(CHART_REPO_NAME)/showroom-deployer

.PHONY: install build serve clean test repo template deploy status uninstall

install:
	cd $(DOCS_DIR) && npm install

build: install
	rm -rf $(SITE_DIR)
	cd $(DOCS_DIR) && npx antora site.yml --stacktrace
	touch $(SITE_DIR)/.nojekyll

serve: build
	@echo "Serving at http://localhost:$(PORT)"
	python3 -m http.server $(PORT) --directory $(SITE_DIR)

test:
	ansible-playbook qa-automation/e2e.yml -v

clean:
	rm -rf $(SITE_DIR)

# --- Showroom deployer (workshop UI) ---

repo:
	helm repo add $(CHART_REPO_NAME) $(CHART_REPO) || true
	helm repo update $(CHART_REPO_NAME)

template:
	helm template $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(VALUES)

deploy:
	helm upgrade --install $(RELEASE) $(CHART) \
	  -n $(NAMESPACE) --create-namespace -f $(VALUES)

status:
	helm status $(RELEASE) -n $(NAMESPACE)

uninstall:
	helm uninstall $(RELEASE) -n $(NAMESPACE)
