Capistrano::Configuration.instance(:must_exist).load do
  def use_recipe(recipe)
    require "capistrano-deploy/#{recipe}"
  end

  def use_recipes(*recipes)
    recipes.each do |recipe|
      use_recipe(recipe)
    end
  end

  namespace :deploy do
    desc 'Run deploy'
    task :default do
      update
      restart
    end

    task :update do
      # nothing
    end

    task :restart do
      # nothing
    end
  end
end
