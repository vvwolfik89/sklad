import {Controller} from "@hotwired/stimulus";
import {initializeSelect2} from "../select2_bootstrap";

export default class extends Controller {
    static targets = [
        "orderDetailsContainer",
        "orderDetailTemplate",
        "addOrderButton",
        "removeButton",
        "totalSum",
        "countPlacesInputTarget"
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
        const orderDetails = this.orderDetailsContainerTarget.querySelectorAll('.order-detail');

        orderDetails.forEach(detail => {
            // Проверяем видимость order-detail
            const isHidden = detail.style.display === 'none' ||
                getComputedStyle(detail).display === 'none';
            if (isHidden) return;

            // Находим все .order с data-controller="dynamic-lists"
            const orders = detail.querySelectorAll('.order[data-controller="dynamic-lists"]');

            const detailTotal = Array.from(orders)
                .filter(order => {
                    // Фильтруем: исключаем заказы с _destroy=1
                    const destroyInput = order.querySelector('[name*="_destroy"]');
                    return !(destroyInput && destroyInput.value === '1');
                })
                .map(order => {
                    const sumField = order.querySelector('[data-dynamic-lists-target="sumField"]');
                    if (!sumField) return 0;

                    const rawValue = sumField.textContent.trim();
                    if (!rawValue) return 0;

                    // Очищаем строку: оставляем только цифры, запятые, точки и минус
                    const cleanValue = rawValue.replace(/[^\d,.-]/g, '').replace(',', '.');
                    const number = parseFloat(cleanValue);

                    return isNaN(number) ? 0 : number;
                })
                .reduce((acc, val) => acc + val, 0);

            // Обновляем отображение суммы для этого order-detail
            const totalSumElement = detail.querySelector('[data-order-log-form-target="totalSum"]');
            if (totalSumElement) {
                totalSumElement.textContent = detailTotal.toLocaleString('ru-RU', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                });
            }
            const countPlacesInput = detail.querySelector('[data-order-log-form-target="countPlacesInput"]');
            if (countPlacesInput) {
                countPlacesInput.value = detailTotal;
            }
        });
    }

    addOrderDetail() {
        const template = this.orderDetailTemplateTarget.content.cloneNode(true);
        const container = this.orderDetailsContainerTarget;
        const detailIndex = container.children.length;

        const newDetail = template.firstElementChild;
        newDetail.dataset.orderDetailIndex = detailIndex;
        newDetail.dataset.orderDetailId = this._generateId();

        this.replacePlaceholder(newDetail, /NEW_ORDER_DETAIL/g, detailIndex);

        container.appendChild(newDetail);
        initializeSelect2(newDetail);

        // 🔥 Откладываем инициализацию dynamic-lists
        Promise.resolve().then(() => {
            this.initializeDynamicListsIn(newDetail);
        });
    }

// Вспомогательный метод
    initializeDynamicListsIn(parentElement) {
        const dynamicListsElements = parentElement.querySelectorAll("[data-controller='dynamic-lists']");

        dynamicListsElements.forEach((element, index) => {
            // 🔁 Ждём, пока контроллер будет доступен
            const controller = this.application.getControllerForElementAndIdentifier(element, "dynamic-lists");

            if (controller) {
                console.log("✅ Контроллер найден для:", element);
                controller.restore();

                // Откладываем updateSum, чтобы event всплыл
                Promise.resolve().then(() => {
                    controller.updateSum();
                });
            } else {
                console.warn("❌ Контроллер dynamic-lists НЕ найден для элемента:", element);
                // Повторная попытка (на крайний случай)
                setTimeout(() => {
                    const retry = this.application.getControllerForElementAndIdentifier(element, "dynamic-lists");
                    if (retry) {
                        console.log("✅ Успешно найден после retry:", element);
                        retry.restore();
                        retry.updateSum();
                    } else {
                        console.error("❌ Не удалось найти контроллер даже после retry:", element);
                    }
                }, 50);
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

        // Получаем значение через dataset
        const orderDetailIndex = orderDetail.dataset.orderDetailIndex;

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
            const name = el.getAttribute("name")
                .replace(/NEW_ORDER_DETAIL/g, orderDetailIndex)
                .replace(/NEW_ORDER/g, orderIndex);
            el.setAttribute("name", name);
        });

        ordersContainer.appendChild(newOrder);
        initializeSelect2(newOrder);
        this.updateTotalSum();
    }

    removeOrder(event) {
        const button = event.currentTarget;
        const order = button.closest(".order");
        const destroyInput = order.querySelector('[name*="_destroy"]');

        if (destroyInput) destroyInput.value = "1";
        order.style.display = "none";
        this.updateTotalSum();
    }

    // ✅ Метод должен быть объявлен ВНУТРИ класса
    replacePlaceholder(element, placeholder, value) {
        if (element.setAttribute) {
            ['name', 'id', 'for'].forEach(attr => {
                if (element.hasAttribute(attr)) {
                    const attrValue = element.getAttribute(attr);
                    if (placeholder.test(attrValue)) {
                        element.setAttribute(attr, attrValue.replace(placeholder, value));
                    }
                }
            });
        }

        // Рекурсивно обходим всех детей
        element.querySelectorAll('*').forEach(child => {
            this.replacePlaceholder(child, placeholder, value);
        });
    }


    _generateId() {
        return `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }
}
