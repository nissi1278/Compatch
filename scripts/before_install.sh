systemctl stop puma.service || true
export DEPLOY_DIR="/home/ec2-user/Compatch"

# ディレクトリがある場合、一度全て削除してから再作成。
if [ -d "$DEPLOY_DIR" ]; then
  rm -rf "$DEPLOY_DIR"
fi

mkdir -p $DEPLOY_DIR
chown -R ec2-user:ec2-user $DEPLOY_DIR