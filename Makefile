.PHONY: b t d l m

b:
	docker-compose build lib
	docker-compose run --rm lib bundle config set --local path vendor/bundle
	docker-compose run --rm lib bundle install

t:
	docker-compose run --rm lib bundle exec rake spec

d:
	docker-compose run --rm lib bundle exec rake app:prepare

l:
	docker-compose run --rm lib bundle exec rubocop -a

m:
	docker-compose run --rm lib bundle exec rake rails[db:migrate]
