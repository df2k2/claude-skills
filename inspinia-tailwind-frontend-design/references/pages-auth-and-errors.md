# Utility pages, authentication flows and error pages

This group covers the "everything else" pages of an admin product: the blank page starter, user-facing
utility screens (profile, account settings, FAQ, pricing, timeline, gallery, sitemap, search results,
coming-soon, legal text), the 27 authentication screens (nine flows in three layout families) and the
seven error / maintenance pages. Reach for it when you need a page that is not a dashboard, a data
table or a CRUD form: a settings screen, a login or OTP step, a 404 served by the web server, an audit
trail, a media library, a "we'll be back" page.

Two facts that matter for the whole group:

- `pages-*` screens sit inside the normal app chrome (sidebar + topbar) and load `vendors.min.js` +
  `app.js`, so Preline autoinit, card actions and dark mode all work.
- `auth-*`, `error-*` and `pages-coming-soon` are **chrome-less** pages with no `<main>`. In the
  vendored demo they load only `assets/js/config.js` (in `<head>`) plus their own page script. They do
  not load `vendors.min.js` or `app.js`, so nothing Preline-driven runs there (the theme-customizer
  offcanvas markup is present but inert) and `<span data-current-year>` is never filled. See the
  "Auth layout families" gotchas.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Start a brand-new page inside the admin chrome | Blank page starter | `pages-empty.html` | none (vendors.min.js + app.js) |
| Show a person: cover, avatar, bio, stats, activity, their items | User profile | `pages-profile.html` | none |
| Let a user edit personal / address / company / social details | Account settings form | `pages-account-settings.html` | none |
| Help centre with collapsible Q&A grouped by topic + search box | FAQ accordion | `pages-faq.html` | Preline `hs-accordion` |
| Compare plans and pick one | Pricing tiers | `pages-pricing.html` | none (no billing toggle shipped) |
| Audit trail, order history, changelog, ticket activity | Timeline (dot / icon / dashed / avatar) | `pages-timeline.html` | none (pure CSS `after:` connector) |
| Media library with category filter, text search, lightbox, drag-reorder | Gallery | `pages-gallery.html` | GLightbox + Muuri + web-animations, `pages/pages-gallery.js` |
| Hierarchical overview of all sections / routes | Sitemap tree | `pages-sitemap.html` | none (CSS `before:`/`after:` tree lines) |
| Global search results with filters, meta and pagination | Search results list | `pages-search-results.html` | none |
| Pre-launch page with countdown + notify-me | Coming soon | `pages-coming-soon.html` | `pages/coming-soon.js` |
| Long-form legal / policy text | Legal text pages | `pages-privacy-policy.html`, `pages-terms-conditions.html` | none |
| Chrome-less auth page, centered form | Auth layout A: basic | `auth-*.html` | none |
| Auth page with a side image inside one rounded card | Auth layout B: card | `auth-card-*.html` | none |
| Full-height auth page, image left, narrow form panel right | Auth layout C: split | `auth-split-*.html` | none |
| Log in with email + password | Sign in | `auth-sign-in.html` (+card/split) | none |
| Register with a password-strength meter | Sign up | `auth-sign-up.html` (+card/split) | `pages/auth-password.js` |
| "Forgot password" request | Reset password | `auth-reset-pass.html` (+card/split) | none |
| Set a new password after an emailed code | New password | `auth-new-pass.html` (+card/split) | `pages/auth-two-factor.js`, `pages/auth-password.js` |
| Enter a 6-digit OTP / SMS code | Two-factor verification | `auth-two-factor.html` (+card/split) | `pages/auth-two-factor.js` |
| Re-enter password on a locked session | Lock screen | `auth-lock-screen.html` (+card/split) | none |
| "Email verified" / success confirmation | Success mail | `auth-success-mail.html` (+card/split) | none |
| Quick re-auth with a numeric PIN | Login with PIN | `auth-login-pin.html` (+card/split) | `pages/auth-two-factor.js` |
| "Account deactivated — reactivate" landing | Delete account | `auth-delete-account.html` (+card/split) | none |
| Show / hide a password field | Password visibility toggle | `form-elements.html` (cross-ref) | Preline `hs-toggle-password` |
| Server error templates: 400 / 401 / 403 / 404 / 408 / 500 | Error pages | `error-400.html` … `error-500.html` | none (CSS animations) |
| Scheduled-downtime page | Maintenance | `error-maintenance.html` | none |

## Blank page starter (pages-empty)

**What it is.** The smallest page in the demo: full app chrome (topbar, sidebar, footer, theme
customizer) plus a `<main>` that contains only the page-title block. It is THE starting point for any
new in-app page.

**Use it when.**
- Creating any new screen that lives inside the admin (settings, reports, custom tools).
- You want the exact script order and wrapper classes without copying 3,000 lines of demo chrome.
- Not for login / error / landing pages: those are chrome-less (see the auth and error sections).

**Source.** `references/sources/pages/pages-empty.html` (3,075 lines; `<main>` is lines 3021-3038).

**Markup.** The full page skeleton, with the sidebar / topbar / customizer bodies elided. Keep the
element order and the wrapper classes exactly; `.page-content` gets its left margin from the sidenav
width and `.footer` uses `margin-top:auto` to stick to the bottom.

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>Empty | INSPINIA</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="shortcut icon" href="assets/images/favicon.ico" />
  <link href="assets/css/app.min.css" rel="stylesheet" type="text/css">
  <script src="assets/js/config.js"></script>   <!-- layout config; must be in <head> -->
</head>
<body>
  <div class="wrapper">
    <header class="app-header">
      <div class="container-fluid flex items-center justify-between">
        <div class="flex items-center gap-2.5">
          <div class="logo-topbar">
            <a href="index.html" class="logo-box">
              <div class="logo-light"><img src="assets/images/logo.png" class="logo-lg h-6" alt="Light logo"><img src="assets/images/logo-sm.png" class="logo-sm h-6" alt="Small logo"></div>
              <div class="logo-dark"><img src="assets/images/logo-black.png" class="logo-lg h-6" alt="Dark logo"><img src="assets/images/logo-sm.png" class="logo-sm h-6" alt="Small logo"></div>
            </a>
          </div>
          <button id="button-toggle-menu" class="sidenav-toggle-button btn btn-icon"><i class="iconify tabler--menu-4 text-xl"></i></button>
          <!-- … search box, mega menus, topbar items (copy from any demo page) … -->
        </div>
      </div>
    </header>

    <aside id="app-menu" class="app-menu">
      <!-- … sidebar menu (copy from any demo page) … -->
    </aside>

    <div class="page-content">
      <main>
        <div class="page-title-head">
          <h4 class="page-main-title">Empty</h4>
          <div class="hidden items-center gap-1.25 text-sm md:flex">
            <a href="#" class="text-sm">Inspinia</a>
            <i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i>
            <a href="#" class="text-sm">Pages</a>
            <i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i>
            <a href="#" class="text-default-400 text-sm" aria-current="page">Empty</a>
          </div>
        </div>

        <!-- YOUR CONTENT: -->
        <div class="container-fluid">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-base">
            <div class="card">
              <div class="card-header"><h4 class="card-title">Card</h4></div>
              <div class="card-body">…</div>
            </div>
          </div>
        </div>
      </main>

      <footer class="footer">
        <div class="container-fluid">
          <div class="flex flex-wrap items-center">
            <div class="w-full md:w-1/2 text-center md:text-left">© <span data-current-year></span> Inspinia By <span class="font-semibold">WebAppLayers</span></div>
            <div class="w-full md:w-1/2"><div class="hidden md:block md:text-right">10GB of <span class="font-bold">250GB</span> Free.</div></div>
          </div>
        </div>
      </footer>
    </div>
  </div>

  <div><div id="theme-customization" class="hs-overlay …">…</div></div>  <!-- optional; drop in production -->

  <script src="assets/js/vendors.min.js"></script>
  <script src="assets/js/app.js"></script>
  <!-- then: assets/plugins/<lib>/… and assets/js/pages/<page>.js -->
</body>
</html>
```

**Gotchas.**
- `.page-title-head` is the only thing in `<main>`; everything else goes in a `.container` (centered,
  max-width: used by pricing, legal, account-settings) or `.container-fluid` (full width: used by
  almost everything else).
- `.page-content main` adds horizontal padding (`padding-inline: calc(var(--spacing)*4)`); don't add
  your own outer padding.
- Breadcrumb chevrons carry `rtl:rotate-180`; keep it if you support RTL.
- The `<title>` suffix and meta tags are demo marketing; replace them.

## User profile (pages-profile)

**What it is.** A profile screen: full-width cover card with a background image, gradient overlay and a
quote, then an avatar + name + role + badge row with Follow / Message / "…" dropdown, followed by a
4/8 column grid: personal info list, skill chips and a social feed on the left; four KPI cards, an
"About" card, a tasks table and a blog-post card grid on the right.

**Use it when.**
- Team member / employee profile in an HR or PM tool; author page in a CMS; customer 360 view in a CRM
  (swap "tasks" for orders and "blog posts" for recent tickets).
- Public creator page in a marketplace (follow / message actions already there).
- Not for editing: pair it with Account settings (next section) via the "Edit Profile" dropdown item.
- The demo has **no tabs** on the profile. If you want Overview / Activity / Settings tabs, add a Preline
  `nav-tabs` block (`ui-tabs.html`) under the cover card and move the two columns into the first pane.

**Source.** `references/sources/pages/pages-profile.html`. Note: this page has no `.page-title-head`;
the cover card is the first child of `<main>`.

**Markup — cover + identity row.**

```html
<div class="mb-5">
  <article class="card">
    <div class="relative overflow-hidden h-62.5 bg-cover bg-center" style="background-image: url('assets/images/profile-bg.jpg')">
      <div class="absolute inset-0 flex flex-col items-center justify-center p-7.5 bg-linear-to-t from-[#313A46] via-[#313a46cc] to-[#313a4680] text-center">
        <h3 class="text-white italic text-xl">"Designing the future, one template at a time"</h3>
      </div>
    </div>
    <div class="card-body">
      <div class="flex flex-wrap justify-between items-center">
        <div class="flex items-center gap-base">
          <div><img src="assets/images/users/user-1.jpg" alt="avatar" class="size-20 rounded-full object-cover border-5 border-default-200" /></div>
          <div>
            <h4 class="font-bold text-lg text-default-800 mb-1.25">Damian D.</h4>
            <p class="text-default-400 text-sm mb-1.25">Product Designer</p>
            <span class="badge bg-primary/15 text-primary text-xs">Author</span>
          </div>
        </div>
        <div class="flex items-center gap-2.5 md:mt-0 mt-5">
          <a href="#!" class="btn border border-primary hover:bg-primary text-primary hover:text-white">Follow</a>
          <a href="#!" class="btn bg-primary hover:bg-primary-hover text-white">Message</a>
          <div class="hs-dropdown [--auto-close:inside] relative inline-flex">
            <button type="button" class="hs-dropdown-toggle btn btn-icon bg-dark text-white" aria-haspopup="menu" aria-expanded="false" aria-label="Dropdown"><i class="iconify tabler--dots text-white size-6"></i></button>
            <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical">
              <div><a class="dropdown-item" href="#">Edit Profile</a><a class="dropdown-item text-danger" href="#">Report</a></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </article>
