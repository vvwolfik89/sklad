document.addEventListener('turbo:load', function() {
    function setupModal() {
        const modal = document.getElementById('versionModal');
        const versionsList = document.getElementById('versions-list');

        if (!modal || !versionsList) {
            console.warn('Элементы не найдены, повторная попытка через 100 мс');
            // setTimeout(setupModal, 100);
            return;
        }

        const bsModal = new bootstrap.Modal(modal);

        modal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const url = button?.getAttribute('data-version-modal-url');

            if (!url) {
                console.error('URL не найден');
                return;
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    let html = '<ul class="list-group">';
                    data.forEach(version => {
                        html += `
                            <li class="list-group-item">
                                <strong>${version.event}</strong>
                                <span class="text-muted">(${version.changed_at})</span><br>
                                <small>Кем: ${version.changed_by}</small><br>
                                <pre style="background-color: #f8f9fa; padding: 5px; border-radius: 4px;">
                                    ${JSON.stringify(version.changes, null, 2)}
                                </pre>
                            </li>
                        `;
                    });
                    html += '</ul>';
                    versionsList.innerHTML = html;
                })
                .catch(error => {
                    versionsList.innerHTML = '<div class="alert alert-danger">Ошибка загрузки данных</div>';
                });
        });

        modal.addEventListener('hidden.bs.modal', function() {
            versionsList.innerHTML = '';
        });
    }

    setupModal();
});
