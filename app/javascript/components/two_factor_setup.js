import { LitElement, html, css } from "lit";

export class TwoFactorSetup extends LitElement {
  static styles = css`
    :host {
      display: block;
    }
    p {
      margin-bottom: 1rem;
    }
    .qr-code {
      text-align: center;
      margin: 1rem 0;
    }
    code {
      background-color: #f3f4f6;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      font-family: monospace;
      margin: 1rem 0;
    }
    form {
      display: flex;
      flex-direction: column;
      gap: 1rem;
      max-width: 300px;
    }
    div {
      display: flex;
      flex-direction: column;
    }
    label {
      font-weight: bold;
      margin-bottom: 0.25rem;
    }
    input {
      padding: 0.5rem;
      border: 1px solid #d1d5db;
      border-radius: 4px;
    }
    button {
      background-color: #3b82f6;
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover {
      background-color: #2563eb;
    }
  `;

  render() {
    return html`
      <h1>Enable two-factor authentication</h1>

      <slot></slot>
    `;
  }
}

if (!customElements.get("two-factor-setup")) {
  customElements.define("two-factor-setup", TwoFactorSetup);
}