
```
# create a container
lxc launch images:ubuntu/xenial absg5
# configure it
lxc exec absg5 -- /bin/bash
# create directory in the container



apt install git ca-certificates nginx postgresql-9.5 build-essential libssl-dev libffi-dev python3.5-dev virtualenv libpq-dev libmagickwand-dev python3-venv --fix-missing

cd /var/www/html

# Download sources
git clone https://github.com/ikit/AbsG5.git

cd Absg5
