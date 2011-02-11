Capistrano deploy recipes
==================

Deploy
------

Git-based deployment process.

Minimal Capfile for deploy:

    require 'capistrano-lest/deploy'

    server 'server name or ip address', :web, :app, :db, :primary => true
    set :user, 'user for deploy'
    set :deploy_to, '/deploy/to/path'
    set :repository, 'your git repository'

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

    require 'capistrano-lest/multistage'

    set :default_stage, :development

    define_stage :development do
      ...
    end

    define_stage :production do
      ...
    end

Bundle
------

    require 'capistrano-lest/bundle'

To automatically install missing gems:

    after 'deploy:update_code', 'bundle:install'

Unicorn
-------

    require 'capistrano-lest/unicorn'

Now you can setup to reload unicorn on `deploy:restart`:

    after 'deploy:restart', 'unicorn:reload'

Whenever
--------

    require 'capistrano-lest/whenever'

To automatically update crontab file:

    after 'deploy:restart', 'whenever:update_crontab'

You can also clear crontab file with command:

    cap whenever:clear_crontab
