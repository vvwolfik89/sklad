import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["field"]

    addField() {

        const template = this.element.querySelector("template")

        const container = document.getElementById("new-fields-container")

        if (!template || !container) {
            return
        }

        const timestamp = Date.now()
        const newField = template.content.cloneNode(true)

        newField.querySelectorAll("[name*='NEW_FIELD']").forEach(input => {
            input.name = input.name.replace(/NEW_FIELD/g, timestamp)
        })

        container.appendChild(newField)
    }


    removeField(event) {
        event.currentTarget.closest("[data-field-target='field']").remove()
    }
}
