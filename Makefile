.PHONY: b t d l

b:
	docker-compose build lib
	docker-compose run --rm lib bundle config set --local path vendor/bundle
	docker-compose run --rm lib bundle install

t:
	docker-compose run --rm lib bundle exec rake spec

d:
	docker-compose run --rm lib bundle exec rake db

l:
	docker-compose run --rm lib bundle exec rubocop -a
