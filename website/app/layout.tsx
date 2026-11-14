import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "HamWhatsApp - Connect. Chat. Share.",
  description: "HamWhatsApp messaging platform for web and Android.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
