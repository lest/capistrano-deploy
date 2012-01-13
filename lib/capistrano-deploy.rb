require 'capistrano'

module CapistranoDeploy
  def self.load_into(configuration)
    configuration.load do
      @used_recipes = []

      class << self
        attr_reader :used_recipes
      end

      def use_recipe(recipe_name)
        return if @used_recipes.include?(recipe_name.to_sym)

        begin
          require "capistrano-deploy/#{recipe_name}"

          recipe = CapistranoDeploy.const_get(recipe_name.to_s.capitalize.gsub(/_(\w)/) { $1.upcase })
          recipe.load_into(self)
          @used_recipes << recipe.to_s.split('::').last.downcase.to_sym
        rescue LoadError
          abort "Are you misspelled `#{recipe_name}` recipe name?"
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
