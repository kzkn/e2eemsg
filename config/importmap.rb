# Pin npm packages by running ./bin/importmap

pin "application"
pin "global"
pin "messaging"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# SEE: https://github.com/rails/importmap-rails/issues/65#issuecomment-2587622340
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