</div>
```

**Markup — two-column body (trimmed).**

```html
<div class="container-fluid px-5">
  <div class="grid xl:grid-cols-12 grid-cols-1 gap-base">
    <div class="xl:col-span-4">
      <!-- Personal information: icon + text rows -->
      <div class="card mb-5">
        <div class="card-header"><h4 class="card-title">Personal Information</h4></div>
        <div class="card-body">
          <div class="space-y-2.5">
            <div class="flex items-center gap-2.5">
              <div class="btn btn-icon size-8 bg-light"><i class="iconify tabler--briefcase text-secondary size-4.5"></i></div>
              <p class="text-default-800">UI/UX Designer &amp; Full-Stack Developer</p>
            </div>
            <div class="flex items-center gap-2.5">
              <div class="btn btn-icon size-8 bg-light"><i class="iconify tabler--mail size-4.5 text-secondary"></i></div>
              <p class="text-default-800">Email <a href="mailto:hello@example.com" class="text-primary font-semibold">hello@example.com</a></p>
            </div>
            <!-- repeat: tabler--school, tabler--map-pin, tabler--users, tabler--link, tabler--world -->
          </div>
          <!-- social buttons row -->
          <div class="flex items-center justify-center gap-2.5 mt-7.5 mb-2.5">
            <a href="#" class="btn btn-icon bg-primary hover:bg-primary-hover text-white rounded-full"><!-- brand svg --></a>
            <!-- repeat with bg-info, bg-danger, bg-success, bg-secondary -->
          </div>
        </div>
      </div>
      <!-- Skills chips -->
      <div class="card mb-5">
        <div class="card-header"><h4 class="card-title">Skills</h4></div>
        <div class="card-body">
          <div class="flex flex-wrap items-center gap-1.25">
            <a href="#" class="btn btn-sm bg-light text-sm hover:text-primary">Product Design</a>
            <!-- repeat per skill -->
          </div>
        </div>
      </div>
      <!-- Social feed: avatar + name/line + action -->
      <div class="card">
        <div class="card-header"><h4 class="card-title">My Social Feed</h4></div>
        <div class="card-body">
          <div class="flex justify-between items-center border-b border-default-200 py-2.5">
            <div class="flex items-center gap-2.5">
              <img src="assets/images/users/user-4.jpg" alt="" class="size-8 rounded-md object-cover" />
              <div><h5 class="font-medium text-default-800 text-sm">Leo Martin</h5><p class="text-xs text-default-400">leo@designbyte.com</p></div>
              <span class="badge bg-success/10 text-success">New Request</span>
            </div>
            <div class="flex items-center gap-0.75">
              <a href="#!" class="btn btn-icon size-8 border-primary text-primary hover:bg-primary hover:text-white" title="Accept"><i class="iconify tabler--check text-lg"></i></a>
              <a href="#!" class="btn btn-icon bg-danger hover:bg-danger-hover size-8 text-white" title="Decline"><i class="iconify tabler--x text-lg"></i></a>
            </div>
          </div>
          <!-- repeat; last row: class="flex justify-between items-center pt-2" (no border); a time stamp is <small class="text-[11px] text-default-400">2m ago</small> -->
        </div>
      </div>
    </div>

    <div class="xl:col-span-8">
      <!-- 4 KPI cards -->
      <div class="grid xl:grid-cols-4 md:grid-cols-2 gap-base mb-5">
        <div class="card">
          <div class="card-body">
            <div class="flex justify-between items-center mb-2">
              <h5 class="card-title">My Tasks</h5>
              <a href="#!"><i class="iconify tabler--external-link size-4.5 text-default-400"></i></a>
            </div>
            <div class="flex items-center gap-2.5 my-5">
              <div class="btn btn-icon rounded-full size-9 bg-primary"><i class="iconify tabler--clipboard-list size-4.5 text-white"></i></div>
              <h3 class="text-default-800 text-xl">124</h3>
              <span class="ms-auto badge bg-primary/15 text-primary text-xs font-medium">+3 New</span>
            </div>
            <div class="flex items-center justify-between text-sm text-default-400">
              <div class="flex items-center gap-1"><span class="text-primary"><i class="iconify tabler--circle align-middle"></i></span><span>Total Tasks</span></div>
              <span class="font-semibold text-default-800">12,450</span>
            </div>
          </div>
        </div>
        <!-- repeat: tabler--messages bg-purple, tabler--users bg-purple, tabler--credit-card bg-primary -->
      </div>

      <div class="card mb-5">
        <div class="card-header"><h4 class="card-title">About Me</h4></div>
        <div class="card-body"><p class="mb-4">…</p><div class="mt-5"><h5 class="card-title mb-2.5">My Approach :</h5><p>…</p></div></div>
      </div>

      <!-- Tasks table -->
      <div class="card">
        <div class="card-header"><h4 class="card-title">My Tasks</h4></div>
        <div class="card-body p-0">
          <div class="table-wrapper whitespace-nowrap">
            <table class="table table-hover w-full text-sm">
              <thead class="bg-light/25 thead-sm">
                <tr class="uppercase text-2xs"><th data-table-sort="task">Task</th><th data-table-sort>Status</th><th data-table-sort="name">Assigned By</th><th data-table-sort>Start Date</th><th data-table-sort>Priority</th><th data-table-sort>Progress</th><th style="width: 30px">Total Time Spent</th></tr>
              </thead>
              <tbody>
                <tr>
                  <td><h5 class="my-1.25"><a href="#">Admin Dashboard Template - Final Touch</a></h5><span class="text-xs text-default-400">Due in 2 days</span></td>
                  <td><span class="badge bg-warning/15 text-warning">In-progress</span></td>
                  <td><div class="flex items-center gap-2.5"><img src="assets/images/users/user-3.jpg" alt="" class="size-8 rounded-full object-cover" /><div><h5>Liam Johnson</h5><p class="text-xs text-default-400">liam@pixelcraft.io</p></div></div></td>
                  <td>Apr 15, 2025</td><td><span class="badge bg-danger/15 text-danger">High</span></td><td>70%</td><td>8h 45min</td>
                  <td><a href="#"><i class="iconify tabler--edit size-4.5 text-default-400"></i></a></td>
                </tr>
                <!-- repeat per row; status badges: bg-success/15 text-success "Completed", bg-default-200 text-default-700 "On Hold", bg-danger/15 text-danger "Outdated" -->
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <h4 class="text-lg font-semibold text-default-800 my-7.5">My Blog Posts</h4>
      <div class="grid xl:grid-cols-3 md:grid-cols-2 gap-base">
        <article class="card">
          <div><span class="absolute top-5 start-5 badge badge-label bg-dark text-white">Technology</span></div>
          <img src="assets/images/blog/blog-4.jpg" alt="" class="rounded-t-md" />
          <div class="card-body">
            <h6 class="text-base mb-2.5"><a href="#!" class="text-default-800 hover:text-primary">The Future of Artificial Intelligence</a></h6>
            <p class="mb-5 text-default-400">Discover how AI is transforming industries…</p>
            <div class="flex flex-wrap gap-1"><a href="#!" class="badge badge-label border border-default-300">AI</a><a href="#!" class="badge badge-label border border-default-300">Technology</a></div>
            <p class="flex flex-wrap items-center gap-base text-default-400 mt-5">
              <span class="flex items-center gap-1.25"><i class="iconify tabler--calendar text-base"></i> Jan 12, 2025</span>
              <span class="flex items-center gap-1.25"><i class="iconify tabler--message-circle text-base"></i><a href="#!" class="hover:text-primary">89</a></span>
              <span class="flex items-center gap-1.25"><i class="iconify tabler--eye text-base"></i> 1,284</span>
            </p>
          </div>
          <div class="card-footer border-0">
            <div class="flex items-center gap-2.5"><img src="assets/images/users/user-4.jpg" alt="" class="size-6 rounded-full" /><div><h5><a href="#!" class="text-sm hover:text-primary">Michael Turner</a></h5></div></div>
            <div><a href="#" class="text-primary text-sm flex items-center gap-1.25">Read more <i class="iconify tabler--arrow-right"></i></a></div>
          </div>
        </article>
        <!-- repeat per post -->
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- The cover `h-62.5` (250px) and the avatar `border-5 border-default-200` are what make the header
  read as a "cover + avatar"; the avatar is **not** overlapping the cover in this demo (it sits in
  `.card-body`). For an overlapping avatar use the account-settings trick (`.card.-mt-12`).
- The "…" dropdown uses `[--auto-close:inside]` so clicking an item closes it; `hs-dropdown` needs
  `vendors.min.js` (loaded on this page).
- `data-table-sort` on `<th>` is only a hook for the table-sort helper used elsewhere; on this page there
  is no page script, so headers are not sortable as shipped.
- The social-feed rows are plain divs with `border-b border-default-200`; the demo uses `pb-2.5` on the
  first and `py-2.5` on the rest.

## Account settings form (pages-account-settings)

**What it is.** A single long form split into four titled sections (Personal Info, Address Info,
Company Info, Social) under a cover banner, in an overlapping card. It is a sectioned form, **not** a
tabbed one; each section header is a dashed, centered, uppercase label with an icon.

**Use it when.**
- "Edit profile" / "My account" screens; onboarding "complete your profile" step; vendor or customer
  detail edit form in a CRM.
- You want the cover-image + "Change Background" pattern (profile customisation).
- If you have many sections (billing, security, notifications…), convert each section into a Preline tab
  pane (`ui-tabs.html`) and keep the section markup below as the pane body.

**Source.** `references/sources/pages/pages-account-settings.html`.

**Markup.**

```html
<div class="container-fluid">
  <!-- cover banner -->
  <div class="mb-5">
    <div class="relative h-62.5 overflow-hidden rounded bg-[url('../images/profile-bg.jpg')] bg-cover bg-center" style="min-height: 300px">
      <div class="absolute inset-0 flex flex-col items-center justify-center gap-3 bg-linear-to-t from-[#313A46] via-[#313a46cc] to-[#313a4680] p-7.5 text-center">
        <h3 class="text-2xl text-white italic">"Designing the future, one template at a time" <a href="#!" class="text-primary inline-block"><i class="iconify tabler--edit text-primary"></i></a></h3>
        <button type="button" class="btn bg-danger text-white hover:bg-danger-hover">Change Background</button>
      </div>
    </div>
  </div>

  <div class="container">
    <div class="card -mt-12">               <!-- overlaps the banner -->
      <div class="card-body">
        <!-- wrap everything below in <form method="post"> in a real app; the demo has no <form> -->

        <h5 class="bg-light/15 border-default-300 mb-5 flex items-center justify-center gap-1.5 rounded border border-dashed p-1.25 text-sm uppercase"><i class="iconify tabler--user-circle text-base"></i> Personal Info</h5>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-x-base gap-y-5 mb-base">
          <div><label for="firstname" class="form-label">First Name</label><input type="text" class="form-input" id="firstname" placeholder="Enter first name" /></div>
          <div><label for="lastname" class="form-label">Last Name</label><input type="text" class="form-input" id="lastname" placeholder="Enter last name" /></div>
          <div class="col-span-1 lg:col-span-2">
            <label for="userbio" class="form-label">Bio</label>
            <textarea rows="4" class="form-textarea" id="userbio" placeholder="Write something about yourself..."></textarea>
          </div>
          <div>
            <label for="useremail" class="form-label">Email Address</label>
            <input type="email" class="form-input" id="useremail" placeholder="Enter email" />
            <span class="text-default-400 text-xs italic"><a href="#" class="hover:text-primary">Click here to change your email</a></span>
          </div>
          <div class="col-span-1 lg:col-span-2">
            <label for="profilephoto" class="form-label">Profile photo</label>
            <input type="file" name="file-input" id="profilephoto" class="form-input" />
          </div>
        </div>

        <h5 class="bg-light/15 border-default-300 mb-5 flex items-center justify-center gap-1.5 rounded border border-dashed p-1.25 text-sm uppercase"><i class="iconify tabler--map-pin text-base"></i> Address Info</h5>
        <div class="mb-5 grid grid-cols-1 lg:grid-cols-6 gap-x-base gap-y-5">
          <div class="col-span-1 lg:col-span-3"><label for="address-line1" class="form-label">Address Line 1</label><input type="text" class="form-input" id="address-line1" placeholder="Street, Apartment, Unit, etc." /></div>
          <div class="col-span-1 lg:col-span-3"><label for="address-line2" class="form-label">Address Line 2</label><input type="text" class="form-input" id="address-line2" placeholder="Optional" /></div>
          <div class="col-span-1 lg:col-span-2"><label for="city" class="form-label">City</label><input type="text" class="form-input" id="city" /></div>
          <div class="col-span-1 lg:col-span-2"><label for="state" class="form-label">State / Province</label><input type="text" class="form-input" id="state" /></div>
          <div class="col-span-1 lg:col-span-4"><label for="zipcode" class="form-label">Postal / ZIP Code</label><input type="text" class="form-input" id="zipcode" /></div>
          <div class="col-span-1 lg:col-span-6"><label for="country" class="form-label">Country</label><input type="text" class="form-input" id="country" /></div>
        </div>

        <h5 class="bg-light/15 border-default-300 mb-5 flex items-center justify-center gap-1.5 rounded border border-dashed p-1.25 text-sm uppercase"><i class="iconify tabler--world text-base"></i> Social</h5>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-x-base gap-y-5 mb-base">
          <div>
            <label for="social-fb" class="form-label">Facebook</label>
            <div class="input-group">
              <span class="input-group-text"><!-- brand svg --></span>
              <input id="social-fb" type="text" class="form-input rounded-s-none!" placeholder="Facebook URL" />
            </div>
          </div>
          <!-- repeat: Twitter X, Instagram, LinkedIn, GitHub, Dribbble -->
        </div>

        <div class="mt-7.5 text-end">
          <button type="submit" class="btn bg-success text-white hover:bg-success-hover">Save Changes</button>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- The banner's `bg-[url('../images/profile-bg.jpg')]` is resolved relative to the **CSS file**
  (`assets/css/`), which is why it is `../images/…` while `<img src>` uses `assets/images/…`.
- The demo has copy-paste mistakes: the file input is labelled "Password" and the password field's helper
  says "change your email". Fix the labels when you copy.
- `.input-group-text` + `form-input rounded-s-none!` is the add-on pattern; the `!` suffix is Tailwind
  v4 `!important`.
- Section heading = `h5.bg-light/15.border.border-dashed.rounded.uppercase.text-sm.p-1.25`; reuse it as a
  divider in any long form.

## FAQ accordion (pages-faq)

**What it is.** A centered hero (title, pill search input, "Popular searches" badges) above a two-column
grid of cards, one card per category, each holding a Preline accordion group.

**Use it when.**
- Help centre / knowledge base landing; "Before you contact support" page; onboarding tips.
- In-product policy explainers (billing, refunds) grouped by topic.
- Not for 100+ questions: there is no client-side search wired up, so put real search behind the input
  (server round-trip or filter the `.hs-accordion` elements by text yourself).

**Source.** `references/sources/pages/pages-faq.html`. Preline `hs-accordion` (in `vendors.min.js`).

**Markup.**

```html
<div class="container-fluid">
  <div class="mx-auto 2xl:w-9/12">
    <!-- hero -->
    <div class="my-7.5">
      <div class="lg:w-5/12 md:w-8/12 mx-auto">
        <div class="text-center">
          <h3 class="text-xl font-bold mb-7.5">Frequently Asked Questions</h3>
          <div class="input-icon-group mb-5">
            <i class="iconify tabler--search text-lg text-default-400 input-icon"></i>
            <input type="text" class="py-2.5 ps-10 pe-3 rounded-full text-sm w-full border border-default-300 placeholder:text-default-400 focus:border-default-500 focus:ring-0 bg-card" placeholder="Search Questions..." />
          </div>
          <div class="flex justify-center items-center gap-1.25">
            <h5 class="text-default-400">Popular Searches :</h5>
            <a href="#!" class="badge bg-primary/10 rounded-full text-primary text-xs">Apps</a>
            <a href="#!" class="badge bg-primary/10 rounded-full text-primary text-xs">Billing</a>
          </div>
        </div>
      </div>
    </div>

    <div class="grid lg:grid-cols-2 grid-cols-1 gap-base">
      <!-- one card per category -->
      <div class="card">
        <div class="card-header block">
          <h4 class="card-title mb-1.25">General</h4>
          <p class="text-default-400">Here are some common questions about our templates.</p>
        </div>
        <div class="card-body">
          <div class="hs-accordion-group flex flex-col gap-2">
            <div class="hs-accordion" id="generalHeadingOne">
              <button class="hs-accordion-toggle bg-default-100 font-secondary flex w-full items-center justify-between rounded px-5 py-4 text-start text-sm font-semibold disabled:pointer-events-none disabled:opacity-50" aria-expanded="false" aria-controls="generalCollapseOne">
                What is included in your template purchase?
                <i class="iconify tabler--chevron-down hs-accordion-active:rotate-180 transition-transform text-base"></i>
              </button>
              <div id="generalCollapseOne" class="hs-accordion-content hidden w-full overflow-hidden transition-[height] duration-300" role="region" aria-labelledby="generalHeadingOne">
                <div class="px-5 py-4">Our templates come with clean source code, comprehensive documentation…</div>
              </div>
            </div>
            <!-- repeat .hs-accordion per question; ids must be unique page-wide -->
          </div>
        </div>
      </div>
      <!-- repeat card per category (Payments, Refunds, Customization) -->
    </div>
  </div>
