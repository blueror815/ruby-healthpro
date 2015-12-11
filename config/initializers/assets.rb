# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( bills.js icheck/flat/flat.png form_data.js job_types.js select2/select2.png users.js jquery.dataTables.rowGrouping.js timesheets.js sweetalert-dev.js custom_forms/field_types.js insurance_companies.js payment_types.js claim_types.js availabilities.js reports.js )
Rails.application.config.assets.precompile += %w( payroll_statistics.js templates.css templates.js)
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
