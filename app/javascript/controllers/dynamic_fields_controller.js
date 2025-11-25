import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["container"]

    updateFields(event) {
        console.log("Updating fields...")
        const quantity = parseInt(event.target.value) || 0;

        if (!this.hasContainerTarget) {
            console.error("Элемент container не найден!");
            return;
        }

        this.clearFields();

        if (quantity > 0) {
            for (let i = 1; i <= quantity; i++) {
                this.addField(i);
            }
        }
    }

    addField(index) {
        const div = document.createElement("div");
        div.className = "mb-3";

        div.innerHTML = `
      <label for="data_list_${index}" class="form-label">Позиция ${index}</label>
      <input
        type="text"
        name="order_log[order][data_list][${index}]"
        id="data_list_${index}"
        class="form-control"
        placeholder="Введите значение"
      >
    `;

        this.containerTarget.appendChild(div);
    }

    clearFields() {
        this.containerTarget.innerHTML = "";
    }
    connect() {
        console.log("DynamicFields controller connected!!!!!!!!!!!!!!!!!!!!!!");
        console.log("Container target:", this.containerTarget);
    }


}