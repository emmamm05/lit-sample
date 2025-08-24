import { LitElement, html, css } from "lit";

export class AppSection extends LitElement {
  static properties = {
    heading: { type: String },
  };

  static styles = css`
    :host {
      display: block;
      margin: 0 auto 1.25rem;
      max-width: 720px;
    }
    section {
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1rem;
      background: #fafafa;
    }
    header h2 {
      margin: 0 0 0.5rem;
      font-size: 1.25rem;
    }
  `;

  constructor() {
    super();
    this.heading = "";
  }

  render() {
    return html`
      <section>
        ${this.heading ? html`<header><h2>${this.heading}</h2></header>` : null}
        <slot></slot>
      </section>
    `;
  }
}

if (!customElements.get("app-section")) {
  customElements.define("app-section", AppSection);
}
