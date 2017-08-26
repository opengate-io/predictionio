# PredictionIO docker container (PredictionIO & Spark Only)
Docker container for PredictionIO-based machine learning services

[![Docker build](http://dockeri.co/image/opengate/predictionio)](https://registry.hub.docker.com/u/opengate/predictionio/)

[![image info](https://images.microbadger.com/badges/image/opengate/predictionio.svg)](https:/microbadger.com/images/opengate/predictionio) [![](https://images.microbadger.com/badges/version/opengate/predictionio.svg)](http://microbadger.com/images/opengate/predictionio "Get your own version badge on microbadger.com")

[PredictionIO](https://prediction.io) is an open-source Machine Learning
server for developers and data scientists to build and deploy predictive
applications in a fraction of the time.

This container uses Apache Spark and PostgreSQL.

**Use it interactively for development:**

```Bash
$ docker run --name prediction-databse 
	-e POSTGRES_USER=postgres
	-e POSTGRES_PASSWORD=prediction 
	-e POSTGRES_DB=postgresql 
	-d postgres:9.4
	
$ docker run -it -v $HOME/my-recommendation-src:/MyRecommendation 
	-p 8000:8000 -p 7070:7070 -p 9000:9000 
	--link prediction-databse:postgres
	opengate/predictionio /bin/bash
```
------------------------

**Bash commands inside container** (See PredictionIO [QuickStart](http://predictionio.incubator.apache.org/templates/recommendation/quickstart/))

```Bash
$ pio status
$ cd /MyRecommendation
$ pio app new MyApp1
... 
$ pio build --verbose
$ pio train
$ pio deploy
```
