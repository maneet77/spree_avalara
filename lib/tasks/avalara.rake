require File.expand_path('../../../app/models/seed/seed_importer', __FILE__)

include SeedImporter

namespace :avalara do
  namespace :import do

    desc %q#import tax codes for avalara#
    task :avalara_codes => :environment  do
      SeedImporter::avalara_taxons
    end
  end
end