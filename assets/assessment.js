/**
 * Assessment Engine for NetLogo Models
 * 
 * Handles loading, displaying, and scoring integrated-causal-reasoning assessments
 * following the EvoFlex pattern.
 */

(function() {
  'use strict';

  class AssessmentEngine {
    constructor() {
      this.currentAssessment = null;
      this.currentItemIndex = 0;
      this.responses = {};
      this.assessments = {};
    }

    /**
     * Load an assessment from a JSON file
     * @param {string} assessmentPath - Path to the assessment JSON file
     */
    async loadAssessment(assessmentPath) {
      try {
        const response = await fetch(assessmentPath);
        if (!response.ok) {
          throw new Error(`Failed to load assessment: ${response.statusText}`);
        }
        this.currentAssessment = await response.json();
        this.currentItemIndex = 0;
        this.responses = {};
        return this.currentAssessment;
      } catch (error) {
        console.error('Error loading assessment:', error);
        throw error;
      }
    }

    /**
     * Get the current assessment item
     * @returns {Object|null} The current item or null if no assessment loaded
     */
    getCurrentItem() {
      if (!this.currentAssessment || this.currentItemIndex >= this.currentAssessment.items.length) {
        return null;
      }
      return this.currentAssessment.items[this.currentItemIndex];
    }

    /**
     * Move to the next item
     * @returns {Object|null} The next item or null if at the end
     */
    nextItem() {
      this.currentItemIndex++;
      return this.getCurrentItem();
    }

    /**
     * Move to the previous item
     * @returns {Object|null} The previous item or null if at the beginning
     */
    previousItem() {
      if (this.currentItemIndex > 0) {
        this.currentItemIndex--;
      }
      return this.getCurrentItem();
    }

    /**
     * Record a response for the current item
     * @param {string} itemId - The item ID
     * @param {string} optionId - The selected option ID
     */
    recordResponse(itemId, optionId) {
      this.responses[itemId] = optionId;
    }

    /**
     * Get the response for a specific item
     * @param {string} itemId - The item ID
     * @returns {string|null} The response option ID or null if not answered
     */
    getResponse(itemId) {
      return this.responses[itemId] || null;
    }

    /**
     * Check if all items have been answered
     * @returns {boolean} True if all items answered
     */
    isComplete() {
      if (!this.currentAssessment) return false;
      return this.currentAssessment.items.every(item => this.responses[item.itemId]);
    }

    /**
     * Score the assessment
     * @returns {Object} Scoring results
     */
    scoreAssessment() {
      if (!this.currentAssessment) {
        throw new Error('No assessment loaded');
      }

      const results = {
        totalItems: this.currentAssessment.items.length,
        answeredItems: Object.keys(this.responses).length,
        integratedCount: 0,
        dichotomizedCount: 0,
        partialCount: 0,
        unansweredCount: 0,
        itemResults: [],
        overallScore: 0,
        reasoningProfile: 'mixed'
      };

      this.currentAssessment.items.forEach(item => {
        const response = this.responses[item.itemId];
        const itemResult = {
          itemId: item.itemId,
          question: item.question,
          response: response,
          correctAnswer: item.correctAnswer,
          isCorrect: response === item.correctAnswer,
          reasoningType: null,
          misconception: null,
          explanation: null
        };

        if (!response) {
          results.unansweredCount++;
          itemResult.status = 'unanswered';
        } else {
          const selectedOption = item.options.find(opt => opt.id === response);
          if (selectedOption) {
            itemResult.reasoningType = selectedOption.reasoningType;
            itemResult.misconception = selectedOption.misconception || null;
            itemResult.explanation = selectedOption.explanation || null;

            if (selectedOption.reasoningType === 'integrated') {
              results.integratedCount++;
              itemResult.status = 'integrated';
            } else if (selectedOption.reasoningType === 'dichotomized') {
              results.dichotomizedCount++;
              itemResult.status = 'dichotomized';
            } else if (selectedOption.reasoningType === 'partial') {
              results.partialCount++;
              itemResult.status = 'partial';
            }
          }
        }

        results.itemResults.push(itemResult);
      });

      // Calculate overall score (percentage of integrated reasoning)
      const answeredCount = results.answeredItems;
      if (answeredCount > 0) {
        results.overallScore = (results.integratedCount / answeredCount) * 100;
      }

      // Determine reasoning profile
      if (results.integratedCount > results.dichotomizedCount * 2) {
        results.reasoningProfile = 'strongly-integrated';
      } else if (results.integratedCount > results.dichotomizedCount) {
        results.reasoningProfile = 'integrated';
      } else if (results.dichotomizedCount > results.integratedCount * 2) {
        results.reasoningProfile = 'strongly-dichotomized';
      } else if (results.dichotomizedCount > results.integratedCount) {
        results.reasoningProfile = 'dichotomized';
      } else {
        results.reasoningProfile = 'mixed';
      }

      return results;
    }

    /**
     * Get feedback based on scoring results
     * @param {Object} results - Scoring results from scoreAssessment()
   * @returns {Object} Feedback object
     */
    getFeedback(results) {
      const feedback = {
        overall: '',
        strengths: [],
        areasForImprovement: [],
        recommendations: []
      };

      // Overall feedback based on reasoning profile
      switch (results.reasoningProfile) {
        case 'strongly-integrated':
          feedback.overall = 'Excellent! You demonstrate strong integrated causal reasoning, recognizing multiple interacting mechanisms and context-dependence.';
          break;
        case 'integrated':
          feedback.overall = 'Good! You show integrated causal reasoning in most responses, with some areas for further development.';
          break;
        case 'mixed':
          feedback.overall = 'You show a mix of integrated and dichotomized reasoning. Focus on recognizing multiple causes and avoiding single-cause explanations.';
          break;
        case 'dichotomized':
          feedback.overall = 'Your responses tend toward dichotomized reasoning. Try to consider multiple interacting factors and avoid reducing complex phenomena to single causes.';
          break;
        case 'strongly-dichotomized':
          feedback.overall = 'Your reasoning is primarily dichotomized. Practice thinking about multiple interacting mechanisms and how context affects outcomes.';
          break;
      }

      // Identify strengths and areas for improvement
      results.itemResults.forEach(item => {
        if (item.status === 'integrated') {
          feedback.strengths.push({
            item: item.itemId,
            strength: `Good integrated reasoning on: "${item.question.substring(0, 50)}..."`
          });
        } else if (item.status === 'dichotomized' && item.misconception) {
          feedback.areasForImprovement.push({
            item: item.itemId,
            area: item.misconception,
            explanation: item.explanation
          });
        }
      });

      // Generate recommendations
      if (results.dichotomizedCount > results.integratedCount) {
        feedback.recommendations.push('Practice using causal mapping to identify multiple interacting factors.');
        feedback.recommendations.push('Use Tinbergen\'s questions to consider function, mechanism, development, and evolution.');
        feedback.recommendations.push('Look for context-dependence - how do different conditions affect outcomes?');
      }

      if (results.unansweredCount > 0) {
        feedback.recommendations.push('Complete all items for a full assessment of your reasoning.');
      }

      return feedback;
    }

    /**
     * Render the assessment to a DOM element
     * @param {HTMLElement} container - The container element
     */
    render(container) {
      if (!this.currentAssessment) {
        container.innerHTML = '<p>No assessment loaded.</p>';
        return;
      }

      const item = this.getCurrentItem();
      if (!item) {
        this.renderResults(container);
        return;
      }

      const progress = ((this.currentItemIndex + 1) / this.currentAssessment.items.length) * 100;

      container.innerHTML = `
        <div class="assessment-container">
          <div class="assessment-header">
            <h2>${this.currentAssessment.title}</h2>
            <p class="assessment-description">${this.currentAssessment.description}</p>
            <div class="assessment-progress">
              <div class="progress-bar">
                <div class="progress-fill" style="width: ${progress}%"></div>
              </div>
              <span class="progress-text">Question ${this.currentItemIndex + 1} of ${this.currentAssessment.items.length}</span>
            </div>
          </div>

          <div class="assessment-vignette">
            <h3>📖 Scenario</h3>
            <p>${this.currentAssessment.vignette.text}</p>
          </div>

          <div class="assessment-item">
            <h3>Question ${this.currentItemIndex + 1}</h3>
            <p class="question-text">${item.question}</p>
            <div class="options-list">
              ${item.options.map(option => `
                <label class="option-label ${this.getResponse(item.itemId) === option.id ? 'selected' : ''}">
                  <input type="radio" name="item-${item.itemId}" value="${option.id}" 
                         ${this.getResponse(item.itemId) === option.id ? 'checked' : ''}
                         onchange="window.AssessmentEngine.recordResponse('${item.itemId}', '${option.id}')">
                  <span class="option-text">${option.id}. ${option.text}</span>
                </label>
              `).join('')}
            </div>
          </div>

          <div class="assessment-navigation">
            <button class="btn btn-secondary" onclick="window.AssessmentEngine.previousItem(); window.AssessmentEngine.render(document.querySelector('.assessment-container').parentNode);" 
                    ${this.currentItemIndex === 0 ? 'disabled' : ''}>Previous</button>
            <button class="btn" onclick="window.AssessmentEngine.nextItem(); window.AssessmentEngine.render(document.querySelector('.assessment-container').parentNode);">Next</button>
          </div>
        </div>
      `;
    }

    /**
     * Render the assessment results
     * @param {HTMLElement} container - The container element
     */
    renderResults(container) {
      const results = this.scoreAssessment();
      const feedback = this.getFeedback(results);

      container.innerHTML = `
        <div class="assessment-results">
          <h2>Assessment Results</h2>
          
          <div class="results-summary">
            <div class="score-display">
              <div class="score-circle">
                <span class="score-number">${Math.round(results.overallScore)}%</span>
                <span class="score-label">Integrated Reasoning</span>
              </div>
              <div class="reasoning-profile">
                <strong>Reasoning Profile:</strong> 
                <span class="profile-${results.reasoningProfile}">${results.reasoningProfile.replace('-', ' ')}</span>
              </div>
            </div>

            <div class="stats-grid">
              <div class="stat-item">
                <span class="stat-value">${results.integratedCount}</span>
                <span class="stat-label">Integrated</span>
              </div>
              <div class="stat-item">
                <span class="stat-value">${results.dichotomizedCount}</span>
                <span class="stat-label">Dichotomized</span>
              </div>
              <div class="stat-item">
                <span class="stat-value">${results.partialCount}</span>
                <span class="stat-label">Partial</span>
              </div>
              <div class="stat-item">
                <span class="stat-value">${results.unansweredCount}</span>
                <span class="stat-label">Unanswered</span>
              </div>
            </div>
          </div>

          <div class="feedback-section">
            <h3>Overall Feedback</h3>
            <p>${feedback.overall}</p>

            ${feedback.strengths.length > 0 ? `
              <h4>Strengths</h4>
              <ul>
                ${feedback.strengths.map(s => `<li>${s.strength}</li>`).join('')}
              </ul>
            ` : ''}

            ${feedback.areasForImprovement.length > 0 ? `
              <h4>Areas for Improvement</h4>
              <ul>
                ${feedback.areasForImprovement.map(a => `<li><strong>${a.area}</strong>: ${a.explanation}</li>`).join('')}
              </ul>
            ` : ''}

            ${feedback.recommendations.length > 0 ? `
              <h4>Recommendations</h4>
              <ul>
                ${feedback.recommendations.map(r => `<li>${r}</li>`).join('')}
              </ul>
            ` : ''}
          </div>

          <div class="item-details">
            <h3>Item-by-Item Details</h3>
            ${results.itemResults.map(item => `
              <div class="item-detail ${item.status}">
                <h4>Item ${item.itemId}</h4>
                <p class="item-question">${item.question}</p>
                <p><strong>Your answer:</strong> ${item.response || 'Not answered'}</p>
                <p><strong>Status:</strong> <span class="status-${item.status}">${item.status}</span></p>
                ${item.explanation ? `<p><strong>Explanation:</strong> ${item.explanation}</p>` : ''}
                ${item.misconception ? `<p><strong>Common misconception:</strong> ${item.misconception}</p>` : ''}
              </div>
            `).join('')}
          </div>

          <div class="results-actions">
            <button class="btn" onclick="window.AssessmentEngine.restart(); window.AssessmentEngine.render(document.querySelector('.assessment-results').parentNode);">Restart Assessment</button>
            <button class="btn btn-secondary" onclick="window.print();">Print Results</button>
          </div>
        </div>
      `;
    }

    /**
     * Restart the assessment
     */
    restart() {
      this.currentItemIndex = 0;
      this.responses = {};
    }
  }

  // Create global instance
  window.AssessmentEngine = new AssessmentEngine();

  // Export for use in other scripts
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = AssessmentEngine;
  }

})();