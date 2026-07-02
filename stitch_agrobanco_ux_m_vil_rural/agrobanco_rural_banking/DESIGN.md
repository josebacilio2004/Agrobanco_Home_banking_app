---
name: Agrobanco Rural Banking
colors:
  surface: '#f9faf2'
  surface-dim: '#d9dbd3'
  surface-bright: '#f9faf2'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4ed'
  surface-container: '#edefe7'
  surface-container-high: '#e7e9e1'
  surface-container-highest: '#e2e3dc'
  on-surface: '#1a1c18'
  on-surface-variant: '#42493e'
  inverse-surface: '#2e312c'
  inverse-on-surface: '#f0f1ea'
  outline: '#72796d'
  outline-variant: '#c2c9bb'
  surface-tint: '#3c6934'
  primary: '#164212'
  on-primary: '#ffffff'
  primary-container: '#2e5a27'
  on-primary-container: '#9ed090'
  inverse-primary: '#a1d493'
  secondary: '#835500'
  on-secondary: '#ffffff'
  secondary-container: '#feae2c'
  on-secondary-container: '#6b4500'
  tertiary: '#553112'
  on-tertiary: '#ffffff'
  tertiary-container: '#704727'
  on-tertiary-container: '#f0b78f'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#bdf0ad'
  primary-fixed-dim: '#a1d493'
  on-primary-fixed: '#002201'
  on-primary-fixed-variant: '#24501e'
  secondary-fixed: '#ffddb4'
  secondary-fixed-dim: '#ffb955'
  on-secondary-fixed: '#291800'
  on-secondary-fixed-variant: '#633f00'
  tertiary-fixed: '#ffdcc5'
  tertiary-fixed-dim: '#f4bb92'
  on-tertiary-fixed: '#301400'
  on-tertiary-fixed-variant: '#653d1e'
  background: '#f9faf2'
  on-background: '#1a1c18'
  surface-variant: '#e2e3dc'
typography:
  display-lg:
    fontFamily: Roboto
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: 0.25px
  headline-md:
    fontFamily: Roboto
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-sm:
    fontFamily: Roboto
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  body-lg:
    fontFamily: Open Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Open Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Open Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Open Sans
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
    letterSpacing: 0.5px
  button-text:
    fontFamily: Roboto
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: 1.25px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  touch-target-min: 48px
---

## Brand & Style

The design system is built upon the pillars of **trust, growth, and accessibility**. Designed specifically for rural communities, the UI emphasizes clarity and resilience. The visual style is **Corporate / Modern with a Tactile twist**, utilizing organic shapes and substantial touch targets to ensure ease of use for individuals with varying levels of digital literacy or those operating devices in outdoor, high-glare environments.

The emotional response should be one of stability and partnership—the digital equivalent of a firm handshake. Every interaction is designed to feel deliberate and secure, avoiding complex animations in favor of clear state changes and high-contrast feedback.

## Colors

The palette is rooted in the natural lifecycle of agriculture:
- **Primary Green (#2E5A27):** Represents healthy crops and financial growth. Used for primary actions and brand presence.
- **Secondary Yellow (#F5A623):** Represents the harvest and energy. Used for highlights and secondary supportive elements.
- **Tertiary Brown (#8B5E3C):** Represents the soil and roots. Used for decorative accents or specific "earth-bound" categories like land loans.
- **Neutrals:** White and Light Gray provide a clean canvas for maximum legibility, while Dark Gray is used for text to ensure WCAG AA compliance against light backgrounds.

The default mode is **Light**, optimized for outdoor readability under sunlight.

## Typography

Typography prioritizes legibility over density. We use **Roboto** for titles to provide a sturdy, professional structure, and **Open Sans** for body text due to its excellent readability at smaller sizes.

- **Minimum Size:** No text should fall below 14px to ensure accessibility.
- **Emphasis:** Use Bold weights for headings to create a clear information hierarchy.
- **Line Height:** Generous leading is applied to body text to prevent "crowding" of information, which can be overwhelming for new digital users.

## Layout & Spacing

This design system utilizes a **8px spacing grid**. Layouts are strictly fluid within a fixed-margin container to ensure consistency across various device widths common in rural markets.

- **Touch Targets:** All interactive elements (buttons, links, inputs) must maintain a minimum height/width of **48px** to accommodate users with larger hands or those operating devices in less-than-ideal physical conditions.
- **Margins:** A standard 16px side margin is maintained on mobile to prevent content from hitting the screen edge.
- **Gutters:** 16px gutters are used between cards and list items to provide clear visual separation.

## Elevation & Depth

To maintain a sense of approachability, we use **Tonal Layers** combined with **Ambient Shadows**. 

- **Surfaces:** The primary background is White (#FFFFFF). Content containers (Cards) use a subtle elevation shadow to distinguish them from the background.
- **Shadows:** Shadows are soft, low-opacity, and slightly tinted with the Primary Green to feel "organic" rather than artificial. They help communicate that an element is tappable.
- **Depth Hierarchy:** 
    - Level 0: Background (#F5F5F5)
    - Level 1: Cards and Inputs (Resting)
    - Level 2: Active Buttons and Bottom Nav
    - Level 3: Modals and Floating Action Buttons

## Shapes

The shape language is **Soft and Organic**. Sharp corners are avoided to reduce visual tension.

- **Cards:** Use a 16px corner radius to feel friendly and protective.
- **Buttons/Inputs:** Use a slightly tighter 8px radius to maintain a professional, sturdy feel.
- **Icons:** Must be linear with a minimum stroke weight of **3px**. Terminals should be rounded to match the overall soft aesthetic. Avoid complex or filled icons which can become muddy at low resolutions.

## Components

### Buttons
- **Primary Button:** Solid Green (#2E5A27) background with White text. Minimum height of 48px. Bold Roboto text.
- **Secondary Button:** Outlined style using the Secondary Yellow (#F5A623) border (2px) and text. Designed for less urgent actions like "Cancel" or "View Details."

### Cards
- **Structure:** White background, 16px rounded corners, and a Level 1 ambient shadow. 
- **Padding:** Always 16px internal padding. 
- **Usage:** Used for account summaries, loan status, and market price updates.

### Input Fields
- **Design:** Outlined containers (Dark Gray #4A4A4A at 40% opacity) with clear, persistent labels above the field. 
- **Focus State:** Border thickens to 2px and changes to Primary Green.
- **Accessibility:** Large text (16px) and high-contrast placeholder text.

### Bottom Navigation
- **Configuration:** Fixed bar at the bottom with 5 slots. 
- **Style:** White background with a subtle top border shadow. 
- **Icons:** 3px stroke icons. The active state uses Primary Green for both the icon and the label; inactive states use Dark Gray.

### Chips & Tags
- **Design:** Pill-shaped (fully rounded) used for status indicators like "Paid," "Pending," or "Due." Use background tints of the status colors (e.g., light green background for a "Success" tag).