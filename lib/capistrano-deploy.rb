module CapistranoDeploy
  def self.load_into(configuration)
    configuration.load do
      @used_recipes = []

      (class << self; self; end).class_eval do
        attr_reader :used_recipes

        define_method :use_recipe do |recipe_name|
          return if @used_recipes.include?(recipe_name.to_sym)
          @used_recipes << recipe_name.to_sym

          require "capistrano-deploy/#{recipe_name}"
          recipe = CapistranoDeploy.const_get(recipe_name.to_s.capitalize.gsub(/_(\w)/) { $1.upcase })
          recipe.load_into(configuration)
        end
      end

      def use_recipes(*recipes)
        recipes.each do |recipe|
          use_recipe(recipe)
        end
      end

      def using_recipe?(recipe)
        used_recipes.include?(recipe.to_sym)
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
  end
end

if Capistrano::Configuration.instance
  CapistranoDeploy.load_into(Capistrano::Configuration.instance)
end
