systemctl stop puma.service || true
export DEPLOY_DIR="/home/ec2-user/Compatch"
mkdir -p $DEPLOY_DIR
rm -rf $DEPLOY_DIR/*
chown -R ec2-user:ec2-user $DEPLOY_DIR