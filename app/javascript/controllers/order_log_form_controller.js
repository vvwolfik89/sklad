import { Controller } from "@hotwired/stimulus";
import { initializeSelect2 } from "../select2_bootstrap"; // Импортируем функцию

export default class extends Controller {
    static targets = [
        "orderDetailsContainer",
        "orderDetailTemplate",
        "orderTemplate",
        "addOrderButton",
        "removeButton"
    ];

    // Добавление нового OrderDetail
    addOrderDetail() {
        const template = this.orderDetailTemplateTarget.content.cloneNode(true);
        const container = this.orderDetailsContainerTarget;

        // Получаем индекс
        const detailIndex = container.querySelectorAll('.order-detail:not([style*="display: none"])').length;

        // 🔁 Заменяем NEW_ORDER_DETAIL ВЕЗДЕ: в полях и в шаблонах
        template.querySelectorAll("[name], [data-order-detail-target='orderTemplate'] [name]").forEach(el => {
            if (el.hasAttribute("name")) {
                const name = el.getAttribute("name").replace(/NEW_ORDER_DETAIL/g, detailIndex);
                el.setAttribute("name", name);
            }
        });

        // Или проще — обработать весь innerHTML
        const tempDiv = document.createElement('div');
        tempDiv.appendChild(template);
        tempDiv.innerHTML = tempDiv.innerHTML.replace(/NEW_ORDER_DETAIL/g, detailIndex);

        const newDetail = tempDiv.firstElementChild;

        // Сохраняем индекс
        newDetail.dataset.orderDetailIndex = detailIndex;
        newDetail.dataset.orderDetailId = this._generateId();

        container.appendChild(newDetail);
        initializeSelect2();
    }

    // Удаление OrderDetail
    removeOrderDetail(event) {
        console.log("removeOrderDetail вызван");
        const button = event.currentTarget;
        const container = button.closest(".order-detail");
        const destroyInput = container.querySelector('[name*="_destroy"]');

        if (destroyInput) destroyInput.value = "1";
        container.style.display = "none";
    }

    // Добавление Order внутри OrderDetail
    addOrder(event) {
        const orderDetail = event.currentTarget.closest(".order-detail");

        // 🔎 Ищем шаблон ВНУТРИ этого order_detail
        const orderTemplate = orderDetail.querySelector('[data-order-detail-target="orderTemplate"]');

        if (!orderTemplate) {
            console.error("Шаблон orderTemplate не найден внутри order_detail");
            return;
        }

        const ordersContainer = orderDetail.querySelector('[data-order-detail-target="ordersContainer"]');
        const orderIndex = ordersContainer.querySelectorAll('.order:not([style*="display: none"])').length;

        // Клонируем
        const template = orderTemplate.content.cloneNode(true);

        // Заменяем плейсхолдеры
        template.querySelectorAll("[name]").forEach(el => {
            if (el.hasAttribute("name")) {
                let name = el.getAttribute("name")
                    .replace(/NEW_ORDER/g, orderIndex);
                el.setAttribute("name", name);
            }
        });

        ordersContainer.appendChild(template.firstElementChild);
        initializeSelect2();
    }

// Вспомогательный метод для генерации ID
    _generateId() {
        return `order_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }


    // Удаление Order
    removeOrder(event) {
        console.log("removeOrder вызван");
        const button = event.currentTarget;
        const order = button.closest(".order");
        const destroyInput = order.querySelector('[name*="_destroy"]');

        if (destroyInput) destroyInput.value = "1";
        order.style.display = "none";
    }

    // Генератор уникального ID
    _generateId() {
        return `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }
}
