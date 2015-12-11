git pull origin alfa
nohup RAILS_ENV=alfa bundle exec rake db:migrate
RAILS_ENV=alfa bundle exec rake assets:precompile
sudo service apache2 restart
nohup RAILS_ENV=alfa bundle exec rake jobs:work > rake.out 2>&1 &


