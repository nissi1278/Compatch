# デプロイ先のディレクトリを変数に設定
export DEPLOY_DIR="/home/ec2-user/Compatch"
export HOME="/home/ec2-user"

# Installフックでrootが配置した全ファイルの所有権をec2-userに戻す
chown -R ec2-user:ec2-user $DEPLOY_DIR

su -l ec2-user -c "
  cd $DEPLOY_DIR

  bundle install --without development test
  RAILS_ENV=production bundle exec rails db:migrate
  RAILS_ENV=production bundle exec rails assets:precompile
"
systemctl start puma.service
systemctl restart nginx.service