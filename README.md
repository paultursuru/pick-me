# Pick Me

Collaboratively pick and vote on items to furnish your next home. Create a flat, add rooms and items, collect options (scraped from product URLs), and vote with 1–5 stars. Budgets and quick-add UX help you decide faster.
Build to learn Hotwire's Turbo Frames and Turbo Streams.

## Table of Contents
- [What it does](#what-it-does)
- [Tech stack](#tech-stack)
- [Domain model](#domain-model)
- [Authorization](#authorization)
- [Setup](#setup)
- [Running the app](#running-the-app)
- [Key workflows](#key-workflows)
- [Scraper details](#scraper-details)
- [PWA](#pwa)
- [Deployment](#deployment)

## What it does
- User auth with Devise; role/record authorization with Pundit.
- Manage `Flats` (with budget) → `Rooms` (typed) → `Items` (importance) → `Options` (price, image, URL).
- Invite collaborators to a flat (pending/accepted/declined; normal/admin).
- Vote 1–5 stars on options; rank by average stars.
- “Quick add” option from a product URL via lightweight scraper (Open Graph).
- Hotwire/Turbo + Stimulus UI, Tailwind styling.
- Active Storage via Cloudinary for images.
- PWA manifest + service worker for installability.

## Tech stack
- Ruby 3.1.2, Rails 7.0.4.x
- Postgres
- Devise, Pundit, Turbo, Stimulus, Tailwind (tailwindcss-rails), Simple Form + simple_form-tailwind
- Active Storage (Cloudinary)
- RSpec, Capybara
- Faraday (+ redirects, cookies, retry) for scraping
- Pundit for authorization

## Domain model
- `User` has many `Flats`, `Invitations`, `Inspirations`
- `Flat` belongs to `User`; has many `Rooms`, `Items` (through rooms), `Options` (through items)
- `Room` belongs to `Flat`; has many `Items`, `Options` (through items); kind enum with auto-naming
- `Item` belongs to `Room`; importance enum; average price computed across options
- `Option` belongs to `Item`; has many `Votes`; image attached; average stars
- `Invitation` belongs to `User` and `Flat`; statuses: pending/accepted/declined; levels: normal/admin
- `Vote` belongs to `User` and `Option` (unique per user/option); 1..5 stars

## Authorization
- Flat owners have full control.
- Invited accepted users can view.
- Invited admin users can create/update/destroy rooms, items, options, and invitations.
- Users can vote on options of flats they own or are invited to; only the voter can update their vote.

## Setup
1. Prereqs: Ruby 3.1.2, Postgres, Bundler, Foreman (auto-installed by `bin/dev`).
2. Env vars (copy to `.env` for development):
   - `CLOUDINARY_URL=cloudinary://<key>:<secret>@<cloud_name>` (required for image uploads)
   - `HTTP_PROXY_URL=` (optional; can improve scraping reliability)
3. Install and prepare:
   ```bash
   bin/setup
   # (optional demo data)
   bin/rails db:seed
   ```
4. Verify DB is running (Postgres).

## Running the app
```bash
bin/dev
# runs web (3000) + tailwind watcher via Procfile.dev
```

## Key workflows
- Create a flat (name, address, optional budget).
- Invite collaborators; they accept/decline (admin or normal).
- Add rooms (typed: kitchen, bedroom, etc.); names auto-suffixed when duplicates.
- Add items to rooms; set importance (low/medium/high/urgent).
- Add options to items:
  - Normal form with name/price/image/description/url/size.
  - Quick add: paste product URL; we prefill from Open Graph tags; you review before saving.
- Vote 1–5 stars on options; items show options sorted by rating.
- Budget insights: flat total estimate = sum of item average prices; see priciest item.

## Scraper details
- Service object: `OptionScrapper` → `HttpClient`.
- Parses HTML with Nokogiri; prefers Open Graph tags.
- If blocked (403, etc.), returns `{ status: "403", website: "<domain>" }` and the UI explains the limitation.
- Optional proxy via `HTTP_PROXY_URL`. Retries/redirections/cookies enabled via Faraday middleware.

## PWA
- Manifest at `/manifest.json`, service worker at `/service-worker.js`.
- Minimal SW (no offline caching yet); safe to iterate later.

## Deployment 
- Required env: `CLOUDINARY_URL`.
- Active Storage service: `cloudinary` in development and production.

