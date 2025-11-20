// // Функция добавления новой строки order_detail
// export function addOrderDetail() {
//     const template = document.getElementById("order-detail-template").content;
//     const container = document.getElementById("order-details-container");
//     const clone = document.importNode(template, true);
//
//     // Генерируем уникальный временный ID
//     const newId = new Date().getTime();
//     const fields = clone.querySelectorAll("input, select, textarea");
//
//     fields.forEach(field => {
//         if (field.name) {
//             field.name = field.name.replace(/new_order_details/g, newId);
//         }
//         if (field.id) {
//             field.id = field.id.replace(/new_order_details/g, newId);
//         }
//     });
//
//     container.appendChild(clone);
// }
//
// // Функция удаления строки
// export function removeOrderDetail(event) {
//     event.preventDefault();
//
//     const wrapper = event.target.closest(".nested-fields");
//
//     // Если это существующая запись — помечаем _destroy
//     const destroyInput = wrapper.querySelector("input[name*='_destroy']");
//
//     if (destroyInput) {
//         destroyInput.value = "1";
//     }
//
//     wrapper.style.display = "none"; // скрываем
// }

// Функция добавления новой строки order_detail
export function addOrderDetail() {
    const container = document.getElementById('order_details');
    const template = document.getElementById('new_order_detail_template');
    // Получаем HTML шаблона
    let newFields = template.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
    // Создаём новый div и добавляем поля
    const newDetail = document.createElement('div');
    newDetail.innerHTML = newFields;
    container.appendChild(newDetail);
}
//
// // Функция удаления строки
export function removeOrderDetail(event) {
    const target = event.target;

    // Проверяем, нажата ли кнопка удаления
    if (target.classList.contains('remove_order_detail')) {
        event.preventDefault();

        // Находим родительский блок детали заказа
        const wrapper = target.closest('.order_detail');
        if (!wrapper) return;

        // Отмечаем для удаления (если есть скрытое поле)
        const destroyInput = wrapper.querySelector("input[name*='_destroy']");
        if (destroyInput) {
            destroyInput.value = "1";
        }

        // Скрываем элемент
        wrapper.style.display = "none";
    }
}






// document.addEventListener("turbo:load", function() {
//     const addButton = document.getElementById('add_order_detail');
//     const container = document.getElementById('order_details');
//     const template = document.getElementById('new_order_detail_template');
//
//     addButton.addEventListener('click', function() {
//         // Получаем HTML шаблона
//         let newFields = template.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
//
//         // Создаём новый div и добавляем поля
//         const newDetail = document.createElement('div');
//         newDetail.innerHTML = newFields;
//         container.appendChild(newDetail);
//     });
//
//     // Обработчик для удаления полей
//     container.addEventListener('click', function(e) {
//         e.preventDefault();
//         if (e.target.classList.contains('remove_order_detail')) {
//             const wrapper = e.target.closest('.order_detail');
//
//             const destroyInput = wrapper.querySelector("input[name*='_destroy']");
//             if (destroyInput) {
//                 destroyInput.value = "1";
//             }
//             wrapper.style.display = "none"; // скрываем
//         }
//     });
// });