</div>
```

**Init / JS.** None beyond Preline autoinit. To open one item by default add `active` to its
`.hs-accordion` and remove `hidden` from its `.hs-accordion-content`. The demo uses the default
`hs-accordion-group` behaviour with no extra `data-hs-accordion-*` options; consult the Preline docs if
you need several panels open at once.

**Gotchas.**
- Every toggle must have a matching `aria-controls` / content `id` and the content must have
  `aria-labelledby` pointing back at the `.hs-accordion` id — Preline uses these to pair them.
- The demo ships `aria-expanded="true"` on every button while all panels are `hidden`; set it to
  `"false"` so screen readers are not lied to.
- `card-header block` (instead of flex) lets the header hold a title + description stacked.
- The search box is a styled `<input>` with no JS. Minimal client filter: on `input`, loop
  `.hs-accordion`, toggle `hidden` on those whose `textContent` does not match.

## Pricing tiers (pages-pricing)

**What it is.** Three plan cards in a `.container`, the middle one highlighted with a coloured border
and a floating "Popular Choice" badge; each card has a title, blurb, big price, two small lines,
feature list with check / cross icons and a full-width rounded CTA.

**Use it when.**
- SaaS plan picker inside the app (upgrade / billing page), marketplace license tiers, add-on packages.
- Any 2–4 option comparison where a single CTA per option is enough.
- The demo has **no monthly / yearly toggle**. If you need one, add a `form-switch` above the grid and
  swap the `<h1>` price text (or render two grids and toggle `hidden`) — there is no helper for it.

**Source.** `references/sources/pages/pages-pricing.html`.

**Markup.**

```html
<div class="container">
  <div class="text-center">
    <h3 class="font-bold text-xl mt-7.5 mb-2">Find the Perfect Fit</h3>
    <div class="text-primary flex justify-center"><!-- decorative svgs --></div>
    <p class="italic mb-4 text-md">Not sure which plan suits you best? Check out our Pricing Guide for detailed insights.</p>
  </div>

  <div class="my-15 xl:px-7.5">
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-base">
      <!-- plain tier -->
      <div class="card h-full rounded-xl">
        <div class="card-body lg:px-7.5 p-15 pb-2.5 text-center">
          <div class="text-center">
            <h3 class="font-bold mb-1.25 text-xl">Free Plan</h3>
            <p class="text-default-400">Great for solo developers trying things out</p>
          </div>
          <div class="my-7.5">
            <h1 class="lg:text-[40px] md:text-[33px] text-[27px] font-bold">$0</h1>
            <small class="block text-default-400 text-sm font-medium">No credit card required</small>
            <small class="block text-default-400 text-sm font-medium">Free forever</small>
          </div>
          <ul class="text-start text-sm font-medium">
            <li class="mb-2.5"><i class="iconify tabler--check text-success me-2.5"></i> 1 user license</li>
            <li class="mb-2.5"><i class="iconify tabler--x text-danger me-2"></i> No commercial use</li>
            <!-- repeat -->
          </ul>
        </div>
        <div class="card-footer bg-transparent border-0 px-15 pb-7.5">
          <a href="#!" class="btn bg-dark text-white w-full py-2.5 font-semibold rounded-full">Start Free</a>
        </div>
      </div>

      <!-- highlighted tier -->
      <div class="card h-full border-success border-2 rounded-xl">
        <div class="card-body lg:px-7.5 p-15 pb-2.5 text-center">
          <!-- same inner structure; price $129 -->
        </div>
        <div class="card-footer bg-transparent border-0 px-15 pb-7.5">
          <a href="#!" class="btn bg-primary text-white w-full py-2.5 font-semibold rounded-full hover:bg-primary-hover">Upgrade Now</a>
        </div>
        <span class="absolute text-xs top-0 inset-s-1/2 -translate-x-1/2 left-1/2 badge bg-primary/15 text-primary rounded-full px-3 py-1.5 mt-5 leading-normal">Popular Choice</span>
      </div>

      <!-- third tier: same as the plain one, CTA "Contact Sales" -->
    </div>
  </div>
</div>
```

**Gotchas.**
- The demo's feature lists carry leftover Bootstrap classes (`list-unstyled`, `fs-sm`, `fw-medium`,
  `fs-5`, `mb-0`) that do nothing in this build; drop them.
- The badge is positioned against `.card` (which is `relative`); keep `absolute top-0 left-1/2 -translate-x-1/2`.
- `h-full` on the cards + the grid makes the three cards equal height; the CTA sits in `.card-footer`
  so it aligns across cards even with different feature counts.

## Timeline (pages-timeline)

**What it is.** A vertical timeline built from flex rows: optional time column, a connector column whose
dashed vertical line is a CSS `after:` pseudo-element, a marker (dot / icon circle / dashed circle /
avatar) and a content column. Four variants ship on one page: Basic (dots), With Icons, With Border
(dashed circles), With Users (avatars, no time column).

**Use it when.**
- Audit trail / activity log on a record (who changed what, when) — Basic or With Users.
- Order / shipment history, ticket conversation history, approval chain — With Icons (icon per event type).
- Product changelog / release notes — With Border.
- Not for horizontal step progress: use a Preline `hs-stepper` instead.

**Source.** `references/sources/pages/pages-timeline.html`. No JS, no plugin.

**Markup — one row of each variant.**

```html
<div class="card">
  <div class="card-header"><h4 class="card-title">Basic Timeline</h4></div>
  <div class="card-body">
    <div>
      <!-- ROW (dot marker). after:top-3 for a dot -->
      <div class="flex gap-x-base">
        <div class="w-15 text-end md:w-25"><span class="text-default-400">Just Now</span></div>
        <div class="after:border-default-300 relative after:absolute after:start-1/2 after:top-3 after:bottom-0 after:w-px after:border-e -ms-px after:border-dashed last:after:hidden">
          <div class="relative z-10 flex items-center justify-center">
            <div class="bg-primary ms-0.5 size-3.25 rounded-full"></div>
          </div>
        </div>
        <div class="flex-1 pb-7.5">
          <h5 class="mb-1.25">Weekly Stand-Up Meeting</h5>
          <p class="text-default-400 mb-1.25">Team members shared updates, discussed blockers, and aligned on weekly goals.</p>
          <span class="text-primary font-semibold">By Olivia Rodriguez</span>
        </div>
      </div>

      <!-- ROW (icon marker, solid). after:top-4 for a 7.5 circle -->
      <div class="flex gap-x-base">
        <div class="w-15 text-end md:w-25"><span class="text-default-400">5 mins ago</span></div>
        <div class="after:border-default-300 relative after:absolute after:start-1/2 after:top-4 after:bottom-0 after:w-px after:border-e -ms-px after:border-dashed last:after:hidden">
          <div class="relative z-10 flex items-center justify-center">
            <div class="bg-primary flex size-7.5 items-center justify-center rounded-full"><i class="iconify tabler--bug text-lg text-white"></i></div>
          </div>
        </div>
        <div class="flex-1 pb-7.5">…</div>
      </div>

      <!-- ROW (icon marker, soft): -->
      <!--   <div class="flex size-7.5 items-center justify-center rounded-full bg-red-100"><i class="iconify tabler--phone-call text-danger text-lg"></i></div> -->
      <!-- ROW (dashed border marker, "With Border"; after:top-8): -->
      <!--   <div class="border-default-300 flex size-7.5 items-center justify-center rounded-full border border-dashed"><i class="iconify tabler--rocket text-default-400 text-lg"></i></div> -->
      <!-- ROW (avatar marker, "With Users"; no time column; after:top-8): -->
      <!--   <div class="relative z-10"><img src="assets/images/users/user-1.jpg" alt="" class="size-7.5 rounded-full" /></div> -->

      <!-- LAST ROW: connector column has NO after:* classes, content has no pb -->
      <div class="flex gap-x-base">
        <div class="w-15 text-end md:w-25"><span class="text-default-400">Last Friday, 4:30 PM</span></div>
        <div>
          <div class="relative z-10 flex items-center justify-center">
            <div class="bg-secondary ms-0.5 size-3.25 rounded-full"></div>
          </div>
        </div>
        <div class="flex-1">…</div>
      </div>
    </div>
  </div>
</div>
```

Variant table:

| Variant | Marker | `after:top-*` on connector | Time column |
|---|---|---|---|
| Basic | `bg-{color} ms-0.5 size-3.25 rounded-full` | `after:top-3` (first row) / `after:top-0` (others) | yes |
| With Icons | `bg-{color} flex size-7.5 … rounded-full > i.text-white` or `bg-red-100 / bg-sky-100 > i.text-danger / text-info` | `after:top-4` (first) / `after:top-0` | yes |
| With Border | `border-default-300 flex size-7.5 … rounded-full border border-dashed > i.text-default-400` | `after:top-8` | yes |
| With Users | `img.size-7.5.rounded-full` in `div.relative.z-10` | `after:top-8` | no |

**Gotchas.**
- The vertical line is the connector column's `after:` pseudo (`after:absolute after:start-1/2
  after:w-px after:border-e after:border-dashed`); the content column's `pb-7.5` is what gives it
  height. Drop `pb-7.5` on the last row and remove the `after:*` classes so the line stops at the last
  marker (`last:after:hidden` only works if the rows are direct siblings of one parent, which they are).
- `after:top-3 / top-4 / top-8` must match the marker height, otherwise the line pokes above the marker.
- Colours are per-row (`bg-primary`, `bg-danger`, `bg-warning`, `bg-info`, `bg-secondary`); map them to
  event types (created / updated / deleted / comment / system).
- The `w-15 … md:w-25` time column is fixed width so content aligns; keep times short or use `text-xs`.

## Gallery with lightbox + filter (pages-gallery)

**What it is.** A card with a search box and category filter buttons in the header and a Muuri
masonry grid in the body; every tile is an image with a hover overlay holding a category badge and a
"View" button that opens the full image in a GLightbox lightbox. Tiles are draggable.

**Use it when.**
- Media library / asset browser in a CMS; product photo manager; design-review board; portfolio grid.
- Attachments gallery on a project or ticket (filter by type instead of category).
- Not for very large libraries (it is client-side only; render pages of ~60 tiles).

**Source.** `references/sources/pages/pages-gallery.html`, `assets/js/pages/pages-gallery.js`, plugins
`assets/plugins/glightbox/glightbox.min.css`, `glightbox.min.js`,
`assets/plugins/web-animations/web-animations.min.js`, `assets/plugins/muuri/muuri.min.js`
(the plugin folders are listed in `MANIFEST-plugins.txt` but are not vendored locally).

**Markup.**

```html
<div class="container-fluid">
  <div class="card">
    <div class="card-header">
      <div>
        <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input type="text" name="search" class="form-input" placeholder="Search..." /></div>
      </div>
      <div class="filter-buttons button flex items-center gap-1.5">
        <button class="btn btn-sm font-semibold text-sm text-primary hover:bg-primary hover:text-white [.active]:bg-primary/20 [.active]:text-primary active" data-filter="">All</button>
        <button class="btn btn-sm font-semibold text-sm text-primary hover:bg-primary hover:text-white [.active]:bg-primary/20 [.active]:text-primary" data-filter="machine-learning">Machine Learning</button>
        <!-- repeat per category: data-filter must equal the tiles' data-category -->
      </div>
    </div>
    <div class="card-body">
      <div id="grid" class="muuri relative flex flex-wrap md:*:w-1/2 lg:*:w-1/5 -mx-1.5">
        <!-- TILE (repeat) -->
        <div class="absolute px-1.5 mb-3" data-category="machine-learning">
          <div class="group relative overflow-hidden rounded-md">
            <img src="assets/images/gallery/1.jpg" alt="Machine Learning" class="h-auto w-full rounded-md" />
            <div class="absolute flex items-center justify-center inset-0 bg-black/60 opacity-0 transition-opacity duration-300 group-hover:opacity-100">
              <span class="badge badge-label bg-dark text-white absolute start-6 top-6 z-40">Machine Learning</span>
              <a href="assets/images/gallery/1.jpg" class="image-popup btn btn-sm bg-primary text-center text-white">View</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/pages-gallery.js` (loaded after the three plugins):

```js
let lightbox = GLightbox({ selector: ".image-popup", title: false });

