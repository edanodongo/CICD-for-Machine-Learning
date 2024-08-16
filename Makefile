install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

format:	
	black *.py 

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	
	cml comment create report.md

	git commit -am "new changes"
	git push origin main

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git add
	git push --force origin HEAD:update

hf-login:
	git pull origin update
	git switch update
	pip install -U "huggingface_hub[cli]"
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	huggingface-cli upload edanodongo/Drug-classification ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload edanodongo/Drug-classification ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload edanodongo/Drug-classification ./Results /Metrics --repo-type=space --commit-message="Sync Model"

deploy: hf-login push-hub