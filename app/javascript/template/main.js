(function ($) {
    'use strict';

    $(document).ready(function () {
        // Вспомогательная функция для безопасной инициализации графика
        function safeInitChart(canvasId, chartConfig) {
            // Проверяем наличие canvas
            const canvas = document.getElementById(canvasId);
            if (!canvas) {
                console.warn(`⚠️ Canvas с ID "${canvasId}" не найден в DOM. График не будет создан.`);
                return null;
            }

            // Проверяем доступность getContext
            const ctx = canvas.getContext('2d');
            if (!ctx) {
                console.error(`❌ Не удалось получить контекст 2D для canvas "${canvasId}".`);
                return null;
            }

            // Инициализируем Chart.js
            try {
                return new Chart(ctx, chartConfig);
            } catch (error) {
                console.error(`❌ Ошибка при создании графика "${canvasId}":`, error);
                return null;
            }
        }

        // 1. Spinner (загрузочный индикатор)
        const spinner = () => {
            setTimeout(() => {
                const spinnerEl = $('#spinner');
                if (spinnerEl.length) {
                    spinnerEl.removeClass('show');
                }
            }, 1);
        };
        spinner();

        // 2. Кнопка "Наверх"
        $(window).on('scroll', () => {
            if ($(window).scrollTop() > 300) {
                $('.back-to-top').fadeIn('slow');
            } else {
                $('.back-to-top').fadeOut('slow');
            }
        });

        $('.back-to-top').on('click', function (e) {
            e.preventDefault();
            $('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
        });

        // 3. Переключатель сайдбара
        $('.sidebar-toggler').on('click', function (e) {
            e.preventDefault();
            $('.sidebar, .content').toggleClass('open');
        });

        // 4. Анимация прогресс-баров (Waypoints)
        if (typeof Waypoint !== 'undefined') {
            $('.pg-bar').waypoint(function () {
                $('.progress .progress-bar').each(function () {
                    $(this).css('width', $(this).attr('aria-valuenow') + '%');
                });
            }, { offset: '80%' });
        } else {
            console.warn('⚠️ Waypoint не загружен. Анимация прогресс-баров отключена.');
        }

        // 5. Календарь (datetimepicker)
        if ($.fn.datetimepicker) {
            $('#calender').datetimepicker({
                inline: true,
                format: 'L'
            });
        } else {
            console.warn('⚠️ datetimepicker не загружен. Календарь недоступен.');
        }

        // 6. Карусель отзывов (Owl Carousel)
        if ($.fn.owlCarousel) {
            $(".testimonial-carousel").owlCarousel({
                autoplay: true,
                smartSpeed: 1000,
                items: 1,
                dots: true,
                loop: true,
                nav: false
            });
        } else {
            console.warn('⚠️ Owl Carousel не загружен. Карусель отключена.');
        }

        // 7. Инициализация всех графиков
        const chartsConfig = {
            'worldwide-sales': {
                type: 'bar',
                data: {
                    labels: ["2016", "2017", "2018", "2019", "2020", "2021", "2022"],
                    datasets: [
                        {
                            label: "USA",
                            data: [15, 30, 55, 65, 60, 80, 95],
                            backgroundColor: "rgba(0, 156, 255, .7)"
                        },
                        {
                            label: "UK",
                            data: [8, 35, 40, 60, 70, 55, 75],
                            backgroundColor: "rgba(0, 156, 255, .5)"
                        },
                        {
                            label: "AU",
                            data: [12, 25, 45, 55, 65, 70, 60],
                            backgroundColor: "rgba(0, 156, 255, .3)"
                        }
                    ]
                },
                options: { responsive: true }
            },
            'salse-revenue': {
                type: 'line',
                data: {
                    labels: ["2016", "2017", "2018", "2019", "2020", "2021", "2022"],
                    datasets: [
                        {
                            label: "Salse",
                            data: [15, 30, 55, 45, 70, 65, 85],
                            backgroundColor: "rgba(0, 156, 255, .5)",
                            fill: true
                        },
                        {
                            label: "Revenue",
                            data: [99, 135, 170, 130, 190, 180, 270],
                            backgroundColor: "rgba(0, 156, 255, .3)",
                            fill: true
                        }
                    ]
                },
                options: { responsive: true }
            },
            // Остальные конфигурации графиков (line-chart, bar-chart, pie-chart, doughnut-chart)
            // ... (аналогично, с теми же структурами)
        };

        // Создаем все графики
        Object.keys(chartsConfig).forEach(canvasId => {
            safeInitChart(canvasId, chartsConfig[canvasId]);
        });
    });

})(jQuery);