let gridElement = document.getElementById("grid"), grid = null;
if (gridElement) {
  grid = new Muuri(gridElement, { dragEnabled: true, layout: { rounding: false } });

  // text search: matches the tile's textContent (badge label + alt text)
  const search = document.querySelector('input[name="search"]');
  search && search.addEventListener("input", e => {
    const q = e.target.value.toLowerCase();
    grid.filter(item => item.getElement().textContent.toLowerCase().includes(q));
  });

  // category buttons
  const buttons = document.querySelectorAll(".filter-buttons button");
  buttons.forEach(btn => btn.addEventListener("click", () => {
    const f = btn.dataset.filter;                       // "" = all
    grid.filter(item => !f || item.getElement().dataset.category === f);
    buttons.forEach(b => b.classList.remove("active"));
    btn.classList.add("active");
  }));
}
```

**Gotchas.**
- The search input must have `name="search"` (the demo markup omits it — the script's
  `querySelector('input[name="search"]')` finds nothing as shipped; add the attribute).
- Tiles must be `absolute` children of `#grid` (Muuri positions them); widths come from the parent's
  child-variant classes `md:*:w-1/2 lg:*:w-1/5`. `.muuri`, `.image-popup`, `.filter-buttons` have no CSS
  — they are JS hooks only.
- `dragEnabled: true` makes every tile draggable; for a read-only media library set it to `false` or
  clicks on the overlay can register as drags.
- After adding tiles dynamically: `grid.add(el); grid.refreshItems().layout();` then rebuild the
  lightbox (`lightbox.reload()`), because GLightbox binds on init.
- Active filter style is the `[.active]:` arbitrary variant — the button needs the literal `active` class.

## Sitemap tree (pages-sitemap)

**What it is.** Three cards, each an uppercase heading and a nested `<ul>` drawn as a dashed tree: the
vertical trunk is each `<li>`'s `before:` pseudo, the horizontal tick is the link's (top level) or the
`<li>`'s (nested) `after:` pseudo. Optional icons and coloured top-level links.

**Use it when.**
- HTML sitemap / "all pages" index; permission or menu-structure overview in an admin; documentation
  table of contents; org-chart-lite.
- For an interactive, collapsible tree with checkboxes use jsTree as on `plugins-tree-view.html` (plugins-and-icons.md); Preline's `hs-tree-view` is in the bundle but not demonstrated.

**Source.** `references/sources/pages/pages-sitemap.html`. No JS.

**Markup.**

```html
<div class="container-fluid">
  <div class="grid grid-cols-1 md:grid-cols-2 gap-base lg:grid-cols-3">
    <div class="card">
      <div class="card-body">
        <h5 class="font-bold uppercase">AI Dashboards</h5>
        <ul class="relative mt-5 list-none">
          <!-- top-level item WITH children -->
          <li class="before:border-default-300 relative before:absolute before:start-2 before:top-0 before:bottom-0 before:border-s before:border-dashed before:content-['']">
            <a href="#" class="after:border-default-300 hover:text-primary relative z-10 inline-block ps-8 font-semibold transition-all after:absolute after:start-2 after:top-3 after:w-4 after:border-t after:border-dashed">Analytics</a>
            <ul class="relative list-none space-y-1 ps-8 pt-2 pb-3">
              <li class="before:border-default-300 after:border-default-300 hover:text-primary relative transition-all before:absolute before:start-2 before:top-0 before:bottom-0 before:border-s before:border-dashed before:content-[''] after:absolute after:start-2 after:top-3 after:w-4 after:border-t after:border-dashed"><a href="#" class="relative z-10 inline-block ps-8">Model Metrics</a></li>
              <!-- LAST child: before:h-3 stops the trunk at the tick -->
              <li class="before:border-default-300 after:border-default-300 hover:text-primary relative transition-all before:absolute before:start-2 before:top-0 before:bottom-0 before:h-3 before:border-s before:border-dashed before:content-[''] after:absolute after:start-2 after:top-3 after:w-4 after:border-t after:border-dashed"><a href="#" class="relative z-10 inline-block ps-8">Data Pipelines</a></li>
            </ul>
          </li>
          <!-- top-level item with icon (flex instead of inline-block) -->
          <li class="before:border-default-300 relative before:absolute before:start-2 before:top-0 before:bottom-0 before:border-s before:border-dashed before:content-['']">
            <a href="#" class="after:border-default-300 hover:text-primary relative z-10 flex items-center gap-2 ps-8 font-semibold transition-all after:absolute after:start-2 after:top-3 after:w-4 after:border-t after:border-dashed"><i class="iconify tabler--calendar text-default-400"></i> Training Scheduler</a>
          </li>
          <!-- LAST top-level item: before:h-3 -->
          <li class="before:border-default-300 relative before:absolute before:start-2 before:top-0 before:bottom-0 before:h-3 before:border-s before:border-dashed before:content-['']">
            <a href="#" class="after:border-default-300 hover:text-primary relative z-10 inline-block ps-8 font-semibold transition-all after:absolute after:start-2 after:top-3 after:w-4 after:border-t after:border-dashed">Create Account</a>
          </li>
        </ul>
      </div>
    </div>
    <!-- repeat card per section -->
  </div>
</div>
```

**Gotchas.**
- The last `<li>` at every level needs `before:h-3` (instead of `before:bottom-0`) or the trunk runs
  past the last tick.
- Coloured top-level links in the third card simply swap `hover:text-primary` for `text-primary` /
  `text-info` / `text-danger` / `text-dark` and drop `transition-all`.
- Links are `relative z-10` so the dashed pseudo-lines are drawn under the text.

## Search results list (pages-search-results)

**What it is.** One card: a centered large pill search bar with an attached "Discover" button and popular
chips; a header row with the result count and filter selects; a borderless result list (title link,
green URL, snippet, meta row with avatar/date/users/feedback/rating), with interstitial blocks
("Featured creators" avatar row, "People also search for" chips); a rounded pagination footer.

**Use it when.**
- Global search results page in an admin (people, documents, tickets); app / integration marketplace
  search; knowledge-base search results.
- The "interstitial block" pattern is handy for surfacing related entities between result groups.

**Source.** `references/sources/pages/pages-search-results.html`. No JS.

**Markup.**

```html
<div class="container-fluid">
  <div class="card">
    <!-- search hero -->
    <div class="card-body">
      <div class="mx-auto py-6 text-center xl:w-1/2 md:w-3/4">
        <div class="input-icon-group mb-base">
          <i class="iconify tabler--search input-icon"></i>
          <input type="text" value="AI Content Tools" placeholder="Search AI platforms..." class="form-input form-input-lg rounded-s-full! font-semibold" />
          <button type="button" class="btn btn-lg text-base rounded-s-none rounded-e-full bg-secondary text-white -ms-px hover:bg-secondary-hover">Discover</button>
        </div>
        <div class="flex flex-wrap items-center justify-center gap-1.25 text-sm">
          <h5 class="text-default-400">Popular Searches :</h5>
          <a href="#!" class="bg-primary/15 text-primary inline-flex items-center rounded-full px-3 py-1 text-xs font-bold">Text Generation</a>
        </div>
      </div>
    </div>

    <!-- count + filters -->
    <div class="card-header">
      <h4 class="text-default-400 text-lg italic">Found <span class="badge bg-danger/15 text-danger font-bold">72</span> results for <span class="text-default-800 font-medium">"AI Content Tools"</span></h4>
      <div class="flex flex-wrap items-center gap-3">
        <span class="font-semibold me-3">Filter By:</span>
        <div class="input-icon-group"><i class="iconify tabler--cpu input-icon"></i>
          <select class="form-select"><option selected>Tool Type</option><option value="chatbot">Chatbot</option></select></div>
        <div class="input-icon-group"><i class="iconify tabler--wallet input-icon"></i>
          <select class="form-select"><option selected>Pricing</option><option value="free">Free</option></select></div>
      </div>
    </div>

    <!-- results -->
    <div class="card-body p-0">
      <div class="border-default-300 border-b border-dashed px-7.5 py-5">
        <h4 class="mb-1.25 text-base font-medium"><a href="#!" target="_blank" class="card-title">NeuroVision AI – Smart Analytics Dashboard</a></h4>
        <p class="text-success mb-2.5 text-sm">https://example.com/neurovision-ai</p>
        <p class="text-default-400 mb-2.5 text-sm">NeuroVision AI is a powerful analytics platform that uses <span class="font-bold">machine learning</span> to …</p>
        <p class="text-sm text-default-500 mb-1.25 flex flex-wrap items-center gap-base">
          <span class="flex items-center gap-1.25"><img src="assets/images/users/user-4.jpg" alt="" class="size-6 rounded-full object-cover" /><a href="#!" class="text-default-400 hover:text-primary font-semibold">Alex Johnson</a></span>
          <span class="text-default-400 flex items-center gap-1"><i class="iconify tabler--calendar"></i><span>Published on: Aug 10, 2025</span></span>
          <span class="text-default-400 flex items-center gap-1"><i class="iconify tabler--users"></i><span>Users: 3,200+</span></span>
          <span class="text-default-400 flex items-center gap-1"><i class="iconify tabler--message-circle"></i><a href="#!" class="hover:text-primary">Feedback: 145</a></span>
          <span class="text-default-400 flex items-center gap-1"><i class="iconify tabler--star"></i><span>Rating: 4.9</span></span>
        </p>
      </div>
      <!-- repeat per result -->

      <!-- interstitial: featured people -->
      <div class="border-default-300 border-b border-dashed px-7.5 py-5">
        <h4 class="card-title mb-base">Featured AI Creators:</h4>
        <div class="flex items-center gap-3">
          <div class="avatar"><img src="assets/images/users/user-4.jpg" alt="" class="size-12 rounded" /></div>
          <!-- repeat -->
        </div>
      </div>

      <!-- interstitial: related searches (last block has no border-b) -->
      <div class="px-7.5 py-5">
        <h4 class="card-title mb-base">People also search for:</h4>
        <div class="flex flex-wrap items-center gap-3">
          <a href="#" class="btn bg-light/50 text-md">AI SaaS Platforms <i class="iconify tabler--search"></i></a>
        </div>
      </div>
    </div>

    <!-- pagination -->
    <div class="card-footer">
      <nav class="mx-auto flex items-center justify-center gap-1.25" aria-label="Pagination">
        <button type="button" class="btn btn-icon size-8.5! border-default-300 rounded-full border" aria-label="Previous"><i class="iconify tabler--chevron-left"></i></button>
        <button type="button" class="btn btn-icon size-8.5! border-default-300 bg-primary rounded-full border text-white" aria-current="page">1</button>
        <button type="button" class="btn btn-icon size-8.5! border-default-300 rounded-full border">2</button>
        <button type="button" class="btn btn-icon size-8.5! border-default-300 rounded-full border">...</button>
        <button type="button" class="btn btn-icon size-8.5! border-default-300 rounded-full border" aria-label="Next"><i class="iconify tabler--chevron-right"></i></button>
      </nav>
    </div>
  </div>
</div>
```

**Gotchas.**
- `input-icon-group` positions `.input-icon:first-child` absolutely at `start-3`; the icon must be the
  first child and the input gets its padding from `.form-input` defaults (the FAQ page overrides with
  `ps-10` because it uses a custom input).
- The pill bar = `form-input-lg rounded-s-full!` + `btn-lg rounded-s-none rounded-e-full -ms-px`.
- Highlight matched terms with `<span class="font-bold">` inside the snippet (what the demo does).
- Pagination buttons are plain `btn btn-icon size-8.5!`; the active page is the one with
  `bg-primary text-white` and `aria-current="page"`.

## Coming soon countdown (pages-coming-soon)

**What it is.** A chrome-less page (no `<main>`, no sidebar): one rounded card split 1/2 — left: logo,
heading, blurb, a 4-tile countdown (days / hours / minutes / seconds), a gradient "Stay tuned" line and a
"Notify me" email input; right: a cover image with a dark gradient overlay (hidden below `lg`).

