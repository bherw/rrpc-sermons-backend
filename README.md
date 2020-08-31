# Description

The backend service powering [http://sermons.russellrpc.org/](http://sermons.russellrpc.org/).

- REST API for sermons, series, speakers
- GraphQL API
- both APIs have search support via ElasticSearch simple query strings
- Atom and RSS feeds for podcast clients
- single user admin authorization for REST create/update/delete methods via a private shared key

# Dependencies

- Ruby v2.4
- Bundler 2.0
- Postgres (persistence)
- ElasticSearch (search)
- Redis (sidekiq workers for search indexing and file upload processing)
- [audiowaveform](https://github.com/bbc/audiowaveform) (waveform generation)

# Development

```shell
bundle install
bundle exec puma
```

# Deployment

Current deployment uses an Nginx reverse proxy to forward traffic to the frontend and backend, SystemD user services to manage the Puma backend server, and a git post-receive hook to update the backend and restart services when pushed.

The configuration files are in .gitignore and must be created.

## Inital deployment

Postgres and curl openssl headers are required to compile dependency gems. On Debian,

```shell
apt install libpq-dev libcurl4-openssl-dev
```

Clone/push the backend repo to the target server, then run:

```shell
git checkout --force
bundle install
RAILS_ENV="production" bundle exec rails db:migrate
```

## Service configuration

### nginx

```
location /api {
    client_max_body_size 50M;

    rewrite /api/(.*)       /$1     break;
    proxy_pass http://unix:///home/rrpc/api/prod/tmp/puma.sock;
    break;
}
```

### systemd service

```
[Unit]
Description=RRPC API
After=elasticsearch.service
Wants=elasticsearch.service

[Service]
Environment=RAILS_ENV=production
Type=simple
WorkingDirectory=/home/rrpc/api/prod
ExecStart=/bin/bash -lc 'bundle exec puma -b unix:///home/rrpc/api/prod/tmp/puma.sock'
ExecReload=/bin/kill -s USR1 $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always

[Install]
WantedBy=default.target
```

### .git/hooks/post-receive

```shell
#!/bin/sh

# Read standard input or hook will fail
while read oldrev newrev refname
do
:
done

PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

unset GIT_DIR

# Change directory to the working tree; exit on failure
cd `git config --get core.worktree` || exit

git checkout --force
bundle install
RAILS_ENV="production" bundle exec rails db:migrate

if `systemctl --user -q is-active rrpc-api`
then
        echo "Reloading rrpc-api"
        systemctl --user reload rrpc-api
fi
if `systemctl --user -q is-active rrpc-api-sidekiq`
then
        echo "Reloading rrpc-api-sidekiq"
        systemctl --user restart rrpc-api-sidekiq
fi
```

# Configuration

### config/app.yml

```yaml
production:
  # mp3 files are renamed to <prefix><date/identifier>.mp3
  mp3_prefix: rrpc-
  # Publically available URLs for the API base and the frontend. Used for upload paths and in the Atom and RSS feeds.
  self_url: https://sermons.russellrpc.org/api
  webapp_url: https://sermons.russellrpc.org
```

### config/chewy.yml

```yaml
production:
  host: "localhost:9200"
  prefix: rrpc_api_production
```

### config/database.yml

```yaml
production:
  adapter: postgresql
  encoding: unicode
  pool: 25
  database: rrpc_api_production
```

### config/secrets.yaml

```yaml
production:
  # Rails secret key
  secret_key_base:

  # shared private key for admin access
  admin_access_key:

  # access key for the biblesearch API (defunct)
  bible_search_access_key:
```

# S3 File Storage

The default storage is the local filesystem. To use S3 instead, add the following configuration:

### app.yml

```yaml
production:
  shrine_use_s3: true
  s3_region:
  s3_bucket:
```

### secrets.yml

```yaml
production:
  s3_access_key_id:
  s3_secret_access_key:
```

To migrate existing files from local storage to S3, run `bundle exec rake shrine:migrate`.
