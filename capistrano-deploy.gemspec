# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'capistrano-deploy'
  s.version     = '0.1.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Just Lest']
  s.email       = ['just.lest@gmail.com']
  s.homepage    = 'https://github.com/lest/capistrano-deploy'
  s.summary     = 'Capistrano deploy recipes'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency('capistrano', '~> 2.6.0')
end