**Use it when.**
- Pre-launch landing, feature "coming soon" placeholder behind a nav item, beta waitlist.
- For a planned-outage page use `error-maintenance` instead (no countdown, no email capture).

**Source.** `references/sources/pages/pages-coming-soon.html` (88 lines, self-contained),
`assets/js/pages/coming-soon.js`. Loads only `config.js` + `coming-soon.js`.

**Markup.**

```html
<body>
<div class="flex min-h-screen items-center p-12.5">
  <div class="container">
    <div class="flex justify-center">
      <div class="xl:w-5/6">
        <div class="card rounded-2xl">
          <div class="grid grid-cols-1 lg:grid-cols-2">
            <div class="card-body relative p-12.5">
              <div class="mb-7.5 flex flex-col items-center justify-center text-center">
                <a href="index.html" class="auth-logo">
                  <img src="assets/images/logo-black.png" alt="logo" class="flex dark:hidden" />
                  <img src="assets/images/logo.png" alt="dark logo" class="hidden dark:flex" />
                </a>
                <h4 class="mt-5 mb-2 text-base font-bold">Big things are on the Way</h4>
                <p class="text-default-400 mx-auto w-full lg:w-3/4">We're working hard to bring you something amazing. Stay tuned!</p>
              </div>

              <div class="my-7.5">
                <div class="grid grid-cols-2 gap-2.5 lg:grid-cols-4">
                  <div class="bg-default-50/10 text-primary rounded px-3 py-6 text-center">
                    <h2 id="days" class="mb-2 text-4xl font-bold">00</h2>
                    <p class="font-semibold text-default-800 text-xs">Days</p>
                  </div>
                  <!-- repeat with id="hours", id="minutes", id="seconds" -->
                </div>
              </div>

              <div class="bg-[linear-gradient(90deg,#6658dd_0%,#f1556c_100%)] bg-clip-text text-center text-lg! font-bold text-transparent">Stay tuned!</div>

              <div class="relative mx-auto mt-5 flex w-auto items-center overflow-hidden rounded-md lg:w-sm">
                <input type="text" placeholder="Enter email..." class="border-default-300 text-default-500 w-full rounded-md border py-3 ps-10 pe-28 text-sm font-semibold" />
                <i class="iconify tabler--mail text-default-400 absolute start-3 text-lg"></i>
                <button type="button" class="bg-secondary absolute end-0 rounded-md rounded-s-none px-6 py-3.25 text-sm font-medium text-white transition">Notify me!</button>
              </div>
            </div>

            <div class="relative hidden h-full overflow-hidden rounded-e-2xl bg-cover bg-center object-cover lg:block" style="background-image: url('assets/images/auth.jpg')">
              <div class="absolute inset-0 flex items-end justify-center rounded-e-sm p-9 [background:linear-gradient(to_top,#313a46,rgba(49,58,70,.8),rgba(49,58,70,.5))]"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="assets/js/pages/coming-soon.js"></script>
</body>
```

**Init / JS.** `assets/js/pages/coming-soon.js` — the whole script, de-minified:

```js
class Countdown {
  initCountDown() {
    const d = document.getElementById("days"), h = document.getElementById("hours"),
          m = document.getElementById("minutes"), s = document.getElementById("seconds");
    if (!(d && h && m && s)) return;
    const target = new Date("Sep 27, 2028 12:00:01").getTime();   // hard-coded launch date
    const timer = setInterval(() => {
      const diff = target - Date.now();
      d.innerHTML = Math.floor(diff / 864e5);
      h.innerHTML = Math.floor((diff % 864e5) / 36e5);
      m.innerHTML = Math.floor((diff % 36e5) / 6e4);
      s.innerHTML = Math.floor((diff % 6e4) / 1e3);
      if (diff < 0) {
        clearInterval(timer);
        d.innerHTML = h.innerHTML = m.innerHTML = s.innerHTML = "";
        const end = document.getElementById("end");               // not present in the markup
        if (end) end.innerHTML = "00:00:00:00";
      }
    }, 1000);
  }
  init() { this.initCountDown(); }
}
document.addEventListener("DOMContentLoaded", () => new Countdown().init());
```

**Gotchas.**
- Change the launch date in the script (or read it from a `data-deadline` attribute); the numbers are not
  zero-padded (`7`, not `07`) — pad with `String(n).padStart(2,"0")` if you want the demo's `00` look.
- The demo tiles use `bg-opacity-10`, a Tailwind v3 utility that is a no-op in this v4 build; use
  `bg-default-50/10` (shown above).
- The "Notify me" button has no handler and there is no `<form>`; wrap the input in a form that posts to
  your waitlist endpoint.
- Demo copy says "Stay tunned!" — fix the typo.

## Legal text pages (pages-privacy-policy, pages-terms-conditions)

**What it is.** A `.container` with one `.card` of long-form text: an italic intro paragraph, numbered
`h4` section headings, paragraphs, `list-disc` bullet lists, a contact email and an "Effective Date"
footer line. A decorative `auth-card-bg.svg` sits top-right at 70% opacity.

**Use it when.**
- Privacy policy, terms of service, cookie policy, acceptable-use policy, SLA, licence text, any
  "read-only document" page inside the app (release notes, changelog prose).
- Link them from the sign-up "Agree the Terms & Policy" checkbox.

**Source.** `references/sources/pages/pages-privacy-policy.html`, `pages-terms-conditions.html`.

**Markup (privacy layout: flat; terms layout: one `<div>` per section with `gap-y-7.5`).**

```html
<div class="container">
  <div class="card relative">
    <div class="card-body">
      <div class="absolute end-0 top-0"><img src="assets/images/auth-card-bg.svg" class="w-full opacity-70" alt="" /></div>

      <!-- privacy-policy style: flat flow -->
      <div class="flex flex-col">
        <p class="italic">This Privacy Policy explains how we collect, use, and safeguard your personal information…</p>
        <h4 class="mb-2 mt-5 text-lg font-bold">1. Information We Collect</h4>
        <p>We may collect personal details such as your name, email address, payment information…</p>
        <h4 class="mb-2 mt-7.5 text-lg font-bold">6. Your Rights</h4>
        <ul class="list-disc space-y-1 ps-8">
          <li>Access, update, or delete your personal data.</li>
          <li>Opt out of marketing communications at any time.</li>
        </ul>
        <h4 class="mb-2 mt-7.5 text-lg font-bold">9. Contact Us</h4>
        <p class="mb-4">If you have any questions, please contact us at <a href="mailto:privacy@example.com" class="text-primary">privacy@example.com</a>.</p>
        <p class="text-default-400 italic">Effective Date: April 19, 2025</p>
      </div>

      <!-- terms-conditions style: sectioned -->
      <!--
      <p class="mb-5 italic">Welcome to our website. By accessing or using this site…</p>
      <div class="flex flex-col gap-y-7.5">
        <div>
          <h4 class="mb-2 text-lg font-bold">1. Acceptance of Terms</h4>
          <p>…</p>
        </div>
        <div>
          <h4 class="mb-2 text-lg font-bold">7. License Types</h4>
          <h5>Single License</h5>
          <ul class="list-disc ps-8 text-sm/6 mt-3"><li>Restricted to a single installation.</li></ul>
        </div>
      </div>
      -->
    </div>
  </div>
</div>
```

**Gotchas.**
- The decorative svg is `absolute end-0 top-0` inside `.card.relative`; it is purely cosmetic and can be
  removed.
- `text-sm/6` is the Tailwind v4 font-size/line-height shorthand (14px / 1.5rem).
- Prefer the terms-style sectioning (`gap-y-7.5` + one div per section) when sections are deep-linked
  (`id` on each section div).

## Auth layout families (shared skeletons)

**What it is.** All 27 auth pages are one of three wrappers around the same inner form. They are
chrome-less: `<body>` contains only the auth wrapper (plus the inert theme-customizer markup). Each
family exists for all nine flows: `auth-<flow>.html`, `auth-card-<flow>.html`, `auth-split-<flow>.html`.

**Use it when.**
- **Basic** (centered card, ~40% width): default for internal admins and anything that must stay simple.
- **Card** (one rounded card, form left, cover image right): marketing-flavoured products, white-label
  portals where a brand image is wanted.
- **Split** (image fills the viewport, fixed-width form panel on the right): SaaS products, when the
  image carries messaging; also the best fit for very tall forms (the panel scrolls, the image stays).

**Source.** `auth-sign-in.html`, `auth-card-sign-in.html`, `auth-split-sign-in.html` (and the same
three for every flow). The inner forms were diffed across families: identical fields, ids and links;
card/split variants wrap inputs in `input-icon-group` with an icon, split adds `mt-9` on the form and
`mb-6` between fields, and in-family links point to the same family (`auth-card-reset-pass.html`,
`auth-split-sign-up.html`, …).

**All 27 auth files.** basic: `auth-sign-in`, `auth-sign-up`, `auth-reset-pass`, `auth-new-pass`, `auth-two-factor`, `auth-lock-screen`, `auth-success-mail`, `auth-login-pin`, `auth-delete-account`; card: `auth-card-sign-in`, `auth-card-sign-up`, `auth-card-reset-pass`, `auth-card-new-pass`, `auth-card-two-factor`, `auth-card-lock-screen`, `auth-card-success-mail`, `auth-card-login-pin`, `auth-card-delete-account`; split: `auth-split-sign-in`, `auth-split-sign-up`, `auth-split-reset-pass`, `auth-split-new-pass`, `auth-split-two-factor`, `auth-split-lock-screen`, `auth-split-success-mail`, `auth-split-login-pin`, `auth-split-delete-account` (all `.html` under `references/sources/pages/`).

**Markup — family A: basic centered.**

```html
<body>
<div class="flex min-h-screen items-center p-12.5">
  <div class="container">
    <div class="flex justify-center px-2.5">
      <div class="2xl:w-4/10 md:w-1/2 sm:w-2/3 w-full">

        <div class="mb-3 flex flex-col items-center justify-center text-center">
          <a href="index.html" class="auth-logo">
            <img src="assets/images/logo-black.png" alt="logo" class="flex dark:hidden" />
            <img src="assets/images/logo.png" alt="dark logo" class="hidden dark:flex" />
          </a>
          <h4 class="font-bold text-base text-dark mt-5 mb-2">Welcome</h4>
          <p class="text-default-400 mx-auto w-full lg:w-3/4 mb-4">Let's get you signed in. Enter your email and password to continue.</p>
        </div>

        <div class="card p-7.5 rounded-2xl">
          <form action="index.html">
            <!-- FLOW FIELDS (see per-flow sections) -->
          </form>
          <p class="text-default-400 mt-7.5 text-center">New here? <a href="auth-sign-up.html" class="text-primary font-semibold underline underline-offset-4">Create an account</a></p>
        </div>

        <p class="text-default-400 mt-7.5 text-center">&copy; <span data-current-year></span> Inspinia - by <span>WebAppLayers</span></p>
      </div>
    </div>
  </div>
</div>
</body>
```

**Markup — family B: card with side image.**

```html
<div class="flex min-h-screen items-center p-12.5">
  <div class="container">
    <div class="flex justify-center">
      <div class="xl:w-5/6">
        <div class="card rounded-2xl">
          <div class="grid grid-cols-1 lg:grid-cols-2">
            <div class="card-body relative p-12.5">
              <div class="mb-7.5 flex flex-col items-center justify-center text-center">
                <a href="index.html" class="auth-logo"><!-- logo swap as above --></a>
                <h4 class="mt-7.5 mb-2 text-base font-bold">Welcome to Admin</h4>
                <p class="text-default-400 mx-auto w-full lg:w-3/4">Let's get you signed in. Enter your email and password to continue.</p>
              </div>
              <div class="rounded-md">
                <form action="index.html">
                  <div class="mb-5">
                    <label for="userEmail" class="form-label">Email address <span class="text-danger">*</span></label>
                    <div class="input-icon-group"><i class="iconify tabler--mail input-icon"></i><input type="email" class="form-input" id="userEmail" placeholder="you@example.com" required /></div>
                  </div>
                  <!-- password: tabler--lock-password ; name: tabler--user -->
                </form>
                <p class="text-default-400 mt-7.5 text-center">New here? <a href="auth-card-sign-up.html" class="text-primary font-semibold underline underline-offset-4">Create an account</a></p>
                <p class="text-default-400 mt-7.5 text-center">&copy; <span data-current-year></span> Inspinia - by <span>WebAppLayers</span></p>
              </div>
            </div>
            <div class="relative hidden h-full overflow-hidden rounded-e-2xl bg-cover bg-center object-cover lg:block" style="background-image: url('assets/images/auth.jpg')">
              <div class="absolute inset-0 flex items-end justify-center rounded-e-sm p-9 [background:linear-gradient(to_top,#313a46,rgba(49,58,70,.8),rgba(49,58,70,.5))]"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Markup — family C: split, full height.**

```html
<div class="min-h-screen">
  <div class="flex h-full w-full">
    <div class="hidden w-full md:block">
      <div class="relative h-full overflow-hidden bg-[url('../images/auth.jpg')] bg-cover bg-center bg-no-repeat">
        <div class="from-zinc-800 via-zinc-800/80 to-zinc-800/50 absolute inset-0 flex items-end justify-center bg-linear-to-t p-9"></div>
      </div>
    </div>
    <div class="min-w-full md:min-w-106 md:max-w-118">
      <div class="card relative flex min-h-screen flex-col justify-between rounded-none p-12.5">
        <div class="mb-7.5 flex flex-col items-center justify-center text-center">
          <a href="index.html" class="auth-logo"><!-- logo swap --></a>
        </div>
        <div>
          <h4 class="font-bold mb-2 text-default-900 text-lg text-center">Welcome to Admin</h4>
          <p class="text-default-400 mb-4 mx-auto w-full text-center lg:w-3/4">You're just one step away - sign in to continue.</p>
          <form action="index.html" class="mt-9">
            <div class="mb-6"><!-- field with input-icon-group --></div>
            <!-- … -->
          </form>
          <p class="text-default-400 mt-7.5 text-center">New here? <a href="auth-split-sign-up.html" class="text-primary font-semibold underline underline-offset-4">Create an account</a></p>
        </div>
        <p class="text-default-400 mt-7.5 text-center">&copy; <span data-current-year></span> Inspinia - by <span>WebAppLayers</span></p>
      </div>
    </div>
  </div>
