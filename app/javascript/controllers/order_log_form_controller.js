import {Controller} from "@hotwired/stimulus";
import {initializeSelect2} from "../select2_bootstrap";

export default class extends Controller {
    static targets = [
        "orderDetailsContainer",
        "orderDetailTemplate",
        "addOrderButton",
        "removeButton",
        "totalSum"
    ];

    connect() {
        this.updateTotalSum();
        this.observeOrderSumUpdates();
    }

    observeOrderSumUpdates() {
        // Слушаем события из dynamic-lists (они всплывают)
        this.orderDetailsContainerTarget.addEventListener("order-sum-updated", () => {
            this.updateTotalSum();
        });
    }

    updateTotalSum() {
        const sumFields = this.orderDetailsContainerTarget.querySelectorAll(
            '.order-detail:not([style*="display: none"]) [data-dynamic-lists-target="sumField"]'
        );

        const total = Array.from(sumFields)
            .map(el => {
                const text = el.textContent.trim();
                const number = parseFloat(text.replace(/\s/g, '').replace(',', '.'));
                return isNaN(number) ? 0 : number;
            })
            .reduce((acc, val) => acc + val, 0);

        this.totalSumTarget.textContent = total.toLocaleString('ru-RU', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });

    }

    addOrderDetail() {
        const template = this.orderDetailTemplateTarget.content.cloneNode(true);
        const container = this.orderDetailsContainerTarget;
        const detailIndex = container.children.length;

        const tempDiv = document.createElement('div');
        tempDiv.appendChild(template);
        tempDiv.innerHTML = tempDiv.innerHTML.replace(/NEW_ORDER_DETAIL/g, detailIndex);

        const newDetail = tempDiv.firstElementChild;
        newDetail.dataset.orderDetailIndex = detailIndex;
        newDetail.dataset.orderDetailId = this._generateId();

        container.appendChild(newDetail);
        initializeSelect2(newDetail);

        // 🔥 Инициализируем все dynamic-lists внутри нового OrderDetail
        this.initializeDynamicListsIn(newDetail);
        this.updateTotalSum(); // пересчитываем общую сумму
    }

// Вспомогательный метод
    initializeDynamicListsIn(parentElement) {
        const dynamicListsElements = parentElement.querySelectorAll("[data-controller='dynamic-lists']");
        dynamicListsElements.forEach(element => {
            const controller = this.application.getControllerForElementAndIdentifier(element, "dynamic-lists");
            if (controller) {
                controller.restore(); // восстанавливаем поля и сумму
            } else {
                console.warn("Контроллер dynamic-lists не найден для элемента", element);
            }
        });
    }

    removeOrderDetail(event) {
        const button = event.currentTarget;
        const container = button.closest(".order-detail");
        const destroyInput = container.querySelector('[name*="_destroy"]');

        if (destroyInput) destroyInput.value = "1";
        container.style.display = "none";
        this.updateTotalSum(); // пересчитываем
    }

    addOrder(event) {
        const orderDetail = event.currentTarget.closest(".order-detail");
        const orderTemplate = orderDetail.querySelector('[data-order-detail-target="orderTemplate"]');

        if (!orderTemplate) {
            console.error("Шаблон orderTemplate не найден");
            return;
        }

        const ordersContainer = orderDetail.querySelector('[data-order-detail-target="ordersContainer"]');
        const orderIndex = ordersContainer.querySelectorAll('.order:not([style*="display: none"])').length;

        const fragment = orderTemplate.content.cloneNode(true);
        const newOrder = fragment.firstElementChild;

        newOrder.querySelectorAll("[name]").forEach(el => {
            const name = el.getAttribute("name").replace(/NEW_ORDER/g, orderIndex);
            el.setAttribute("name", name);
        });

        ordersContainer.appendChild(newOrder);
        initializeSelect2(newOrder);
        this.updateTotalSum(); // на случай, если dynamic-lists не сработал
    }

    removeOrder(event) {
        const button = event.currentTarget;
        const order = button.closest(".order");
        const destroyInput = order.querySelector('[name*="_destroy"]');

        if (destroyInput) destroyInput.value = "1";
        order.style.display = "none";
        this.updateTotalSum();
    }

    _generateId() {
        return `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }
}
