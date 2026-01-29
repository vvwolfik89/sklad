import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
    static targets = ["relatedSection", "optionsSection"]

    toggleSections(event) {
        const fieldType = event.target.value;

        // Скрываем все секции
        this.relatedSectionTargets.forEach(section => section.classList.add("d-none"));
        this.optionsSectionTargets.forEach(section => section.classList.add("d-none"));

        // Показываем нужную секцию в зависимости от типа поля
        if (fieldType === "user_select" || fieldType === "car_select") {
            this.relatedSectionTargets.forEach(section => section.classList.remove("d-none"));
        } else if (fieldType === "dropdown") {
            this.optionsSectionTargets.forEach(section => section.classList.remove("d-none"));
        }
    }
}