</div>
```

**Shared pieces.**

| Piece | Markup / class | Notes |
|---|---|---|
| Logo swap | `<img src="assets/images/logo-black.png" class="flex dark:hidden"> <img src="assets/images/logo.png" class="hidden dark:flex">` | `dark:` compiles to `:where([data-theme=dark], [data-theme=dark] *)`; `.auth-logo img { height: 30px }` |
| Required mark | `<span class="text-danger">*</span>` inside `label.form-label` | |
| Plain field | `<div class="input-group"><input class="form-input" …></div>` | basic family |
| Icon field | `<div class="input-icon-group"><i class="iconify tabler--mail input-icon"></i><input class="form-input" …></div>` | card / split families; icons used: `tabler--mail`, `tabler--lock-password`, `tabler--user` |
| Checkbox | `<input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" id="…"> <label class="form-check-label" for="…">` | `.form-checkbox-light` = light border; `form-check-label` has no CSS of its own |
| Primary CTA | `<button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">` | always full width |
| Secondary link | `<a class="text-primary font-semibold underline underline-offset-4">` (or `underline-offset-3`) | |
| Muted link | `<a class="text-default-400 underline underline-offset-4">Forgot Password?</a>` | |
| Footer | `<p class="text-default-400 mt-7.5 text-center">&copy; <span data-current-year></span> …</p>` | see gotcha |

**Gotchas.**
- **Scripts.** The vendored auth pages load only `assets/js/config.js` (in `<head>`) and, where needed,
  `assets/js/pages/auth-two-factor.js` / `auth-password.js` (the latter as `type="module"`). They do
  not load `vendors.min.js` or `app.js`. Consequences: Preline features (`hs-toggle-password`,
  dropdowns, the customizer overlay) do nothing unless you add `vendors.min.js`; `data-current-year`
  is **not** stamped — the handler lives at the end of `app.js`, which these pages do not load. Either add
  `vendors.min.js` + `app.js`, or stamp it yourself:
  `document.querySelectorAll("[data-current-year]").forEach(e => e.textContent = new Date().getFullYear())`.
- Dark mode still works without JS because `config.js` applies `data-theme` to `<html>` from
  `sessionStorage` / URL params before paint.
- Every form is `action="index.html"` with the default GET method; set `method="post"`, add a CSRF
  token and `name` attributes (the demo inputs only have `id`s).
- Delete the `#theme-customization` block from production auth pages; it is ~350 lines of inert markup.
- Image paths differ by family on purpose: the card family uses an inline `style="background-image:
  url('assets/images/auth.jpg')"` (relative to the page), the split family uses the utility
  `bg-[url('../images/auth.jpg')]` (relative to the CSS file). Keep whichever you copy consistent.

## Sign in (auth-sign-in, auth-card-sign-in, auth-split-sign-in)

**What it is.** Email + password + "Keep me signed in" + "Forgot Password?" + full-width Sign In button,
with a "Create an account" link under the card.

**Use it when.** Any username/password login. If you also offer SSO, add provider buttons under the
submit (`btn border border-default-300 w-full` rows) — the demo has none.

**Source.** `auth-sign-in.html` (+ `auth-card-sign-in.html`, `auth-split-sign-in.html`). No page script.

**Markup — the form (basic family).**

```html
<form action="index.html">
  <div class="mb-5">
    <label for="userEmail" class="form-label">Email address <span class="text-danger">*</span></label>
    <div class="input-group"><input type="email" class="form-input" id="userEmail" placeholder="you@example.com" required /></div>
  </div>
  <div class="mb-5">
    <label for="userPassword" class="form-label">Password <span class="text-danger">*</span></label>
    <div class="input-group"><input type="password" class="form-input" id="userPassword" placeholder="••••••••" required /></div>
  </div>
  <div class="mb-5 flex items-center justify-between gap-2">
    <div class="flex items-start gap-2 lg:items-center">
      <input class="form-checkbox form-checkbox-light mt-1 size-4.25 lg:mt-0" type="checkbox" id="rememberMe" checked />
      <label class="form-check-label" for="rememberMe">Keep me signed in</label>
    </div>
    <a href="auth-reset-pass.html" class="text-default-400 underline underline-offset-4">Forgot Password?</a>
  </div>
  <div>
    <button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Sign In</button>
  </div>
</form>
<p class="text-default-400 mt-7.5 text-center">New here? <a href="auth-sign-up.html" class="text-primary font-semibold underline underline-offset-4">Create an account</a></p>
```

| Field | id | type | attrs |
|---|---|---|---|
| Email | `userEmail` | email | required |
| Password | `userPassword` | password | required |
| Remember | `rememberMe` | checkbox | `checked` in basic/split, unchecked in card |

Links: Forgot → `auth-reset-pass.html`; Create account → `auth-sign-up.html` (card/split: same with
their prefix). Header copy: "Welcome" / "Let's get you signed in…" (card/split: "Welcome to Admin").

**Gotchas.** Add the show/hide eye from the "Password visibility toggle" section if you want it; it is
not on the demo sign-in. For an inline error, insert `<p class="text-danger text-sm mt-1">` under the
field and add `border-danger` to the input.

## Sign up (auth-sign-up, auth-card-sign-up, auth-split-sign-up)

**What it is.** Name + email + password with a 4-segment strength meter + "Agree the Terms & Policy"
checkbox + Create Account; "Already have an account? Login" link.

**Use it when.** Self-service registration, invite-acceptance "set your details" step (prefill email and
add `readonly`).

**Source.** `auth-sign-up.html` (+card/split), `assets/js/pages/auth-password.js` (loaded with
`type="module"`).

**Markup — the form.**

```html
<form action="index.html">
  <div class="mb-5">
    <label for="userName" class="form-label">Name <span class="text-danger">*</span></label>
    <div class="input-group"><input type="text" class="form-input" id="userName" placeholder="Damian D." required /></div>
  </div>
  <div class="mb-5">
    <label for="userEmail" class="form-label">Email address <span class="text-danger">*</span></label>
    <div class="input-group"><input type="email" class="form-input" id="userEmail" placeholder="you@example.com" required /></div>
  </div>
  <div class="mb-5" data-password="bar">                       <!-- strength-meter wrapper -->
    <label for="userPassword" class="form-label">Password <span class="text-danger">*</span></label>
    <input type="password" id="userPassword" class="form-input" placeholder="••••••••" />
    <div class="password-bar my-3"></div>                      <!-- 4 .strong-bar divs rendered by JS -->
    <p class="text-default-400 text-xs">Use 8+ characters with letters, numbers &amp; symbols.</p>
  </div>
  <div class="mb-6">
    <div class="flex items-center gap-2">
      <input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" id="termAndPolicy" />
      <label class="form-check-label" for="termAndPolicy">Agree the Terms &amp; Policy</label>
    </div>
  </div>
  <div>
    <button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Create Account</button>
  </div>
</form>
<p class="text-default-400 mt-7.5 text-center">Already have an account? <a href="auth-sign-in.html" class="text-primary font-semibold underline underline-offset-4">Login</a></p>
```

**Init / JS.** `assets/js/pages/auth-password.js` — de-minified; it is self-initialising on
`DOMContentLoaded`:

```js
class PasswordAuth {
  constructor() { this.barCount = 4; }
  init() {
    document.querySelectorAll('[data-password="bar"]').forEach(wrap => {
      const input = wrap.querySelector('input[type="password"]');
      const bar   = wrap.querySelector(".password-bar");
      if (!input || !bar) return console.warn("Auth: Missing input or .password-bar in", wrap);
      bar.innerHTML = "";
      for (let i = 0; i < this.barCount; i++) bar.appendChild(Object.assign(document.createElement("div"), { className: "strong-bar" }));
      const bars = bar.querySelectorAll(".strong-bar");
      input.addEventListener("input", () => {
        const v = input.value; let score = 0;
        if (v.length >= 8) score++; if (/[A-Z]/.test(v)) score++; if (/\d/.test(v)) score++; if (/[\W_]/.test(v)) score++;
        bars.forEach((b, i) => { b.className = "strong-bar"; if (i < score) b.classList.add("bar-active-" + score); });
      });
    });
  }
}
document.addEventListener("DOMContentLoaded", () => new PasswordAuth().init());
```

CSS (from `app.min.css`): `.password-bar{display:flex;gap:12px}` · `.strong-bar{flex:1;height:6px;
border-radius:10px;background:var(--color-light);transition:background .3s}` · `.bar-active-1` danger,
`.bar-active-2` warning, `.bar-active-3` primary, `.bar-active-4` success.

**Gotchas.**
- The script looks for `input[type="password"]` **inside** the `[data-password="bar"]` wrapper at load
  time; if you add a show/hide toggle that flips the type, that is fine (the listener is already bound),
  but the input must be `type="password"` in the HTML.
- Scoring is purely client-side cosmetics; enforce the policy server-side.
- The password input in the demo has no `required`; add it. Neither the password nor the checkbox has
  `name`.

## Reset password (auth-reset-pass, auth-card-reset-pass, auth-split-reset-pass)

**What it is.** "Forgot Password?" — a single email field, a checkbox, "Send Request", and "Return to
Sign in".

**Use it when.** Start of the forgot-password flow. The success state is the Success mail page (reworded)
and the next step is New password.

**Source.** `auth-reset-pass.html` (+card/split). No page script.

**Markup.**

```html
<h4 class="font-bold text-base text-dark mt-5 mb-2">Forgot Password?</h4>
<p class="text-default-400 mx-auto w-full lg:w-3/4 mb-4">Enter your email address and we'll send you a link to reset your password.</p>
…
<form action="index.html">
  <div class="mb-5">
    <label for="userEmail" class="form-label">Email address <span class="text-danger">*</span></label>
    <div class="input-group"><input type="email" class="form-input" id="userEmail" placeholder="you@example.com" required /></div>
  </div>
  <div class="mb-6">
    <div class="flex items-center gap-2">
      <input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" id="rememberMe" />
      <label class="form-check-label" for="rememberMe">Agree the Terms &amp; Policy</label>
    </div>
  </div>
  <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Send Request</button></div>
</form>
<p class="text-default-400 mt-7.5 text-center">Return to <a href="auth-sign-in.html" class="text-primary font-semibold underline underline-offset-4">Sign in</a></p>
```

