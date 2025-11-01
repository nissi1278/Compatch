export DEPLOY_DIR="/home/ec2-user/Compatch"
export HOME="/home/ec2-user"
export AWS_REGION="ap-northeast-1"

chown -R ec2-user:ec2-user $DEPLOY_DIR

# systemdが読み込む環境変数ファイル用のディレクトリを作成
mkdir -p /run/puma
chown -R ec2-user:ec2-user /run/puma
chmod 700 /run/puma

# SSMからマスターキーを取得し、ファイルに書き出す (rootで実行)
aws ssm get-parameters \
  --name "/compatch/production/RAILS_MASTER_KEY" \
  --with-decryption \
  --query "Parameters[0].Value" \
  --output text > /run/puma/environment

sed -i -e 's/^/RAILS_MASTER_KEY=/' /run/puma/environment

# ファイルの権限をec2-userのみに絞る
chown ec2-user:ec2-user /run/puma/environment
chmod 600 /run/puma/environment

# --- 3. ec2-userとしてデプロイ作業を実行 ---
su -l ec2-user -c "
  source /run/puma/environment

  cd $DEPLOY_DIR

  bundle install --without development test

  RAILS_ENV=production bundle exec rails tailwind:build
  RAILS_ENV=production bundle exec rails db:migrate
  RAILS_ENV=production bundle exec rails assets:precompile
"

systemctl start puma.service
systemctl restart nginx.service