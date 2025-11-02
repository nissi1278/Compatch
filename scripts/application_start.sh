export DEPLOY_DIR="/home/ec2-user/Compatch"
 export HOME="/home/ec2-user"
 export AWS_REGION="ap-northeast-1"

 chown -R ec2-user:ec2-user $DEPLOY_DIR

 # systemdが読み込む環境変数ファイル用のディレクトリを作成
 mkdir -p /run/puma
 chown -R ec2-user:ec2-user /run/puma
 chmod 700 /run/puma

# SSMからマスターキーを取得し、「MASTER_KEY」に格納する (rootで実行)
MASTER_KEY=$(aws ssm get-parameters \
  --name "/compatch/production/RAILS_MASTER_KEY" \
  --with-decryption \
  --query "Parameters[0].Value" \
  --output text)

 # systemd 用のファイルを作成 (KEY=VALUE 形式)
 echo "RAILS_MASTER_KEY=$MASTER_KEY" > /run/puma/environment_systemd
 echo "RAILS_ENV=production" >> /run/puma/environment_systemd

 # デプロイ作業用のファイルを作成 (export 形式)
 echo "export RAILS_MASTER_KEY=$MASTER_KEY" > /run/puma/environment_deploy
 echo "export RAILS_ENV=production" >> /run/puma/environment_deploy

 chown ec2-user:ec2-user /run/puma/environment_systemd
 chmod 600 /run/puma/environment_systemd
 chown ec2-user:ec2-user /run/puma/environment_deploy
 chmod 600 /run/puma/environment_deploy

 # ec2-userとしてデプロイ作業を実行 ---
 su -l ec2-user -c "
   source /run/puma/environment_deploy

   cd $DEPLOY_DIR

   bundle install --without development test
   bundle exec rails tailwind:build
   bundle exec rails db:migrate
   bundle exec rails assets:precompile
 "

 systemctl start puma.service
 systemctl restart nginx.service