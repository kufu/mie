// Entry point for the build script in your package.json

import './controllers';
import '@hotwired/turbo-rails';

if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        const serviceWorkerPath = document.querySelector('meta[name="pwa-service-worker-path"]')?.content || '/service-worker.js'

        navigator.serviceWorker.register(serviceWorkerPath, { updateViaCache: 'none' })
            .then(registration => {
                console.log('Service Worker registered:', registration);
                registration.update();
            })
            .catch(error => {
                console.log('Service Worker registration failed:', error);
            });
    });
}
