Capistrano deploy recipes [![TravisCI](https://secure.travis-ci.org/lest/capistrano-deploy.png?branch=master)](http://travis-ci.org/lest/capistrano-deploy)
=========================

Git & Rails
-----------

Minimal Capfile for Rails deploy using Git:

```ruby
require 'capistrano-deploy'
use_recipes :git, :rails

server 'server name or ip address', :web, :app, :db, :primary => true
set :user, 'user for deploy'
set :deploy_to, '/deploy/to/path'
set :repository, 'your git repository'
```

To setup:

    cap deploy:setup

Then when you push some changes to git repository simply run:

    cap deploy

If you have migrations instead of previous command run:

    cap deploy:migrations

To look through changes to be deployed:

    cap deploy:pending

Multistage
----------

```ruby
use_recipe :multistage

set :default_stage, :development

stage :development do
  ...
end

stage :production do
  ...
end
```

Bundle
------

```ruby
use_recipe :bundle
```

To automatically install missing gems:

```ruby
after 'deploy:update', 'bundle:install'
```

Passenger
---------

```ruby
use_recipe :passenger
```

Unicorn
-------

```ruby
use_recipe :unicorn
```

Now you can setup to reload unicorn on `deploy:restart`:

```ruby
after 'deploy:restart', 'unicorn:reload'
```

Whenever
--------

```ruby
use_recipe :whenever
```

To automatically update crontab file:

```ruby
after 'deploy:restart', 'whenever:update_crontab'
```

You can also clear crontab file with command:

    cap whenever:clear_crontab
