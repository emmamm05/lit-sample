import { LitElement, html, css } from "lit";

export class SessionList extends LitElement {
  static styles = css`
    :host {
      display: block;
    }
    div {
      border: 1px solid #e5e7eb;
      border-radius: 4px;
      padding: 0.5rem;
      margin-bottom: 1rem;
    }
    p {
      margin: 0.25rem 0;
    }
    button {
      background-color: #ef4444;
      color: white;
      border: none;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover {
      background-color: #dc2626;
    }
  `;

  render() {
    return html`
      <slot></slot>
    `;
  }
}

if (!customElements.get("session-list")) {
  customElements.define("session-list", SessionList);
}