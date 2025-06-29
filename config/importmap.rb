# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "preline", to: "https://ga.jspm.io/npm:preline@1.9.0/dist/preline.js"
pin "flatpickr" # @4.6.13
pin "stimulus-flatpickr" # @3.0.0
