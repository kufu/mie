const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        ...defaultTheme.colors,
        accent: '#5D29FC',
        shade: {
          10: '#131416',
          30: '#5E626E',
          90: '#F4F4F6',
          100: '#FCFCFD'
        }
      },
      fontFamily: {
        sans: ['Inter var', 'Noto Sans JP var', ...defaultTheme.fontFamily.sans]
      },
      textColor: {
        black: '#131416',
        ...defaultTheme.colors
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')
  ]
};
