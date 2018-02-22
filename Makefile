ELASTIC_NAME=elasticsearch
LOGSTASH_NAME=logstash
KIBANA_NAME=kibana

killelastic:
	-docker rm -f $(ELASTIC_NAME)
runelastic: killelastic
	docker run -d -p 9200:9200 -p 9300:9300 --name $(ELASTIC_NAME) -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.2.2

killlogstash:
	-docker rm -f $(LOGSTASH_NAME)
runlogstash: killlogstash
	docker run --rm -d --name $(LOGSTASH_NAME) --link $(ELASTIC_NAME):localhost docker.elastic.co/logstash/logstash:6.2.2

killkibana:
	-docker rm -f $(KIBANA_NAME)
runkibana: killkibana
	docker run --rm -d --name $(KIBANA_NAME) --link $(ELASTIC_NAME):localhost -p 5601:5601 docker.elastic.co/kibana/kibana:6.2.2

run: runelastic runlogstash runkibana
