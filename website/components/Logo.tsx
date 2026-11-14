export default function Logo({ size = 40 }: { size?: number }) {
  return (
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src="/branding/hamwhatsapp-icon.png"
      alt="HamWhatsApp logo"
      width={size}
      height={size}
      style={{ width: size, height: size }}
    />
  );
}
