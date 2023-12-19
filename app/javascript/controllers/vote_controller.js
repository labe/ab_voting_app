import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vote"
export default class extends Controller {
  static targets = ["countdown", "form", "other", "writeIn"];

  connect() {
    this.sessionExpiresAt = this.countdownTarget.dataset.sessionExpiresAt;
    this.endTime = new Date(this.sessionExpiresAt);
    this.countdown = setInterval(this.countdown.bind(this), 1000);
    this.canWriteIn = this.formTarget.dataset.canWriteIn === "true";
    this.formTarget.querySelector("input").focus();
  }

  countdown() {
    const now = new Date();
    const secondsRemaining = (this.endTime - now) / 1000;

    if (secondsRemaining <= 0) {
      clearInterval(this.countdown);
      this.countdownTarget.innerHTML = "Signing out...";
      setTimeout(this.endSession, 1000);
      return;
    }

    const secondsPerHour = 3600;
    const secondsPerMinute = 60;
    const minutes = Math.floor(
      (secondsRemaining % secondsPerHour) / secondsPerMinute
    );
    const seconds = Math.floor(secondsRemaining % secondsPerMinute);

    this.countdownTarget.innerHTML = `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
  }

  endSession() {
    window.location.replace("/logout?expired=true");
  }

  selectOther() {
    this.otherTarget.checked = true;
  }

  focusWriteIn() {
    this.writeInTarget.focus()
  }

  clearWriteIn() {
    if (this.canWriteIn) {
      this.writeInTarget.value = "";
    }
  }

  disconnect() {
    clearInterval(this.countdown);
  }
}
