/**
 * Digital Lab Notebook for NetLogo Models
 * 
 * Provides structured observation, data logging, and reflection capabilities
 * for students exploring NetLogo models.
 */

(function() {
  'use strict';

  class LabNotebook {
    constructor() {
      this.entries = [];
      this.activeEntry = null;
      this.storageKey = 'netlogo-lab-notebook';
      this.loadFromStorage();
    }

    /**
     * Start a new lab notebook entry for a model
     * @param {string} modelSlug - The model identifier
     * @param {string} modelTitle - The model title
     */
    startEntry(modelSlug, modelTitle) {
      this.activeEntry = {
        id: Date.now(),
        timestamp: new Date().toISOString(),
        model: {
          slug: modelSlug,
          title: modelTitle
        },
        observations: [],
        screenshots: [],
        reflections: {
          patterns: '',
          surprises: '',
          questions: '',
          connections: ''
        },
        thinkingTools: {},
        dataPoints: []
      };
      return this.activeEntry;
    }

    /**
     * Add an observation to the active entry
     * @param {string} text - The observation text
     * @param {Object} metadata - Optional metadata (tick count, parameter values, etc.)
     */
    addObservation(text, metadata = {}) {
      if (!this.activeEntry) {
        console.warn('No active entry. Call startEntry() first.');
        return null;
      }

      const observation = {
        id: Date.now(),
        time: Date.now(),
        text: text,
        metadata: metadata
      };

      this.activeEntry.observations.push(observation);
      this.saveToStorage();
      return observation;
    }

    /**
     * Add a screenshot to the active entry
     * @param {string} imageData - Base64 encoded image data
     * @param {string} caption - Optional caption for the screenshot
     */
    addScreenshot(imageData, caption = '') {
      if (!this.activeEntry) {
        console.warn('No active entry. Call startEntry() first.');
        return null;
      }

      const screenshot = {
        id: Date.now(),
        time: Date.now(),
        data: imageData,
        caption: caption
      };

      this.activeEntry.screenshots.push(screenshot);
      this.saveToStorage();
      return screenshot;
    }

    /**
     * Add a reflection to the active entry
     * @param {string} type - Type of reflection (patterns, surprises, questions, connections)
     * @param {string} text - The reflection text
     */
    addReflection(type, text) {
      if (!this.activeEntry) {
        console.warn('No active entry. Call startEntry() first.');
        return null;
      }

      this.activeEntry.reflections[type] = text;
      this.saveToStorage();
      return this.activeEntry.reflections;
    }

    /**
     * Add a thinking tool response to the active entry
     * @param {string} toolName - Name of the thinking tool
     * @param {Object} response - The thinking tool response
     */
    addThinkingTool(toolName, response) {
      if (!this.activeEntry) {
        console.warn('No active entry. Call startEntry() first.');
        return null;
      }

      this.activeEntry.thinkingTools[toolName] = {
        timestamp: new Date().toISOString(),
        response: response
      };
      this.saveToStorage();
      return this.activeEntry.thinkingTools[toolName];
    }

    /**
     * Add a data point to the active entry
     * @param {Object} data - The data point (e.g., {tick: 100, population: 50})
     */
    addDataPoint(data) {
      if (!this.activeEntry) {
        console.warn('No active entry. Call startEntry() first.');
        return null;
      }

      this.activeEntry.dataPoints.push({
        time: Date.now(),
        data: data
      });
      this.saveToStorage();
      return this.activeEntry.dataPoints;
    }

    /**
     * Save the active entry and add it to the entries list
     */
    saveEntry() {
      if (!this.activeEntry) {
        console.warn('No active entry to save.');
        return null;
      }

      this.activeEntry.savedAt = new Date().toISOString();
      this.entries.push(this.activeEntry);
      this.activeEntry = null;
      this.saveToStorage();
      return this.entries[this.entries.length - 1];
    }

    /**
     * Get all entries for a specific model
     * @param {string} modelSlug - The model identifier
     * @returns {Array} Array of entries for the model
     */
    getEntriesByModel(modelSlug) {
      return this.entries.filter(entry => entry.model.slug === modelSlug);
    }

    /**
     * Get a specific entry by ID
     * @param {number} entryId - The entry ID
     * @returns {Object|null} The entry or null if not found
     */
    getEntry(entryId) {
      return this.entries.find(entry => entry.id === entryId) || null;
    }

    /**
     * Delete an entry
     * @param {number} entryId - The entry ID
     */
    deleteEntry(entryId) {
      this.entries = this.entries.filter(entry => entry.id !== entryId);
      this.saveToStorage();
    }

    /**
     * Export an entry as JSON
     * @param {number} entryId - The entry ID
     * @returns {string} JSON string of the entry
     */
    exportEntry(entryId) {
      const entry = this.getEntry(entryId);
      if (!entry) {
        return null;
      }
      return JSON.stringify(entry, null, 2);
    }

    /**
     * Export all entries as JSON
     * @returns {string} JSON string of all entries
     */
    exportAll() {
      return JSON.stringify(this.entries, null, 2);
    }

    /**
     * Save entries to localStorage
     */
    saveToStorage() {
      try {
        localStorage.setItem(this.storageKey, JSON.stringify(this.entries));
      } catch (e) {
        console.error('Failed to save to localStorage:', e);
      }
    }

    /**
     * Load entries from localStorage
     */
    loadFromStorage() {
      try {
        const stored = localStorage.getItem(this.storageKey);
        if (stored) {
          this.entries = JSON.parse(stored);
        }
      } catch (e) {
        console.error('Failed to load from localStorage:', e);
        this.entries = [];
      }
    }

    /**
     * Clear all entries
     */
    clearAll() {
      this.entries = [];
      this.activeEntry = null;
      this.saveToStorage();
    }

    /**
     * Get statistics about entries
     * @returns {Object} Statistics object
     */
    getStats() {
      const modelCounts = {};
      this.entries.forEach(entry => {
        const slug = entry.model.slug;
        modelCounts[slug] = (modelCounts[slug] || 0) + 1;
      });

      return {
        totalEntries: this.entries.length,
        modelsExplored: Object.keys(modelCounts).length,
        modelCounts: modelCounts,
        totalObservations: this.entries.reduce((sum, entry) => sum + entry.observations.length, 0),
        totalScreenshots: this.entries.reduce((sum, entry) => sum + entry.screenshots.length, 0)
      };
    }
  }

  // Create global instance
  window.LabNotebook = new LabNotebook();

  // Export for use in other scripts
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = LabNotebook;
  }

})();