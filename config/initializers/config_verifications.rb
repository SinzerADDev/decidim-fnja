# frozen_string_literal: true

# We are using the same DirectVerifications engine without the admin part to
# create a custom verification method called "direct_verifications_managers"
# Decidim::Verifications.register_workflow(:direct_verifications_managers) do |workflow|
#   workflow.engine = Decidim::DirectVerifications::Verification::Engine
# end

# We need to tell the plugin to handle this method in addition to the default "Direct verification". Any registered workflow is valid.
Decidim::DirectVerifications.configure do |config|
  config.manage_workflows = %w(direct_verifications id_documents)

  # change the to the metadata_parser if you want it
  # config.input_parser = :metadata_parser
end

# Remove NIE from id_documents form
Rails.application.config.to_prepare do
  Decidim::Verifications::IdDocuments::InformationForm.class_eval do
    Decidim::Verifications::IdDocuments::InformationForm.send(:remove_const, :DOCUMENT_TYPES)
    Decidim::Verifications::IdDocuments::InformationForm.const_set(:DOCUMENT_TYPES, %w(DNI passport))
  end
end
