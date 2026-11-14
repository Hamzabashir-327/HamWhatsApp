"use client";

import { useState } from "react";

const COUNTRIES = [
  { code: "+92", name: "Pakistan" },
  { code: "+91", name: "India" },
  { code: "+1", name: "USA / Canada" },
  { code: "+44", name: "United Kingdom" },
  { code: "+971", name: "UAE" },
  { code: "+966", name: "Saudi Arabia" },
];

export default function PhoneForm({ isRegister }: { isRegister: boolean }) {
  const [name, setName] = useState("");
  const [code, setCode] = useState("+92");
  const [phone, setPhone] = useState("");
  const [message, setMessage] = useState<{ ok: boolean; text: string } | null>(
    null,
  );

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (isRegister && name.trim().length < 2) {
      setMessage({ ok: false, text: "Please enter your display name." });
      return;
    }
    if (!/^\d{7,12}$/.test(phone)) {
      setMessage({ ok: false, text: "Phone number must be 7 to 12 digits." });
      return;
    }
    setMessage({
      ok: true,
      text: "Number looks valid. Real SMS OTP will be enabled in Milestone 2 with Firebase.",
    });
  }

  const field =
    "w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-black outline-none focus:border-ham-secondary";

  return (
    <form onSubmit={onSubmit} className="space-y-4">
      {isRegister && (
        <input
          className={field}
          placeholder="Display name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
      )}
      <div className="flex gap-2">
        <select
          className={`${field} w-36`}
          value={code}
          onChange={(e) => setCode(e.target.value)}
        >
          {COUNTRIES.map((c) => (
            <option key={c.code} value={c.code}>
              {c.name} {c.code}
            </option>
          ))}
        </select>
        <input
          className={field}
          placeholder="Phone number"
          inputMode="numeric"
          value={phone}
          onChange={(e) => setPhone(e.target.value.replace(/\D/g, ""))}
        />
      </div>
      <button
        type="submit"
        className="w-full rounded-lg bg-ham-primary py-2 font-semibold text-white hover:bg-ham-secondary"
      >
        Send OTP
      </button>
      {message && (
        <p className={message.ok ? "text-ham-secondary" : "text-red-600"}>
          {message.text}
        </p>
      )}
    </form>
  );
}
