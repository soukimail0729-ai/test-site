(() => {
  // Navbar: add a subtle glow when scrolled.
  const header = document.querySelector(".site-header");
  if (header) {
    const onScroll = () => {
      const y = window.scrollY;
      header.style.background = y > 8 ? "rgba(7,7,13,0.92)" : "rgba(7,7,13,0.85)";
    };
    window.addEventListener(" scroll", onScroll, { passive: true });
    onScroll();
  }

  // Smooth scroll for anchor links (fallback).
  document.querySelectorAll("a[href^='#']").forEach((a) => {
    a.addEventListener("click", (e) => {
      const id = a.getAttribute("href");
      if (id === "#" || id.startsWith("#") === false) return;
      const el = document.querySelector(id);
      if (el) {
        e.preventDefault();
        el.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    });
  });
})();
