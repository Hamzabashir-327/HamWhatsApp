import Link from "next/link";
import Logo from "../components/Logo";

const roadmap = [
  "Phone login with real SMS OTP",
  "Real-time one-to-one and group chat",
  "Photos, videos, documents and voice messages",
  "Status updates that expire after 24 hours",
  "Voice and video calling",
  "Privacy controls and end-to-end encryption",
];

export default function Home() {
  return (
    <main className="min-h-screen">
      <header className="flex items-center justify-between bg-ham-primary px-6 py-4 text-white">
        <div className="flex items-center gap-3">
          <Logo size={40} />
          <span className="text-xl font-bold">HamWhatsApp</span>
        </div>
        <nav className="flex gap-3">
          <Link href="/login" className="rounded-lg px-4 py-2 hover:bg-ham-secondary">
            Login
          </Link>
          <Link
            href="/register"
            className="rounded-lg bg-ham-accent px-4 py-2 font-semibold text-black"
          >
            Create account
          </Link>
        </nav>
      </header>

      <section className="mx-auto max-w-3xl px-6 py-16 text-center">
        <div className="mb-6 flex justify-center">
          <Logo size={128} />
        </div>
        <h1 className="text-4xl font-bold">Connect. Chat. Share.</h1>
        <p className="mt-4 text-lg opacity-80">
          HamWhatsApp is a messaging platform for the web and Android, currently
          under active development.
        </p>
        <Link
          href="/dashboard"
          className="mt-6 inline-block rounded-lg border border-ham-secondary px-5 py-2 text-ham-secondary"
        >
          Preview dashboard (development only)
        </Link>
      </section>

      <section className="mx-auto max-w-3xl px-6 pb-16">
        <h2 className="mb-4 text-2xl font-semibold">In development</h2>
        <ul className="grid gap-3 sm:grid-cols-2">
          {roadmap.map((item) => (
            <li
              key={item}
              className="rounded-xl p-4 shadow"
              style={{ background: "var(--card-bg)" }}
            >
              {item}
            </li>
          ))}
        </ul>
      </section>
    </main>
  );
}
