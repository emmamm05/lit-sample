import { LitElement, html, css } from "lit";

export class AppSidebar extends LitElement {
  static properties = {
    heading: { type: String },
  };

  static styles = css`
    :host {
      display: block;
    }
    aside {
      position: sticky;
      top: 1rem;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1rem;
      background: #f8fafc;
    }
    h3 {
      margin: 0 0 0.5rem;
      font-size: 1rem;
    }
    nav a {
      display: block;
      color: #1f2937;
      text-decoration: none;
      padding: 0.25rem 0;
    }
    nav a:hover {
      text-decoration: underline;
    }
  `;

  constructor() {
    super();
    this.heading = "Navigation";
  }

  render() {
    return html`
      <aside aria-label="Sidebar">
        <nav>
          <a href="/profile">Profile</a>
          <a href="/sessions">Sessions</a>
          <slot></slot>
        </nav>
      </aside>
    `;
  }
}

if (!customElements.get("app-sidebar")) {
  customElements.define("app-sidebar", AppSidebar);
}
