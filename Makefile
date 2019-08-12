run:
	bundle exec rails s -b 0.0.0.0 -p 8093

debug:
	rails c

migrate:
	rails db:migrate && RAILS_ENV=test rails db:migrate

rollback:
	rails db:migrate VERSION=0 && RAILS_ENV=test rails db:migrate VERSION=0

seed:
	bin/seed

.PHONY: test
test:
	RAILS_ENV=test bundle exec rspec
