Ruby version: 2.4.*
Requires bundler 2.0

Required for deps:
apt install libpq-dev libcurl4-openssl-dev

Install audiowaveform binary

send to remote using git push prod master or git push staging master


app.yml:

development:
  mp3_prefix: rrpc-
  self_url: http://192.168.1.3:3000
  webapp_url: http://192.168.1.3:3001
  s3_public_url: 
