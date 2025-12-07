import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "jsonField"]

    connect() {
        this.restore()
    }

    // Восстанавливаем поля из data_lists при загрузке
    restore() {
        const jsonField = this.jsonFieldTarget
        const select = this.element.querySelector("select[name*='[lists]']")

        if (!jsonField || !select) return

        const data = this.parseJson(jsonField.value)
        const count = Object.keys(data).length > 0
            ? Math.max(...Object.keys(data).map(k => parseInt(k, 10)))
            : parseInt(select.value || 0, 10)

        // Устанавливаем значение select, если не было
        if (select.value === "" || select.value === "0") {
            select.value = count
        }

        this.renderFields(count, data)
    }

    // Основное обновление при изменении select
    update() {
        const select = this.element.querySelector("select[name*='[lists]']")
        const count = parseInt(select?.value || 0, 10)
        const currentData = this.getCurrentData()

        this.renderFields(count, currentData)
    }

    // Отрисовка полей
    renderFields(count, data = {}) {
        const container = this.containerTarget

        container.innerHTML = ""

        // Создаём таблицу
        const table = document.createElement("table")
        table.className = "table table-bordered table-sm"

        // Шапка: Лист 1, Лист 2, ...
        const thead = document.createElement("thead")
        const headerRow = document.createElement("tr")

        for (let i = 1; i <= count; i++) {
            const th = document.createElement("th")
            th.style.textAlign = "center"
            th.textContent = `Лист ${i}`
            th.width = `${100 / count}%`
            headerRow.appendChild(th)
        }

        thead.appendChild(headerRow)
        table.appendChild(thead)

        // Тело: строка с полями ввода
        const tbody = document.createElement("tbody")
        const inputRow = document.createElement("tr")

        for (let i = 1; i <= count; i++) {
            const td = document.createElement("td")

            const input = document.createElement("input")
            input.type = "number"
            input.className = "form-control form-control-sm"
            input.dataset.index = i
            input.placeholder = `Значение`
            input.value = data[i] || ""
            input.style.textAlign = "center"

            input.addEventListener("input", () => {
                this.updateJson()
            })

            td.appendChild(input)
            inputRow.appendChild(td)
        }

        tbody.appendChild(inputRow)
        table.appendChild(tbody)

        container.appendChild(table)

        // Обновляем JSON
        this.updateJson()
    }


    // Обновляем JSON из текущих полей
    updateJson() {
        const inputs = this.containerTarget.querySelectorAll("input[data-index]")
        const data = {}

        inputs.forEach(input => {
            data[input.dataset.index] = input.value
        })

        this.jsonFieldTarget.value = JSON.stringify(data)
    }

    // Текущие данные из полей
    getCurrentData() {
        const inputs = this.containerTarget.querySelectorAll("input[data-index]")
        const data = {}
        inputs.forEach(input => {
            data[input.dataset.index] = input.value
        })
        return data
    }

    // Парсим JSON безопасно
    parseJson(jsonString) {
        try {
            return jsonString ? JSON.parse(jsonString) : {}
        } catch (e) {
            console.error("Invalid JSON in data_list:", jsonString)
            return {}
        }
    }
}
