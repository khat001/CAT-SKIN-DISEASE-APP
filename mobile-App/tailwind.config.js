/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts,js}",
    "./www/**/*.{html,js}",    // ADD THIS LINE
    "./*.html"                 // ADD THIS LINE
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}