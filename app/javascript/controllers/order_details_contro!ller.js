import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["template", "container"]

    add(event) {
        event.preventDefault()

        const content = this.templateTarget.innerHTML
        const newId = Date.now()
        const fragment = document.createRange().createContextualFragment(
            content.replace(/new_order_details/g, newId)
        )
        // Назначаем обработчик удаления
        const removeBtn = fragment.querySelector(".remove_order_detail")

        if (removeBtn) {
            removeBtn.addEventListener("click", this.remove.bind(this))

        } else {
            console.warn("Кнопка .remove-detail-btn не найдена в шаблоне")
        }

        this.containerTarget.appendChild(fragment)
    }

    remove(event) {
        event.preventDefault()
        const wrapper = event.target.closest(".order_detail")
        if (!wrapper) return
        const destroyInput = wrapper.querySelector("input[name*='_destroy']")
        if (destroyInput) {
            destroyInput.value = "1"
        }
        wrapper.style.display = "none"
    }
}