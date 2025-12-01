export function initializeSelect2() {
    $('.select2-auto').each(function () {
        const $select = $(this);

        // Если уже инициализирован — не трогаем
        if ($select.data('select2')) {
            return; // выходим, не пересоздаём
        }

        // Инициализируем только если ещё не был создан
        $select.select2({
            theme: 'bootstrap-5',
            width: $select.data('width') || ($select.hasClass('w-100') ? '100%' : 'style'),
            placeholder: $select.data('placeholder') || 'Выберите...',
            closeOnSelect: false,
            tags: true,
            allowClear: true
        });
    });
}



// Инициализация при загрузке страницы или фрейма
document.addEventListener('turbo:load', initializeSelect2);

// Инициализация после добавления новых элементов (например, через Turbo Streams)
// document.addEventListener('turbo:frame-render', initializeSelect2);