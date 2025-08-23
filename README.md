# Lit + esbuild setup

This Rails app is configured to use jsbundling-rails with esbuild and the Lit (lit.dev) web components framework.

## Install Node dependencies

```sh
npm install
```

## Build assets

One-off build:

```sh
npm run build
```

Watch mode (during development):

```sh
npm run build:watch
```

If you use foreman/bin/dev with Procfile.dev, ensure the build script runs alongside Rails.

## Using the example component

A sample Lit component is included at `app/javascript/components/hello-lit.js` and imported from the application entrypoint. You can use it in any view:

```html
<hello-lit name="Rails"></hello-lit>
```

The compiled bundle is emitted to `app/assets/builds`, and is included by the layout via:

```erb
<%= javascript_include_tag "application", "data-turbo-track": "reload", type: "module" %>
```

That means any component imported from `app/javascript/application.js` will be available on pages rendering the default layout.
