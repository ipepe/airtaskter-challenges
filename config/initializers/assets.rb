Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.digest = true
Rails.application.config.assets.precompile += %w(.svg .eot .woff .ttf .woff2 .png)
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'font-awesome', 'fonts')

NonStupidDigestAssets.whitelist += [/.(?i:)(?:svg|eot|woff|ttf|otf)$/]
