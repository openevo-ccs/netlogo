/**
 * Enhanced App JavaScript for NetLogo Explorer
 *
 * Adds comparison mode, assessment integration, lab notebook,
 * and thinking tools to the base explorer.
 */

(function() {
  'use strict';

  var currentMode = 'explore';
  var currentModel = null;
  var labNotebookEntry = null;

  // Mode switching
  function setMode(mode) {
    currentMode = mode;
    
    // Update mode buttons
    document.querySelectorAll('.mode-btn').forEach(function(btn) {
      btn.classList.toggle('active', btn.dataset.mode === mode);
    });
    
    // Show/hide appropriate sections
    var modelFrameWrap = document.getElementById('model-frame-wrap');
    var comparisonMode = document.getElementById('comparison-mode');
    var assessmentMode = document.getElementById('assessment-mode');
    var graphMode = document.getElementById('graph-mode');
    var modelList = document.getElementById('model-list');

    if (modelFrameWrap) {
      modelFrameWrap.style.display = mode === 'explore' ? 'block' : 'none';
    }
    if (comparisonMode) {
      comparisonMode.style.display = mode === 'compare' ? 'block' : 'none';
    }
    if (assessmentMode) {
      assessmentMode.style.display = mode === 'assessment' ? 'block' : 'none';
    }
    if (graphMode) {
      graphMode.style.display = mode === 'graph' ? 'flex' : 'none';
      if (mode === 'graph' && window.GraphExplorer) {
        window.GraphExplorer.onShow();
      }
    }
    if (modelList) {
      modelList.style.display = mode === 'explore' ? 'block' : 'none';
    }

    // Hide details panel in non-explore modes
    if (mode !== 'explore') {
      var detailsContent = document.getElementById('details-content');
      if (detailsContent) {
        detailsContent.innerHTML = '';
      }
    }
  }

  // Comparison sequences
  var comparisonSequences = {
    cooperation: {
      title: 'Cooperation Progression',
      description: 'Explore how cooperation evolves from simple two-agent dilemmas to complex multi-group dynamics.',
      models: ['two-foresters', 'two-communities', 'evolution-ethnocentrism', 'evolution-resource-use-social-behavior', 'evolution-resource-use-behavior-imitation'],
      questions: [
        'How does the complexity of cooperation increase across these models?',
        'What mechanisms help sustain cooperation in each model?',
        'How do ethnic markers affect cooperation?',
        'When is punishment effective for maintaining cooperation?',
        'How does cultural transmission differ from genetic evolution?'
      ]
    },
    evolution: {
      title: 'Evolution Mechanisms',
      description: 'Compare different evolutionary mechanisms across models.',
      models: ['bug-evolution', 'island-world', 'evolution-ethnocentrism', 'evolution-competition-forest-resources'],
      questions: [
        'How does natural selection work differently in each model?',
        'What role does population structure play?',
        'How do trade-offs affect evolution?',
        'What creates variation in each model?'
      ]
    },
    resources: {
      title: 'Resource Management',
      description: 'Explore sustainable and unsustainable resource use across different contexts.',
      models: ['two-foresters', 'population-size-living-costs', 'evolution-competition-forest-resources', 'evolution-resource-use-harvest-efficiency'],
      questions: [
        'What makes resource use sustainable or unsustainable?',
        'How do population size and harvest rate interact?',
        'What role does evolution play in resource use?',
        'How can cooperation help manage shared resources?'
      ]
    }
  };

  function loadComparison() {
    var sequenceId = document.getElementById('comparison-sequence').value;
    var content = document.getElementById('comparison-content');
    
    if (!sequenceId || !content) {
      return;
    }
    
    var sequence = comparisonSequences[sequenceId];
    
    if (!sequence) {
      content.innerHTML = '<p>Sequence not found.</p>';
      return;
    }
    
    // Get models from the global state if available
    var models = window.NetLogoApp ? window.NetLogoApp.state.models : [];
    
    content.innerHTML = 
      '<div class="comparison-header">' +
        '<h3>' + sequence.title + '</h3>' +
        '<p>' + sequence.description + '</p>' +
      '</div>' +
      
      '<div class="comparison-steps">' +
        '<h4>Models in this sequence:</h4>' +
        '<ol>' +
          sequence.models.map(function(slug) {
            var model = models.find(function(m) { return m.slug === slug; });
            return model ? 
              '<li><a href="#" onclick="if(window.selectModel) window.selectModel(\'' + slug + '\'); setMode(\'explore\'); return false;">' + model.title + '</a></li>' : 
              '';
          }).join('') +
        '</ol>' +
      '</div>' +
      
      '<div class="comparison-questions">' +
        '<h4>Guiding Questions:</h4>' +
        sequence.questions.map(function(q) {
          return '<div class="comparison-question"><h4>?</h4><p>' + q + '</p></div>';
        }).join('') +
      '</div>' +
      
      '<div class="comparison-actions">' +
        '<button class="btn" onclick="startComparisonSequence(\'' + sequenceId + '\')">Start Sequence</button>' +
        '<a href="lpm-strands/cooperation-progression.md" target="_blank" class="btn btn-secondary">View Full Guide →</a>' +
      '</div>';
  }

  function startComparisonSequence(sequenceId) {
    var sequence = comparisonSequences[sequenceId];
    if (sequence && sequence.models.length > 0) {
      setMode('explore');
      if (window.selectModel) {
        window.selectModel(sequence.models[0]);
      }
      alert('Starting ' + sequence.title + '. Begin with ' + sequence.models[0] + ', then progress through the sequence.');
    }
  }

  // Assessment loading
  async function loadAssessment() {
    var assessmentPath = document.getElementById('assessment-select').value;
    var content = document.getElementById('assessment-content');
    
    if (!assessmentPath || !content) {
      return;
    }
    
    try {
      content.innerHTML = '<p>Loading assessment...</p>';
      if (window.AssessmentEngine) {
        await window.AssessmentEngine.loadAssessment(assessmentPath);
        window.AssessmentEngine.render(content);
      } else {
        content.innerHTML = '<p>Assessment engine not available.</p>';
      }
    } catch (error) {
      content.innerHTML = '<p>Error loading assessment: ' + error.message + '</p>';
    }
  }

  // Lab notebook functions
  function toggleLabNotebook() {
    var panel = document.getElementById('lab-notebook-panel');
    if (panel) {
      panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    }
  }

  function showNotebookTab(tabName) {
    // Hide all sections
    document.querySelectorAll('.notebook-section').forEach(function(section) {
      section.classList.remove('active');
    });
    
    // Remove active class from all tabs
    document.querySelectorAll('.notebook-tab').forEach(function(tab) {
      tab.classList.remove('active');
    });
    
    // Show selected section
    var section = document.getElementById('notebook-' + tabName);
    if (section) {
      section.classList.add('active');
    }
    
    // Add active class to clicked tab (if event is available)
    if (event && event.target) {
      event.target.classList.add('active');
    }
  }

  function addObservation() {
    var input = document.getElementById('observation-input');
    if (!input) return;
    
    var text = input.value.trim();
    
    if (!text) {
      alert('Please enter an observation.');
      return;
    }
    
    if (!labNotebookEntry) {
      if (currentModel) {
        if (window.LabNotebook) {
          labNotebookEntry = window.LabNotebook.startEntry(currentModel.slug, currentModel.title);
        }
      } else {
        alert('Please select a model first.');
        return;
      }
    }
    
    if (window.LabNotebook) {
      window.LabNotebook.addObservation(text, {
        model: currentModel ? currentModel.slug : null,
        timestamp: new Date().toISOString()
      });
    }
    
    input.value = '';
    displayObservations();
  }

  function displayObservations() {
    var list = document.getElementById('observations-list');
    if (!list) return;
    
    if (!labNotebookEntry) {
      list.innerHTML = '<p>No observations yet. Start exploring a model and record what you notice!</p>';
      return;
    }
    
    var observationsHtml = labNotebookEntry.observations.map(function(obs) {
      return '<div class="observation-item">' +
        '<div class="observation-time">' + new Date(obs.time).toLocaleTimeString() + '</div>' +
        '<p>' + obs.text + '</p>' +
        '</div>';
    }).join('');

    var screenshotsHtml = (labNotebookEntry.screenshots || []).map(function(shot) {
      return '<div class="observation-item">' +
        '<div class="observation-time">' + new Date(shot.time).toLocaleTimeString() + '</div>' +
        '<img src="' + shot.data + '" alt="Model screenshot" style="max-width:100%;border-radius:4px;">' +
        '</div>';
    }).join('');

    list.innerHTML = observationsHtml + screenshotsHtml ||
      '<p>No observations yet. Start exploring a model and record what you notice!</p>';
  }

  function captureModelScreenshot() {
    var iframe = document.getElementById('model-frame');
    if (!iframe) {
      alert('No model is currently loaded.');
      return;
    }

    var canvas;
    try {
      var frameDoc = iframe.contentDocument || iframe.contentWindow.document;
      canvas = frameDoc.querySelector('canvas');
    } catch (e) {
      alert('Could not access the model view to capture it. Make sure a model is loaded and running.');
      return;
    }

    if (!canvas) {
      alert('No model view found to capture yet. Make sure a model is loaded and running.');
      return;
    }

    var dataUrl;
    try {
      dataUrl = canvas.toDataURL('image/png');
    } catch (e) {
      alert('Could not capture the model view: ' + e.message);
      return;
    }

    if (!labNotebookEntry) {
      if (currentModel && window.LabNotebook) {
        labNotebookEntry = window.LabNotebook.startEntry(currentModel.slug, currentModel.title);
      } else {
        alert('Please select a model first.');
        return;
      }
    }

    if (window.LabNotebook) {
      window.LabNotebook.addScreenshot(dataUrl, currentModel ? currentModel.title : '');
    }

    displayObservations();
  }

  function saveReflections() {
    if (!labNotebookEntry) {
      if (currentModel) {
        if (window.LabNotebook) {
          labNotebookEntry = window.LabNotebook.startEntry(currentModel.slug, currentModel.title);
        }
      } else {
        alert('Please select a model first.');
        return;
      }
    }
    
    if (window.LabNotebook) {
      var patterns = document.getElementById('reflection-patterns');
      var surprises = document.getElementById('reflection-surprises');
      var questions = document.getElementById('reflection-questions');
      var connections = document.getElementById('reflection-connections');
      
      if (patterns) window.LabNotebook.addReflection('patterns', patterns.value);
      if (surprises) window.LabNotebook.addReflection('surprises', surprises.value);
      if (questions) window.LabNotebook.addReflection('questions', questions.value);
      if (connections) window.LabNotebook.addReflection('connections', connections.value);
    }
    
    alert('Reflections saved!');
  }

  function clearNotebook() {
    if (confirm('Are you sure you want to clear all notebook entries?')) {
      if (window.LabNotebook) {
        window.LabNotebook.clearAll();
      }
      labNotebookEntry = null;
      
      var observationInput = document.getElementById('observation-input');
      var patterns = document.getElementById('reflection-patterns');
      var surprises = document.getElementById('reflection-surprises');
      var questions = document.getElementById('reflection-questions');
      var connections = document.getElementById('reflection-connections');
      
      if (observationInput) observationInput.value = '';
      if (patterns) patterns.value = '';
      if (surprises) surprises.value = '';
      if (questions) questions.value = '';
      if (connections) connections.value = '';
      
      displayObservations();
    }
  }

  function exportNotebook() {
    if (!window.LabNotebook) return;
    
    var data = window.LabNotebook.exportAll();
    var blob = new Blob([data], { type: 'application/json' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = 'lab-notebook-' + new Date().toISOString().split('T')[0] + '.json';
    a.click();
    URL.revokeObjectURL(url);
  }

  function openThinkingTool(toolName) {
    var toolUrls = {
      'tinbergen': 'thinking-tools/tinbergen-questions.html',
      'causal-mapping': 'thinking-tools/causal-mapping.html',
      'payoff-matrix': 'thinking-tools/payoff-matrix.html'
    };
    
    var url = toolUrls[toolName];
    if (url) {
      window.open(url, '_blank', 'width=900,height=700');
    } else {
      alert('Thinking tool not yet available: ' + toolName);
    }
  }

  // Enhance the existing selectModel function
  function enhanceSelectModel() {
    // Wait for app.js to load and make selectModel available
    var checkInterval = setInterval(function() {
      if (window.selectModel) {
        clearInterval(checkInterval);
        
        var originalSelectModel = window.selectModel;
        window.selectModel = function(slug) {
          originalSelectModel(slug);
          
          // Update current model
          if (window.NetLogoApp && window.NetLogoApp.state) {
            currentModel = window.NetLogoApp.state.models.find(function(m) { 
              return m.slug === slug; 
            });
          }
          
          // Show lab notebook button in details
          var details = document.getElementById('details-content');
          var notebookBtn = document.getElementById('notebook-toggle-btn');
          
          if (details && !notebookBtn) {
            var btn = document.createElement('button');
            btn.id = 'notebook-toggle-btn';
            btn.className = 'btn';
            btn.textContent = '📓 Open Lab Notebook';
            btn.onclick = toggleLabNotebook;
            btn.style.marginTop = '15px';
            details.appendChild(btn);
          }
          
          // Start new notebook entry if needed
          if (currentModel && !labNotebookEntry && window.LabNotebook) {
            labNotebookEntry = window.LabNotebook.startEntry(currentModel.slug, currentModel.title);
          }
        };
      }
    }, 100);
    
    // Stop checking after 10 seconds
    setTimeout(function() {
      clearInterval(checkInterval);
    }, 10000);
  }

  // Make functions globally available
  window.setMode = setMode;
  window.loadComparison = loadComparison;
  window.startComparisonSequence = startComparisonSequence;
  window.loadAssessment = loadAssessment;
  window.toggleLabNotebook = toggleLabNotebook;
  window.showNotebookTab = showNotebookTab;
  window.addObservation = addObservation;
  window.captureModelScreenshot = captureModelScreenshot;
  window.saveReflections = saveReflections;
  window.clearNotebook = clearNotebook;
  window.exportNotebook = exportNotebook;
  window.openThinkingTool = openThinkingTool;

  // Initialize
  console.log('Enhanced NetLogo Explorer loaded');
  console.log('Features: Comparison mode, Assessment integration, Lab notebook, Thinking tools');
  
  // Enhance selectModel when app.js is ready
  enhanceSelectModel();

})();