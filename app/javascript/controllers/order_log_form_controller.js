import { Controller } from "@hotwired/stimulus";

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
        console.log("addOrderDetail вызван");
        const template = this.orderDetailTemplateTarget.content.cloneNode(true);
        const newId = this._generateId();

        // Заменяем плейсхолдер на уникальный ID
        template.querySelectorAll("[data-order-detail-id]").forEach(el => {
            el.dataset.orderDetailId = newId;
        });

        this.orderDetailsContainerTarget.appendChild(template);
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
        const button = event.currentTarget;
        const orderDetail = button.closest(".order-detail");
        const ordersContainer = orderDetail.querySelector(
            '[data-order-detail-target="ordersContainer"]'
        );

        if (!ordersContainer) {
            console.error("Container для заказов не найден!");
            return;
        }

        // Получаем ID родительского OrderDetail
        const detailId = orderDetail.dataset.orderDetailId || "NEW_ORDER_DETAIL";

        // Генерируем уникальный ID для нового Order
        const orderId = this._generateId();

        // Клонируем шаблон
        const template = this.orderTemplateTarget.content.cloneNode(true);

        // Заменяем плейсхолдеры на реальные ID
        template.querySelectorAll("[name], [data-order-id]").forEach(element => {
            if (element.hasAttribute("name")) {
                element.setAttribute(
                    "name",
                    element.getAttribute("name")
                        .replace(/NEW_ORDER_DETAIL/g, detailId)
                        .replace(/NEW_ORDER/g, orderId)
                );
            }
            if (element.hasAttribute("data-order-id")) {
                element.dataset.orderId = orderId;
            }
        });

        // Вставляем в DOM
        ordersContainer.appendChild(template);
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
        const destroyInput = order.querySelector('[name*="[orders][][_destroy]"]');

        if (destroyInput) destroyInput.value = "1";
        order.style.display = "none";
    }

    // Генератор уникального ID
    _generateId() {
        return `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }
}
