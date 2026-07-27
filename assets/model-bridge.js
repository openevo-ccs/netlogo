/**
 * Model Bridge - Communication layer for NetLogo models
 * 
 * Enables bidirectional communication between the parent app
 * and embedded NetLogo models via postMessage API.
 */

(function() {
  'use strict';

  class ModelBridge {
    constructor(iframe) {
      this.iframe = iframe;
      this.messageQueue = [];
      this.responseHandlers = {};
      this.messageId = 0;
      this.isReady = false;
      this.setupMessageListener();
    }

    setupMessageListener() {
      window.addEventListener('message', (event) => {
        // Verify message origin (in production, use specific origin)
        if (event.source !== this.iframe.contentWindow) return;
        
        const { type, id, data } = event.data;
        
        if (type === 'model-ready') {
          this.isReady = true;
          console.log('Model is ready for communication');
          this.processMessageQueue();
        } else if (type === 'model-response' && this.responseHandlers[id]) {
          this.responseHandlers[id](data);
          delete this.responseHandlers[id];
        }
      });
    }

    processMessageQueue() {
      while (this.messageQueue.length > 0) {
        const message = this.messageQueue.shift();
        this.sendMessage(message.command, message.data, message.resolve, message.reject);
      }
    }

    sendMessage(type, data = {}) {
      return new Promise((resolve, reject) => {
        const id = ++this.messageId;
        
        this.responseHandlers[id] = (response) => {
          if (response.error) {
            reject(new Error(response.error));
          } else {
            resolve(response);
          }
        };
        
        const message = {
          type: 'model-command',
          id: id,
          command: type,
          data: data
        };
        
        if (this.isReady) {
          this.iframe.contentWindow.postMessage(message, '*');
        } else {
          // Queue message until model is ready
          this.messageQueue.push({ command: type, data, resolve, reject });
        }
      });
    }

    /**
     * Get the current state of the model
     * @returns {Promise<Object>} Model state including tick count, agent counts, etc.
     */
    async getState() {
      return this.sendMessage('get-state');
    }

    /**
     * Set a model parameter
     * @param {string} name - Parameter name
     * @param {*} value - Parameter value
     * @returns {Promise<Object>} Confirmation
     */
    async setParameter(name, value) {
      return this.sendMessage('set-parameter', { name, value });
    }

    /**
     * Start the model simulation
     * @returns {Promise<Object>} Confirmation
     */
    async start() {
      return this.sendMessage('start');
    }

    /**
     * Stop the model simulation
     * @returns {Promise<Object>} Confirmation
     */
    async stop() {
      return this.sendMessage('stop');
    }

    /**
     * Reset the model to initial state
     * @returns {Promise<Object>} Confirmation
     */
    async reset() {
      return this.sendMessage('reset');
    }

    /**
     * Capture a screenshot of the current model state
     * @returns {Promise<Object>} Screenshot data (base64)
     */
    async captureScreenshot() {
      return this.sendMessage('capture-screenshot');
    }

    /**
     * Export model data
     * @param {Object} options - Export options
     * @returns {Promise<Object>} Exported data
     */
    async exportData(options = {}) {
      return this.sendMessage('export-data', options);
    }

    /**
     * Run a BehaviorSpace experiment
     * @param {string} experimentName - Name of experiment
     * @param {Object} options - Experiment options
     * @returns {Promise<Object>} Experiment results
     */
    async runExperiment(experimentName, options = {}) {
      return this.sendMessage('run-experiment', { experimentName, options });
    }

    /**
     * Get list of available experiments
     * @returns {Promise<Array>} List of experiment names
     */
    async getExperiments() {
      return this.sendMessage('get-experiments');
    }

    /**
     * Check if model supports a feature
     * @param {string} feature - Feature name
     * @returns {Promise<boolean>} Whether feature is supported
     */
    async supportsFeature(feature) {
      try {
        const response = await this.sendMessage('supports-feature', { feature });
        return response.supported || false;
      } catch (error) {
        return false;
      }
    }
  }

  // Export for use in other scripts
  window.ModelBridge = ModelBridge;

  // Export for use in other scripts
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = ModelBridge;
  }

})();