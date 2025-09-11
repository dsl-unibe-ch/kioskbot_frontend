# KioskBot Frontend

Minimal setup to install and run the app with pnpm.

## Quickstart

1. Prerequisites

- Node.js 18+ and pnpm installed

2. Configure environment

- Copy `.env.example` to `.env` and set the backend URL:
  - `PUBLIC_API` — the backend base URL (including protocol), e.g. `https://your-backend.example.com`

3. Install dependencies

```pwsh
pnpm install
```

4. Start the dev server

```pwsh
pnpm dev
```

The app will be available on http://localhost:5173 (default).

## Build and preview

```pwsh
pnpm build
pnpm preview
```

## Useful scripts

- `pnpm check` — Svelte type checks
- `pnpm lint` — Prettier check + ESLint
- `pnpm format` — Format files with Prettier

## Environment variables

- `PUBLIC_API` is required and is exposed to the browser. Make sure it points to your backend (and that CORS is configured accordingly).
