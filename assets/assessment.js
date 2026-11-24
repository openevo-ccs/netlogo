/**
 * Question sets for the NetLogo models ("Check your thinking").
 *
 * Loads assessments/<slug>.json, shows one question at a time, and ends with
 * plain feedback on how the answers handled causes: did they look at several
 * causes together, lean on one cause, or land in between. The question sets
 * are AI drafts that no expert has reviewed yet, so the feedback is for
 * practice and discussion and carries no grade.
 */
(function () {
  'use strict';

  function esc(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  var WORDS = {
    integrated: 'Looked at several causes together',
    dichotomized: 'Leaned on a single cause',
    partial: 'Partly there'
  };

  class AssessmentEngine {
    constructor() {
      this.currentAssessment = null;
      this.currentItemIndex = 0;
      this.responses = {};
      this.host = null;
    }

    async loadAssessment(assessmentPath) {
      var response = await fetch(assessmentPath);
      if (!response.ok) {
        throw new Error('Could not load the question set (' + response.status + ')');
      }
      this.currentAssessment = await response.json();
      this.currentItemIndex = 0;
      this.responses = {};
      return this.currentAssessment;
    }

    getCurrentItem() {
      if (!this.currentAssessment || this.currentItemIndex >= this.currentAssessment.items.length) {
        return null;
      }
      return this.currentAssessment.items[this.currentItemIndex];
    }

    nextItem() {
      this.currentItemIndex = Math.min(this.currentItemIndex + 1, this.currentAssessment.items.length);
      return this.getCurrentItem();
    }

    previousItem() {
      this.currentItemIndex = Math.max(0, this.currentItemIndex - 1);
      return this.getCurrentItem();
    }

    recordResponse(itemId, optionId) {
      this.responses[itemId] = optionId;
    }

    getResponse(itemId) {
      return this.responses[itemId] || null;
    }

    restart() {
      this.currentItemIndex = 0;
      this.responses = {};
    }

    /** Counts how each answer handled the causes, and keeps the explanation for each. */
    summarize() {
      var counts = { integrated: 0, dichotomized: 0, partial: 0, unanswered: 0 };
      var items = this.currentAssessment.items.map(function (item) {
        var answer = this.responses[item.itemId];
        var option = answer ? item.options.find(function (o) { return o.id === answer; }) : null;
        var type = option ? option.reasoningType : 'unanswered';
        if (counts[type] === undefined) type = 'partial';
        counts[type] += 1;
        return { item: item, option: option, type: type };
      }, this);
      return { counts: counts, items: items };
    }

    feedbackLine(counts) {
      if (counts.integrated + counts.dichotomized + counts.partial === 0) {
        return 'No questions were answered yet.';
      }
      if (counts.integrated > counts.dichotomized * 2) {
        return 'Most of your answers looked at several causes working together. Try the model again and see whether you can explain why each cause matters.';
      }
      if (counts.integrated > counts.dichotomized) {
        return 'Many of your answers looked at several causes together. Check the questions below where one cause carried the whole answer.';
      }
      if (counts.dichotomized > counts.integrated) {
        return 'Several answers leaned on a single cause. In the model, change one setting at a time and then two together, and compare what happens.';
      }
      return 'Your answers were a mix of single-cause and several-cause thinking. The notes below show where each kind came in.';
    }

    render(container) {
      if (container) this.host = container;
      var host = this.host;
      if (!host) return;
      if (!this.currentAssessment) {
        host.innerHTML = '<p>No question set is loaded.</p>';
        return;
      }
      var item = this.getCurrentItem();
      if (!item) {
        this.renderResults(host);
        return;
      }

      var a = this.currentAssessment;
      var total = a.items.length;
      var progress = ((this.currentItemIndex + 1) / total) * 100;
      var answer = this.getResponse(item.itemId);
      var self = this;

      host.innerHTML =
        '<div class="assessment-container">' +
          '<h2>' + esc(a.title) + '</h2>' +
          '<p class="assessment-description">' + esc(a.description) + '</p>' +
          '<div class="assessment-progress"><div class="progress-bar"><div class="progress-fill" style="width:' + progress + '%"></div></div>' +
          '<span class="progress-text">Question ' + (this.currentItemIndex + 1) + ' of ' + total + '</span></div>' +
          (a.vignette && a.vignette.text ? '<div class="assessment-vignette"><h3>The situation</h3>' +
            a.vignette.text.split(/\n\n+/).map(function (para) { return '<p>' + esc(para) + '</p>'; }).join('') + '</div>' : '') +
          '<div class="assessment-item"><p class="question-text">' + esc(item.question) + '</p>' +
          '<div class="options-list">' +
          item.options.map(function (o) {
            return '<label class="option-label' + (answer === o.id ? ' selected' : '') + '">' +
              '<input type="radio" name="item-' + esc(item.itemId) + '" value="' + esc(o.id) + '"' + (answer === o.id ? ' checked' : '') + '>' +
              '<span class="option-text">' + esc(o.id) + '. ' + esc(o.text) + '</span></label>';
          }).join('') +
          '</div></div>' +
          '<div class="assessment-navigation">' +
            '<button type="button" class="btn btn-secondary" data-act="prev"' + (this.currentItemIndex === 0 ? ' disabled' : '') + '>Previous</button>' +
            '<button type="button" class="btn" data-act="next">' + (this.currentItemIndex === total - 1 ? 'See feedback' : 'Next') + '</button>' +
          '</div>' +
        '</div>';

      host.querySelectorAll('input[type=radio]').forEach(function (input) {
        input.addEventListener('change', function () {
          self.recordResponse(item.itemId, input.value);
          host.querySelectorAll('.option-label').forEach(function (l) {
            l.classList.toggle('selected', l.contains(input) && input.checked);
          });
        });
      });
      host.querySelector('[data-act=prev]').addEventListener('click', function () { self.previousItem(); self.render(); });
      host.querySelector('[data-act=next]').addEventListener('click', function () { self.nextItem(); self.render(); });
    }

    renderResults(host) {
      var s = this.summarize();
      var c = s.counts;
      var self = this;

      host.innerHTML =
        '<div class="assessment-results">' +
          '<h2>Your answers</h2>' +
          '<p>' + esc(this.feedbackLine(c)) + '</p>' +
          '<div class="stats-grid">' +
            '<div class="stat-item"><span class="stat-value">' + c.integrated + '</span><span class="stat-label">' + WORDS.integrated + '</span></div>' +
            '<div class="stat-item"><span class="stat-value">' + c.partial + '</span><span class="stat-label">' + WORDS.partial + '</span></div>' +
            '<div class="stat-item"><span class="stat-value">' + c.dichotomized + '</span><span class="stat-label">' + WORDS.dichotomized + '</span></div>' +
            (c.unanswered ? '<div class="stat-item"><span class="stat-value">' + c.unanswered + '</span><span class="stat-label">Skipped</span></div>' : '') +
          '</div>' +
          '<h3>Question by question</h3>' +
          s.items.map(function (r, i) {
            var note = r.option ? (r.option.explanation || r.option.misconception || '') : '';
            return '<div class="item-detail status-' + r.type + '">' +
              '<h4>Question ' + (i + 1) + '</h4>' +
              '<p class="item-question">' + esc(r.item.question) + '</p>' +
              '<p><strong>Your answer:</strong> ' + (r.option ? esc(r.option.id + '. ' + r.option.text) : 'Skipped') + '</p>' +
              (r.type !== 'unanswered' ? '<p><strong>How it handled the causes:</strong> ' + (WORDS[r.type] || '') + '</p>' : '') +
              (note ? '<p>' + esc(note) + '</p>' : '') +
              '</div>';
          }).join('') +
          '<div class="assessment-navigation">' +
            '<button type="button" class="btn" data-act="restart">Try again</button>' +
            '<button type="button" class="btn btn-secondary" data-act="print">Print</button>' +
          '</div>' +
        '</div>';

      host.querySelector('[data-act=restart]').addEventListener('click', function () { self.restart(); self.render(); });
      host.querySelector('[data-act=print]').addEventListener('click', function () { window.print(); });
    }
  }

  window.AssessmentEngine = new AssessmentEngine();
})();
