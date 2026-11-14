"use client";

import { useState } from "react";
import Link from "next/link";
import Logo from "../../components/Logo";

const SECTIONS = [
  { key: "chats", label: "Chats", note: "Messaging arrives in Milestone 3." },
  { key: "status", label: "Status", note: "Status arrives in Milestone 5." },
  { key: "calls", label: "Calls", note: "Calling arrives in Milestone 6." },
  { key: "contacts", label: "Contacts", note: "Contacts arrive in Milestone 2/3." },
  { key: "groups", label: "Groups", note: "Groups arrive in Milestone 4." },
  { key: "profile", label: "Profile", note: "Profile setup arrives in Milestone 2." },
  { key: "settings", label: "Settings", note: "Privacy and account settings arrive in Milestone 7." },
];

export default function Dashboard() {
  const [active, setActive] = useState(SECTIONS[0]);

  return (
    <div className="flex h-screen flex-col md:flex-row">
      <nav className="flex gap-1 overflow-x-auto bg-ham-primary p-2 text-white md:w-52 md:flex-col md:overflow-visible">
        <div className="hidden items-center gap-2 p-2 md:flex">
          <Logo size={32} />
          <span className="font-bold">HamWhatsApp</span>
        </div>
        {SECTIONS.map((s) => (
          <button
            key={s.key}
            onClick={() => setActive(s)}
            className={`whitespace-nowrap rounded-lg px-4 py-3 text-left ${
              active.key === s.key ? "bg-ham-secondary" : "hover:bg-ham-secondary/60"
            }`}
          >
            {s.label}
          </button>
        ))}
        <Link href="/" className="rounded-lg px-4 py-3 hover:bg-ham-secondary/60 md:mt-auto">
          Home
        </Link>
      </nav>

      <aside
        className="border-b border-gray-300 p-4 md:w-80 md:border-b-0 md:border-r"
        style={{ background: "var(--card-bg)" }}
      >
        <h2 className="text-lg font-semibold">{active.label}</h2>
        <p className="mt-6 text-center opacity-70">Nothing here yet.</p>
      </aside>

      <section className="flex flex-1 items-center justify-center p-6 text-center">
        <div>
          <Logo size={96} />
          <p className="mt-4 text-lg font-semibold">{active.label}</p>
          <p className="opacity-70">{active.note}</p>
        </div>
      </section>
    </div>
  );
}
