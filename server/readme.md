# Protoype Server  

* Start App
nohup coffee coffee/server.coffee >> server.log &
supervisor -e 'html|jade|less|coffee|ejs' node coffee/server.coffee

### sync code to server
rsync -chavP --exclude 'node_modules' --exclude 'backup' --exclude server/coffee/Config.coffee . 107.170.166.67:~/clasiserv/front
rsync -chavP  107.170.166.67:~/clasiserv/front/test.log .

## Tech Stack
* Node.js

### Server
* http://expressjs.com/guide.html
* https://github.com/remy/nodemon - Start app with nodemon
* https://github.com/isaacs/node-supervisor - Automatic restart
* https://www.npmjs.org/package/reload - automatic browser refresh
* https://github.com/adunkman/connect-assets
* https://www.npmjs.org/package/sha1
* https://www.npmjs.com/package/cors


#### Elasticsearch
http://localhost:9200/_plugin/marvel/kibana/index.html#/dashboard/file/marvel.overview.json
http://localhost:9200//_cluster/health
http://localhost:9301/clasiserv/settings/_search?q=_id:lastReadPage
curl -XGET 'http://localhost:9200/clasiserv/ad/_count'
  cd /Applications/develop/elasticsearch-1.1.1/data/elasticsearch
  du -sh . - show disk space of current folder and subfolders
curl -XPUT 'http://localhost:9301/clasiserv/settings/lastReadPage' -d '{
    "categoryOffset" : 50,
    "pageOffset" : 0,
    "totalPages" : 6212
}
http://chrissimpson.co.uk/elasticsearch-aggregations-overview.html
http://chrissimpson.co.uk/elasticsearch-snapshot-restore-api.html
https://github.com/taskrabbit/elasticsearch-dump
  elasticdump --input=http://localhost:9200/clasiserv --output=./backup/clasiserv.json
  elasticdump --input=http://localhost:9200/clasiserv --output=$ | gzip > ./backup/clasiserv.json.gz
  rsync 107.170.166.67:~/clasiserv/front/backup/clasiserv.json.gz backup
  cd backup; gzip -d clasiserv.json.gz  
  elasticdump --bulk=true --input=./clasiserv.json --output=http://localhost:9200/
##### Search Tips
http://www.elasticsearch.org/guide/en/elasticsearch/reference/1.x/query-dsl-query-string-query.html
precio:[200000000 TO 300000001] - Range

To have launchd start elasticsearch at login:
    ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
Then to load elasticsearch now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
Or, if you don't want/need launchctl, you can just run:
    elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
==> Summary
🍺  /usr/local/Cellar/elasticsearch/1.1.1: 31 files, 21M, built in 42 seconds

Tunnel to EL
  ssh -f -N -L 9300:127.0.0.1:9200 sun@clasiserv
  wget http://localhost:9200//_cluster/health
  
### Login
https://auth0.com/blog/2014/01/07/angularjs-authentication-with-cookies-vs-token/
https://stormpath.com/blog/nodejs-jwt-create-verify/
* jsonwebtoken
* express-jwt
  

## Tips
* npm install package_name --save - writes version number in package.json
* https://github.com/node-inspector/node-inspector - Debugger
* https://github.com/caolan/async - escape callback trash
* http://updates.html5rocks.com/2014/06/Automating-Web-Performance-Measurement?PageSpeed=noscript
* https://www.npmjs.com/package/bora