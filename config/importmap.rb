# Pin npm packages by running ./bin/importmap

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.2/dist/esm/index.js"
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.js"
pin "select2", to: "https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"
pin "chart", to: "template/lib/chart/chart.min.js"
pin "easing", to: "template/lib/easing/easing.min.js"
pin "waypoints", to: "template/lib/waypoints/waypoints.min.js"
pin "owl.carousel", to: "template/lib/owlcarousel/owl.carousel.min.js"
pin "moment", to: "template/lib/tempusdominus/js/moment.min.js", preload: true
pin "moment-timezone", to: "template/lib/tempusdominus/js/moment-timezone.min.js"
pin "tempusdominus-bootstrap-4", to: "template/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"
pin "main", to: "template/main.js"
pin "select2_bootstrap", to: "select2_bootstrap.js"
pin "templatejs"
pin "application"