**Gotchas.** The checkbox is a copy-paste from sign-up (id `rememberMe`, label "Agree the Terms &
Policy") and makes no sense here; drop it. Always respond with the same success message whether or not
the email exists.

## New password (auth-new-pass, auth-card-new-pass, auth-split-new-pass)

**What it is.** "Setup New Password!" — a read-only email, the 6-digit code inputs, a new password with
strength meter, a confirm field, a terms checkbox and "Update Password"; plus "Resend / Call Us" and
"Return to Sign in" links.

**Use it when.** The step after a reset email; also "first login — set your password" for invited users.

**Source.** `auth-new-pass.html` (+card/split), `assets/js/pages/auth-two-factor.js` **and**
`assets/js/pages/auth-password.js` (both loaded).

**Markup.**

```html
<form action="index.html">
  <div class="mb-5">
    <label for="userEmail" class="form-label">Email address <span class="text-danger">*</span></label>
    <div class="input-group"><input type="email" class="form-input cursor-not-allowed" id="userEmail" value="your@email.com" readonly required /></div>
  </div>
  <div class="mb-5">
    <label class="form-label">Enter your 6-digit code <span class="text-danger">*</span></label>
    <div class="two-factor flex gap-2">
      <input type="text" class="form-input text-center" required />
      <input type="text" class="form-input text-center" required />
      <input type="text" class="form-input text-center" required />
      <input type="text" class="form-input text-center" required />
      <input type="text" class="form-input text-center" required />
      <input type="text" class="form-input text-center" required />
    </div>
  </div>
  <div class="mb-5" data-password="bar">
    <label for="userPassword" class="form-label">Password <span class="text-danger">*</span></label>
    <input type="password" id="userPassword" class="form-input" placeholder="••••••••" />
    <div class="password-bar my-3"></div>
    <p class="text-default-400 text-xs">Use 8+ characters with letters, numbers &amp; symbols.</p>
  </div>
  <div class="mb-5">
    <label for="userNewPassword" class="form-label">Confirm New Password <span class="text-danger">*</span></label>
    <div class="input-group"><input type="password" class="form-input" id="userNewPassword" placeholder="••••••••" required /></div>
  </div>
  <div class="mb-6">
    <div class="flex items-center gap-2">
      <input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" id="termAndPolicy" />
      <label class="form-check-label" for="termAndPolicy">Agree the Terms &amp; Policy</label>
    </div>
  </div>
  <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Update Password</button></div>
</form>
<p class="text-default-400 my-9 text-center">Don't have a code? <a href="#" class="text-primary font-semibold underline underline-offset-3">Resend</a> or <a href="#" class="text-primary font-semibold underline underline-offset-3">Call Us</a></p>
<p class="text-default-400 text-center">Return to <a href="auth-sign-in.html" class="underline text-primary font-semibold">Sign in</a></p>
```

**Init / JS.** See Two-factor (code inputs) and Sign up (strength meter). Both scripts self-init.

**Gotchas.**
- The demo email field only *looks* read-only (`cursor-not-allowed`); add `readonly` (shown above).
- The demo re-uses `for="userEmail"` on the code label; give the code group its own label text without
  `for` or point it at the first input.
- `auth-two-factor.js` hijacks the submit button click (see next section): as shipped the form never
  submits. Replace `handleSubmit` or remove the script and validate server-side.
- Compare the two password values yourself (no JS does it).

## Two-factor verification (auth-two-factor, auth-card-two-factor, auth-split-two-factor)

**What it is.** A masked phone number, six single-digit boxes that auto-advance, a Confirm button,
"Resend / Call Us" and "Return to Sign in".

**Use it when.** SMS / authenticator OTP after password; email verification code; step-up auth before a
sensitive action (wrap the same `.two-factor` group in a modal).

**Source.** `auth-two-factor.html` (+card/split), `assets/js/pages/auth-two-factor.js`.

**Markup.**

```html
<h4 class="font-bold text-base text-dark mt-5 mb-2">Two-Factor Verification!</h4>
<p class="text-default-400 mx-auto w-full lg:w-3/4 mb-4">We've emailed you a 6-digit verification code we sent to</p>
…
<div class="card p-7.5 rounded-2xl">
  <div class="mb-9"><div class="text-center text-2xl font-bold">******6789</div></div>
  <form action="index.html">
    <div class="mb-5">
      <label class="form-label">Enter your 6-digit code <span class="text-danger">*</span></label>
      <div class="two-factor flex gap-2">
        <input type="text" class="form-input text-center" required inputmode="numeric" maxlength="1" />
        <!-- x6 -->
      </div>
    </div>
    <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Confirm</button></div>
  </form>
  <p class="text-default-400 my-9 text-center">Don't have a code? <a href="#" class="text-primary font-semibold underline underline-offset-3">Resend</a> or <a href="#" class="text-primary font-semibold underline underline-offset-3">Call Us</a></p>
  <p class="text-default-400 text-center">Return to <a href="auth-sign-in.html" class="text-primary font-semibold underline underline-offset-3">Sign in</a></p>
</div>
```

**Init / JS.** `assets/js/pages/auth-two-factor.js` — de-minified. It binds to the **first**
`.two-factor` container on the page and self-inits on `DOMContentLoaded`:

```js
class TwoFactorAuth {
  constructor(sel = ".two-factor") {
    this.container = document.querySelector(sel);
    if (!this.container) return console.error(`TwoFactorAuth: Container "${sel}" not found.`);
    this.inputs = Array.from(this.container.querySelectorAll("input"));
    if (!this.inputs.length) return console.error("TwoFactorAuth: No input fields found in the container.");
    this.confirmBtn = this.container.closest("form")?.querySelector('button[type="submit"]');
    this.init();
  }
  init() {
    this.inputs[0].focus();
    this.inputs.forEach((inp, i) => {
      inp.setAttribute("inputmode", "numeric");
      inp.setAttribute("maxlength", "1");
      inp.addEventListener("input",   e => this.handleInput(e, i));
      inp.addEventListener("keydown", e => this.handleKeyDown(e, i));
      inp.addEventListener("paste",   e => e.preventDefault());          // paste is BLOCKED
    });
    this.confirmBtn ? this.confirmBtn.addEventListener("click", e => this.handleSubmit(e))
                    : console.warn("TwoFactorAuth: Submit button not found.");
  }
  handleInput(e, i) {
    let v = e.target.value.replace(/\D/g, ""); if (v.length > 1) v = v.charAt(0);
    this.inputs[i].value = v;
    if (v && i < this.inputs.length - 1) this.inputs[i + 1].focus();   // auto-advance
  }
  handleKeyDown(e, i) {
    if (e.key === "Backspace" && !this.inputs[i].value && i > 0) this.inputs[i - 1].focus();
  }
  handleSubmit(e) {
    e.preventDefault();                                                   // form never submits as shipped
    const code = this.inputs.map(i => i.value).join("");
    if (/^\d+$/.test(code) && code.length === this.inputs.length) console.log("Entered 2FA code:", code);
    else { this.showError("Please enter a valid verification code."); setTimeout(() => this.clearError(), 3000); }
  }
  showError(msg) {
    if (!this.errorSpan) {
      this.errorSpan = document.createElement("span");
      this.errorSpan.className = "text-danger d-block mb-3";             // d-block is Bootstrap; use "block"
      this.inputs[0].parentElement.insertAdjacentElement("afterend", this.errorSpan);
    }
    this.errorSpan.textContent = msg;
  }
  clearError() { this.errorSpan?.remove(); this.errorSpan = null; }
}
document.addEventListener("DOMContentLoaded", () => new TwoFactorAuth());
```

**Gotchas.**
- `handleSubmit` calls `preventDefault()` and only `console.log`s the code. For a real flow, replace the
  success branch with: write the joined code into a hidden `<input name="code">` and call
  `this.confirmBtn.form.submit()` (or `fetch`).
- Paste is blocked (`preventDefault`), which is hostile to SMS autofill. Better: on `paste`, read
  `clipboardData.getData("text")`, strip non-digits, distribute one char per input, focus the last filled.
- Only the first `.two-factor` on the page is wired (`querySelector`); for several, loop with
  `querySelectorAll` and `new TwoFactorAuth` per container (pass a unique selector).
- The number of boxes is whatever you render — the script validates `code.length === inputs.length`,
  so a 4-digit PIN just needs four inputs.
- `inputmode`/`maxlength` are set by JS; put them in the HTML too (as `auth-login-pin` does) so the
  numeric keyboard shows even before JS runs. There is no `.two-factor` CSS; the layout is the `flex gap-2`
  on the wrapper and `text-center` on the inputs.

## Lock screen (auth-lock-screen, auth-card-lock-screen, auth-split-lock-screen)

**What it is.** Avatar in a thick ring, user name, a single password field, "Unlock", and "Not you?
Return to Sign in".

**Use it when.** Session idle-timeout re-auth (keep the user context, ask only for the password);
"confirm it's you" before showing sensitive data.

**Source.** `auth-lock-screen.html` (+card/split). No page script.

**Markup.**

```html
<h4 class="font-bold text-base text-dark mt-5 mb-2">Lock Screen!</h4>
<p class="text-default-400 mx-auto w-full lg:w-3/4 mb-4">This screen is locked. Enter your password to continue</p>
…
<form action="index.html">
  <div class="mb-9 text-center">
    <div class="border-default-300 mx-auto mb-3 size-20 rounded-full border-4"><img src="assets/images/users/user-1.jpg" class="size-18 rounded-full" alt="thumbnail" /></div>
    <h5 class="text-base mb-2 font-semibold">Damian D.</h5>
  </div>
  <div class="mb-5">
    <label for="userPassword" class="form-label">Password <span class="text-danger">*</span></label>
    <div class="input-group"><input type="password" class="form-input" id="userPassword" placeholder="••••••••" required /></div>
  </div>
  <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Unlock</button></div>
</form>
<p class="text-default-400 mt-7.5 text-center">Not you? Return to <a href="auth-sign-in.html" class="text-primary font-semibold underline underline-offset-3">Sign in</a></p>
```

**Gotchas.** The demo misspells `font-semibol` on the "Sign in" link (basic + card); use
`font-semibold`. Render the lock screen as a full-page overlay if you want to keep the app state behind
it (`fixed inset-0 z-80 bg-body-bg` around the wrapper).

## Success mail (auth-success-mail, auth-card-success-mail, auth-split-success-mail)

**What it is.** A confirmation card: a dashed-ring bubble with a checkmark image, a bold "Well Done!
Email verified Successfully" line and a "Back to dashboard" button. The header has only the logo and a
one-line blurb (no `h4`).

**Use it when.** Email-verified, password-changed, invitation-accepted, order-placed, "check your inbox"
(swap the heading and icon) — any terminal step of an auth / onboarding flow.

**Source.** `auth-success-mail.html` (+card/split). No page script.

**Markup.**

```html
<div class="mb-3 flex flex-col items-center justify-center text-center">
  <a href="index.html" class="auth-logo"><!-- logo swap --></a>
  <p class="text-default-400 mx-auto mt-6 mb-4 w-full lg:w-3/4">Awesome! You've read the important message like a pro.</p>
</div>
<div class="card p-7.5 rounded-2xl">
  <form action="index.html">
    <div class="mt-3 mb-9">
      <div class="bg-default-50 border-light mx-auto flex size-20 items-center justify-center rounded-full border border-dashed">
        <img src="assets/images/checkmark.png" alt="checkmark" class="size-16" />
      </div>
    </div>
    <h4 class="mb-9 text-center text-lg font-bold">Well Done! Email verified Successfully</h4>
    <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Back to dashboard</button></div>
  </form>
</div>
```

**Gotchas.** The `<form>` is only there to make the button a submit; a plain `<a class="btn …">` to the
dashboard is simpler. Replace `checkmark.png` with an icon if you prefer:
`<i class="iconify tabler--circle-check text-success text-5xl"></i>` inside the same bubble.

## Login with PIN (auth-login-pin, auth-card-login-pin, auth-split-login-pin)

**What it is.** Lock-screen header (avatar ring + name) plus the six `.two-factor` boxes and Confirm.

**Use it when.** Shared-device / kiosk re-auth with a short numeric PIN; POS or warehouse terminals;
parental-control style quick unlock. Not a replacement for the password login — pair it with a real
session.

**Source.** `auth-login-pin.html` (+card/split), `assets/js/pages/auth-two-factor.js`.

**Markup.**

```html
<h4 class="font-bold text-base text-dark mt-5 mb-2">Login with PIN!</h4>
<p class="text-default-400 mx-auto w-full lg:w-3/4 mb-4">This screen is locked. Enter your PIN to continue.</p>
…
<form action="index.html">
  <div class="mb-9 text-center">
    <div class="border-default-300 mx-auto mb-3 size-20 rounded-full border-4"><img src="assets/images/users/user-1.jpg" class="size-18 rounded-full" alt="thumbnail" /></div>
    <h5 class="text-lg">Damian D.</h5>
  </div>
  <div class="mb-5">
    <label class="form-label">Enter your 6-digit code <span class="text-danger">*</span></label>
    <div class="two-factor flex gap-2">
      <input type="text" class="form-input text-center" required inputmode="numeric" maxlength="1" />
      <!-- x6 -->
    </div>
  </div>
  <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Confirm</button></div>
</form>
<p class="text-default-400 mt-7.5 text-center">Not you? Return to <a href="auth-sign-in.html" class="text-primary font-semibold underline underline-offset-4">Sign in</a></p>
```

**Gotchas.** Same script caveats as Two-factor. For a PIN you probably want `type="password"` boxes;
the script only reads `.value`, so that works, but then set `autocomplete="off"`.

## Delete account / deactivated (auth-delete-account, auth-card-delete-account, auth-split-delete-account)

**What it is.** A notice card: logo, a dashed bubble with a "delete" illustration, "Account
Deactivated" heading, explanatory paragraph and a "Reactivate Now" button.

**Use it when.** Landing page for a deactivated / suspended / scheduled-for-deletion account; "your
trial ended" wall; the confirmation shown right after a user deletes their account (reword to "Account
deleted" and drop the button).

**Source.** `auth-delete-account.html` (+card/split). No page script.

**Markup.**

```html
<div class="mb-7 flex flex-col items-center justify-center text-center">
  <a href="index.html" class="auth-logo"><!-- logo swap --></a>
</div>
<div class="card p-7.5 rounded-2xl">
  <form action="index.html">
    <div class="mt-3 mb-9">
      <div class="bg-default-50 border-light mx-auto flex size-20 items-center justify-center rounded-full border border-dashed">
        <img src="assets/images/delete.png" alt="" class="size-16 object-contain" />
      </div>
    </div>
    <h4 class="mb-6 text-center text-lg font-bold">Account Deactivated</h4>
    <p class="text-default-400 mb-9 text-center">Your account is currently inactive. Reactivate now to regain access to all features and opportunities.</p>
    <div><button type="submit" class="btn bg-primary w-full py-3 font-semibold text-white hover:bg-primary-hover">Reactivate Now</button></div>
  </form>
</div>
```

**Gotchas.** For a destructive variant ("Delete my account" confirmation) swap the button to
`btn bg-danger text-white hover:bg-danger-hover` and add a `btn border border-default-300` "Cancel"
beside it in a `flex gap-2` row.

## Password visibility toggle (Preline hs-toggle-password)

**What it is.** Preline's show/hide password control: a button with `data-hs-toggle-password` pointing
at the input; the `hs-password-active:` variant flips which icon shows. Not on the demo auth pages —
taken from `form-elements.html` — but it is the piece you add to any password field above.

**Use it when.** Every password field on sign-in, sign-up, new-password, lock screen.

**Source.** `references/sources/pages/form-elements.html` (Preline, in `vendors.min.js`).

**Markup.**

```html
<div class="relative flex items-center">
  <input id="password" type="password" class="form-input w-full" placeholder="Enter password" />
  <button type="button" data-hs-toggle-password='{"target":"#password"}' class="bg-default-100 border-default-300 absolute inset-y-0 end-0 flex items-center rounded rounded-s-none! border px-3 py-1.75">
    <i class="iconify tabler--eye hs-password-active:hidden block text-sm"></i>
    <i class="iconify tabler--eye-off hs-password-active:block hidden text-sm"></i>
  </button>
</div>
```

**Gotchas.**
- Needs `assets/js/vendors.min.js` (Preline autoinit). The auth pages don't load it — add it before
  your page script.
- The same attribute is used elsewhere in the template as a generic active-state toggle
  (`apps-file-manager.html` points it at an empty `<span>` to flip a star icon), so the `target` does
  not have to be a password input.
- Preline's `hs-strong-password` meter is **not used anywhere** in this template; the demo ships its own
  `auth-password.js` (see Sign up). Pick one — don't run both on the same input.

## Error pages (error-400, 401, 403, 404, 408, 500)

**What it is.** Chrome-less pages sharing one skeleton: logo, a big visual (animated glitch number,
animated wave number, or an SVG illustration), an uppercase title, one line of copy, one or two buttons
and the copyright footer. Nothing but `app.min.css` + `config.js` is loaded, so they render even when
the app's JS is broken.

**Use it when.** Map each HTTP status to a template:

| Code | Page | Title / copy (demo) | Visual | Buttons | Serve it when… |
|---|---|---|---|---|---|
| 400 | `error-400.html` | "Oops! Invalid Request" — The request couldn't be processed. Please check the URL or try again. | `.error-glitch` | Go Back (outline secondary) · Back to Dashboard | malformed request / bad query string |
| 401 | `error-401.html` | "Unauthorized Access" — You are not authorized to access this page. | `.error-wave-*` | Return Home | not logged in / expired session (better: redirect to sign-in with `?next=`) |
| 403 | `error-403.html` | "Permission Required" — You don't have the required permissions… contact your administrator or try a different account. | `.error-glitch` | Go to Dashboard · Back (outline) | logged in but lacks the role / ACL |
| 404 | `error-404.html` | "Page Not Found" — We couldn't find the page you were looking for. It might have been moved or deleted. | `assets/images/svg/404.svg` | Back to Home · Search (outline info) | unknown route / deleted record |
| 408 | `error-408.html` | "Connection Timed Out" — The request took too long to respond. Please check your connection and try again. | `.error-wave-*` | Try Again · Get Help (outline info) | gateway / upstream timeout, offline detection |
| 500 | `error-500.html` | "Internal Server Error" — We ran into an issue while processing your request. Please try again in a moment. | `assets/images/svg/500.svg` | Try Again · Get Support (outline info) | unhandled exception (also use for 502/503 unless you have the maintenance page up) |

**Source.** `references/sources/pages/error-400.html` … `error-500.html`. No page script.

**Markup — shared skeleton (404 shown; swap the visual block).**

```html
<body>
<div class="flex min-h-screen items-center">
  <div class="container">
    <div class="flex justify-center lg:p-0 p-12.5">
      <div class="2xl:w-4/10 md:w-1/2 sm:w-2/3 w-full">
        <div class="p-7.5">
          <div class="mb-5 flex flex-col items-center justify-center text-center">
            <a href="index.html" class="auth-logo">
              <img src="assets/images/logo-black.png" alt="logo" class="flex dark:hidden" />
              <img src="assets/images/logo.png" alt="dark logo" class="hidden dark:flex" />
            </a>
          </div>
          <div class="p-6 text-center">
            <!-- VISUAL (one of the three below) -->
            <img src="assets/images/svg/404.svg" alt="" class="mx-auto md:size-64" />

            <h3 class="mb-2 text-xl font-bold uppercase">Page Not Found</h3>
            <p class="text-default-400 mx-auto">We couldn't find the page you were looking for. It might have been moved or deleted.</p>
            <div class="mt-8 flex items-center justify-center gap-1.5">
              <a href="index.html" class="btn bg-primary text-white hover:bg-primary-hover">Back to Home</a>
              <button class="btn border-info text-info hover:bg-info hover:text-white">Search</button>
            </div>
          </div>
        </div>
        <p class="text-default-400 mt-7.5 text-center">&copy; <span data-current-year></span> Inspinia - by <span>WebAppLayers</span></p>
      </div>
    </div>
  </div>
</div>
</body>
```

The three visuals:

```html
<!-- (a) glitch number — 400, 403. data-text MUST equal the text: the CSS draws two offset copies with attr(data-text) -->
<div class="error-glitch" data-text="403">403</div>

<!-- (b) wave number — 401, 408. One span per character; gradient primary→purple, staggered bounce -->
<div class="error-wave-container justify-center gap-1">
  <span class="error-wave-char">4</span><span class="error-wave-char">0</span><span class="error-wave-char">1</span>
</div>

<!-- (c) illustration — 404, 500 -->
<img src="assets/images/svg/500.svg" alt="" class="mx-auto md:size-64" />
```

Button variants used: primary `btn bg-primary text-white hover:bg-primary-hover`; outline secondary
`btn border border-secondary text-secondary hover:text-white hover:bg-secondary` (400) or
`btn border-secondary text-secondary hover:bg-secondary hover:text-white` (403); outline info
`btn border-info text-info hover:bg-info hover:text-white` (404/408/500). Inner padding is `p-3`
(400/401), `p-6` (404) or `p-9` (403/408/500) — purely cosmetic.

**CSS (already in app.min.css).** `.error-glitch` = 120px bold, `animation: flicker 2s infinite`, with
`:before` (primary, `glitchTop`) and `:after` (danger, `glitchBottom`) clip-path layers at `z-index:-1`.
`.error-wave-container` = flex, 120px, weight 900; `.error-wave-char` = `background-clip:text` gradient
`var(--color-primary) → var(--color-purple)` + `wave 2s ease-in-out infinite`, delays 0 / .2s / .4s for
the first three chars (a 4th char gets no delay — stay at three digits).

**Wiring as server error templates.**
- Static servers: nginx `error_page 404 /errors/404.html; error_page 500 502 503 504 /errors/500.html;`
  (+ `location /errors/ { internal; }`); Apache `ErrorDocument 404 /errors/404.html`.
- Frameworks: Laravel `resources/views/errors/{404,403,500,503}.blade.php`; Django `templates/404.html`
  / `500.html`; Express `app.use((req,res)=>res.status(404).sendFile(...))`; Rails `public/404.html`.
- Because the page can be served from any URL depth, make asset paths absolute (`/assets/css/app.min.css`,
  `/assets/images/svg/404.svg`) and point the logo/buttons at absolute routes.
- "Go Back" buttons are `href="#!"` in the demo; use `onclick="history.back()"` or a real referrer link.
  "Try Again" → `location.reload()`. "Search" → your search route. For 401 prefer a server redirect to
  the sign-in page with a `next` parameter over showing the page.
- Keep `config.js` in `<head>` so dark mode matches the user's choice; drop the `#theme-customization`
  block; stamp `data-current-year` yourself (no handler is loaded on these pages).
- Send the real status code with the template (`res.status(404)`), and `Retry-After` with 503 (see
  Maintenance). Don't leak stack traces into the copy.

## Maintenance page (error-maintenance)

**What it is.** A wider (`lg:w-1/2`) rounded card with the logo, `assets/images/maintenance.svg`, "Site
Under Maintenance", a two-line message and two pill buttons (Call Support, Send Email).

**Use it when.** Planned downtime / deploy window (serve with HTTP 503 + `Retry-After`); feature
temporarily disabled; region not yet available. For a pre-launch page with a date use Coming soon.

**Source.** `references/sources/pages/error-maintenance.html`. No page script.

**Markup.**

```html
<div class="flex min-h-screen items-center">
  <div class="container">
    <div class="flex justify-center lg:p-0 p-12.5">
      <div class="w-full lg:w-1/2">
        <div class="card rounded-2xl">
          <div class="card-body p-12.5">
            <div class="flex flex-col items-center justify-center text-center">
              <a href="index.html" class="auth-logo">
                <img src="assets/images/logo-black.png" alt="logo" class="flex dark:hidden" />
                <img src="assets/images/logo.png" alt="dark logo" class="hidden dark:flex" />
              </a>
            </div>
            <div class="p-3 text-center mt-5">
              <img src="assets/images/maintenance.svg" alt="Maintenance" class="mx-auto md:size-64" />
              <h3 class="mb-2 text-xl font-bold uppercase">Site Under Maintenance</h3>
              <p class="text-default-400">We're currently performing scheduled maintenance. <br /> Please check back soon.</p>
              <div class="mt-8 flex items-center justify-center gap-2 flex-wrap">
                <button class="btn bg-primary text-white hover:bg-primary-hover rounded-full">Call Support</button>
                <button class="btn bg-info text-white hover:bg-info-hover rounded-full">Send Email</button>
              </div>
            </div>
            <p class="text-default-400 mt-18 text-center">&copy; <span data-current-year></span> Inspinia - by <span>WebAppLayers</span></p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- Unlike the other error pages this one is inside a `.card` (the others use a bare `.p-7.5` block).
- Make the buttons real links: `tel:` and `mailto:` (`<a class="btn …">`). Add the expected end time
  ("back at 02:00 UTC") to the paragraph; if you want a live countdown, borrow the four-tile grid and
  script from Coming soon.
- Serve as `503 Service Unavailable` with a `Retry-After` header so crawlers and uptime monitors treat it
  correctly; keep it a fully static file that does not touch the app or database.

## Original sources

Pages (via `scripts/inspinia/extract_main.py`, `--body` for chrome-less pages):

- `references/sources/pages/pages-empty.html` (also raw `head`/`tail`/lines 3014-3075 for the chrome skeleton)
- `references/sources/pages/pages-profile.html`
- `references/sources/pages/pages-account-settings.html`
- `references/sources/pages/pages-faq.html`
- `references/sources/pages/pages-pricing.html`
- `references/sources/pages/pages-timeline.html`
- `references/sources/pages/pages-gallery.html`
- `references/sources/pages/pages-sitemap.html`
- `references/sources/pages/pages-search-results.html`
- `references/sources/pages/pages-coming-soon.html`
- `references/sources/pages/pages-privacy-policy.html`
- `references/sources/pages/pages-terms-conditions.html`
- `references/sources/pages/auth-sign-in.html`, `auth-sign-up.html`, `auth-reset-pass.html`, `auth-new-pass.html`, `auth-two-factor.html`, `auth-lock-screen.html`, `auth-success-mail.html`, `auth-login-pin.html`, `auth-delete-account.html`
- `references/sources/pages/auth-card-sign-in.html`, `auth-card-lock-screen.html`, `auth-card-success-mail.html`, `auth-card-new-pass.html` (+ `<form>` regions of all nine `auth-card-*` pages, diffed against the basic family)
- `references/sources/pages/auth-split-sign-in.html`, `auth-split-new-pass.html`, `auth-split-delete-account.html`, `auth-split-two-factor.html` (+ `<form>` regions of all nine `auth-split-*` pages, diffed)
- `references/sources/pages/error-400.html`, `error-401.html`, `error-403.html`, `error-404.html`, `error-408.html`, `error-500.html`, `error-maintenance.html`
- `references/sources/pages/form-elements.html` (only the `hs-toggle-password` block)

Scripts and manifests:

- `references/sources/assets/js/pages/auth-two-factor.js`
- `references/sources/assets/js/pages/auth-password.js`
- `references/sources/assets/js/pages/pages-gallery.js`
- `references/sources/assets/js/pages/coming-soon.js`
- `references/sources/assets/js/config.js` (head); `assets/js/app.js` is **not loaded** on these pages (its `[data-current-year]` stamper at the end of the file therefore never runs here)
- `references/sources/assets/css/app.min.css` (grepped: `.error-glitch`, `.error-wave-*`, `@keyframes flicker/wave/glitchTop/glitchBottom`, `.password-bar`, `.strong-bar`, `.bar-active-*`, `.auth-logo`, `.form-checkbox-light`, `.input-icon-group`, `.input-icon`, `.form-input-lg`, `.badge-label`, `.thead-sm`, `.table-wrapper`, `.text-2xs`, `.btn-icon`, `.form-switch`, `.page-title-head`, `.page-main-title`, `.page-content`, `.footer`, `.logo-light/.logo-dark`, `.dark\:hidden`)
- `references/sources/MANIFEST-page-deps.txt`, `MANIFEST-plugins.txt`, `MANIFEST-page-scripts.txt`, `FETCHED.txt`
