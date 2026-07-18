let timer = null;

const TIMEOUT = 5 * 60 * 1000;

export function startSecurityTimer(callback) {
  clearSecurityTimer();
  timer = setTimeout(callback, TIMEOUT);
}

export function resetSecurityTimer(callback) {
  startSecurityTimer(callback);
}

export function clearSecurityTimer() {
  if (timer) {
    clearTimeout(timer);
    timer = null;
  }
}

export function stopSecurityTimer() {
  clearSecurityTimer();
}

export function wipeSensitive(value) {
  return typeof value === "string"
    ? "\0".repeat(value.length)
    : null;
}

export function secureClipboardClear() {
  if (navigator.clipboard) {
    setTimeout(() => {
      navigator.clipboard.writeText("");
    }, 15000);
  }
}

export function preventSeedCapture() {
  document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
      console.warn("NUVYRA: écran masqué");
    }
  });
}
