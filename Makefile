setup:
	cp packages/contracts/.env.example packages/contracts/.env
	git update-index --assume-unchanged packages/contracts/deploys/31337/latest.json

update-deploy:
	git update-index --no-assume-unchanged packages/contracts/deploys/31337/latest.json
	git add packages/contracts/deploys/31337/latest.json
	git update-index --assume-unchanged packages/contracts/deploys/31337/latest.json

