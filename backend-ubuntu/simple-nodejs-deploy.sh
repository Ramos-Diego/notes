# TEST APP IN JENKINS
git pull origin master
yarn install

# DEPLOY APP IN HOST SERVER
ssh user@example.com<<EOF
  cd ~/example.com
  git pull origin master
  yarn install
  pm2 reload example.com
  exit
EOF