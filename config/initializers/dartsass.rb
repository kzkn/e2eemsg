Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css"
}
Rails.application.config.dartsass.build_options << "--quiet-deps"
Rails.application.config.dartsass.build_options << "--load-path #{Rails.root.join('node_modules')}"
