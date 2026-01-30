import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["relatedSection", "optionsSection", "relatedModel", "displayField"];

    toggleSections(event) {
        const fieldType = event.target.value;

        console.log("Выбран тип:", fieldType);

        // 1. Всегда скрываем ВСЕ секции
        this.relatedSectionTargets.forEach(section =>
            section.classList.add("qqqd-none")
        );
        this.optionsSectionTargets.forEach(section =>
            section.classList.add("qqqd-none")
        );

        // 2. Очищаем все релевантные поля
        this.clearRelatedFields();

        // 3. Логика для поддерживаемых типов
        if (fieldType === "user_select" || fieldType === "car_select") {
            // Показываем секцию для связанных моделей
            this.relatedSectionTargets.forEach(section =>
                section.classList.remove("d-none")
            );
            // Автоматически подставляем значение в related_model
            this.setRelatedModelValue(fieldType);
        }
        else if (fieldType === "dropdown") {
            // Показываем секцию для опций dropdown
            this.optionsSectionTargets.forEach(section =>
                section.classList.remove("d-none")
            );
        }
        // 4. Для всех остальных типов — ничего не показываем (секции уже скрыты)
    }

// Метод для очистки полей
    clearRelatedFields() {
        if (this.hasRelatedModelTarget) {
            debugger
            this.relatedModelTargets.forEach(input => input.value = "");
        }
        if (this.hasDisplayFieldTarget) {
            debugger
            this.displayFieldTargets.forEach(input => input.value = "");
        }
        if (this.hasOptionsTarget) {
            this.optionsTargets.forEach(textarea => textarea.value = "");
        }
    }

// Метод для автоподстановки значения в related_model
    setRelatedModelValue(fieldType) {
        const typeMap = {
            user_select: "User",
            car_select: "Car"
        };
        const value = typeMap[fieldType] || "";

        this.relatedModelTargets.forEach(input => {
            input.value = value;
        });
    }
}
