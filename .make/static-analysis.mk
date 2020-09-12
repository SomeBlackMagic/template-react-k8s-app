static-analysis: sa-eslint sa-lint-sass

sa-eslint: ## executes php analizers
	docker-compose run --rm --no-deps app sh -lc 'npx eslint ./ --ignore-path .gitignore'

sa-lint-sass: ## executes php analizers
	docker-compose run --rm --no-deps app sh -lc 'node_modules/sass-lint/bin/sass-lint.js --verbose --no-exit'
