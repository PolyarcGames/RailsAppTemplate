# app_template.rb

# Add gems or custom configurations if needed
gem "pg" # PostgreSQL for UUIDs and database management

gem_group :development, :test do
  gem "debug", ">= 1.0.0"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "ruby-lsp-rspec", require: false
end

# Run bundle install after adding gems
after_bundle do
  say "setup up rspec"
  generate "rspec:install"

  FileUtils.mv('./test/dummy', "./spec/dummy")

  file 'spec/support/factory_bot.rb' do <<~RUBY
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY
  end
  initializer 'factory_bot.rb', <<~RUBY
    FactoryBot.definition_file_paths = ["RSpec.root.join('spec', 'factories')"]
  RUBY

  inject_into_file 'spec/rails_helper.rb' do <<-'RUBY'
    require_relative 'support/factory_bot'
  RUBY
  end

  inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-'RUBY'
    config.generators do |g|
      g.test_framework :rspec,
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  RUBY
  end

  say "setting up UUIDs"
  # Set UUID as the primary key type for all models
  generate "migration enable_uuid_extension", <<~RUBY
    class EnableUuidExtension < ActiveRecord::Migration[6.1]
      def change
        enable_extension 'pgcrypto'
      end
    end
  RUBY

  # Set default primary key type to UUID in config/application.rb
  inject_into_file "config/application.rb", after: "class Application < Rails::Application\n" do <<-'RUBY'
    # Use UUIDs as the default primary key type
    config.active_record.primary_key = :uuid
  RUBY
  end
end
