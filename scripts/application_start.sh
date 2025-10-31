# デプロイ先のディレクトリを変数に設定
export DEPLOY_DIR="/home/ec2-user/Compatch"
export HOME="/home/ec2-user"

su -l ec2-user -c "
  cd $DEPLOY_DIR

  bundle install --without development test
  RAILS_ENV=production bundle exec rails db:migrate
  RAILS_ENV=production bundle exec rails assets:precompile
"
systemctl start puma.service
systemctl restart nginx.service