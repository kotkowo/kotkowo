// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require('tailwindcss/plugin')
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    '**/*.heex'
  ],
  theme: {
    extend: {
      colors: {
        primary: '#116858',
        'primary-light': '#F3F8F6',
        'primary-lighter': '#579488',
        highlight: '#FEEC8F',
        secondary: "#444444"
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
        inter: ['Inter'],
        manrope: ['Manrope']
      },
      spacing: {
        5.5: '1.375rem',
        82: '21.5rem'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    require('tailwindcss-counter')(),
    plugin(({ addVariant }) =>
      { addVariant('phx-no-feedback', ['.phx-no-feedback&', '.phx-no-feedback &']); }
    ),
    plugin(({ addVariant }) =>
      { addVariant('phx-click-loading', [
        '.phx-click-loading&',
        '.phx-click-loading &'
      ]); }
    ),
    plugin(({ addVariant }) =>
      { addVariant('phx-submit-loading', [
        '.phx-submit-loading&',
        '.phx-submit-loading &'
      ]); }
    ),
    plugin(({ addVariant }) =>
      { addVariant('phx-change-loading', [
        '.phx-change-loading&',
        '.phx-change-loading &'
      ]); }
    )
  ]
}
