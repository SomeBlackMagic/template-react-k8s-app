static-analysis: sa-eslint sa-lint-sass
static-analysis-fixer: sa-eslint sa-lint-sass

pipline-debug: ## executes php analizers
	bash .pipelines/.pipelines-debug.sh
