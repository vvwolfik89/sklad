import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["detailRow", "destroyField"]

    addDetail() {
        // Находим последний row
        const lastRow = this.detailRowTargets[this.detailRowTargets.length - 1]
        debugger
        if (!lastRow) return

        // Клонируем его
        const newRow = lastRow.cloneNode(true)

        // Очищаем значения полей
        newRow.querySelectorAll('input').forEach(input => {
            if (input.name.includes('[id]')) {
                input.value = ''
            } else if (input.name.includes('[_destroy]')) {
                input.value = 'false'
            } else {
                input.value = ''
            }
        })

        // Вставляем после последнего
        lastRow.parentNode.insertBefore(newRow, lastRow.nextSibling)
    }

    removeDetail(event) {
        const row = event.currentTarget.closest('[data-order-details-target="detailRow"]')

        // Если есть поле _destroy — ставим true и скрываем
        const destroyField = row.querySelector('[data-order-details-target="destroyField"]')
        if (destroyField) {
            destroyField.value = 'true'
        }

        row.style.display = 'none'
    }
}