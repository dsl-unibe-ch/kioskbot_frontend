/** @type {import('tailwindcss').Config} */
module.exports = {
	theme: {
		extend: {
			typography: () => ({
				DEFAULT: {
					css: {
						'--tw-prose-links': 'rgb(0, 116, 196)'
					}
				}
			})
		}
	}
};
