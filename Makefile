.PHONY: b t

b:
	docker-compose build lib
	docker-compose run --rm lib bundle config set --local path vendor/bundle
	docker-compose run --rm lib bundle install

t:
	docker-compose run --rm lib bundle exec rspec
