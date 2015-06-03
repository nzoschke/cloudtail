build:
	docker-compose build

console:
	@export $(shell cat .env); docker-compose run cli irb

run:
	@export $(shell cat .env); docker-compose run cli