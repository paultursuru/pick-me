const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  safelist: [
    'bg-red-500',
    'bg-emerald-500',
    'bg-blue-500',
    'bg-yellow-500',
    'bg-indigo-500',
    'bg-pink-500',
    'bg-purple-500',
    'bg-green-500',
    'bg-gray-500',
    'bg-orange-500'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      fontSize: {
        'xxs': '10px',
      },
      padding: {
        'xxxs': '4px'
      },
      keyframes: {
        fade_in: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        }
      },
      animation: {
        fade_in: 'fade_in 0.4s ease-in-out',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')
  ]
}
