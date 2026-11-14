import Link from "next/link";
import Logo from "../../components/Logo";
import PhoneForm from "../../components/PhoneForm";

export default function Page() {
  return (
    <main className="flex min-h-screen items-center justify-center px-4">
      <div
        className="w-full max-w-md space-y-6 rounded-2xl p-8 shadow-lg"
        style={{ background: "var(--card-bg)" }}
      >
        <div className="flex flex-col items-center gap-3">
          <Logo size={72} />
          <h1 className="text-2xl font-bold">Create account</h1>
        </div>
        <PhoneForm isRegister={true} />
        <p className="text-center">
          <Link href="/login" className="text-ham-secondary underline">
            Already have an account? Login
          </Link>
        </p>
      </div>
    </main>
  );
}
