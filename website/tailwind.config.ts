import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  darkMode: "media",
  theme: {
    extend: {
      colors: {
        ham: {
          primary: "#075E54",
          secondary: "#128C7E",
          accent: "#25D366",
          bg: "#ECE5DD",
        },
      },
    },
  },
  plugins: [],
};
export default config;
