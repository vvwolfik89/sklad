import { Application } from "@hotwired/stimulus"
import OrderDetailsController from "./controllers/order_details_controller"

const application = Application.start()
application.register("order-details", OrderDetailsController)
// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
