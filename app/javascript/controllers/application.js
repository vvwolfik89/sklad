import { Application } from "@hotwired/stimulus"
import { addOrderDetail, removeOrderDetail } from "order_details";
// import OrderDetailsController from "./controllers/order_details_controller"

const application = Application.start()
// application.register("order-details", OrderDetailsController)
// Configure Stimulus development experience
// application.debug = false
window.Stimulus   = application



// При загрузке страницы (Turbo-friendly)
document.addEventListener("turbo:load", () => {
    const addButton = document.getElementById("add-order-detail");
    if (addButton) {
        addButton.addEventListener("click", (e) => {
            e.preventDefault();
            addOrderDetail();
        });
    }
});




export { application }
