/**
 * TextZoomLimiter Plugin
 * Disponible en: window.TextZoomLimiter
 */

var exec = require('cordova/exec');

var TextZoomLimiter = {
    
    /**
     * Obtener el zoom de texto actual del sistema
     * @returns {Promise<{textZoom: number, percentage: string, platform: string}>}
     * 
     * Ejemplo:
     * const zoom = await window.TextZoomLimiter.getTextZoom();
     * console.log(zoom.percentage); // "120%"
     */
    getTextZoom: function() {
        return new Promise((resolve, reject) => {
            exec(
                function(result) {
                    console.log('✅ Text Zoom obtenido:', result.percentage);
                    resolve(result);
                },
                function(error) {
                    console.error('❌ Error al obtener zoom:', error);
                    reject(error);
                },
                'TextZoomPlugin',
                'getTextZoom',
                []
            );
        });
    },

    /**
     * Limitar el zoom de texto a un máximo
     * @param {number} maxZoom - Máximo zoom permitido (ej: 120 para 120%)
     * @returns {Promise<{appliedZoom: number, previousZoom: number, maxZoom: number, platform: string}>}
     * 
     * Ejemplo:
     * const result = await window.TextZoomLimiter.setTextZoomMax(120);
     * console.log(result.appliedZoom); // 120
     */
    setTextZoomMax: function(maxZoom) {
        return new Promise((resolve, reject) => {
            exec(
                function(result) {
                    console.log('✅ Zoom limitado correctamente:', result);
                    resolve(result);
                },
                function(error) {
                    console.error('❌ Error al limitar zoom:', error);
                    reject(error);
                },
                'TextZoomPlugin',
                'setTextZoomMax',
                [maxZoom]
            );
        });
    },

    /**
     * Establecer el zoom de texto a un valor específico
     * @param {number} zoom - Zoom a establecer (50-200)
     * @returns {Promise<{textZoom: number, message: string, platform: string}>}
     * 
     * Ejemplo:
     * const result = await window.TextZoomLimiter.setTextZoom(100);
     * console.log(result.message); // "Zoom establecido a: 100%"
     */
    setTextZoom: function(zoom) {
        return new Promise((resolve, reject) => {
            exec(
                function(result) {
                    console.log('✅ Zoom establecido:', result.message);
                    resolve(result);
                },
                function(error) {
                    console.error('❌ Error al establecer zoom:', error);
                    reject(error);
                },
                'TextZoomPlugin',
                'setTextZoom',
                [zoom]
            );
        });
    },

    /**
     * Obtener información del dispositivo
     * @returns {Promise<{platform: string, version: string}>}
     */
    getPlatformInfo: function() {
        return new Promise((resolve, reject) => {
            exec(
                function(result) {
                    console.log('📱 Información:', result);
                    resolve(result);
                },
                function(error) {
                    console.error('❌ Error:', error);
                    reject(error);
                },
                'TextZoomPlugin',
                'getPlatformInfo',
                []
            );
        });
    }
};

module.exports = TextZoomLimiter;
