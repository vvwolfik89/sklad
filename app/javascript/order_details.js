// Функция добавления новой строки order_detail
export function addOrderDetail() {
    const template = document.getElementById("order-detail-template").content;
    const container = document.getElementById("order-details-container");
debugger
    const clone = document.importNode(template, true);

    // Генерируем уникальный временный ID
    const newId = new Date().getTime();
    const fields = clone.querySelectorAll("input, select, textarea");

    fields.forEach(field => {
        if (field.name) {
            field.name = field.name.replace(/new_order_details/g, newId);
        }
        if (field.id) {
            field.id = field.id.replace(/new_order_details/g, newId);
        }
    });

    container.appendChild(clone);
}

// Функция удаления строки
export function removeOrderDetail(event) {
    event.preventDefault();
    const wrapper = event.target.closest(".nested-fields");

    // Если это существующая запись — помечаем _destroy
    const destroyInput = wrapper.querySelector("input[name*='_destroy']");
    if (destroyInput) {
        destroyInput.value = "1";
    }

    wrapper.style.display = "none"; // скрываем
}
