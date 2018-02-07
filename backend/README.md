# InterfaceApi API


## Install Ruby (via rbenv and ruby-build)

1. Install rbenv and ruby-build

  - [rbenv](https://github.com/sstephenson/rbenv)
  - [ruby-build](https://github.com/sstephenson/rbenv)

```
  $ brew update && brew install rbenv ruby-build
```

2. Make sure rbenv is on the path and runs on terminal start

```
  $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
```

```
  $ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

3. Install Ruby 2.2.2 and Bundler

```
  $ rbenv install 2.2.2
  $ gem install bundler && rbenv rehash
```

## Database Setup

1. Install PostgreSQL and PostgreSQL Server
  - **Ubuntu**:   sudo apt-get install postgresql postgres_server_dev_all
  - **OS X**:     [Postgres.app](http://postgresapp.com/)
  - **Windows**:  [You're on your own](http://i0.kym-cdn.com/photos/images/newsfeed/000/101/781/Y0UJC.png)

2. Enter the PostgreSQL shell as user 'postgres':

```
  $ sudo -u postgres psql
```

3. Create the InterfaceApi databases:

```PLpgSQL
  CREATE DATABASE app_dev;

  CREATE DATABASE app_test;
```

4. Create the 'rails_api' user:

```PLpgSQL
  CREATE USER rails_api PASSWORD 'rails_api';

  ALTER USER rails_api WITH superuser;
```

5. Exit the PostgreSQL shell:

```
  \q <PRESS ENTER>
```

6. Install gems via bundler:

```
  bundle install
  
  # rename app
  rails g rename:app_to New-App-Name
```

7. Set up the database and populate with development data:

```
  rake db:setup && rake db:populate
```

8. Run background tasks, resque and rpush

```
  bundle exec rpush start -f
  rake resque:work QUEUE='*'
```

## Run the App

```
  $ rails s
```
