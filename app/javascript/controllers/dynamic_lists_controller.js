import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "jsonField", "sumField"]

    connect() {
        this.restore()
        this.updateSum() // Считаем при загрузке
    }

    // Восстанавливаем поля из data_lists при загрузке
    restore() {
        const jsonField = this.jsonFieldTarget
        const select = this.element.querySelector("select[name*='[lists]']")

        if (!jsonField || !select) return

        const json = jsonField.value.trim();
        const data = json ? this.parseJson(json) : {};

        // Извлекаем только числовые ключи (например, "1", "2", а не "data_list_sum")
        const numericKeys = Object.keys(data).filter(key => /^\d+$/.test(key));

        const count = numericKeys.length > 0
            ? Math.max(...numericKeys.map(k => parseInt(k, 10)))
            : parseInt(this.selectTarget.value || 0, 10);
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
        this.updateSum()
    }

    // Отрисовка полей
    renderFields(count, data = {}) {
        const container = this.containerTarget

        container.innerHTML = ""

        // Создаём таблицу
        const table = document.createElement("table")
        table.classList.add("table", "table-bordered", "table-sm", "mb-0")
        table.style.fontSize = "0.9rem"

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
                this.updateSum()
            })

            td.appendChild(input)
            inputRow.appendChild(td)
        }

        tbody.appendChild(inputRow)
        table.appendChild(tbody)

        container.appendChild(table)

        // Обновляем JSON
        this.updateJson()
        this.updateSum()
    }

    updateJson() {
        const inputs = this.containerTarget.querySelectorAll("input[data-index]")
        const data = {}

        inputs.forEach(input => {
            data[input.dataset.index] = input.value
        })

        // Добавляем сумму в JSON
        const sum = Object.values(data).map(v => parseFloat(v) || 0).reduce((a, b) => a + b, 0)
        data.data_list_sum = parseFloat(sum.toFixed(2))

        // Сохраняем в hidden_field
        this.jsonFieldTarget.value = JSON.stringify(data)
    }


    // Обновляем JSON из текущих полей
    updateSum() {
        const inputs = this.containerTarget.querySelectorAll("input[data-index]")
        const sum = Array.from(inputs)
            .map(input => parseFloat(input.value) || 0)
            .reduce((acc, val) => acc + val, 0)

        if (this.hasSumFieldTarget) {
            this.sumFieldTarget.value = sum
            this.sumFieldTarget.textContent = sum.toLocaleString()
        }

        // Уведомляем OrderDetail о пересчёте
        this.element.dispatchEvent(new CustomEvent("order-sum-updated", {
            bubbles: true,   // ← ВСПЛЫВАЕТ
            cancelable: true // ← Можно отменить (не обязательно)
        }));
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
