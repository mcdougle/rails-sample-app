source 'https://rubygems.org'

gem 'rails', '3.2.13'

group :development, :test do
	gem 'sqlite3'
end

group :test do
	# this is for rspec and stuff
	# I haven't played around with that in this project
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :production do
	# I don't know. postgres or mysql?
	# obviously whatever I'd be using for db
end

gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'		# To use ActiveModel has_secure_password
gem 'will_paginate'					# to paginate items
