"# UI Mockups and Design System\n\n## Design System Overview\n\n### Color Palette\n\n#### Primary Colors\n```css\n--primary: #4F46E5;        /* Indigo 600 */\n--primary-hover: #4338CA;  /* Indigo 700 */\n--primary-light: #EEF2FF;  /* Indigo 50 */\n\n--secondary: #10B981;      /* Emerald 500 */\n--secondary-hover: #059669; /* Emerald 600 */\n--secondary-light: #D1FAE5; /* Emerald 100 */\n\n--accent: #F59E0B;         /* Amber 500 */\n--accent-hover: #D97706;   /* Amber 600 */\n```\n\n#### Neutral Colors\n```css\n--bg-primary: #FFFFFF;\n--bg-secondary: #F9FAFB;\n--bg-tertiary: #F3F4F6;\n\n--text-primary: #111827;\n--text-secondary: #6B7280;\n--text-tertiary: #9CA3AF;\n\n--border-light: #E5E7EB;\n--border-medium: #D1D5DB;\n--border-dark: #9CA3AF;\n```\n\n#### Semantic Colors\n```css\n--success: #10B981;\n--warning: #F59E0B;\n--error: #EF4444;\n--info: #3B82F6;\n```\n\n### Typography\n\n#### Font Families\n```css\n--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;\n--font-mono: 'JetBrains Mono', 'Fira Code', monospace;\n```\n\n#### Type Scale\n```css\n--text-xs: 0.75rem;   /* 12px */\n--text-sm: 0.875rem;  /* 14px */\n--text-base: 1rem;    /* 16px */\n--text-lg: 1.125rem;  /* 18px */\n--text-xl: 1.25rem;   /* 20px */\n--text-2xl: 1.5rem;   /* 24px */\n--text-3xl: 1.875rem; /* 30px */\n--text-4xl: 2.25rem;  /* 36px */\n```\n\n#### Font Weights\n```css\n--font-normal: 400;\n--font-medium: 500;\n--font-semibold: 600;\n--font-bold: 700;\n```\n\n### Spacing Scale\n```css\n--space-1: 0.25rem;  /* 4px */\n--space-2: 0.5rem;   /* 8px */\n--space-3: 0.75rem;  /* 12px */\n--space-4: 1rem;     /* 16px */\n--space-5: 1.25rem;  /* 20px */\n--space-6: 1.5rem;   /* 24px */\n--space-8: 2rem;     /* 32px */\n--space-10: 2.5rem;  /* 40px */\n--space-12: 3rem;    /* 48px */\n--space-16: 4rem;    /* 64px */\n```\n\n### Border Radius\n```css\n--radius-sm: 0.25rem;  /* 4px */\n--radius-md: 0.5rem;   /* 8px */\n--radius-lg: 0.75rem;  /* 12px */\n--radius-xl: 1rem;     /* 16px */\n--radius-full: 9999px;\n```\n\n### Shadows\n```css\n--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);\n--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);\n--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);\n--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);\n```\n\n## Component Library\n\n### Buttons\n\n#### Primary Button\n```\n┌─────────────────────┐\n│  🚀 Explore Models  │\n└─────────────────────┘\n```\n- Background: Primary color\n- Text: White\n- Hover: Primary hover\n- Active: Scale 0.98\n\n#### Secondary Button\n```\n┌─────────────────────┐\n│  📓 Open Notebook   │\n└─────────────────────┘\n```\n- Background: Secondary color\n- Text: White\n- Hover: Secondary hover\n\n#### Outline Button\n```\n┌─────────────────────┐\n│  ⚙️ Settings        │\n└─────────────────────┘\n```\n- Background: Transparent\n- Border: Border medium\n- Text: Text primary\n- Hover: Background secondary\n\n### Cards\n\n#### Model Card\n```\n┌─────────────────────────────────────┐\n│  [Thumbnail: 200x120]               │\n│                                     │\n│  Two Foresters                      │\n│  Cooperation, Social Dilemma        │\n│                                     │\n│  Grades: 3-5, 6-8, 9-12            │\n│                                     │\n│  [Explore] [Add to Favorites]       │\n└─────────────────────────────────────┘\n```\n\n#### Feature Card\n```\n┌─────────────────────────────────────┐\n│  📊 Assessment Results              │\n│                                     │\n│  Your integrated reasoning score:  │\n│  80%                                │\n│                                     │\n│  [View Details] [Retake]            │\n└─────────────────────────────────────┘\n```\n\n### Navigation\n\n#### Breadcrumb\n```\nHome > Models > Evolution > Evolution of Ethnocentrism\n```\n\n#### Mode Tabs\n```\n┌──────────┬──────────┬──────────┐\n│ Explore  │ Compare  │ Assess   │\n└──────────┴──────────┴──────────┘\n     ↑ Active\n```\n\n### Inputs\n\n#### Search Input\n```\n┌─────────────────────────────────────┐\n│ 🔍 Search models...                 │\n└─────────────────────────────────────┘\n```\n\n#### Filter Dropdown\n```\n┌─────────────────────────────────────┐\n│ All Concepts ▼                      │\n└─────────────────────────────────────┘\n```\n\n### Badges\n\n#### Concept Badge\n```\n┌──────────────┐\n│ Cooperation  │\n└──────────────┘\n```\n- Background: Primary light\n- Text: Primary\n- Rounded: Full\n\n#### Grade Badge\n```\n┌──────────┐\n│ 9-12     │\n└──────────┘\n```\n- Background: Secondary light\n- Text: Secondary\n- Rounded: Full\n\n## Page Layouts\n\n### Main Explorer Page\n\n```\n┌─────────────────────────────────────────────────────────────┐\n│  OpenEvo NetLogo Models                    [🌙] [👤] [⚙️]  │\n│  Agent-based models of evolution, cooperation & sustainability│\n├──────────┬──────────────────────────────────┬───────────────┤\n│          │                                  │               │\n│  Filters │                                  │  Model Details │\n│          │                                  │               │\n│  🔍      │  ┌────────────────────────────┐  │  Two Foresters │\n│  Search  │  │                            │  │               │\n│          │  │                            │  │  An interactive│\n│  Concept │  │   [NetLogo Model Canvas]   │  │  introduction │\n│  ▼       │  │                            │  │  into concepts │\n│          │  │                            │  │  of ecology... │\n│  Grade   │  │                            │  │               │\n│  ▼       │  │                            │  │  ┌───────────┐ │\n│          │  │                            │  │  │ 🚀 Explore │ │\n│  ─────── │  │                            │  │  └───────────┘ │\n│          │  │                            │  │               │\n│  Models  │  │                            │  │  ┌───────────┐ │\n│          │  │                            │  │  │ 📓 Notebook│ │\n│  📁 All  │  │                            │  │  └───────────┘ │\n│  📁 Recent│  │                            │  │               │\n│  📁 Favorites│                            │  │  Concepts:     │\n│          │  │                            │  │  • Cooperation │\n│  ─────── │  │                            │  │  • Social     │\n│          │  │                            │  │    Dilemma    │\n│  📄 Two  │  │                            │  │               │\n│    Foresters│                            │  │  Grades:       │\n│  📄 Two  │  │                            │  │  3-5, 6-8, 9-12│\n│    Communities│                          │  │               │\n│  📄 Bug   │  │                            │  │  LPM Strand:   │\n│    Evolution│                            │  │  [View →]      │\n│  📄 ...   │  │                            │  │               │\n│          │  └────────────────────────────┘  │               │\n│          │                                  │               │\n└──────────┴──────────────────────────────────┴───────────────┘\n```\n\n### Assessment Mode\n\n```\n┌─────────────────────────────────────────────────────────────┐\n│  Assessment: Evolution of Ethnocentrism    [← Back]        │\n├─────────────────────────────────────────────────────────────┤\n│                                                             │\│  Progress: ████████░░░░░░░░ 4/5                             │\n│                                                             │\│  ┌─────────────────────────────────────────────────────┐   │\│  │ 📖 Scenario: The Two Communities of River Valley    │   │\│  │                                                     │   │
│  │ River Valley is a small town with two long-...      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Question 4 of 5                                            │
│                                                             │
│  If River Valley's community projects create situations... │
│                                                             │
│  ○ A. Red residents will quickly abandon their...          │
│  ○ B. Both strategies will remain equally common...        │
│  ● C. The proportion of residents who cooperate...         │
│  ○ D. The Red strategy will disappear completely...        │
│                                                             │
│  [← Previous]  [Next →]                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘\n```\n\n### Lab Notebook\n\n```\n┌─────────────────────────────────────────────────────────────┐\n│  📓 Lab Notebook - Two Foresters              [× Close]    │
├─────────────────────────────────────────────────────────────┤\n│                                                             │
│  [Observations] [Reflections] [Data] [Screenshots]          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Add a new observation...                            │   │
│  │                                                     │   │
│  │                                                     │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│  [Add Observation] [📷 Capture Screenshot]                │
│                                                             │
│  Recent Observations:                                       │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📅 Jan 9, 2025 2:34 PM                              │   │
│  │                                                     │   │
│  │ When both foresters harvest at 50%, the forest...   │   │
│  │                                                     │   │
│  │ [📊 Plot Data] [✏️ Edit] [🗑️ Delete]                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📅 Jan 9, 2025 2:30 PM                              │   │
│  │                                                     │   │
│  │ The greedy forester's trees run out faster...       │   │
│  │                                                     │   │
│  │ [📊 Plot Data] [✏️ Edit] [🗑️ Delete]                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  [Export PDF] [Export JSON] [Share Link]                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘\n```\n\n### Comparison Mode\n\n```\n┌─────────────────────────────────────────────────────────────┐\n│  ⚖️ Compare Models: Cooperation Progression  [← Back]     │
├─────────────────────────────────────────────────────────────┤\n│                                                             │
│  Sequence: Two Foresters → Two Communities → ...           │
│                                                             │
│  Step 1 of 5: Two Foresters                                 │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📋 Guiding Question:                                │   │
│  │                                                     │   │
│  │ How does the tension between individual and         │   │
│  │ collective interests play out in this simple model? │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │   [Two Foresters Model]                             │   │
│  │                                                     │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📝 Notes:                                           │   │
│  │                                                     │   │
│  │ [Your notes about this model...]                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  [← Previous Model]  [Next Model →]  [Finish Sequence]     │
│                                                             │
└─────────────────────────────────────────────────────────────┘\n```\n\n## Responsive Breakpoints\n\n### Mobile (< 640px)\n- Single column layout\n- Hamburger menu\n- Bottom navigation for modes\n- Simplified model cards\n\n### Tablet (640px - 1024px)\n- Two column layout\n- Collapsible sidebar\n- Tab-based navigation\n\n### Desktop (> 1024px)\n- Three column layout\n- Full sidebar\n- All features visible\n\n## Animation Guidelines\n\n### Micro-interactions\n- Button hover: 0.2s ease\n- Card hover: 0.3s ease\n- Modal open: 0.3s ease\n- Page transition: 0.4s ease\n\n### Loading States\n- Skeleton screens for content\n- Spinner for async operations\n- Progress bars for long operations\n\n### Feedback\n- Success: Green checkmark animation\n- Error: Red shake animation\n- Warning: Yellow pulse animation\n\n## Accessibility Guidelines\n\n### Color Contrast\n- Normal text: 4.5:1 minimum\n- Large text: 3:1 minimum\n- Interactive elements: 3:1 minimum\n\n### Keyboard Navigation\n- Tab order follows visual layout\n- Focus indicators visible\n- Skip to main content link\n\n### Screen Reader Support\n- ARIA labels on all interactive elements\n- Live regions for dynamic content\n- Descriptive alt text for images\n\n---\n\n**Document Version**: 1.0  \n**Created**: 2025-01-09  \n**Status**: Ready for Implementation"