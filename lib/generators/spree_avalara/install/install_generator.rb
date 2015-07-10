module SpreeAvalara
  module Generators
    class InstallGenerator < Rails::Generators::Base

      argument :file_name, :type => :string, :desc => 'rails app_path', :default => '.'
      source_root File.expand_path('../../templates', __FILE__)

      def copy_initializer_file
        template 'spree_avalara.rb', "#{file_name}/config/initializers/spree_avalara.rb"
      end
      
      def add_javascripts
        append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_avalara\n"
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_avalara\n"
      end

  
      def add_stylesheets
        inject_into_file sassify('app/assets/stylesheets/store/all.css'), " *= require store/spree_avalara\n", :before => /\*\//, :verbose => true
        inject_into_file sassify('app/assets/stylesheets/admin/all.css'), " *= require admin/spree_avalara\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_avalara'
      end

      def run_migrations
         res = ask 'Would you like to run the migrations now? [Y/n]'
         if res == '' || res.downcase == 'y'
           run 'bundle exec rake db:migrate'
         else
           puts 'Skipping rake db:migrate, don\'t forget to run it!'
         end
      end
      private
      def sassify(filename, extension='.scss')
        File.exist?(filename + extension) ? filename + extension : filename     
      end
    end
  end
end


module SpreeContactUs
  module Generators
    class InstallGenerator < Rails::Generators::Base

      argument :file_name, :type => :string, :desc => 'rails app_path', :default => '.'
      source_root File.expand_path('../../templates', __FILE__)

      def copy_initializer_file
        template 'spree_contact_us.rb', "#{file_name}/config/initializers/spree_contact_us.rb"
      end

    end
  end
end
