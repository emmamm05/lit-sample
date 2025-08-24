import { LitElement, html, css } from "lit";

export class AppShell extends LitElement {
  static properties = {
    // Optional properties for future use (e.g., flash messages)
    notice: { type: String },
    alert: { type: String },
  };

  static styles = css`
    :host {
      display: block;
      box-sizing: border-box;
      min-height: 100dvh;
      background: #fff;
      color: #111;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
      line-height: 1.4;
      padding: 1rem;
    }
    .flash {
      margin: 0 0 1rem;
      padding: 0.5rem 0.75rem;
      border-radius: 6px;
    }
    .notice { background: #e6ffed; color: #045d1f; border: 1px solid #b7f5c7; }
    .alert  { background: #ffecec; color: #8a1111; border: 1px solid #ffbaba; }
    main { display: block; }
  `;

  constructor() {
    super();
    this.notice = "";
    this.alert = "";
  }

  render() {
    return html`
      ${this.notice ? html`<div class="flash notice">${this.notice}</div>` : null}
      ${this.alert ? html`<div class="flash alert">${this.alert}</div>` : null}
      <main><slot></slot></main>
    `;
  }
}

if (!customElements.get("app-shell")) {
  customElements.define("app-shell", AppShell);
}
