.PHONY: help
help: ## Print this help menu
help:
	@echo InSpec Resource Pack for HashiCorp Nomad
	@echo
	@echo "Local CLI Version: `nomad version`"
	@echo
	@echo Optional environment variables:
	@echo "* NOMAD_ADDR (${NOMAD_ADDR})"
	@echo "* NOMAD_TOKEN (${NOMAD_TOKEN})"
	@echo "* NOMAD_CACERT (${NOMAD_CACERT})"
	@echo "* NOMAD_CLIENT_CERT (${NOMAD_CLIENT_CERT})"
	@echo "* NOMAD_CLIENT_KEY (${NOMAD_CLIENT_KEY})"
	@echo
	@echo 'Usage: make <target>'
	@echo
	@echo 'Targets:'
	@egrep '^(.+)\:\ ##\ (.+)' $(MAKEFILE_LIST) | column -t -c 2 -s ':#'

.PHONY: inspec/repl
inspec/repl: ## Starts an InSpec REPL with the Nomad library loaded
	inspec shell --depends .

.PHONY: inspec/exec
inspec/exec: ## Runs InSpec test using local controls
	inspec exec .