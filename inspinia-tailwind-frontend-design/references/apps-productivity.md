# App pages: file manager, email, chat, calendar, projects & kanban, users & roles, invoices, blog, forum, social, misc

This group covers the 34 "Apps" demo pages of INSPINIA Tailwind: full-page productivity and
collaboration screens (file browser, mailbox, chat, calendar, social feed, project tools, user/role
admin, invoicing, CMS/blog, forum, CRM lists, integrations, notes). Reach for these when the product
needs a complete working screen rather than a single widget: they are the templates for "a Drive-like
media library", "a ticket inbox", "a Trello board", "an RBAC admin", "a printable invoice", and so on.
Most list pages share one tiny vanilla-JS list engine (`assets/js/pages/custom-table.js`, documented
first) that gives search, sort, filter, paginate and bulk-delete to any `.card` with `data-table`.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Search / sort / filter / paginate / bulk-delete any static table | `data-table` list engine | (shared) | `assets/js/pages/custom-table.js` |
| Browse folders + files, star, share/download/delete, storage sidebar; attachment picker / media library | File manager | `apps-file-manager.html` | custom-table.js |
| Message queue with labels, star, bulk actions (ticket inbox, notifications centre) | Email inbox | `apps-email-inbox.html` | custom-table.js, `apps-email.js` |
| Threaded message view with collapsible replies, attachments, inline reply box | Email details | `apps-email-details.html` | Preline `hs-collapse` |
| Rich-text compose with To/Cc/Bcc and send-split-button | Email compose | `apps-email-compose.html` | Quill, `apps-email-compose.js` |
| Contact list + message thread + composer (support chat, team DM) | Chat | `apps-chat.html` | `apps-chat.js` (Chat class) |
| Month/week/day/list calendar with drag-drop + create/edit modal | Calendar | `apps-calendar.html` | FullCalendar, `apps-calendar.js` |
| Post composer, media posts, comments, poll, trending/requests sidebars | Social feed | `apps-social-feed.html` | `hs-toggle-password` like-toggle |
| Project cards with stats, team avatars, progress | Projects grid | `apps-projects-grid.html` | – |
| Project table with members/progress/actions | Projects list | `apps-projects-list.html` | custom-table.js |
| Project overview: description, meta, tabs (comments / tasks / activity), team + files sidebar | Project details | `apps-projects-details.html` | Preline `hs-tab` |
| Drag-and-drop board with columns (tasks, pipeline, hiring stages) | Kanban | `apps-projects-kanban.html` | SortableJS, `apps-kanban.js` |
| Team cards with members, KPIs, progress + add-team modal | Team board | `apps-projects-team-board.html` | – |
| Audit log / activity stream (compact rows and expanded timeline) | Activity | `apps-projects-activity.html` | – |
| People directory cards (email/phone/location) with filters | Users contacts | `apps-users-contacts.html` | – |
| Role cards + users table + add-role / add-user modals (RBAC admin) | Users roles | `apps-users-roles.html` | custom-table.js |
| One role: summary card + its members table | Role details | `apps-users-role-details.html` | custom-table.js |
| Permission → roles matrix table | Permissions | `apps-users-permissions.html` | custom-table.js |
| Invoice table with status filter | Invoice list | `apps-invoice-list.html` | custom-table.js |
| Printable invoice (from/to, line items, totals, QR, signature, print/send) | Invoice details | `apps-invoice-details.html` | `window.print()` |
| Invoice editor: logo upload, dates, addresses, line-item rows, totals | Invoice create | `apps-invoice-create.html` | flatpickr via app.js, `apps-create-invoice.js` |
| Article list with image, tags, meta + blog sidebar | Blog list | `apps-blog-list.html` | – |
| Masonry card grid of articles | Blog grid | `apps-blog-grid.html` | Masonry, `apps-blog-grid.js` |
| Single article page, helpful-vote, author box, share, sidebar | Blog article | `apps-blog-article.html` | – |
| CMS post editor with Quill, SEO + visibility settings | Blog add | `apps-blog-add.html` | Quill, `form-quilljs.js` |
| Thread list (Q&A / discussion board) + sidebar | Forum view | `apps-forum-view.html` | – |
| Thread + reply form + nested replies | Forum post | `apps-forum-post.html` | – |
| CRM clients table with country/type filters + add-client modal | Clients | `apps-clients.html` | custom-table.js |
| Company directory cards (logo, follow, KPIs, rating) | Companies | `apps-companies.html` | – |
| Two-pane mail reader (vertical tab list → reading pane with reply) | Outlook view | `apps-outlook.html` | Preline `hs-tab` (vertical) |
| Upvote/downvote topic list | Vote list | `apps-vote-list.html` | – |
| Bug/ticket table with progress + issue-detail modal | Issue tracker | `apps-issue-tracker.html` | custom-table.js |
| API key table with copy-to-clipboard + generate-key modal | API keys | `apps-api-keys.html` | ClipboardJS, `apps-api-keys.js` |
| Integrations grid with connect switches, quota bars | Manage apps | `apps-manage.html` | – |
| Sticky-note board with removable notes + add-note modal | Pin board | `apps-pin-board.html` | Preline `hs-remove-element` |

## `data-table` list engine (custom-table.js) — shared by 11 pages in this group

**What it is.** A ~15 KB vanilla class (`CustomTable` → one `Table` per `[data-table]` root) that adds
client-side search, column sort, select filters, range/date filters, rows-per-page, pagination,
select-all, bulk delete and per-row delete (with a generated Preline confirm modal) to a plain
`<table>`. No jQuery, no DataTables. It self-initialises on `DOMContentLoaded`.
**Use it when.**
- Any admin list ≤ a few hundred rows that is rendered server-side as HTML and only needs client-side
  convenience (clients, invoices, API keys, users, permissions, issues, projects).
- NOT for server-paginated / remote data or column visibility/export — use Preline `hs-datatable`
  (DataTables) from the tables group instead.
**Source.** `references/sources/assets/js/pages/custom-table.js`. Used by: apps-file-manager, apps-email-inbox,
apps-clients, apps-invoice-list, apps-issue-tracker, apps-outlook (included but unused), apps-projects-list,
apps-users-permissions, apps-users-role-details, apps-users-roles, apps-api-keys (plus ecommerce pages
in other groups).
**Markup.** Every hook is a data attribute inside the root:

```html
<div data-table data-table-rows-per-page="8" class="card">          <!-- root; attr overrides default 10 -->
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i>
        <input data-table-search type="search" placeholder="Search..." class="form-input" /></div>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button>
    </div>
    <div class="flex flex-wrap items-center gap-2.5"><span class="me-2.5 font-semibold">Filter By:</span>
      <div class="input-icon-group"><i class="iconify tabler--circle-check input-icon"></i>
        <select data-table-filter="status" class="form-select">          <!-- exact match on the th[data-column=status] cell -->
          <option value="All">Status</option><option value="Paid">Paid</option></select></div>
      <select data-table-range-filter="date" class="form-select">        <!-- "Today" | "Last 7 Days" | "Last 30 Days" | "This Year" for *date* columns; "0-100" / "100+" for numeric -->
        <option value="All">Deadline</option><option value="Last 7 Days">Last 7 Days</option></select>
      <select data-table-set-rows-per-page class="form-select">
        <option value="5">5</option><option value="10">10</option><option value="20">20</option></select>
    </div>
  </div>
  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="thead-sm">
        <tr class="bg-light/25 text-2xs uppercase">
          <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
          <th data-table-sort="name">Name</th>                 <!-- value = key of a [data-sort="name"] element inside the cell -->
          <th data-table-sort data-column="status">Status</th> <!-- data-column pairs with data-table-filter -->
          <th data-table-sort>Amount</th>                      <!-- sorts on the cell's own text -->
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr><!-- repeat per row -->
          <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
          <td><h5><a data-sort="name" href="#!" class="hover:text-primary">Emily Parker</a></h5></td>
          <td><span class="badge badge-label bg-success/15 text-success">Paid</span></td>
          <td>$999.00 USD</td>
          <td><div class="flex justify-center gap-1.25">
            <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--eye text-base"></i></a>
            <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a>
          </div></td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="card-footer">
    <div data-table-pagination-info="invoices"></div>   <!-- "Showing 1 to 8 of 24 invoices" -->
    <div data-table-pagination></div>                   <!-- renders ul.pagination > li.page-item > a.page-link -->
  </div>
</div>
```

**Init / JS.** Nothing to call: the script ends with
`document.addEventListener("DOMContentLoaded", () => { new CustomTable })`. All selectors are
constructor options if you need different attribute names:

```js
new CustomTable({ tableSelector: "[data-table]", checkAllSelector: "[data-table-select-all]",
  searchSelector: "[data-table-search]", filterSelector: "select[data-table-filter], input[data-table-filter]",
  rangeFilterSelector: "select[data-table-range-filter], input[data-table-range-filter]",
  rowsPerPageSelector: "[data-table-set-rows-per-page]", rowsPerPageAttribute: "data-table-rows-per-page",
  paginationSelector: "[data-table-pagination]", sortSelector: "[data-table-sort]", sortAttribute: "data-table-sort",
  paginationInfoSelector: "[data-table-pagination-info]", deleteSelectedSelector: "[data-table-delete-selected]",
  deleteRowSelector: "[data-table-delete-row]", rowsPerPage: 10, currentPage: 1 });
```

**Gotchas.**
- Rows are DOM nodes sliced into pages: with no `[data-table-pagination]` element only the first
  `rows-per-page` rows ever render (file manager shows 8, email inbox 15 — the "Loading…" spinner under
  them is decorative). Add the pagination div or raise the attribute.
- Filters compare `td.textContent.trim()` case-insensitively against the option value; `""` and `"All"`
  mean no filter. Range filter only understands the four date presets above (the projects-list demo's
  "This Week/This Month" options silently do nothing) and `min-max` / `min+` numeric strings.
- Search is a substring match over all `td` text on `keyup`. Sort auto-detects `$1,234`, `12%`, `1.5K/M/B`,
  `(1,000)` negatives, ordinals and `Date.parse`-able strings; the sort icon is injected unless the `th`
  already contains an `<i>`.
- Delete opens a generated `#confirm-delete-modal` (`HSOverlay`) appended to `<body>`; the row is removed
  from the DOM only — wire your own fetch in a `#confirm-delete` click handler if you need persistence.
- Select-all toggles every row's checkbox (not just the visible page); the bulk Delete button is
  shown/hidden by the engine, so start it with `hidden`.

## File manager

**What it is.** Drive-style file browser: offcanvas/static sidebar (Upload button, My Files / Shared /
Recent / Favourites / Downloads / Trash, categories), a card header with search + type filter + rows
selector, a row of dashed folder cards, then a `data-table` file table (icon, size, type, modified,
owner, shared-with avatars, star toggle, action dropdown).
**Use it when.**
- Document/asset management: browsing, uploading, downloading, sharing, favouriting, trashing files.
- A media library for a CMS, or an attachment picker inside a ticket/project (drop the sidebar, keep the
  table, open it in an `hs-overlay` modal).
- Showing storage usage per folder (the folder cards carry the size line).
- NOT for a few attachments on one record — use the dashed attachment chips from Email details instead.
**Source.** `references/sources/pages/apps-file-manager.html` + `assets/js/pages/custom-table.js`.
No upload widget is wired: "Upload Files" is a plain `<a class="btn">`; add Dropzone from
`assets/plugins/dropzone/dropzone-min.js` as `form-fileuploads.html` does (forms.md) if you need a real dropzone.
**Markup.**

```html
<main class="pb-0!">
  <div class="page-title-head"><h4 class="page-main-title">File Manager</h4><!-- breadcrumb --></div>
  <div class="container-fluid">
    <div class="flex h-[calc(100vh-200px)]">
      <!-- sidebar: offcanvas below lg, static column at lg+ -->
      <div class="card h-full">
        <div id="fileSidebaroffcanvas" class="hs-overlay hs-overlay-open:translate-x-0 rounded fixed start-0 top-0 bottom-0 z-50 h-full w-62.5 -translate-x-full transform bg-card transition-all duration-300 [--auto-close:lg] lg:static lg:end-auto lg:bottom-0 lg:block! lg:translate-x-0" role="dialog" tabindex="-1">
          <div class="card-body h-full" data-simplebar>
            <a href="#!" class="btn w-full bg-danger text-white hover:bg-danger-hover">Upload Files</a>
            <div class="mt-5 flex flex-col">
              <a href="#" class="bg-default-100 font-medium flex items-center gap-2 rounded px-3 py-2 transition"><i class="iconify tabler--folder text-base"></i><span>My Files</span><span class="ms-auto badge text-2xs bg-danger/15 text-danger font-semibold">21</span></a>
              <a href="#" class="hover:bg-default-100 font-medium flex items-center gap-2 rounded px-3 py-2 transition"><i class="iconify tabler--share text-base text-default-700"></i><span>Shared with Me</span></a>
              <!-- tabler--clock Recent, tabler--star Favourites, tabler--download Downloads, tabler--trash Trash -->
            </div>
            <div class="mt-2.5">
              <div class="text-default-800 px-3 py-2 text-sm font-medium tracking-wider">Categories</div>
              <a href="#" class="hover:bg-default-100 font-medium flex items-center gap-2 rounded px-3 py-2 transition"><i class="iconify tabler--chart-donut text-primary text-sm"></i><span>Work</span></a>
            </div>
          </div>
        </div>
      </div>
      <!-- content -->
      <div class="min-w-0 flex-1">
        <div data-table data-table-rows-per-page="8" class="card h-full">
          <div class="card-header">
            <div class="flex gap-2.5">
              <div class="flex items-center gap-2.5 lg:hidden">
                <button class="btn btn-sm btn-icon border-default-300" data-hs-overlay="#fileSidebaroffcanvas"><i class="iconify tabler--menu-4 text-default-600 size-6"></i></button></div>
              <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search files..." class="form-input" /></div>
              <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button>
            </div>
            <div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap"><span class="me-2.5 font-semibold text-nowrap">Filter By:</span>
              <div class="input-icon-group"><i class="iconify tabler--file input-icon"></i>
                <select data-table-filter="type" class="form-select"><option value="">File Type</option><option value="Folder">Folder</option><option value="MP4">MP4</option></select></div>
              <select data-table-set-rows-per-page class="form-select"><option value="8">8</option><option value="20">20</option></select>
            </div>
          </div>
          <div class="card-body h-[calc(100%-100px)]" data-simplebar>
            <!-- folder cards -->
            <div class="grid grid-cols-1 gap-3 md:grid-cols-2 lg:grid-cols-4 mb-base">
              <div class="card border-default-300 border border-dashed"><!-- repeat per folder -->
                <div class="card-body p-2.5"><div class="flex items-center justify-between gap-3">
                  <div class="bg-light/50 text-default-400 flex size-9 items-center justify-center rounded-md"><i class="iconify tabler--folder text-2xl"></i></div>
                  <div><h5 class="mb-1.25 text-xs"><a href="#!" class="hover:text-primary">Premium Multi</a></h5><p class="text-default-400 text-xs">2.3 GB</p></div>
                  <div class="relative ms-auto"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
                    <button type="button" class="hs-dropdown-toggle text-xl text-default-400"><i class="iconify tabler--dots-vertical text-xl"></i></button>
                    <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5">
                      <a class="dropdown-item" href="#"><i class="iconify tabler--share"></i> Share</a>
                      <a class="dropdown-item" href="#"><i class="iconify tabler--link"></i> Get Sharable Link</a>
                      <a class="dropdown-item" href="file.zip" download><i class="iconify tabler--download"></i> Download</a>
                      <a class="dropdown-item" href="#"><i class="iconify tabler--pin"></i> Pin</a>
                      <a class="dropdown-item" href="#"><i class="iconify tabler--edit"></i> Edit</a>
                      <a class="dropdown-item" href="#"><i class="iconify tabler--trash"></i> Delete</a>
                    </div></div></div></div>
                </div></div>
              </div>
            </div>
            <!-- file table -->
            <div class="table-wrapper"><table class="table table-hover">
              <thead class="thead-sm border-t border-default-200"><tr class="bg-light/25 text-2xs uppercase">
                <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
                <th data-table-sort="name">Name</th><th data-table-sort data-column="type">Type</th><th data-table-sort>Modified</th>
                <th data-table-sort="owner">Owner</th><th>Shared with</th><th class="text-end">Actions</th></tr></thead>
              <tbody><tr><!-- repeat per file -->
                <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
                <td><div class="flex items-center gap-2.5">
                  <div class="bg-light/50 text-default-400 flex size-9 items-center justify-center rounded"><i class="iconify tabler--video text-xl"></i></div>
                  <div><h5 class="mb-1.25"><a data-sort="name" href="#!" class="hover:text-primary">Project Overview Video</a></h5><p class="text-default-400 text-xs">120MB</p></div></div></td>
                <td>MP4</td><td>April 2, 2025</td>
                <td><div class="flex items-center gap-2.5"><img src="assets/images/users/user-3.jpg" class="size-6 rounded-full" alt="" /><h5><a href="#!" data-sort="owner" class="hover:text-primary">john@techgroup.com</a></h5></div></td>
                <td><div class="flex items-center -space-x-2"><img src="assets/images/users/user-5.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-1" alt="" /><!-- more avatars --></div></td>
                <td><div class="flex items-center justify-end gap-3">
                  <!-- star toggle (abuses hs-toggle-password as a boolean switch) -->
                  <div class="relative"><span id="star-1"></span>
                    <button type="button" data-hs-toggle-password='{"target": "#star-1"}'>
                      <div class="hs-password-active:flex hidden items-center gap-1"><i class="iconify tabler--star-filled text-warning text-base"></i></div>
                      <div class="hs-password-active:hidden flex items-center gap-1"><i class="iconify tabler--star-filled text-default-400 text-base"></i></div>
                    </button></div>
                  <!-- same hs-dropdown action menu as the folder card -->
                </div></td>
              </tr></tbody>
            </table></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>
```

File-type icons used: `tabler--folder`, `tabler--video`, `tabler--brand-figma`, `tabler--file`,
`tabler--photo`, `tabler--music`, `tabler--file-zip`, `tabler--code`, `tabler--database`.
**Init / JS.** `custom-table.js` only (search, type filter, rows selector, select-all, bulk delete).
**Gotchas.**
- There is no `[data-table-pagination]`, so only 8 rows render; add the footer from the engine section
  or set `data-table-rows-per-page="100"`.
- `data-hs-toggle-password` needs a `target` element with an `id` — the empty `<span id="star-N">`
  is required, one unique id per row.
- The page uses `<main class="pb-0!">` and fixed heights (`h-[calc(100vh-200px)]`, inner
  `h-[calc(100%-100px)]` + `data-simplebar`) to get an app-like scroll region; keep those if you keep
  the layout, drop them for a normal scrolling page.

## Email inbox

**What it is.** Mailbox list: the same offcanvas sidebar pattern as the file manager (Compose button,
Inbox/Sent/Starred/Scheduled/Drafts/… with count badges, Labels), a toolbar of icon buttons with
tooltips (delete, mark read, tag, archive, move, forward, snooze, important) plus search, and a
`table.table-hover` without `<thead>` whose rows are the messages (checkbox, star, avatar + sender,
subject — preview, attachment count, time). Read rows get `mark-as-read opacity-75`.
**Use it when.**
- Any message queue: support ticket inbox, notification centre, approval requests, moderation queue,
  comment moderation.
- Lists where the whole row is one link: the subject `<a>` uses `after:absolute after:inset-0` on a
  `tr.relative` so the entire row is clickable while the checkbox keeps `z-10`.
**Source.** `references/sources/pages/apps-email-inbox.html` + `custom-table.js` + `assets/js/pages/apps-email.js`.
**Markup.**

```html
<div class="container-fluid">
  <div class="lg:flex lg:h-[calc(100vh-200px)]">
    <div class="card h-full">
      <div id="emailSidebaroffcanvas" class="hs-overlay hs-overlay-open:translate-x-0 fixed rounded start-0 top-0 bottom-0 z-50 hidden bg-card h-full w-56.5 -translate-x-full transform transition-all duration-300 [--auto-close:lg] lg:static lg:end-auto lg:bottom-0 lg:block! lg:translate-x-0" role="dialog" tabindex="-1">
        <div class="card-body h-full" data-simplebar>
          <a href="apps-email-compose.html" class="btn w-full bg-danger text-white hover:bg-danger-hover">Compose</a>
          <div class="mt-5 flex flex-col">
            <a href="#" class="bg-default-100 font-medium flex items-center gap-2 rounded px-3 py-2 transition"><i class="iconify tabler--inbox text-base"></i><span>Inbox</span><span class="ms-auto badge text-2xs bg-danger/15 text-danger font-semibold">21</span></a>
            <a href="#" class="hover:bg-default-100 font-medium flex items-center gap-2 rounded px-3 py-2 transition"><i class="iconify tabler--send-2 text-base text-default-700"></i><span>Sent</span></a>
            <!-- tabler--star Starred, tabler--clock Scheduled, tabler--pencil Drafts (badge bg-secondary/15 text-secondary) -->
          </div>
          <div class="mt-2.5"><div class="text-default-800 px-3 py-2 text-sm font-medium tracking-wider">Labels</div>
            <a href="#" class="hover:bg-default-100 font-medium flex items-center gap-2 rounded px-3 py-2 transition"><i class="iconify tabler--chart-donut text-primary text-sm"></i><span>Business</span></a>
          </div>
        </div>
      </div>
    </div>
    <div class="w-full min-w-0 flex-1">
      <div data-table data-table-rows-per-page="15" class="card rounded-none h-full">
        <div class="card-header lg:hidden">  <!-- mobile: sidebar toggle + search -->
          <button class="btn btn-icon border-default-300 rounded border" data-hs-overlay="#emailSidebaroffcanvas"><i class="iconify tabler--menu-4 text-default-600 size-6"></i></button>
          <div class="input-icon-group inline-flex"><i class="iconify tabler--search input-icon"></i><input data-table-search type="text" class="form-input" placeholder="Search mails..." /></div>
        </div>
        <div class="card-header">
          <div class="flex flex-wrap items-center gap-1.25">
            <input class="form-checkbox form-checkbox-light size-4.5 me-6" type="checkbox" id="select-all-email" />
            <span class="hs-tooltip inline-block [--placement:top]"><!-- repeat per toolbar action -->
              <button type="button" class="hs-tooltip-toggle btn btn-icon size-7.75 border-default-300 hover:border-default-400/50 hover:text-primary"><i class="iconify tabler--trash text-base"></i>
                <span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible bg-dark invisible absolute z-10 inline-block rounded px-2 py-1 text-xs font-medium text-white opacity-0 transition-opacity" role="tooltip">Delete</span></button></span>
            <!-- tabler--mail-opened Mark as Read · tabler--tag Tag · tabler--archive Archive · tabler--folder Move to Folder · tabler--mail-forward Forward · tabler--clock-pause Snooze · tabler--alert-circle Mark as Important -->
          </div>
          <div class="input-icon-group hidden lg:inline-flex"><i class="iconify tabler--search input-icon"></i><input data-table-search type="text" class="form-input" placeholder="Search mails..." /></div>
        </div>
        <div class="lg:h-[calc(100vh-275px)] h-[calc(100vh-360px)]" data-simplebar>
          <div class="table-wrapper"><table class="table table-hover table-select"><tbody>
            <tr class="relative"><!-- unread row -->
              <td class="ps-6 w-[1%]"><div class="flex items-center gap-6">
                <input class="form-checkbox form-checkbox-light size-4.5 z-10 email-item-check" type="checkbox" />
                <button class="flex text-warning"><i class="iconify tabler--star-filled text-lg"></i></button></div></td>
              <td><div class="flex items-center gap-2.5"><img src="assets/images/users/user-5.jpg" class="size-6 rounded-full" alt="" /><h5>Amanda Reyes</h5></div></td>
              <td><a href="apps-email-details.html" class="hover:text-primary font-medium after:absolute after:inset-0">Design Review & Feedback</a><span class="hidden lg:inline-block">—</span><span class="text-default-400 hidden lg:inline-block">I've reviewed the updated UI mockups…</span></td>
              <td><div class="flex items-center gap-1.25"><i class="iconify tabler--paperclip"></i><span class="font-semibold">3</span></div></td>
              <td><p class="text-default-400 pe-3 text-end text-xs">Apr 20, 10:12 AM</p></td>
            </tr>
            <tr class="relative mark-as-read opacity-75"><!-- read row: initials avatar variant -->
              <td class="ps-6 w-[1%]"><div class="flex items-center gap-6"><input class="form-checkbox form-checkbox-light size-4.5 z-10 email-item-check" type="checkbox" /><button class="flex text-default-400"><i class="iconify tabler--star text-lg"></i></button></div></td>
              <td><div class="flex items-center gap-3"><div class="avatar-xs"><span class="btn btn-icon bg-primary/70 size-6! rounded-full font-semibold text-white">L</span></div><h5>Lucas Martin</h5></div></td>
              <!-- … -->
            </tr>
          </tbody></table></div>
          <div class="flex items-center justify-center gap-2.5 p-5"><strong>Loading...</strong>
            <div class="text-danger inline-block size-4 animate-spin rounded-full border-2 border-current border-t-transparent" role="status"></div></div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** `apps-email.js` is three lines: `#select-all-email` change → sets every
`.email-item-check`. `custom-table.js` provides the search (the root has no `thead`, so sort/filter
are skipped) and limits rendering to 15 rows.
**Gotchas.**
- The star button is static markup (no toggle); copy the `hs-toggle-password` trick from the file
  manager if you want it interactive.
- Keep `tr.relative` + `after:absolute after:inset-0` on the subject link and `z-10` on the checkbox,
  otherwise clicking the checkbox navigates.
- `.table-select` is not a template class (nothing in app.min.css); harmless, but don't rely on it.
- The sidebar `id` is reused across inbox/details/compose so the mobile toggle button can stay identical.

## Email details (thread view)

**What it is.** Same sidebar + a reading card: toolbar (back, delete, mark read, archive, move), a
sticky subject `h4`, one collapsible block per message in the thread (`hs-collapse`; header = avatar,
name, email, star/forward/read icons, timestamp), attachments as dashed chips, a hidden sticky reply
composer toggled by the footer "Reply" button, and Forward/Print buttons.
**Use it when.**
- Ticket / conversation detail where older replies collapse and only the latest is open.
- Any "record + comment thread" page where you want a lightweight reply box without Quill.
**Source.** `references/sources/pages/apps-email-details.html` (Preline `hs-collapse`, no page script).
**Markup.**

```html
<div data-table data-table-rows-per-page="15" class="card z-90 rounded-none h-full">
  <div class="card-header justify-between">
    <div class="flex flex-wrap items-center gap-1.25">
      <span class="hs-tooltip [--placement:top] inline-block"><a href="apps-email-inbox.html" class="hs-tooltip-toggle btn btn-icon size-8 border border-default-300"><i class="iconify tabler--arrow-left text-base text-default-800"></i><span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible opacity-0 transition-opacity inline-block absolute invisible z-90 py-1 px-2 bg-dark text-xs font-medium text-white rounded" role="tooltip">Back to Inbox</span></a></span>
      <!-- tabler--trash, tabler--mail-opened, tabler--archive, tabler--folder as btn.btn-icon.size-8.border.border-default-300 -->
    </div>
    <div class="flex items-center gap-1.5">
      <button type="button" class="btn btn-icon size-7.5 text-secondary hover:bg-secondary hover:text-white rounded-full"><i class="iconify tabler--corner-up-right-double text-lg"></i></button>
      <button type="button" class="btn btn-icon size-7.5 text-dark hover:bg-dark hover:text-white rounded-full"><i class="iconify tabler--dots-vertical text-lg"></i></button>
    </div>
  </div>
  <div class="card-body py-0 lg:h-[calc(100vh-334px)] h-[calc(100vh-420px)]" data-simplebar>
    <h4 class="py-5 text-lg sticky top-0 card border-none! rounded-none! z-20">Design Reviews & Feedback</h4>

    <div class="pb-base border-b border-dashed border-default-300"><!-- repeat per message; last one open -->
      <div class="flex justify-between items-center flex-wrap">
        <button type="button" class="hs-collapse-toggle" id="EmailOne" aria-expanded="false" aria-controls="EmailOne-heading" data-hs-collapse="#EmailOne-heading">
          <a class="flex items-center text-reset"><img src="assets/images/users/user-3.jpg" class="size-9 rounded-full" alt="" />
            <div class="ms-2.5 overflow-hidden text-start"><h5>John Maxwell</h5><p class="text-default-400">john.maxwell@uxstudio.com</p></div></a>
        </button>
        <div class="md:ms-auto flex items-center gap-1">
          <button class="btn btn-icon hover:bg-default-100 size-8 rounded-full text-default-800"><i class="iconify tabler--star-filled text-warning text-base"></i></button>
          <button class="btn btn-icon hover:bg-default-100 size-8 rounded-full text-default-800"><i class="iconify tabler--mail-forward text-base"></i></button>
          <button class="btn btn-icon hover:bg-default-100 size-8 rounded-full text-default-800"><i class="iconify tabler--mail-opened text-base"></i></button>
          <span class="text-default-400 text-xs ms-2">Apr 11, 07:47 AM</span>
        </div>
      </div>
      <div id="EmailOne-heading" class="hs-collapse hidden w-full overflow-hidden transition-[height] duration-300" aria-labelledby="EmailOne">
        <div class="mt-5"><p class="mb-4">Hey team,</p><p class="mb-4">…</p><p class="font-medium">John</p></div>
        <!-- attachments (optional) -->
        <div class="mt-5"><h4 class="text-default-400 text-sm">2 Attachments</h4>
          <div class="mt-4 flex flex-wrap gap-base">
            <div class="flex p-2.5 gap-2.5 items-center text-start relative border border-dashed border-default-300 rounded group">
              <i class="iconify tabler--file text-2xl text-danger"></i>
              <div><h4 class="mb-1.25"><a href="#!" class="group-hover:text-primary">footer-contrast-notes.pdf</a></h4><p class="text-xs">1.2 MB</p></div>
              <i class="iconify tabler--download text-default-400 text-2xl"></i>
            </div>
          </div></div>
      </div>
    </div>

    <!-- reply composer: hidden, sticky at bottom, toggled from footer -->
    <div id="EmailReply-heading" class="hs-collapse hidden sticky bottom-0 z-10 w-full overflow-hidden transition-[height] duration-300" aria-labelledby="EmailReply">
      <div class="card border border-default-300 mb-4">
        <textarea class="form-textarea border-0!" rows="6" placeholder="Enter message"></textarea>
        <div class="bg-light/15 border-t border-default-300 p-3"><div class="flex flex-wrap gap-1.5 items-center">
          <span class="hs-tooltip [--placement:top] inline-block"><button type="button" class="hs-tooltip-toggle btn btn-icon bg-default-100 size-8"><i class="iconify tabler--bold text-xs"></i><span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible opacity-0 transition-opacity inline-block absolute invisible z-10 py-1 px-2 bg-dark text-xs font-medium text-white rounded" role="tooltip">Bold</span></button></span>
          <!-- tabler--italic, tabler--paperclip, tabler--link, tabler--photo-up -->
          <button type="button" class="btn btn-sm bg-light ms-auto"><i class="iconify tabler--x text-xs"></i> Cancel</button>
          <button type="button" class="btn btn-sm bg-success text-white"><i class="iconify tabler--send-2 text-xs"></i> Send</button>
        </div></div>
      </div>
    </div>
  </div>
  <div class="card-footer border-t border-dashed"><div class="flex flex-wrap gap-3 items-center justify-between">
    <button class="hs-collapse-toggle btn btn-sm border border-default-300 hover:border-default-400 hover:bg-default-50" id="EmailReply" data-hs-collapse="#EmailReply-heading"><i class="iconify tabler--corner-up-left text-base"></i><span class="font-medium">Reply</span></button>
    <button class="btn btn-sm border border-default-300 hover:border-default-400 hover:bg-default-50" type="button"><i class="iconify tabler--corner-up-right-double text-base"></i><span class="font-medium">Forward</span></button>
    <button class="btn btn-sm border border-default-300 hover:border-default-400 hover:bg-default-50" type="button"><i class="iconify tabler--printer text-base"></i><span class="font-medium">Print</span></button>
  </div></div>
</div>
```

**Gotchas.**
- Open the latest message by omitting `hidden` on its `.hs-collapse` panel (demo: `#EmailThree-heading`).
- The wrapping card has `z-90` so its tooltips sit above the sticky subject bar; the subject `h4` reuses
  `.card` to get an opaque background while sticky.
- Attachment chip icons by type: `tabler--file text-danger` (pdf), `tabler--photo text-secondary` (image).
- The reply toolbar buttons are visual only; for real formatting use the Quill composer below.

## Email compose (Quill)

**What it is.** Compose screen: borderless To / Cc / Bcc / Subject inputs (Cc and Bcc revealed by
`hs-collapse` links), a Quill "snow" editor (`#snow-editor`, toolbar icons swapped for Tabler SVGs),
and a footer with a split Send button (`hs-dropdown`: Send & Archive, Schedule Send, Save as Draft,
Discard), settings and delete icons.
**Use it when.**
- Sending email / announcements / templated notifications from the admin.
- Any long-form rich-text input with recipients (internal memo, customer reply from a ticket).
**Source.** `references/sources/pages/apps-email-compose.html`, `assets/plugins/quill/quill.js`,
`assets/js/pages/apps-email-compose.js`. Quill's snow/bubble CSS is compiled into `app.min.css` (`.ql-*`
rules present); do not link `quill.snow.css` separately.
**Markup.**

```html
<div class="card h-full rounded-none">
  <div class="card-header"><h4 class="card-title">Compose Message</h4></div>
  <div class="lg:h-[calc(100vh-270px)] h-[calc(100vh-360px)]" data-simplebar data-simplebar-md>
    <div class="card-body border-default-300 border-b border-dashed py-3">
      <div class="flex items-center justify-between">
        <div class="flex items-center"><span class="text-sm font-semibold">To:</span><input type="text" class="form-input border-0! focus:border-0!" placeholder="Enter emails.." /></div>
        <div class="flex gap-4">
          <button type="button" class="hs-collapse-toggle underline" id="email-cc" data-hs-collapse="#email-cc-heading">Cc</button>
          <button type="button" class="hs-collapse-toggle underline" id="email-bcc" data-hs-collapse="#email-bcc-heading">Bcc</button>
        </div>
      </div>
    </div>
    <div id="email-cc-heading" class="hs-collapse card-body border-default-300 hidden w-full overflow-hidden border-b border-dashed py-4! transition-[height] duration-300" aria-labelledby="email-cc">
      <div class="flex items-center"><span class="text-sm font-semibold">Cc:</span><input type="text" class="form-input border-0! py-3 focus:border-0!" placeholder="Enter emails.." /></div>
    </div>
    <div id="email-bcc-heading" class="hs-collapse card-body border-default-300 hidden w-full overflow-hidden border-b border-dashed py-4! transition-[height] duration-300" aria-labelledby="email-bcc"><!-- Bcc input --></div>
    <div class="card-body py-3 border-default-300 border-b border-dashed">
      <input type="text" class="form-input border-0! focus:border-0! font-semibold ps-0" placeholder="Subject" />
    </div>
    <div class="email-editor">
      <div id="snow-editor"><p>Hi <strong><em>James</em></strong>,</p><p>…initial HTML becomes the editor content…</p></div>
    </div>
    <div class="bg-light/15 border-light border-b p-2.5"><div class="flex items-center justify-between gap-1.25">
      <div class="inline-flex">
        <button type="button" class="btn bg-primary hover:bg-primary-hover relative rounded-e-none! text-white"><i class="iconify tabler--send-2 text-base"></i> Send</button>
        <div class="hs-dropdown relative inline-flex [--placement:bottom-left]">
          <button type="button" class="hs-dropdown-toggle btn btn-icon bg-primary/85 hover:bg-primary-hover relative rounded-s-none! text-white"><i class="iconify tabler--chevron-down text-base"></i></button>
          <div class="hs-dropdown-menu" role="menu"><a class="dropdown-item" href="#">Send & Archive</a><a class="dropdown-item" href="#">Schedule Send</a><a class="dropdown-item" href="#">Save as Draft</a><hr class="dropdown-divider" /><a class="dropdown-item" href="#">Discard</a></div>
        </div>
      </div>
      <div class="flex gap-1.25">
        <button type="button" class="btn btn-icon bg-default-200 size-7.75!"><i class="iconify tabler--settings text-sm"></i></button>
        <button type="button" class="btn btn-icon bg-danger/15 text-danger hover:bg-danger size-7.75! hover:text-white"><i class="iconify tabler--trash text-sm"></i></button>
      </div>
    </div></div>
  </div>
</div>
```

**Init / JS.** (`apps-email-compose.js`, trimmed — the script first overrides
`Quill.import("ui/icons")` entries `bold italic underline strike list.ordered bullet link image video
color background blockquote` with Tabler SVG strings)

```js
const el = document.getElementById("snow-editor");
el && new Quill(el, { theme: "snow", modules: { toolbar: [
  [{ header: [false, 1, 2, 3, 4, 5, 6] }], ["bold", "italic", "underline", "strike"],
  [{ color: [] }, { background: [] }], ["blockquote", "code-block"],
  [{ list: "ordered" }, { list: "bullet" }], ["link", "image", "video"] ] } });
```

Read the HTML back with `quill.root.innerHTML` (or `quill.getSemanticHTML()` in Quill 2) when sending.
**Gotchas.**
- Wrap the editor in `.email-editor` (template class) so the toolbar/borders match the card.
- Load order: `vendors.min.js` → `app.js` → `assets/plugins/quill/quill.js` → page script. Quill is
  not in `vendors.min.js`.
- `data-simplebar-md` on the scroll wrapper disables SimpleBar below `md` (native scroll on phones).

## Chat

**What it is.** Two-column messenger: left card = search + "new chat" button (opens
`#createSingleChatModal`) + a SimpleBar contact list (`#chat-sidebar`, items carry `data-chat-id`);
right card = header (contact name via `[data-chat-username]`, Active status, video/audio call buttons
that open full-screen dark modals, export dropdown), message area `#chat-container[data-chat]`, and a
composer row (input + `[data-send]` button). A `Chat` class holds a `chatData` array and re-renders
the thread on contact switch.
**Use it when.**
- Live support chat, team DMs, customer messaging inside a CRM, AI assistant chat.
- NOT for threaded/async discussions — use Forum post or the comments tab from Project details.
**Source.** `references/sources/pages/apps-chat.html`, `assets/js/pages/apps-chat.js`.
**Markup.**

```html
<div class="container-fluid">
  <div class="flex h-[calc(100vh-190px)]">
    <!-- contacts -->
    <div id="chatSidebaroffcanvas" class="hs-overlay hs-overlay-open:translate-x-0 fixed start-0 top-0 bottom-0 z-70 h-full w-80 -translate-x-full transform transition-all duration-300 [--auto-close:lg] lg:static lg:block lg:translate-x-0" role="dialog" tabindex="-1">
      <div class="card rounded-e-none">
        <div class="card-header p-5 gap-3">
          <div class="input-icon-group grow"><i class="iconify tabler--search input-icon"></i><input data-chat-search type="search" placeholder="Search here..." class="form-input bg-light/30" /></div>
          <a href="#!" class="btn bg-dark btn-icon size-9.25 text-white" data-hs-overlay="#createSingleChatModal"><i class="iconify tabler--pencil text-lg"></i></a>
        </div>
        <div id="chat-sidebar" class="lg:h-[calc(100vh-265px)] h-screen p-2.5" data-simplebar>
          <div class="*:[.active]:bg-default-100 *:hover:bg-default-100 space-y-0.5 list-group">
            <a href="#" data-chat-id="chat1" class="block w-full rounded active list-group-item"><!-- repeat per contact -->
              <div class="flex justify-between gap-2.5 px-3.75 py-3">
                <div class="flex items-center gap-2.5"><img src="assets/images/users/user-4.jpg" class="size-8 rounded-full" alt="" />
                  <span class="text-start overflow-hidden"><span data-chat-search-field class="font-semibold text-nowrap">Ava Thompson</span><span class="text-default-400 block truncate text-xs max-w-40">I'll send the invoice by evening.</span></span></div>
                <span class="flex shrink-0 flex-col items-end justify-center gap-1.25"><span class="text-default-400 text-xs">Just Now</span><span class="badge text-2xs bg-primary text-white">2</span></span>
              </div>
            </a>
            <!-- initials avatar variant: <div class="bg-primary flex size-8 items-center justify-center rounded-full font-semibold text-white">EW</div> -->
          </div>
        </div>
      </div>
    </div>
    <!-- thread -->
    <div class="card min-w-0 flex-1 rounded-s-none">
      <div class="card-header">
        <div class="flex items-center gap-4">
          <div class="flex items-center gap-2 lg:hidden!"><button class="btn btn-sm btn-icon border-default-300" data-hs-overlay="#chatSidebaroffcanvas"><i class="iconify tabler--menu-4 text-default-600 size-6"></i></button></div>
          <div><h5 class="text-base mb-1.25"><a data-chat-username href="#!" class="hover:text-primary">Ava Thompson</a></h5>
            <p class="text-default-400 flex items-center leading-tight gap-1.5"><i class="iconify tabler--circle-filled text-success"></i> Active</p></div>
        </div>
        <div class="flex gap-1.25">
          <button class="btn btn-icon border-default-300 hover:border-default-400/75 hover:bg-default-50" data-hs-overlay="#videoCallModal"><i class="iconify tabler--video size-4.25"></i></button>
          <button class="btn btn-icon border-default-300 hover:border-default-400/75 hover:bg-default-50" data-hs-overlay="#audioCallModal"><i class="iconify tabler--phone-call size-4.25"></i></button>
          <div class="hs-dropdown inline-flex [--placement:bottom-right]"><button type="button" class="hs-dropdown-toggle btn btn-icon border-default-300 hover:border-default-400/75 hover:bg-default-50"><i class="iconify tabler--dots-vertical text-sm"></i></button>
            <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a href="#" class="dropdown-item"><i class="iconify tabler--user"></i> Export as PDF</a></div></div></div>
        </div>
      </div>
      <div class="h-[calc(100vh-333px)]" data-simplebar>
        <div id="chat-container" data-chat class="card-body pb-2.5 py-0">
          <!-- incoming -->
          <div class="my-5 flex items-start gap-2.5"><img src="assets/images/users/user-4.jpg" class="size-9 rounded-full" alt="" />
            <div><div class="bg-warning/15 rounded px-6 py-3">Hey! Are you available for a quick call?</div>
              <div class="text-default-400 mt-1.5 flex items-center gap-1 text-xs"><i class="iconify tabler--clock"></i> 08:55 am</div></div></div>
          <!-- outgoing -->
          <div class="my-5 flex items-start justify-end gap-2.5">
            <div><div class="bg-info/15 rounded px-6 py-3">Sure, give me 5 minutes.</div>
              <div class="text-default-400 mt-1.5 flex items-center justify-end gap-1 text-xs"><i class="iconify tabler--clock"></i> 08:57 am</div></div>
            <img src="assets/images/users/user-2.jpg" class="size-9 rounded-full" alt="" /></div>
        </div>
      </div>
      <div class="border-t border-default-300 border-dashed px-6 py-3.75"><div class="flex gap-2">
        <div class="input-icon-group grow"><i class="iconify tabler--message input-icon"></i><input data-chat-input type="text" class="form-input bg-light/20" placeholder="Enter message..." /></div>
        <a data-send href="#!" class="btn bg-primary text-white hover:bg-primary-hover">Send <i class="iconify tabler--send-2 ms-1 text-xl"></i></a>
      </div></div>
    </div>
  </div>
</div>

<!-- new chat modal (outside <main>) -->
<div id="createSingleChatModal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" role="dialog" tabindex="-1">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 m-3 flex min-h-[calc(100%-56px)] scale-95 opacity-0 transition-all duration-200 ease-in-out md:mx-auto md:w-full md:max-w-lg">
    <div class="card pointer-events-auto flex w-full flex-col">
      <div class="card-header"><h3 class="text-sm font-bold">Start New Chat</h3><button type="button" data-hs-overlay="#createSingleChatModal"><i class="iconify tabler--x text-xl"></i></button></div>
      <div class="card-body overflow-y-auto">
        <div class="mb-5"><label class="form-label">Recipient</label><input type="text" class="form-input" placeholder="Enter username or email" /></div>
        <div><label class="form-label">Message</label><textarea class="form-textarea" rows="3" placeholder="Type your message here..."></textarea></div>
      </div>
      <div class="border-default-300 flex items-center justify-end gap-x-2 border-t border-dashed p-5">
        <button type="button" class="btn bg-light hover:text-primary" data-hs-overlay="#createSingleChatModal">Cancel</button>
        <button type="button" class="btn bg-primary text-white hover:bg-primary-hover">Send Message</button>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** (`apps-chat.js`) `new Chat({ data: chatData })` on `DOMContentLoaded`, where
`chatData = [{ id: "chat1", contact: { name, avatar }, messages: [{ from: "me" | name, text, time, avatar }] }]`.
Constructor options and what they do:

```js
new Chat({
  sidebarSelector: "#chat-sidebar",        // click delegation on [data-chat-id] → switchChat(id)
  sidebarContactAttribute: "data-chat-id",
  searchSelector: "[data-chat-search]",    // keyup filters .list-group .list-group-item by [data-chat-search-field] text
  contentSelector: "[data-chat]",          // thread container; innerHTML replaced by renderMessages()
  inputSelector: "[data-chat-input]",      // Enter key sends; input toggles send button disabled
  sendSelector: "[data-send]",
  errorSelector: "[data-error]",           // optional "Message cannot be empty." element
  usernameSelector: "[data-chat-username]",
  data: chatData });
```
`renderMessages()` builds bubbles with `bg-warning/15` (them) / `bg-info/15` (me), auto-scrolls via
`SimpleBar.instances.get(container)` when present, and `simulateIncomingMessage()` fakes a reply after
1–3 s — remove that for production and push messages from your socket into `chat.getChatById(id).messages`
then call `chat.renderMessages(...)`.
**Gotchas.**
- The shipped HTML is NOT fully wired: the composer input lacks `data-chat-input`, the search lacks
  `data-chat-search`, and the list has no `.list-group`/`.list-group-item` classes — so send and search do
  nothing in the demo. The skeleton above adds all three; keep them.
- The first entry of `chatData` is auto-selected on init and the thread markup in the HTML is
  immediately replaced, so the static bubbles are only a no-JS fallback.
- Video/audio call modals (`#videoCallModal`, `#audioCallModal`) are `card !bg-dark` overlays with
  Camera/Mic/End Call buttons — purely presentational.

## Calendar (FullCalendar)

**What it is.** Left card (lg+ only) with "Create New Event" button and a draggable list of
`.external-event` chips; right card with `#calendar`. FullCalendar v6 global build renders month /
week / day / list views with Tailwind theme; `#event-modal` (outside `<main>`) is a Preline modal with
Event Name + Category (colour class) used for both create and edit; a `CalendarApp` class wires it.
**Use it when.**
- Scheduling: appointments, bookings, shifts, content calendar, deadlines, room reservations.
- Drag-to-create from a palette (the external events) — e.g. drag "Sales Demo" onto a day.
- NOT for a date-picker in a form — use flatpickr (`data-provider="flatpickr"`, handled by app.js).
**Source.** `references/sources/pages/apps-calendar.html`, `assets/plugins/fullcalendar/index.global.min.js`,
`assets/js/pages/apps-calendar.js`. FullCalendar CSS (`.fc-*`) is compiled into `app.min.css`.
**Markup.**

```html
<div class="container-fluid">
  <div class="flex lg:h-[calc(100vh-192px)]">
    <div class="card hidden lg:flex h-full">
      <div class="card-body">
        <button class="btn bg-primary w-full text-white" data-hs-overlay="#event-modal"><i class="iconify tabler--plus align-middle"></i> Create New Event</button>
        <div id="external-events">
          <p class="text-default-400 mt-2.5 mb-5 text-xs italic">Drag and drop your event or click in the calendar</p>
          <div data-class="!text-primary" class="text-primary external-event fc-event bg-primary/10 my-1.5 rounded px-4 py-2 font-semibold"><i class="iconify tabler--circle-filled me-2"></i> Design Review</div>
          <div data-class="!text-success" class="text-success external-event fc-event bg-success/10 my-1.5 rounded px-4 py-2 font-semibold"><i class="iconify tabler--circle-filled me-2"></i> Sales Demo</div>
          <!-- secondary / danger / info / warning / dark variants -->
        </div>
      </div>
    </div>
    <div class="card flex-1 h-full">
      <div class="card-header inline-flex lg:hidden"><button class="btn bg-primary w-full text-white" data-hs-overlay="#event-modal"><i class="iconify tabler--plus align-middle"></i> Create New Event</button></div>
      <div class="card-body"><div id="calendar"></div></div>
    </div>
  </div>
</div>

<!-- event modal (outside <main>) -->
<div id="event-modal" class="hs-overlay hidden size-full fixed top-0 start-0 z-80 overflow-x-hidden overflow-y-auto pointer-events-none" role="dialog" tabindex="-1">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 scale-95 opacity-0 ease-in-out transition-all duration-200 sm:max-w-lg sm:w-full m-3 sm:mx-auto min-h-[calc(100%-56px)] flex items-center">
    <div class="card w-full flex flex-col border border-default-200 shadow-2xs pointer-events-auto">
      <div class="card-header p-5"><h3 id="modal-title" class="font-semibold text-base text-default-800 dark:text-white">Create Event</h3>
        <button type="button" class="size-5 text-default-800" data-hs-overlay="#event-modal"><span data-icon="x" class="text-xl"></span></button></div>
      <form class="needs-validation" id="form-event" autocomplete="off">
        <div class="card-body"><div class="grid grid-cols-1 gap-4">
          <div><label for="event-title" class="form-label">Event Name</label><input type="text" id="event-title" class="form-input" placeholder="Insert Event Name" required /></div>
          <div><label for="event-category" class="form-label">Category</label>
            <select class="form-input flex items-center" id="event-category" required>
              <option selected value="!text-primary">Primary</option><option value="!text-success">Success</option><option value="!text-info">Info</option><option value="!text-warning">Warning</option><option value="!text-danger">Danger</option>
            </select></div>
        </div></div>
        <div class="card-footer flex gap-2 md:justify-end">
          <button type="button" data-hs-overlay="#event-modal" id="btn-delete-event" class="btn bg-light hover:text-primary">Cancel</button>
          <button type="submit" id="btn-save-event" class="btn bg-primary text-white hover:bg-primary-hover">Save</button>
        </div>
      </form>
    </div>
  </div>
</div>
```

**Init / JS.** (`apps-calendar.js`, trimmed — required ids: `#calendar #external-events #event-modal
#modal-title #form-event #event-title #event-category #btn-delete-event #btn-save-event`, optional
`#drop-remove` checkbox)

```js
this.calendarObj = new FullCalendar.Calendar(document.getElementById("calendar"), {
  timeZone: "local", editable: true, droppable: true, selectable: true,
  height: window.innerHeight - 240, themeSystem: "tailwindcss",
  headerToolbar: { left: "prev,next,today", center: "title", right: "dayGridMonth,timeGridWeek,timeGridDay,listMonth" },
  drop: (e) => dropRemove.checked && e.draggedEl.parentNode.removeChild(e.draggedEl),
  eventClick: (e) => { HSOverlay.open("#event-modal"); form.reset(); this.selectedEvent = e.event;
    title.value = e.event.title; category.value = e.event.classNames[0]; deleteBtn.classList.remove("hidden"); saveBtn.innerText = "Edit Event"; },
  dateClick: (e) => { HSOverlay.open("#event-modal"); form.reset(); this.newEventData = e; modalTitle.innerText = "Add Event"; deleteBtn.classList.add("hidden"); },
  events: [{ title: "Interview - Backend Engineer", start: new Date(), end: new Date(),
             className: "bg-primary/15 !text-primary border-s! !border-[3px] border-primary" } /* … */ ]
});
form.addEventListener("submit", (e) => { e.preventDefault();
  if (this.selectedEvent) { this.selectedEvent.setProp("title", title.value); this.selectedEvent.setProp("classNames", [category.value]); }
  else this.calendarObj.addEvent({ title: title.value, start: this.newEventData.date, allDay: this.newEventData.allDay, className: category.value });
  HSOverlay.close("#event-modal"); });
deleteBtn.addEventListener("click", () => { this.selectedEvent?.remove(); HSOverlay.close("#event-modal"); });
this.calendarObj.render();
new FullCalendar.Draggable(document.getElementById("external-events"), {
  itemSelector: ".external-event", eventData: (el) => ({ title: el.innerText, classNames: el.getAttribute("data-class") }) });
// boot: document.addEventListener("DOMContentLoaded", () => setTimeout(() => new CalendarApp().init(), 20));
```

Event colouring is done with Tailwind classes on `className`: seeded events use
`bg-<colour>/15 !text-<colour> border-s! !border-[3px] border-<colour>`; the modal/palette only set
`!text-<colour>`.
**Gotchas.**
- The script queries `#drop-remove`, `#businessCalendar`, `#weekNumberCalendar` which are not in the
  page; `#drop-remove` being `null` makes `drop:` throw on the first external drop — add
  `<input type="checkbox" id="drop-remove">` (hidden if you like) or remove the handler.
- `#btn-delete-event` doubles as the Cancel button (it carries `data-hs-overlay` to close) and is
  hidden for new events, so there is no visible Cancel when creating — add a separate one if needed.
- `height` is fixed at `window.innerHeight - 240` once; call `calendarObj.updateSize()` on resize or
  use `height: "auto"`.
- Persist events by replacing `events: [...]` with an `events: "/api/events"` feed and hooking
  `eventDrop` / `eventResize` / the submit handler to your API.

## Social feed

**What it is.** Three-column community page (`container` → `grid lg:grid-cols-4`): sticky left card
with profile header + nav (News Feed / Messages / Friends / Notifications … with badges) + categories,
inside an offcanvas wrapper for mobile; middle column (`lg:col-span-2`) with a "What's on your mind?"
composer and a stream of post cards (text, image mosaic, quote, poll, comments with reply input);
right column with Trending, Requests (with Accept/Review buttons) and a featured video card.
**Use it when.**
- Internal social intranet, community/announcement feed, customer forum home.
- Post composer + comment thread patterns reusable in any "record with discussion" page.
- Polls: a radio list inside a card with a submit button.
**Source.** `references/sources/pages/apps-social-feed.html` (no page script; like-toggle uses
`hs-toggle-password`).
**Markup.**

```html
<div class="container"><div class="lg:gap-base grid grid-cols-1 lg:grid-cols-4">
  <!-- left: profile + nav (sticky) -->
  <div><div class="card overflow-hidden lg:top-22 lg:sticky">
    <div id="outlookSidebaroffcanvas" class="hs-overlay hs-overlay-open:translate-x-0 fixed start-0 top-0 bottom-0 z-50 lg:z-10 hidden h-full lg:min-w-auto min-w-75 -translate-x-full transform bg-card transition-all duration-300 [--auto-close:lg] lg:static lg:end-auto lg:bottom-0 lg:block! lg:translate-x-0" role="dialog" tabindex="-1">
      <div class="card-body h-full" data-simplebar>
        <div class="mb-5 flex items-center justify-between">
          <div class="flex items-center gap-2.5"><img src="assets/images/users/user-3.jpg" class="size-10.5 rounded" alt="" />
            <div><h5 class="flex items-center"><a href="#!" class="hover:text-primary">Damian D.</a><img src="assets/images/flags/us.svg" class="ms-2.5 size-4 rounded-full" alt="" /></h5><p class="text-default-400">Content Creator</p></div></div>
          <div class="hs-dropdown relative inline-flex [--placement:bottom-right]"><button type="button" class="hs-dropdown-toggle"><i class="iconify tabler--dots-vertical text-default-400 text-2xl"></i></button>
            <div class="hs-dropdown-menu" role="menu"><a class="dropdown-item" href="#">View Profile</a><div class="border-default-300 my-3 border-t"></div><a class="dropdown-item text-danger" href="#">Block user</a></div></div>
        </div>
        <div>
          <a href="#" class="active hover:bg-default-100 bg-default-100 flex w-full items-center gap-2.25 rounded px-3 py-2 font-semibold"><i class="iconify tabler--smart-home text-base text-default-700"></i> News Feed</a>
          <a href="#" class="hover:bg-default-100 focus:bg-default-100 flex w-full items-center gap-2.25 rounded px-3 py-2 font-semibold"><i class="iconify tabler--message-circle text-base text-default-700"></i> Messages <span class="badge font-semibold text-danger bg-danger/10 ms-auto">5</span></a>
          <div class="list-group-item mt-2.5 px-3.5 py-2.25"><span class="font-semibold">Categories</span></div>
          <a href="#" class="hover:bg-default-100 flex w-full items-center gap-2.25 rounded px-3 py-2 font-semibold"><i class="iconify tabler--tag text-primary text-base"></i> Technology</a>
        </div>
      </div>
    </div>
  </div></div>

  <!-- middle: composer + posts -->
  <div class="mb-5 lg:col-span-2 lg:mb-0"><div class="flex gap-base flex-col">
    <div class="card">
      <div class="card-header lg:hidden"><button class="btn btn-sm btn-icon border-default-300" data-hs-overlay="#outlookSidebaroffcanvas"><i class="iconify tabler--menu-4 text-default-600 text-2xl"></i></button></div>
      <div class="card-body">
        <h5 class="mb-2.5">What's on your mind?</h5>
        <textarea rows="3" class="form-textarea" placeholder="Share your thoughts..."></textarea>
        <div class="flex justify-between pt-2.5">
          <div class="flex gap-1.25"><a href="#" class="btn btn-sm btn-icon bg-light hover:text-primary size-8"><i class="iconify tabler--user text-base"></i></a><!-- tabler--map-pin, tabler--camera, tabler--mood-smile --></div>
          <button type="submit" class="btn bg-dark btn-sm text-white">Post</button>
        </div>
      </div>
    </div>

    <div class="card"><!-- post card -->
      <div class="card-body pb-2">
        <div class="mb-2.5 flex items-center gap-2.5"><img class="size-9 rounded-full" src="assets/images/users/user-10.jpg" alt="" />
          <div class="w-full"><h5><a href="#!" class="hover:text-primary">Jeremy Tomlinson</a></h5><p class="text-default-400"><small>about 2 minutes ago</small></p></div>
          <div class="hs-dropdown relative inline-flex [--placement:bottom-right]"><button type="button" class="hs-dropdown-toggle"><i class="iconify tabler--dots-vertical text-default-400 text-base"></i></button>
            <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#"><i class="iconify tabler--edit"></i> Edit post</a><a class="dropdown-item" href="#"><i class="iconify tabler--trash"></i> Delete post</a><a class="dropdown-item" href="#"><i class="iconify tabler--pin"></i> Pin to top</a><a class="dropdown-item" href="#"><i class="iconify tabler--flag"></i> Report post</a></div></div></div>
        </div>
        <p class="mb-4">Story based around the idea of time lapse…</p>
        <div class="grid grid-cols-2 gap-1.25"><!-- image mosaic -->
          <img src="assets/images/gallery/10.jpg" class="h-full rounded" style="aspect-ratio: 3/4; object-fit: cover" alt="" />
          <div class="flex flex-col gap-1.25"><img src="assets/images/gallery/2.jpg" class="rounded" style="aspect-ratio: 4/3; object-fit: cover" alt="" /><img src="assets/images/gallery/3.jpg" class="rounded" style="aspect-ratio: 4/3; object-fit: cover" alt="" /></div>
        </div>
        <div class="mt-2.5">
          <a href="#" class="btn btn-sm text-default-400 text-sm"><i class="iconify tabler--corner-up-left text-sm"></i> Reply</a>
          <a href="#" class="btn btn-sm text-default-400 text-sm"><!-- like toggle -->
            <div class="relative"><span id="like-count-one"></span>
              <button type="button" data-hs-toggle-password='{"target": "#like-count-one"}'>
                <div class="hs-password-active:hidden flex items-center gap-1.25"><i class="iconify tabler--heart-filled text-danger"></i> Liked!</div>
                <div class="hs-password-active:flex hidden items-center gap-1.25"><i class="iconify tabler--heart text-default-400"></i> Like</div>
              </button></div></a>
          <a href="#" class="btn btn-sm text-default-400 text-sm"><i class="iconify tabler--share text-sm"></i> Share</a>
        </div>
      </div>
    </div>

    <div class="card"><!-- quote post + comments -->
      <div class="card-body pb-0!">
        <!-- header as above -->
        <div class="mt-5 mb-7.5 text-center text-base italic"><i class="iconify tabler--quote text-xl"></i> Just finished a weekend project! …</div>
      </div>
      <div class="border-default-300 card-body bg-default-50 border-t border-b border-dashed">
        <div class="flex"><img class="me-2.5 size-8 rounded-full" src="assets/images/users/user-1.jpg" alt="" />
          <div class="flex-1">
            <h5 class="mb-1.25"><a href="#!" class="hover:text-primary">Liam Johnson</a><small class="text-default-400 float-end font-normal">10 minutes ago</small></h5>
            That sounds awesome! <br /><a href="#" class="text-default-400 mt-2.5 inline-flex items-center gap-1"><i class="iconify tabler--corner-up-left"></i> Reply</a>
            <div class="mt-5 flex"><!-- nested reply: same structure --></div>
          </div></div>
        <div class="mt-5 flex items-start gap-2"><img src="assets/images/users/user-3.jpg" class="size-7.75 rounded-full" alt="" />
          <div class="w-full"><input type="text" class="form-input" placeholder="Add a comment..." /></div></div>
      </div>
      <div class="my-3 px-6"><!-- Reply / Like(45) / Share row as above --></div>
    </div>

    <div class="card"><div class="card-body"><!-- poll -->
      <h5 class="mb-5">🔥 Quick Poll: What's your go-to front-end framework in 2025?</h5>
      <p class="text-default-400 mb-4">Cast your vote below!</p>
      <form>
        <div class="mb-1.25 flex items-center gap-1.5"><input class="form-checkbox rounded-full" type="radio" name="framework_poll" id="optionReact" /><label class="form-check-label font-normal" for="optionReact">React (Meta)</label></div>
        <div class="mb-5 flex items-center gap-1.5"><input class="form-checkbox rounded-full" type="radio" name="framework_poll" id="optionVue" /><label class="form-check-label font-normal" for="optionVue">Vue.js</label></div>
        <button type="submit" class="btn btn-sm bg-primary text-white hover:bg-primary-hover">Submit Vote</button>
      </form>
    </div></div>
  </div></div>

  <!-- right: trending / requests / video -->
  <div>
    <div class="card"><div class="card-header"><h4 class="card-title">Trending</h4><!-- hs-dropdown ms-auto --></div>
      <div class="card-body">
        <div class="mb-5 flex"><div><i class="iconify tabler--trending-up text-primary me-2.5 mt-1.25 text-sm"></i></div><a href="#!" class="hover:text-primary"><strong>Golden Globes:</strong> The 27 Best moments…</a></div>
      </div></div>
    <div class="card"><div class="card-header"><h4 class="card-title">Requests</h4></div>
      <div class="card-body">
        <div class="mb-5 flex items-center justify-between">
          <div class="flex items-start"><img src="assets/images/users/user-6.jpg" class="me-2.5 size-6 rounded-full" alt="" />
            <div><p class="mb-1.25"><strong>Emily Zhang</strong> requested to collaborate. <span class="badge font-semibold bg-primary ms-1.25 text-white">New</span></p><small class="text-default-400 text-xs">2 minutes ago</small></div></div>
          <button class="btn btn-sm px-1.25 py-0 border-default-300 hover:border-primary hover:text-primary">Accept</button>
        </div>
        <!-- icon variant: <div class="bg-info me-2.5 flex size-6 items-center justify-center rounded-full text-white"><i class="iconify tabler--rocket"></i></div> -->
      </div></div>
    <div class="card"><div class="card-header"><h4 class="card-title">Featured Video For You</h4></div>
      <div class="card-body"><div class="relative w-full overflow-hidden rounded pt-[56.25%]"><iframe src="https://player.vimeo.com/video/357274789" allowfullscreen class="absolute start-0 top-0 h-full w-full rounded"></iframe></div></div></div>
  </div>
</div></div>
```

**Gotchas.**
- The sidebar wrapper id is `outlookSidebaroffcanvas` (copied from the Outlook page) — rename if both
  pages share a layout.
- The like toggle shows "Liked!" by default (the `hs-password-active:hidden` block is the initial state);
  swap the two inner divs to start un-liked.
- Poll radios use `form-checkbox rounded-full` rather than `form-radio` (works, but `form-radio` is
  the semantic class used elsewhere).

## Projects grid

**What it is.** Filter bar card (search, Status / Team / Deadline selects, Apply, grid-vs-list toggle)
over a 4-column grid of project cards: coloured icon tile, title + status badge + "updated" line,
action dropdown, a 2×2 stat grid (tasks, files, comments, due date), stacked team avatars and a
progress bar. Ends with a round-button pagination nav.
**Use it when.**
- Portfolio / project / campaign / client-engagement overviews where each item has progress and a team.
- Any "cards with KPIs + avatars + progress" listing (courses, sprints, initiatives).
- Switch to Projects list for dense data or bulk actions.
**Source.** `references/sources/pages/apps-projects-grid.html` (no JS; the filter bar is static).
**Markup.**

```html
<div class="container-fluid">
  <div class="card mb-base"><div class="card-body bg-light/20">
    <div class="grid grid-cols-1 items-center lg:grid-cols-3 gap-base">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input type="text" class="form-input" placeholder="Search project name..." /></div>
      <div class="lg:col-span-2"><div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap">
        <div class="items-center gap-2.5 md:flex"><span class="font-semibold me-2.5">Filter By:</span>
          <div class="input-icon-group"><i class="iconify tabler--activity input-icon"></i><select class="form-select"><option selected>Status</option><option>On Track</option><option>Delayed</option></select></div>
          <div class="input-icon-group"><i class="iconify tabler--users input-icon"></i><select class="form-select"><option selected>Team</option></select></div>
          <div class="input-icon-group"><i class="iconify tabler--calendar-clock input-icon"></i><select class="form-select"><option selected>Deadline</option></select></div>
          <button type="submit" class="btn bg-secondary text-white hover:bg-secondary-hover">Apply</button></div>
        <div class="md:ms-auto"><nav class="flex items-center gap-x-1">
          <a href="apps-projects-grid.html" class="btn bg-primary btn-icon text-white hover:bg-primary-hover"><i class="iconify tabler--category text-lg"></i></a>
          <a href="apps-projects-list.html" class="btn bg-primary/15 text-primary btn-icon hover:bg-primary hover:text-white"><i class="iconify tabler--list-check text-lg"></i></a></nav></div>
      </div></div>
    </div>
  </div></div>

  <div class="grid grid-cols-1 md:grid-cols-2 gap-base lg:grid-cols-4">
    <div class="card"><div class="card-body"><!-- repeat per project -->
      <div class="mb-5 pb-6 border-b border-default-300 flex">
        <div class="me-6"><span class="bg-primary text-white flex size-12 items-center justify-center rounded"><i class="iconify tabler--robot text-2xl"></i></span></div>
        <div class="flex-1">
          <div class="flex items-start gap-3"><h5 class="hover:text-primary mb-1.25 text-md flex items-center"><a href="apps-projects-details.html" class="leading-tight hover:text-primary">AI Analytics Dashboard</a></h5><span class="badge badge-label bg-success/15 text-success whitespace-nowrap">In Progress</span></div>
          <p class="text-default-400 text-2xs">Updated 5 minutes ago</p></div>
        <div class="relative ms-3"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
          <button type="button" class="hs-dropdown-toggle btn btn-icon text-default-400 hover:bg-default-100"><i class="iconify tabler--dots-vertical text-lg"></i></button>
          <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#"><i class="iconify tabler--share"></i> Share</a><a class="dropdown-item" href="#"><i class="iconify tabler--edit"></i> Edit</a><a class="dropdown-item" href="#"><i class="iconify tabler--ban"></i> Block</a><a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash"></i> Delete</a></div></div></div></div>
      </div>
      <div class="grid md:grid-cols-2 gap-base mb-5">
        <div class="flex items-center gap-2.5"><i class="iconify tabler--list-check text-default-400 text-base"></i><div><div class="font-medium">18/60</div><small class="text-default-400 text-xs">Tasks</small></div></div>
        <div class="flex items-center gap-2.5"><i class="iconify tabler--paperclip text-default-400 text-base"></i><div><div class="font-medium">15 Files</div><small class="text-default-400 text-xs">Assets & docs</small></div></div>
        <div class="flex items-center gap-2.5"><i class="iconify tabler--message text-default-400 text-base"></i><div><div class="font-medium">5 Comments</div><small class="text-default-400 text-xs">Latest: today</small></div></div>
        <div class="flex items-center gap-2.5"><i class="iconify tabler--calendar-clock text-default-400 text-base"></i><div><div class="font-medium">10 Jun, 2025</div><small class="text-default-400 text-xs">Due date</small></div></div>
      </div>
      <p class="text-default-400 text-xs mb-2.5 pt-2.5 font-semibold">Team Members:</p>
      <div class="mb-5 flex">
        <div><img src="assets/images/users/user-2.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-0.5" alt="" /></div>
        <div class="-ms-1.5"><img src="assets/images/users/user-3.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-0.5" alt="" /></div>
      </div>
      <div class="mb-2.5 flex items-center justify-between"><p class="text-default-400 text-xs font-semibold">Progress</p><p class="font-semibold">65%</p></div>
      <div class="bg-default-100 h-1.25 w-full overflow-hidden rounded-full"><div class="bg-success h-full w-[65%]"></div></div>
    </div></div>
  </div>

  <div class="mt-5"><nav class="mx-auto flex items-center justify-center gap-1.5" aria-label="Pagination">
    <button type="button" class="btn btn-icon bg-card border-default-300 hover:bg-default-50 hover:text-primary rounded-full"><span>«</span></button>
    <button type="button" class="btn btn-icon bg-primary rounded-full text-white">1</button>
    <button type="button" class="btn btn-icon bg-card hover:bg-default-50 border-default-300 hover:text-primary rounded-full">2</button>
    <button type="button" class="btn btn-icon bg-card border-default-300 hover:bg-default-50 hover:text-primary rounded-full"><span>»</span></button>
  </nav></div>
</div>
```

**Gotchas.**
- Progress width is a Tailwind arbitrary value (`w-[65%]`); for dynamic values use `style="width:65%"`
  as the Kanban cards do, because arbitrary classes must exist at build time.
- The filter bar is not wired to any script here — the list variant uses `data-table-filter`.

## Projects list

**What it is.** The table twin of the grid: a `data-table` card with search, bulk Delete, Status
filter, Deadline range filter, rows-per-page, grid/list toggle, and a table with checkbox, project
(icon + name + updated), stacked members, status badge, tasks `18/60 +4 New`, progress bar, files,
comments, due date, eye/edit/trash actions, plus pagination footer.
**Use it when.**
- Same data as the grid but you need sorting, filtering, bulk delete or more columns.
**Source.** `references/sources/pages/apps-projects-list.html` + `custom-table.js`.
**Markup.** (header/footer identical to the engine section; only the table differs)

```html
<div data-table data-table-rows-per-page="8" class="card mb-base">
  <div class="card-header"><!-- search, data-table-delete-selected, data-table-filter="status", data-table-range-filter="date", rows-per-page, grid/list nav --></div>
  <div class="table-wrapper">
    <table class="table-custom table-centered table-select table-hover table w-full">
      <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
        <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
        <th data-table-sort="project">Project</th><th>Members</th><th data-table-sort data-column="status">Status</th>
        <th>Tasks</th><th>Progress</th><th>Attachments</th><th>Comments</th><th data-table-sort data-column="date">Due Date</th><th class="text-center w-[1%]">Actions</th></tr></thead>
      <tbody class="divide-default-300 divide-y whitespace-nowrap">
        <tr>
          <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
          <td><div class="flex gap-base">
            <div class="bg-light flex size-9 items-center justify-center rounded"><i class="iconify tabler--code text-default-400 text-xl"></i></div>
            <div class="flex-1"><h5 class="hover:text-primary mb-1.25 flex items-center"><a data-sort="project" href="apps-projects-details.html">AI Analytics Dashboard</a></h5><p class="text-default-400 text-2xs">Updated 5 minutes ago</p></div></div></td>
          <td><div class="flex"><div><img src="assets/images/users/user-2.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-0.5" alt="" /></div><div class="-ms-1.5"><img src="assets/images/users/user-3.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-0.5" alt="" /></div></div></td>
          <td><span class="badge badge-label bg-success/15 text-success">In Progress</span></td>
          <td><h5> 18/60 <span class="badge bg-secondary text-white">+4 New</span></h5></td>
          <td><div class="bg-default-100 h-1.25 w-full overflow-hidden rounded-full"><div class="bg-success h-full w-[65%]"></div></div></td>
          <td>15 Files</td><td>5 Comments</td><td>10 May, 2025</td>
          <td><div class="flex justify-center gap-1.25">
            <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--eye text-base"></i></a>
            <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--edit text-base"></i></a>
            <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a></div></td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="card-footer"><div data-table-pagination-info="projects"></div><div data-table-pagination></div></div>
</div>
```

**Gotchas.**
- Status badge tokens used: `bg-success/15 text-success` In Progress, `bg-warning/15 text-warning`
  Pending, `bg-danger/15 text-danger` Overdue, `bg-info/15 text-info` In Review, `bg-secondary/15
  text-secondary` Scheduled.
- `table-centered`/`table-select` are not in app.min.css (no effect); `table-custom` is.
- The Deadline range filter options (This Week/Month) are not among the engine's date presets — use
  `Today`, `Last 7 Days`, `Last 30 Days`, `This Year` or extend `applyFilters`.

## Project details

**What it is.** `container` → `grid lg:grid-cols-4` (no gap at lg so the two cards join): a
`lg:col-span-3` card with header (client logo tile, title, updated line, status badge, Edit button),
description, 4-col meta (Created / Deadline / Created By / Client), Preline tabs
(Comments | Task List | Activity) and a `card lg:rounded-s-none shadow-none` sidebar with Status
select, Team Members list (avatar, role, message button) and Files list (type icon, size, download).
**Use it when.**
- Any entity detail page with discussion + checklist + history: project, campaign, deal, work order.
- The comments tab (textarea + nested dashed comment boxes + pagination) and the task-row cards are
  independently reusable.
**Source.** `references/sources/pages/apps-projects-details.html` (Preline `hs-tab`).
**Markup.**

```html
<div class="container"><div class="grid grid-cols-1 lg:grid-cols-4 gap-base lg:gap-0">
  <div class="lg:col-span-3"><div class="card h-full">
    <div class="card-header flex flex-wrap items-start gap-base p-7.5">
      <div class="bg-light me-5 flex size-20 items-center justify-center rounded"><img src="assets/images/logos/starbucks.svg" class="h-12" alt="" /></div>
      <div><h3 class="mb-1.25 flex items-center text-lg">Starbucks - AI Analytics Dashboard</h3>
        <p class="text-default-400 text-2xs mb-2.5">Updated 5 minutes ago</p><span class="badge badge-label text-2xs text-success bg-success/15">In Progress</span></div>
      <div class="ms-auto"><a href="#" class="btn bg-light hover:text-primary"><i class="iconify tabler--pencil"></i> Edit</a></div>
    </div>
    <div class="card-body px-7.5">
      <div class="mb-7.5"><h5 class="mb-2.5">Project Description:</h5><p class="text-default-400 mb-4">…</p></div>
      <div class="mb-7.5"><div class="grid grid-cols-2 gap-base md:grid-cols-4">
        <div><h6 class="text-xs text-default-400 mb-1.25 uppercase">Created Date:</h6><p class="font-medium">March 15, 2025</p></div>
        <div><h6 class="text-xs text-default-400 mb-1.25 uppercase">Deadline:</h6><p class="font-medium">June 30, 2025</p></div>
        <!-- Created By, Client Name -->
      </div></div>
      <div class="border-default-300 border-b"><nav class="flex gap-x-1" role="tablist" aria-orientation="horizontal">
        <button type="button" class="hs-tab-active:font-semibold hs-tab-active:border-primary hs-tab-active:text-primary hover:text-primary active inline-flex items-center gap-x-2 border-b border-transparent px-4 py-2 text-sm whitespace-nowrap focus:outline-hidden" id="comments" data-hs-tab="#comments-tab" aria-controls="comments-tab" role="tab"><i class="iconify tabler--message-circle text-base"></i><span class="hidden md:inline-block">Comments</span></button>
        <button type="button" class="hs-tab-active:font-semibold hs-tab-active:border-primary hs-tab-active:text-primary hover:text-primary inline-flex items-center gap-x-2 border-b border-transparent px-4 py-2 text-sm whitespace-nowrap focus:outline-hidden" id="tasks" data-hs-tab="#tasks-tab" aria-controls="tasks-tab" role="tab"><i class="iconify tabler--list-check text-base"></i><span class="hidden md:inline-block">Task List</span></button>
        <button type="button" class="… same …" id="activity" data-hs-tab="#activity-tab" aria-controls="activity-tab" role="tab"><i class="iconify tabler--activity text-base"></i><span class="hidden md:inline-block">Activity</span></button>
      </nav></div>
      <div class="mt-5">
        <div id="comments-tab" role="tabpanel">
          <div class="mb-5"><textarea class="form-textarea" rows="4" placeholder="Enter your messages..."></textarea></div>
          <div class="text-end"><button type="button" class="btn btn-sm bg-secondary text-white hover:bg-secondary-hover">Comment <i class="iconify tabler--send-2"></i></button></div>
          <h4 class="text-md mb-base">Comments (15)</h4>
          <div class="border-default-300 mb-2.5 rounded border border-dashed p-5"><!-- comment box; nested replies use mt-7.5 flex gap-2.5 -->
            <div class="flex gap-2.5"><div class="shrink-0"><img src="assets/images/users/user-8.jpg" class="size-8 rounded-full" alt="" /></div>
              <div><h5 class="mb-1.25"> Liam Carter <small class="text-default-400">15 Apr 2025 · 09:20AM</small></h5>
                <p class="mb-2.5">Customers are reporting that the checkout page freezes…</p>
                <a href="#" class="badge bg-light text-default-400"><i class="iconify tabler--corner-up-left text-base"></i> Reply</a>
                <div class="mt-7.5 flex gap-2.5"><!-- reply, same inner structure --></div>
              </div></div>
          </div>
          <nav class="flex items-center justify-center gap-1.5" aria-label="Pagination"><!-- round btn-icon pagination, tabler--chevron-left / -right --></nav>
        </div>
        <div id="tasks-tab" class="hidden" role="tabpanel">
          <div class="card mb-1.25"><div class="card-body p-2.5"><!-- task row -->
            <div class="grid grid-cols-1 items-center justify-between lg:grid-cols-2 gap-base">
              <div class="flex items-center gap-2.5"><input type="checkbox" class="form-checkbox size-5.5! rounded-full" id="task2" /><a href="#!" class="hover:text-primary font-medium">Finalize monthly performance report</a></div>
              <div class="flex gap-base flex-wrap items-center justify-start lg:justify-end">
                <div class="flex items-center gap-1.5"><img src="assets/images/users/user-2.jpg" class="size-6 rounded-full" alt="" /><h5 class="text-nowrap"><a href="#!" class="hover:text-primary">Liam James</a></h5></div>
                <span class="badge badge-label bg-success text-white">Completed</span>
                <ul class="flex shrink-0 flex-wrap items-center gap-3.5 text-end">
                  <li><i class="iconify tabler--calendar text-default-400 me-1.25 text-base"></i><span class="font-semibold">Yesterday</span></li>
                  <li><i class="iconify tabler--list-details text-default-400 me-1.25 text-base"></i><span class="font-medium">7/7</span></li>
                  <li><i class="iconify tabler--message text-default-400 me-1.25 text-base"></i><span class="font-medium">12</span></li></ul>
              </div>
            </div></div></div>
        </div>
        <div id="activity-tab" class="hidden" role="tabpanel">
          <div class="border-default-300 flex gap-1.5 border-b border-dashed py-5"><!-- repeat; first uses pb-5 -->
            <div class="me-2.5 shrink-0"><img src="assets/images/users/user-1.jpg" class="size-9 rounded-full" alt="" /></div>
            <div class="text-default-400 grow"><span class="text-default-700 text-sm font-medium">Daniel Martinez</span> uploaded a revised contract file.
              <p class="text-default-400 text-xs">Today 10:15 am - 24 Apr, 2025</p></div>
            <p class="text-default-400 text-xs">5m ago</p>
          </div>
        </div>
      </div>
    </div>
  </div></div>

  <div><div class="card h-full lg:rounded-s-none shadow-none">
    <div class="border-default-300 border-b border-dashed p-5"><h5 class="mb-2.5">Status</h5>
      <div class="input-icon-group"><i class="iconify tabler--calendar-clock input-icon"></i><select class="form-select"><option selected>On Track</option><option>Delayed</option><option>At Risk</option><option>Completed</option></select></div></div>
    <div class="border-default-300 border-b border-dashed p-5">
      <div class="mb-5 flex items-center justify-between"><h5 class="font-semibold">Team Members:</h5><a href="#" class="btn bg-light btn-icon size-7.75 rounded-full"><i class="iconify tabler--plus"></i></a></div>
      <div class="flex items-center justify-between pb-2.5"><!-- repeat per member -->
        <div class="flex items-center gap-2.5 py-1.25"><div class="size-8"><img src="assets/images/users/user-3.jpg" class="img-fluid rounded-full" alt="" /></div>
          <div><h5 class="text-nowrap"><a href="#!" class="hover:text-primary">Ava Brooks</a></h5><p class="text-default-400 text-2xs">UI/UX Designer</p></div></div>
        <a href="#" class="btn btn-sm btn-icon border-default-300 hover:border-default-400 hover:bg-default-100 size-7.75 border" title="Message"><i class="iconify tabler--message text-default-400 text-base"></i></a>
      </div>
    </div>
    <div class="p-5">
      <div class="mb-5 flex items-center justify-between"><h5 class="font-semibold">Files:</h5><a href="#" class="btn bg-light btn-icon size-7.75 rounded-full"><i class="iconify tabler--plus"></i></a></div>
      <div class="flex items-center justify-between pb-2.5"><!-- repeat per file -->
        <div class="flex items-center gap-2.5 py-1.25"><div class="btn bg-light btn-icon size-9"><i class="iconify tabler--file-text text-default-400 text-lg"></i></div>
          <div><h5 class="text-nowrap"><a href="#!" class="hover:text-primary">Project-Brief.pdf</a></h5><p class="text-default-400 text-2xs">2.1MB</p></div></div>
        <a href="#" class="btn btn-sm btn-icon border-default-300 hover:border-default-400 hover:bg-default-100 size-7.75 border" title="Download"><i class="iconify tabler--download text-base"></i></a>
      </div>
    </div>
  </div></div>
</div></div>
```

**Gotchas.**
- Preline tabs: the active button needs `active`; panels other than the first need `hidden`. The
  `hs-tab-active:*` variants style the active state — no extra CSS.
- Task status badges here are solid (`bg-success text-white`, `bg-danger text-white` Delayed,
  `bg-warning text-white`), unlike the soft badges in lists.
- The two cards only look joined at `lg` because of `lg:gap-0` + `lg:rounded-s-none` on the sidebar.

## Kanban board (SortableJS)

**What it is.** A full-height card: header with search, Department / Due Date selects and an
"Add New Task" button; body = horizontally scrolling `flex` of fixed-width columns (`w-85 min-w-84`,
dashed right border), each with a title `To Do (6)` + round add button and a SimpleBar scroll area
holding `<ul data-plugins="sortable">` of task cards (department badge + dropdown, title, optional
image, stacked avatars, due date, progress). SortableJS makes cards draggable within and across columns.
**Use it when.**
- Task boards, sales pipeline stages, hiring funnel, content workflow, support triage lanes.
- Any "move item between buckets" UI — set `group: "shared"` so lists accept each other's items.
**Source.** `references/sources/pages/apps-projects-kanban.html`, `assets/plugins/sortablejs/Sortable.min.js`,
`assets/js/pages/apps-kanban.js`; `.sortable-item-ghost` styling is in `app.min.css`.
**Markup.**

```html
<div class="container-fluid"><div class="card h-[calc(100vh-200px)]">
  <div class="card-header gap-base!">
    <div class="flex gap-base flex-wrap items-center">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon text-default-400"></i><input type="text" class="form-input" placeholder="Search tasks..." /></div>
      <div class="flex items-center gap-2.5">
        <div class="input-icon-group"><i class="iconify tabler--briefcase input-icon text-default-400"></i><select class="form-select"><option selected>Department</option><option>Design</option></select></div>
        <div class="input-icon-group"><i class="iconify tabler--calendar-clock input-icon text-default-400"></i><select class="form-select"><option selected>Due Date</option><option>Today</option></select></div>
      </div>
    </div>
    <button class="btn bg-secondary text-white hover:bg-secondary-hover" data-hs-overlay="#addTaskModal"><i class="iconify tabler--plus"></i> Add New Task</button>
  </div>
  <div class="card-body p-0">
    <div class="bg-light/40 flex items-stretch overflow-x-auto relative">
      <div class="w-85 min-w-84 border-default-300 border-e border-dashed"><!-- repeat per column: To Do / In Progress / In Review / Done -->
        <div class="flex items-center px-5 py-2.5"><h5>To Do (6)</h5><a href="#!" class="bg-primary ms-auto inline-flex size-7.75 items-center justify-center rounded-full text-white"><i class="iconify tabler--plus text-white"></i></a></div>
        <div class="h-[calc(100vh-332px)] px-5 pb-5" data-simplebar data-simplebar-md>
          <ul data-plugins="sortable" class="space-y-2.5">
            <li><div class="card border border-light hover:shadow-lg!"><div class="card-body">
              <div class="mb-2.5 flex items-center justify-between">
                <span class="badge bg-success/15 text-success"><i class="iconify tabler--circle-filled"></i> Design</span>
                <div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
                  <button type="button" class="hs-dropdown-toggle btn btn-icon size-7.75 text-default-400 hover:bg-default-100"><i class="iconify tabler--dots-vertical text-xl"></i></button>
                  <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#"><i class="iconify tabler--edit me-2"></i> Edit</a><a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash me-2"></i> Delete</a></div></div></div>
              </div>
              <h5 class="mb-5"><a href="#!" class="hover:text-primary" draggable="false">AI Analytics Dashboard</a></h5>
              <!-- optional: <div class="mb-5"><img src="assets/images/kanban/img-1.png" class="rounded" alt="" /></div> -->
              <div class="flex justify-between items-center">
                <div class="flex items-center -space-x-1.5"><div><img src="assets/images/users/user-2.jpg" class="size-6 rounded-full" draggable="false" alt="" /></div><div><img src="assets/images/users/user-3.jpg" class="size-6 rounded-full" draggable="false" alt="" /></div></div>
                <div class="flex items-center gap-2.5"><i class="iconify tabler--calendar-clock text-default-400 text-lg"></i><h5 class="text-sm font-medium">25 May, 2025</h5></div>
              </div>
              <div class="mt-5">
                <div class="flex items-center justify-between mb-2.5"><p class="text-default-400 font-semibold text-2xs">Progress</p><p class="font-semibold mb-0">65%</p></div>
                <div class="w-full bg-default-200 rounded-full h-1.25"><div class="bg-success h-1.25 rounded-full" style="width: 65%"></div></div>
              </div>
            </div></div></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div></div>
```

**Init / JS.** (`apps-kanban.js`, complete)

```js
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('[data-plugins="sortable"]').forEach((el) => {
    new Sortable(el, { animation: 150, group: "shared", ghostClass: "sortable-item-ghost",
      forceFallback: true, emptyInsertThreshold: 100, chosenClass: "sortable-item-active" });
  });
});
```
Add `onEnd: (evt) => persist(evt.item, evt.from, evt.to, evt.newIndex)` to save moves; give each
`<li>` a `data-id` and each `<ul>` a `data-status` for that.
**Gotchas.**
- `#addTaskModal` is referenced by the button but the modal is NOT in the page — add your own
  `hs-overlay` (copy `#addTeamModal` from the team board).
- `draggable="false"` on links/images inside cards stops the browser's native drag from hijacking
  SortableJS (`forceFallback: true` is set for the same reason).
- Column counts in headings are static text; update them in `onAdd`/`onRemove`.
- `emptyInsertThreshold: 100` lets you drop into an empty column; keep the `<ul>` even when empty.
- Department badge colours: `bg-success/15 text-success` Design, `bg-warning/15 text-warning`
  Development, plus info/danger/primary soft variants.

## Team board

**What it is.** Page header (title + description + "Add New Team" button opening `#addTeamModal`) and a
3-column grid of team cards: title with optional badge + dropdown, member count, stacked avatars,
"About Team", 3 KPI tiles (Projects / Ranking / Budgets with `bg-light` round icons), a progress bar
and an "Updated … / Details" footer. The modal collects name, code, status, multi-select members and
description.
**Use it when.**
- Teams, departments, squads, vendor groups — anything that is a named group of people with KPIs.
- A create-group modal with a native `<select multiple>` (swap for Choices.js from vendors if needed).
**Source.** `references/sources/pages/apps-projects-team-board.html` (no page script).
**Markup.**

```html
<div class="mb-5 flex flex-wrap items-center justify-between gap-3">
  <div><h4 class="mb-1.25 page-main-title">Manage Teams</h4><p class="text-default-400">Assign roles to streamline teamwork and secure access.</p></div>
  <a href="#addTeamModal" class="btn bg-success text-white hover:bg-success-hover" data-hs-overlay="#addTeamModal"><i class="iconify tabler--plus"></i> Add New Team</a>
</div>
<div class="grid xl:grid-cols-3 md:grid-cols-2 grid-cols-1 gap-base">
  <div class="card h-full"><!-- repeat per team -->
    <div class="card-header">
      <h4 class="card-title"> IT-01 - Design Team <span class="badge badge-label ms-2.5 text-white bg-primary">New</span></h4>
      <div class="ms-auto relative"><div class="hs-dropdown [--placement:bottom-right] relative inline-flex">
        <button type="button" class="hs-dropdown-toggle text-default-400"><i class="iconify tabler--dots-vertical size-4.5"></i></button>
        <div class="hs-dropdown-menu min-w-44 px-0 py-1" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#"><i class="iconify tabler--eye"></i> View</a><a class="dropdown-item" href="#"><i class="iconify tabler--edit"></i> Edit</a><a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash"></i> Remove</a></div></div></div></div>
    </div>
    <div class="card-body">
      <p class="mb-2.5 text-default-400 text-sm">Total 4 members</p>
      <div class="flex mb-5"><div><img src="assets/images/users/user-7.jpg" class="rounded-full size-8 hover:-translate-y-0.5 transition-all duration-200" alt="" /></div><div class="-ms-2"><img src="assets/images/users/user-8.jpg" class="rounded-full size-8 hover:-translate-y-0.5 transition-all duration-200" alt="" /></div></div>
      <div class="pb-5"><h5 class="mb-2.5">About Team:</h5><p class="text-default-400 mb-4">The Design Team focuses on…</p></div>
      <div class="grid xl:grid-cols-3 md:grid-cols-2 grid-cols-1 gap-base">
        <div class="flex gap-2.5"><span class="flex justify-center items-center size-8 bg-light rounded-full"><i class="iconify tabler--layout-kanban text-primary size-4"></i></span><div><h6 class="mb-1.25 text-default-400 text-xs uppercase">Projects</h6><p class="font-medium">25</p></div></div>
        <div class="flex gap-2.5"><span class="flex justify-center items-center size-8 bg-light rounded-full"><i class="iconify tabler--medal text-primary size-4"></i></span><div><h6 class="mb-1.25 text-default-400 text-xs uppercase">Ranking</h6><p class="font-medium">#5</p></div></div>
        <div class="flex gap-2.5"><span class="flex justify-center items-center size-8 bg-light rounded-full"><i class="iconify tabler--wallet text-primary size-4"></i></span><div><h6 class="mb-1.25 text-default-400 text-xs uppercase">Budgets</h6><p class="font-medium">$20.3M</p></div></div>
      </div>
      <div class="my-5">
        <div class="flex items-center justify-between mb-2.5"><p class="text-default-400 font-semibold text-xs">Status of current project</p><p class="font-semibold">65%</p></div>
        <div class="w-full h-2 bg-default-100 rounded-full overflow-hidden"><div class="bg-primary h-full w-[65%]"></div></div>
      </div>
      <div class="flex justify-between items-center"><span class="text-default-400 text-xs flex items-center"><i class="iconify tabler--clock me-1.25"></i> Updated 1 hour ago</span><a href="#" class="btn btn-sm bg-primary text-white rounded-full">Details</a></div>
    </div>
  </div>
</div>

<!-- add-team modal (outside <main>) — the canonical "create record" modal in this group -->
<div id="addTeamModal" class="hs-overlay pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" role="dialog" tabindex="-1">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 m-3 flex min-h-[calc(100%-56px)] scale-95 items-center opacity-0 transition-all duration-200 ease-in-out md:mx-auto md:w-full md:max-w-lg">
    <div class="card pointer-events-auto flex w-full flex-col">
      <div class="card-header p-5"><h3 class="font-bold">Add New Team</h3><button type="button" data-hs-overlay="#addTeamModal"><i class="iconify tabler--x text-2xl align-middle text-default-600"></i></button></div>
      <div class="card-body">
        <div class="mb-5"><label class="form-label">Team Name</label><input type="text" class="form-input" placeholder="e.g., Creative Design Team" required /></div>
        <div class="mb-5"><label class="form-label">Team Code</label><input type="text" class="form-input" placeholder="e.g., IT-01" required /></div>
        <div class="mb-5"><label class="form-label">Status</label><select class="form-select"><option value="New" selected>New</option><option value="Active">Active</option></select></div>
        <div class="mb-5"><label class="form-label">Team Members</label><select class="form-select" multiple><option value="1">Liam Carter</option><option value="2">Ava Mitchell</option></select>
          <div class="text-2xs text-default-400 mt-1">Hold Ctrl (Windows) or Cmd (Mac) to select multiple users.</div></div>
        <div><label class="form-label">Description</label><textarea class="form-textarea" rows="3" placeholder="Brief team responsibilities..."></textarea></div>
      </div>
      <div class="border-default-300 flex items-center justify-end gap-2 border-t p-5">
        <button type="button" class="btn bg-light hover:text-primary" data-hs-overlay="#addTeamModal">Cancel</button>
        <button type="button" class="btn bg-success text-white hover:bg-success-hover"><i class="iconify tabler--check"></i> Save Team</button>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- Modals must sit outside `<main>` (or at least outside any `transform`/`overflow` ancestor) or the
  `fixed` overlay will be clipped; every demo places them just before the theme customizer.
- The dropdown here uses verbose per-link classes; `dropdown-item` is the equivalent shorthand.

## Activity stream

**What it is.** Two cards side by side: "Basic Activity Stream" — one flex row per event (solid badge
verb, timestamp, avatar + actor link, description); "Expended Activity Stream" — a vertical timeline
where each entry has a dashed-circle icon with a dashed connector drawn by `after:` pseudo-elements,
a title + soft badge, timestamp, description and actor.
**Use it when.**
- Audit logs, system event logs, order/ticket history, release notes feed, user activity on a profile.
- Basic = dense log table; Expanded = narrative timeline for a detail sidebar.
**Source.** `references/sources/pages/apps-projects-activity.html` (no JS).
**Markup.**

```html
<div class="grid grid-cols-1 lg:grid-cols-2 gap-base">
  <div class="card"><div class="card-header"><h4 class="card-title">Basic Activity Stream</h4></div>
    <div class="card-body">
      <div class="flex items-center gap-base py-2.5"><!-- repeat per event (first: pb-2.5) -->
        <span class="badge badge-label bg-info text-white">Add</span>
        <span class="text-default-400">Today at 08:05:33 am</span>
        <a href="#!" class="hover:text-primary flex items-center gap-1.5 font-semibold"><img src="assets/images/users/user-1.jpg" class="size-4 rounded-full" alt="" /> Olivia Lee</a>
        Added a new design asset
      </div>
      <!-- verb → colour: Add bg-info/bg-primary · Update/Approve/Create bg-success · Upload bg-primary · Remove/Reject/Delete bg-danger · Comment/Edit bg-warning · Share bg-info -->
    </div></div>

  <div class="card h-full"><div class="card-header"><h4 class="card-title">Expended Activity Stream</h4></div>
    <div class="card-body">
      <div class="flex gap-x-base"><!-- repeat per entry -->
        <div class="after:border-default-300 relative after:absolute after:start-1/2 after:top-7 after:bottom-0 after:w-px after:border-e -ms-px after:border-dashed last:after:hidden">
          <div class="relative z-10 flex items-center justify-center">
            <div class="border-default-300 flex size-7.5 items-center justify-center rounded-full border border-dashed"><i class="iconify tabler--rocket text-primary text-lg"></i></div>
          </div>
        </div>
        <div class="flex-1 pb-5">
          <div class="flex justify-between"><h5 class="mb-1.25"> New Feature Released <span class="badge badge-label ms-2.5 bg-info/15 text-info">Deploy</span></h5><span class="text-default-400 text-xs">Today at 3:45 PM</span></div>
          <p class="text-default-400 mb-1.25">Launched the real-time chat feature across all user accounts.</p>
          <div class="flex items-center gap-2.5"><img src="assets/images/users/user-6.jpg" class="size-4 rounded-full" alt="" /><a href="#!" class="hover:text-primary font-semibold">Natalie Brooks</a></div>
        </div>
      </div>
      <!-- icons used: tabler--rocket (primary), tabler--calendar-event (warning), tabler--palette (success), tabler--check (success) -->
    </div></div>
</div>
```

**Gotchas.**
- The connector line is the `after:` pseudo on the icon column; `last:after:hidden` only works if the
  entries are siblings — keep each entry as a direct child of `.card-body`.
- Entry `pb-5` controls the gap between timeline items; the line length follows automatically.

## Users contacts

**What it is.** Filter card (search, Designation / Location / Department selects, Apply, grid/list
tab buttons) and a 4-column grid of contact cards: 72 px avatar with a rating badge, name + flag,
title, role badge, dropdown, a list of email / phone / location / website rows with round `bg-light`
icons, and an "Updated … / View Profile" footer; round-button pagination.
**Use it when.**
- Staff directory, customer contacts, vendor contacts, speaker list — any people grid.
- NOT for role management or bulk editing — use Users roles (table) instead.
**Source.** `references/sources/pages/apps-users-contacts.html` (no JS).
**Markup.**

```html
<div class="card mb-base"><div class="card-body"><div class="grid xl:grid-cols-3 gap-base">
  <div class="col-span-1 lg:pe-2.5"><div class="input-icon-group"><i class="iconify tabler--search input-icon text-default-400"></i><input type="text" class="form-input" placeholder="Search contact name..." /></div></div>
  <div class="xl:col-span-2 lg:ps-2.5"><div class="flex flex-wrap items-center gap-2.5"><span class="font-semibold me-2.5">Filter By:</span>
    <div class="input-icon-group"><i class="iconify tabler--user-check input-icon text-default-400"></i><select class="form-select"><option selected>Designation</option><option>Manager</option></select></div>
    <div class="input-icon-group"><i class="iconify tabler--map-pin input-icon text-default-400"></i><select class="form-select"><option selected>Location</option></select></div>
    <div class="input-icon-group"><i class="iconify tabler--stack-2 input-icon text-default-400"></i><select class="form-select"><option selected>Department</option></select></div>
    <button type="submit" class="btn bg-secondary text-white hover:bg-secondary-hover">Apply</button>
    <div class="ms-auto"><nav class="flex items-center gap-x-1" role="tablist">
      <button type="button" class="hs-tab-active:bg-primary hs-tab-active:text-white bg-primary/15 text-primary btn btn-icon active size-9.25!" id="contact-tab-1" data-hs-tab="#tabs-contact-1" role="tab"><i class="iconify tabler--apps text-lg"></i></button>
      <button type="button" class="hs-tab-active:bg-primary hs-tab-active:text-white bg-primary/15 text-primary btn btn-icon size-9.25!" id="contact-tab-2" data-hs-tab="#tabs-contact-2" role="tab"><i class="iconify tabler--list-check text-lg"></i></button></nav></div>
  </div></div>
</div></div></div>

<div class="grid xl:grid-cols-4 md:grid-cols-2 grid-cols-1 gap-base">
  <div class="card"><div class="card-body"><!-- repeat per contact -->
    <div class="flex items-center mb-7.5">
      <div class="me-5 relative"><img src="assets/images/users/user-5.jpg" class="rounded-full" width="72" height="72" alt="" /><span class="absolute bottom-0 inset-e-0 badge bg-warning rounded-full p-1.25 text-white" title="Rating 4.8"><i class="iconify tabler--star text-white"></i></span></div>
      <div><h5 class="mb-1.25 flex items-center"><a href="#!" class="hover:text-primary">Sophia Carter</a><img src="assets/images/flags/gb.svg" class="ms-2.5 rounded-full size-4" alt="" /></h5>
        <p class="text-default-400 mb-1.25">Lead UI/UX Designer</p><span class="badge bg-light badge-label">Admin</span></div>
      <div class="relative ms-auto"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
        <button type="button" class="hs-dropdown-toggle btn size-9.25 text-default-400 hover:bg-default-100"><i class="iconify tabler--dots-vertical text-xl"></i></button>
        <div class="hs-dropdown-menu" role="menu"><a class="dropdown-item" href="#"><i class="iconify tabler--share"></i> Share</a><a class="dropdown-item" href="#"><i class="iconify tabler--edit"></i> Edit</a><a class="dropdown-item" href="#"><i class="iconify tabler--ban"></i> Block</a><a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash"></i> Delete</a></div></div></div>
    </div>
    <ul class="text-default-400 mb-7.5">
      <li class="mb-2.5"><div class="flex items-center gap-2.5"><span class="size-6 flex justify-center items-center bg-light text-default-800 rounded-full"><i class="iconify tabler--mail"></i></span><h5 class="text-sm font-medium"><a href="#" class="hover:text-primary">sophia@designhub.com</a></h5></div></li>
      <li class="mb-2.5"><div class="flex items-center gap-2.5"><span class="size-6 flex justify-center items-center bg-light text-default-800 rounded-full"><i class="iconify tabler--phone"></i></span><h5 class="text-sm font-medium">+44 7911 123456</h5></div></li>
      <li class="mb-2.5"><div class="flex items-center gap-2.5"><span class="size-6 flex justify-center items-center bg-light text-default-800 rounded-full"><i class="iconify tabler--map-pin"></i></span><h5 class="text-sm font-medium">London, UK</h5></div></li>
      <li><div class="flex items-center gap-2.5"><span class="size-6 flex justify-center items-center bg-light text-default-800 rounded-full"><i class="iconify tabler--link"></i></span><h5 class="text-sm font-medium"><a href="#" class="text-primary hover:text-primary-hover">www.sophiacarter.com</a></h5></div></li>
    </ul>
    <div class="flex justify-between items-center"><span class="text-default-400 text-xs flex items-center"><i class="iconify tabler--refresh me-1.25"></i> Updated 30 min ago</span><a href="#!" class="btn bg-primary/15 text-primary btn-sm rounded-full hover:bg-primary hover:text-white">View Profile</a></div>
  </div></div>
</div>
```

**Gotchas.**
- The grid/list tab buttons point at `#tabs-contact-1/2` panels that do not exist in the page — add
  the panels (grid in one, a `data-table` table in the other) or make them links to two pages as the
  projects pages do.
- Rating badge colour varies per card (`bg-warning`, `bg-success`); `inset-e-0` is the logical-end
  utility (RTL-safe).

## Users roles

**What it is.** RBAC landing page: header with "Add New Role" (opens `#addRoleModal`), a 4-column grid
of role cards (round `bg-primary/15` icon, name, description, dropdown, checklist of responsibilities,
user count, stacked avatars, "Details" link to role details), then a `data-table` users card
(search, bulk delete, Role + Status filters, rows selector, "Add User" button → `#addUserModal`) with
ID / User / Role / Last Updated / Status / Actions.
**Use it when.**
- Role & user administration, permission groups, membership tiers.
- The role card is a good generic "plan / tier / package" card (icon, bullets, count, CTA).
**Source.** `references/sources/pages/apps-users-roles.html` + `custom-table.js`.
**Markup.**

```html
<div class="mb-5 flex flex-wrap items-center justify-between gap-3">
  <div><h4 class="page-main-title mb-1.25">Manage Roles</h4><p class="text-default-400">Manage roles for smoother operations and secure access.</p></div>
  <a href="#" class="btn bg-success text-white hover:bg-success-hover" data-hs-overlay="#addRoleModal"><i class="iconify tabler--plus"></i> Add New Role</a>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-base mb-base">
  <div class="card"><div class="card-body"><!-- repeat per role -->
    <div class="mb-7.5 flex items-start">
      <div class="bg-primary/15 text-primary flex size-12 items-center justify-center rounded-full"><i class="iconify tabler--shield-lock text-2xl"></i></div>
      <div class="ms-6"><h5 class="mb-1.25 text-sm">Security Officer</h5><p class="text-default-400">Handles platform safety and protocol reviews.</p></div>
      <div class="relative ms-auto"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]"><button type="button" class="hs-dropdown-toggle text-lg text-default-400"><i class="iconify tabler--dots-vertical text-xl"></i></button>
        <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#"><i class="iconify tabler--eye"></i> View</a><a class="dropdown-item" href="#"><i class="iconify tabler--edit"></i> Edit</a><a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash"></i> Remove</a></div></div></div></div>
    </div>
    <ul class="mb-5 flex flex-col gap-y-3">
      <li class="flex items-center gap-3"><i class="iconify tabler--check text-success text-base"></i> Daily Risk Assessment</li>
      <li class="flex items-center gap-3"><i class="iconify tabler--check text-success text-base"></i> Manage Security Logs</li>
    </ul>
    <p class="text-default-400 mb-3 text-sm">Total 4 users</p>
    <div class="mb-5 flex items-center -space-x-2"><img src="assets/images/users/user-7.jpg" class="size-8 rounded-full transition-all duration-200 hover:-translate-y-1" alt="" /><img src="assets/images/users/user-8.jpg" class="size-8 rounded-full transition-all duration-200 hover:-translate-y-1" alt="" /></div>
    <div class="flex justify-between"><span class="text-default-400 flex items-center gap-1.5 text-xs"><i class="iconify tabler--clock"></i> Updated 1 hour ago</span>
      <a href="apps-users-role-details.html" class="btn btn-sm border-primary text-primary hover:bg-primary rounded-full border hover:text-white">Details</a></div>
  </div></div>
  <!-- other role icons: tabler--briefcase, tabler--code, tabler--headset -->
</div>

<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="flex gap-2"><div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search Users..." class="form-input" /></div>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button></div>
    <div class="flex flex-wrap items-center gap-3">
      <div class="items-center gap-3 md:flex"><span class="me-3 font-semibold text-nowrap">Filter By:</span>
        <div class="input-icon-group"><i class="iconify tabler--user-hexagon input-icon"></i><select data-table-filter="roles" class="form-select"><option value="">Role</option><option value="Project Manager">Project Manager</option></select></div>
        <div class="input-icon-group"><i class="iconify tabler--user-check input-icon"></i><select data-table-filter="status" class="form-select"><option value="">Status</option><option value="Active">Active</option><option value="Inactive">Inactive</option><option value="Suspended">Suspended</option></select></div>
        <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="8">8</option><option value="20">20</option></select></div>
      <button class="btn bg-secondary text-white hover:bg-secondary-hover" type="button" data-hs-overlay="#addUserModal">Add User</button>
    </div>
  </div>
  <div class="table-wrapper"><table class="table table-hover">
    <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
      <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
      <th data-table-sort>ID</th><th data-table-sort="user">User</th><th data-table-sort data-column="roles">Role</th><th data-table-sort>Last Updated</th><th data-table-sort data-column="status">Status</th><th class="text-center">Actions</th></tr></thead>
    <tbody><tr>
      <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
      <td><h5><a href="#" class="hover:text-primary">#USR00123</a></h5></td>
      <td><div class="flex items-center gap-3"><img src="assets/images/users/user-5.jpg" class="size-8 rounded-full" alt="" /><div><h5><a data-sort="user" href="#!" class="hover:text-primary">Nathan Young</a></h5><p class="text-default-400 text-xs">nathan@companymail.com</p></div></div></td>
      <td>Project Manager</td><td> 18 Apr, 2025 <small class="text-default-400">9:45 AM</small></td>
      <td><span class="badge badge-label bg-warning/15 text-warning">Inactive</span></td>
      <td><div class="flex justify-center gap-1.25"><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--eye text-base"></i></a><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--edit text-base"></i></a><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a></div></td>
    </tr></tbody></table></div>
  <div class="card-footer"><div data-table-pagination-info="roles"></div><div data-table-pagination></div></div>
</div>
```

Add-role modal (`#addRoleModal`, `md:max-w-2xl lg:max-w-3xl`, 2-col grid): Role Name, Description,
Key Responsibilities textarea (`md:col-span-2`), Assign Users `<select multiple>`, Role Icon text
input. Add-user modal (`#addUserModal`): Full Name, Email, Role `<select multiple>`, Status select,
Avatar `<input type="file" class="form-input">`. Both end with the standard
`border-default-300 flex items-center justify-end gap-x-2 border-t p-5` footer.
**Gotchas.**
- The users table search input in this page lacks `data-table-search` (only role-details has it) — add
  it. The role/status filters do work because the `th`s carry `data-column="roles|status"`.
- The demo modals use `class="form-textarea"` on `<select multiple>` for height; `form-select` with
  a `h-*` utility is cleaner.
- Trigger buttons use a typo'd `aria-inputs=` attribute; use `aria-controls`.

## Role details

**What it is.** One role: `grid lg:grid-cols-4` with a `col-span-1` role card (same card as the roles
grid, but with an "Edit Role" button opening `#editRoleModal`) and a `lg:col-span-3` `data-table`
of that role's users (search, bulk delete, Status filter, rows, "Add User") with ID / User / Joined
Date / Status / Actions and pagination.
**Use it when.**
- Drill-down from the roles grid; also fits "group → members", "plan → subscribers", "team → people".
**Source.** `references/sources/pages/apps-users-role-details.html` + `custom-table.js`.
**Markup.** (role card and table are identical to Users roles except the following)

```html
<div class="grid lg:grid-cols-4 grid-cols-1 gap-base">
  <div class="col-span-1"><div class="card"><div class="card-body">
    <!-- icon / name / description / dropdown / checklist / "Total 17 users" / avatars as in Users roles -->
    <div class="flex justify-between"><span class="flex items-center gap-1.5 text-default-400 text-xs"><i class="iconify tabler--clock"></i> Updated 1 hour ago</span>
      <a href="#" class="btn btn-sm border border-primary text-primary hover:bg-primary hover:text-white rounded-full" data-hs-overlay="#editRoleModal">Edit Role</a></div>
  </div></div></div>
  <div class="lg:col-span-3">
    <div data-table data-table-rows-per-page="8" class="card">
      <div class="card-header">
        <div class="flex gap-2"><div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search Users..." class="form-input" /></div>
          <button data-table-delete-selected class="hidden btn bg-danger text-white hover:bg-danger-hover">Delete</button></div>
        <div class="flex flex-wrap items-center gap-3">
          <div class="input-icon-group"><i class="iconify tabler--user-check input-icon"></i><select data-table-filter="status" class="form-select"><option value="">Status</option><option value="Active">Active</option></select></div>
          <select data-table-set-rows-per-page class="form-select"><option value="8">8</option></select>
          <button class="btn bg-secondary text-white hover:bg-secondary-hover" type="button" data-hs-overlay="#addUserModal">Add User</button></div>
      </div>
      <div class="table-wrapper"><table class="table table-hover">
        <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase"><th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th><th data-table-sort>ID</th><th data-table-sort="user">User</th><th data-table-sort>Joined Date</th><th data-table-sort data-column="status">Status</th><th class="text-center">Actions</th></tr></thead>
        <tbody><tr>
          <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
          <td><h5><a href="apps-users-profile.html" class="text-sm font-semibold hover:text-primary">#USR76129</a></h5></td>
          <td><div class="flex gap-3 items-center"><img src="assets/images/users/user-1.jpg" class="size-8 rounded-full" alt="" /><div><h5><a href="#!" class="hover:text-primary">Elena Carter</a></h5><p class="text-default-400 text-xs">elena@webcore.dev</p></div></div></td>
          <td> 19 Jul, 2025 <small class="text-default-400">11:00 AM</small></td>
          <td><span class="badge badge-label bg-success/15 text-success">Active</span></td>
          <td><!-- eye / edit / data-table-delete-row --></td>
        </tr></tbody></table></div>
      <div class="card-footer"><div data-table-pagination-info="users"></div><div data-table-pagination></div></div>
    </div>
  </div>
</div>
```

**Gotchas.**
- Status tokens: Active `bg-success/15 text-success`, Inactive `bg-warning/15 text-warning`,
  Suspended `bg-danger/15 text-danger`.
- `#editRoleModal` is the add-role modal with values pre-filled; both modals are outside `<main>`.

## Permissions

**What it is.** A single `data-table` card: search + rows selector, and a table Name / Assign To /
Created Date / Users / Actions where "Assign To" is a row of soft role badges (Administrator,
Developer, Analyst, Support, Trial, DevOps…). Pagination footer.
**Use it when.**
- Permission → roles mapping, feature flags → plans, scopes → API clients: any many-to-many matrix
  shown as badges per row.
- For an editable matrix, replace each badge cell with `form-checkbox` / `form-switch` inputs per
  role column — the demo is read-only (no toggles).
**Source.** `references/sources/pages/apps-users-permissions.html` + `custom-table.js`.
**Markup.**

```html
<div class="container">
  <div data-table data-table-rows-per-page="8" class="card">
    <div class="card-header">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search permissions..." class="form-input" /></div>
      <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="8">8</option><option value="20">20</option></select>
    </div>
    <div class="table-wrapper"><table class="table table-hover">
      <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase"><th data-table-sort>Name</th><th>Assign To</th><th data-table-sort>Created Date</th><th data-table-sort>Users</th><th class="text-center">Actions</th></tr></thead>
      <tbody>
        <tr><td>Content Management</td>
          <td class="space-x-1 px-2.25 py-3">
            <span class="badge badge-label bg-primary/15 text-primary">Administrator</span>
            <span class="badge badge-label bg-danger/15 text-danger">Developer</span>
            <span class="badge badge-label bg-info/15 text-info">Analyst</span>
            <span class="badge badge-label bg-secondary/15 text-secondary">Support</span>
            <span class="badge badge-label bg-warning/15 text-warning">Trial</span></td>
          <td> 21 Feb 2025, <small class="text-default-400 text-sm">11:05 am</small></td><td>5</td>
          <td><div class="flex justify-center gap-1.5"><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--eye text-base"></i></a><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a></div></td>
        </tr>
      </tbody></table></div>
    <div class="card-footer"><div data-table-pagination-info="permissions"></div><div data-table-pagination></div></div>
  </div>
</div>
```

**Gotchas.**
- The demo search input lacks `data-table-search`; add it (shown above).
- No checkbox column here, so `data-table-delete-selected` is not used; per-row delete still works.

## Invoice list

**What it is.** `data-table` card: search, round "+" link to the create page, bulk Delete, Status
filter, rows selector; table with checkbox, ID (invoice icon coloured by status + link to details),
Create & End Date, client (avatar or initials, name, email), Purchase, Amount, Status badge, actions.
**Use it when.**
- Invoices, quotes, orders, subscriptions, payouts — any billing document list.
**Source.** `references/sources/pages/apps-invoice-list.html` + `custom-table.js`.
**Markup.** (engine header/footer as usual; distinctive cells only)

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header flex flex-wrap justify-between">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search invoices..." class="form-input" /></div>
      <a href="apps-invoice-create.html" class="btn btn-icon rounded-full bg-secondary text-white hover:bg-secondary-hover"><i class="iconify tabler--plus text-base"></i></a>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button></div>
    <div class="flex items-center gap-2.5"><span class="me-2.5 font-semibold">Filter By:</span>
      <div class="input-icon-group"><i class="iconify tabler--circle-check input-icon"></i><select data-table-filter="status" class="form-select"><option value="All">Status</option><option value="Paid">Paid</option><option value="Pending">Pending</option><option value="Overdue">Overdue</option><option value="Draft">Draft</option></select></div>
      <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="10">10</option></select></div>
  </div>
  <div class="table-wrapper"><table class="table-custom table-select table table-hover">
    <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase"><th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th><th>ID</th><th>Create & End Date</th><th data-table-sort="name">Clients Name</th><th data-table-sort>Purchase</th><th data-table-sort>Amount</th><th data-table-sort data-column="status">Status</th><th class="text-center">Actions</th></tr></thead>
    <tbody><tr>
      <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
      <td><h5 class="flex items-center gap-1.5"><i class="iconify tabler--invoice text-success text-base"></i><a href="apps-invoice-details.html" class="hover:text-primary font-semibold">#INS-0120010</a></h5></td>
      <td>Feb 2 - Feb 10, 2025</td>
      <td><div class="flex items-center gap-2.5"><div><img src="assets/images/users/user-7.jpg" class="size-8 rounded-full" alt="" /></div>
        <div><h5><a data-sort="name" href="#!" class="text-default-900 hover:text-primary">Emily Parker</a></h5><p class="text-default-400 text-xs">emily@startupwave.io</p></div></div></td>
      <td>Inspinia - Extended License</td><td>$999.00 USD</td>
      <td><span class="badge badge-label bg-success/15 text-success">Paid</span></td>
      <td><div class="flex justify-center gap-1.25"><!-- eye / edit / data-table-delete-row --></div></td>
    </tr></tbody></table></div>
  <div class="card-footer"><div data-table-pagination-info="invoices"></div><div data-table-pagination></div></div>
</div>
```

Initials avatar variant for the client cell:
`<div class="bg-info flex size-8 items-center justify-center rounded-full text-sm font-bold text-white">MS</div>`.
**Gotchas.**
- The `tabler--invoice` icon colour mirrors the status (`text-success` Paid, `text-warning` Pending,
  `text-danger` Overdue) — keep them in sync server-side.
- Amount sort works because the engine parses `$999.00 USD` → 999.

## Invoice details (printable)

**What it is.** `lg:w-10/12 mx-auto` → `grid lg:grid-cols-4`: a `lg:col-span-3` invoice card (logo with
light/dark/print variants, status badge + number, From / To / QR columns with Invoice Date / Due Date,
`table-bordered` line items, right-aligned borderless totals table, note box, thank-you + signature) and
a `sticky top-25` action card (Edit, Print → `window.print()`, Download, large Send).
**Use it when.**
- Invoice / receipt / quote / purchase order / delivery note views that must print cleanly.
- The totals table and the From/To grid are reusable for order confirmation pages.
**Source.** `references/sources/pages/apps-invoice-details.html` (no JS beyond `javascript:window.print()`).
**Markup.**

```html
<div class="container-fluid"><div class="lg:w-10/12 w-full mx-auto"><div class="grid grid-cols-1 lg:grid-cols-4 gap-base">
  <div class="col-span-1 lg:col-span-3"><div class="card"><div class="card-body px-7.5">
    <div class="border-default-300 mb-5 flex items-center justify-between border-b pb-5">
      <a href="index.html" class="logo-dark"><img src="assets/images/logo-black.png" class="h-6.5 flex dark:hidden print:flex" alt="" /><img src="assets/images/logo.png" class="h-6.5 hidden dark:flex print:hidden" alt="" /></a>
      <div class="text-end"><span class="badge px-3 py-1.5 bg-warning/15 text-warning text-xs mb-2.5">Pending</span><h4 class="text-dark text-lg font-bold">Invoice #INS-0120001</h4></div>
    </div>
    <div class="grid grid-cols-1 gap-2.5 md:grid-cols-3">
      <div><h6 class="text-2xs text-default-400 mb-2.5 uppercase">From</h6><p class="mb-1.25 font-semibold">Alina Thompson</p><p class="text-default-400 mb-1.25">88 Crescent Ave,<br />Boston, MA - 02125</p><p class="text-default-400">Phone: 617-452-0099</p>
        <div class="mt-7.5"><h6 class="text-2xs text-default-400 uppercase mb-2">Invoice Date</h6><p class="font-medium">20 Apr 2025</p></div></div>
      <div><h6 class="text-2xs text-default-400 mb-2.5 uppercase">To</h6><!-- same shape --><div class="mt-7.5"><h6 class="text-2xs text-default-400 uppercase mb-2">Due Date</h6><p class="font-medium">05 May 2025</p></div></div>
      <div class="flex justify-end"><img src="assets/images/qr.png" class="size-20" style="max-height: 80px" alt="" /></div>
    </div>
    <div class="mt-7.5 mb-4 table-wrapper"><table class="table table-bordered text-center align-middle text-sm">
      <thead class="bg-light/25 thead-sm text-xs text-center uppercase"><tr><th class="text-center w-12">#</th><th>Product Details</th><th class="text-center">Qty</th><th class="text-center">Unit Price</th><th class="text-end">Total</th></tr></thead>
      <tbody><tr><td>01</td><td class="text-start"><strong class="block font-medium">Figma Design System</strong><div class="text-default-400 text-2xs">(Desktop &amp; Mobile UI Kit)</div></td><td>1</td><td>$350.00</td><td class="text-end">$350.00</td></tr></tbody>
    </table></div>
    <div class="mb-4 flex justify-end"><table class="table table-borderless text-end"><tbody class="text-sm">
      <tr><td class="font-medium">Subtotal</td><td>$1,270.00</td></tr>
      <tr><td class="font-medium">Discount (5%)</td><td class="text-danger px-2.25 py-3">- $63.50</td></tr>
      <tr><td class="font-medium">Tax (7%)</td><td>$84.42</td></tr>
      <tr><td class="border-t border-default-300">Total</td><td class="border-t border-default-300">$1,290.92</td></tr>
    </tbody></table></div>
    <div class="bg-light/50 mt-3 rounded px-6 py-3 lg:mt-7.5"><p class="text-default-400"><strong>Note:</strong> Please make payment within 10 days…</p></div>
    <div class="mt-7.5"><p class="mb-5 font-semibold">Thank you for your business!</p><img src="assets/images/sign.png" class="h-10.5" alt="" /><p class="text-default-400 text-2xs mb-4 italic">Authorized Signature</p></div>
  </div></div></div>
  <div class="col-span-1"><div class="sticky top-25"><div class="card"><div class="card-body">
    <div class="flex flex-col justify-center gap-2.5">
      <a href="#" class="btn bg-light hover:text-primary"><i class="iconify tabler--pencil"></i> Edit</a>
      <a href="javascript:window.print()" class="btn bg-primary text-white hover:bg-primary-hover"><i class="iconify tabler--printer"></i> Print</a>
      <a href="#" class="btn bg-info text-white hover:bg-info-hover"><i class="iconify tabler--download"></i> Download</a>
      <a href="#" class="btn bg-danger btn-lg text-lg text-white hover:bg-danger-hover"><i class="iconify tabler--send-2"></i> Send</a>
    </div>
  </div></div></div></div>
</div></div></div>
```

**Gotchas.**
- Logo pair uses `print:flex` / `print:hidden` so the black logo prints even in dark mode; the
  template's print CSS hides sidebar/topbar. Add `print:hidden` to the action card if it shows up.
- Use the `table-borderless` + `border-t` on the last row pattern for totals; avoid `table-sm` here —
  the numbers need the padding to stay readable on paper.

## Invoice create

**What it is.** Same `lg:w-10/12` two-column shell: a `card-body p-7.5` form with a clickable logo
upload box (`label[for=invoiceLogo]` over a hidden file input), Invoice # + Currency, three
flatpickr dates/payment method, Billing + Shipping address blocks (name, address textarea, phone
input-group with dial-code select), a `#invoice-items` line-item table with "Add Item", a totals
table of inputs (`#subtotal #tax #discount #total`), notes; sticky Preview / Download / Send card.
**Use it when.**
- Creating invoices, quotes, expense claims, purchase orders — any editable line-item document.
**Source.** `references/sources/pages/apps-invoice-create.html`, `assets/js/pages/apps-create-invoice.js`
(only a `previewImage(event)` helper for the logo), flatpickr via app.js `data-provider`.
**Markup.**

```html
<div class="card"><div class="card-body p-7.5">
  <div class="mb-7.5 flex flex-wrap items-center justify-between gap-4">
    <div class="border-default-300 relative flex h-15 w-65 items-center justify-between rounded border px-2 text-center">
      <label for="invoiceLogo" class="absolute inset-0 flex cursor-pointer items-center justify-between px-2"><img id="preview" src="assets/images/logo-black.png" class="h-7 flex dark:hidden print:flex" alt="" /><i class="iconify tabler--cloud-upload text-default-400 text-xl"></i></label>
      <input type="file" id="invoiceLogo" accept="image/*" class="hidden" onchange="previewImage(event)" />
    </div>
    <div class="flex flex-wrap items-center gap-2.5">
      <div class="flex flex-col"><label for="invoiceNumber" class="form-label">Invoice #</label><input type="text" id="invoiceNumber" class="form-input w-40" placeholder="e.g. INV-0001" /></div>
      <div class="flex flex-col"><label for="currency" class="form-label">Currency</label><select id="currency" class="form-select"><option value="USD" selected>USD ($)</option><option value="EUR">EUR (€)</option></select></div>
    </div>
  </div>
  <div class="grid grid-cols-1 md:grid-cols-3 gap-base">
    <div><label for="invoiceDate" class="form-label">Invoice Date</label><input type="text" id="invoiceDate" class="form-input flatpickr-input bg-transparent!" data-provider="flatpickr" placeholder="Select Date" readonly /></div>
    <div><label for="dueDate" class="form-label">Due Date</label><input type="text" id="dueDate" class="form-input flatpickr-input bg-transparent!" data-provider="flatpickr" placeholder="Select Date" readonly /></div>
    <div><label for="paymentMethod" class="form-label">Payment Method</label><select id="paymentMethod" class="form-input"><option value="">Select</option><option>Bank Transfer</option></select></div>
  </div>
  <div class="mt-7.5"><div class="grid grid-cols-1 md:grid-cols-2 gap-base">
    <div><label class="form-label">Billing Address</label><input type="text" class="form-input mb-3" placeholder="Name" /><textarea rows="3" class="form-textarea mb-3" placeholder="Address"></textarea>
      <div class="input-group flex"><select class="form-select" style="max-width: 120px"><option value="+1">+1 (US)</option><option value="+44" selected>+44 (UK)</option></select><input type="text" class="form-input" placeholder="Phone Number" /></div></div>
    <div><label class="form-label">Shipping Address</label><!-- same --></div>
  </div></div>
  <div class="mt-7.5 table-wrapper">
    <table class="table mb-4 min-w-full text-center align-middle">
      <thead class="bg-light/25 text-2xs tracking-wider uppercase"><tr><th class="p-2">#</th><th class="p-2 text-left">Item Description</th><th class="p-2">Qty</th><th class="p-2">Unit Price</th><th class="p-2">Amount</th><th class="p-2">Action</th></tr></thead>
      <tbody id="invoice-items">
        <tr><td class="px-2.25 py-3">1</td><td class="px-2.25 py-3"><input type="text" class="form-input" placeholder="Description" /></td><td class="px-2.25 py-3"><input type="number" class="form-input" placeholder="1" /></td><td class="px-2.25 py-3"><input type="number" class="form-input" placeholder="0.00" /></td><td class="px-2.25 py-3"><input type="number" class="form-input" placeholder="0.00" /></td>
          <td class="px-2.25 py-3"><button type="button" class="btn btn-icon bg-danger size-7.5 text-white hover:bg-danger-hover">×</button></td></tr>
      </tbody>
    </table>
    <button type="button" class="btn bg-primary mt-3 text-white hover:bg-primary-hover"><i class="iconify tabler--plus"></i> Add Item</button>
  </div>
  <div class="mt-7.5 flex justify-end"><div class="md:w-1/3"><div class="table-wrapper"><table class="table table-borderless">
    <tr><td class="text-end">Subtotal</td><td><input type="number" id="subtotal" placeholder="0.00" class="form-input" /></td></tr>
    <tr><td class="text-end">Tax (%)</td><td><input type="number" id="tax" placeholder="0.00" class="form-input" /></td></tr>
    <tr><td class="text-end">Discount</td><td><input type="number" id="discount" placeholder="0.00" class="form-input" /></td></tr>
    <tr class="font-bold"><td class="text-end">Total</td><td><input type="number" id="total" placeholder="0.00" readonly class="form-input bg-transparent!" /></td></tr>
  </table></div></div></div>
  <div class="mt-7.5"><label for="invoiceNote" class="form-label">Additional Notes</label><textarea id="invoiceNote" class="form-textarea" rows="3" placeholder="e.g. Thank you for your business!"></textarea></div>
</div></div>
<!-- sidebar: sticky top-25 card with Preview (tabler--eye) / Download (tabler--download) bg-light buttons and Send btn-lg bg-danger -->
```

**Init / JS.** `apps-create-invoice.js` exposes `window.previewImage(event)` which reads the chosen file
into `#preview` via `FileReader` — the demo page never calls it (no `onchange`, no `#preview` id), so
wire both as shown above. flatpickr is initialised by app.js for every `[data-provider="flatpickr"]`
(options via `data-date-format`, `data-enable-time`, `data-inline`, `data-default-date`).
The "Add Item", "×" and total recomputation have no script: clone the first `#invoice-items tr`,
renumber, and recompute `subtotal/tax/discount/total` on `input`.
**Gotchas.**
- Keep `readonly` on flatpickr inputs (app.js sets `disableMobile: true`, so the picker is used on
  phones too).
- `bg-transparent!` on the date/total inputs removes the input background so they blend into the
  bordered table/row.

## Blog list

**What it is.** One big card (`p-7.5`) → `grid xl:grid-cols-3`: a `xl:col-span-2 space-y-5` column of
horizontal `article.card border border-light` items (image with category badge in a `md:grid-cols-3`
cell, title, excerpt, outline tag badges, date / comments / views meta, author footer with "Read more")
and a sidebar column: "Add New Article" button, Search, Categories (count badges), Popular Posts,
Popular Tags (btn-sm chips), newsletter form.
**Use it when.**
- CMS article index, knowledge-base articles, news/press pages, changelog with images.
- The sidebar widgets (categories with counts, tag cloud, newsletter) are reusable on any content page.
**Source.** `references/sources/pages/apps-blog-list.html` (no JS).
**Markup.**

```html
<div class="card"><div class="p-7.5"><div class="grid xl:grid-cols-3 gap-base lg:gap-15">
  <div class="space-y-5 xl:col-span-2">
    <article class="card border border-light"><!-- repeat per post -->
      <div class="grid grid-cols-1 md:grid-cols-3">
        <div><div class="relative h-full overflow-hidden rounded-s-md">
          <div class="badge badge-label bg-dark text-white m-5 absolute start-0 top-0">Development</div>
          <img src="assets/images/blog/blog-1.jpg" class="h-full w-full object-cover" alt="" /></div></div>
        <div class="md:col-span-2">
          <div class="card-body">
            <h6 class="card-title mb-2.5"><a href="apps-blog-article.html" class="text-base hover:text-primary">Building REST APIs with Node.js</a></h6>
            <p class="text-default-400 mb-5">Learn how to design and build scalable REST APIs…</p>
            <div><a href="#!" class="badge badge-label border border-default-300">Node.js</a><a href="#!" class="badge badge-label border border-default-300">API</a></div>
            <p class="text-default-400 mt-5 flex flex-wrap items-center gap-base text-sm">
              <span class="flex items-center gap-1.25"><i class="iconify tabler--calendar text-md"></i> Feb 2, 2025</span>
              <span class="flex items-center gap-1.25"><i class="iconify tabler--message-circle text-md"></i><a href="#!" class="hover:text-primary">16</a></span>
              <span class="flex items-center gap-1.25"><i class="iconify tabler--eye text-md"></i> 8,974</span></p>
          </div>
          <div class="card-footer border-top items-center bg-transparent">
            <div class="flex items-center gap-2.5"><img src="assets/images/users/user-3.jpg" class="size-6 rounded-full" alt="" /><h5 class="font-bold"><a href="#!" class="hover:text-primary">John Doe</a></h5></div>
            <a class="text-primary flex items-center gap-1.25 font-semibold" href="apps-blog-article.html"> Read more <i class="iconify tabler--arrow-right"></i></a>
          </div>
        </div>
      </div>
    </article>
  </div>

  <div class="col-span-1">
    <div class="mb-7.5"><a href="apps-blog-add.html" class="btn bg-primary btn-lg w-full text-sm text-white hover:bg-primary-hover"><i class="iconify tabler--circle-dashed-plus"></i> Add New Article</a></div>
    <h5 class="mb-5 font-bold uppercase">Search</h5>
    <div class="input-icon-group mb-15"><i class="iconify tabler--search input-icon"></i><input type="text" class="form-input bg-light/20 border-light" placeholder="Search post..." /></div>
    <div class="mb-15"><h5 class="mb-5 font-bold uppercase">Categories</h5>
      <ul class="*:py-3 *:pe-5 *:flex *:items-center *:justify-between">
        <li class="border-b border-default-300"><a href="#" class="hover:text-primary flex items-center gap-3 font-medium"><i class="iconify tabler--folder"></i> Development</a><span class="badge bg-light">12</span></li>
        <li><a href="#" class="hover:text-primary flex items-center gap-3 font-medium"><i class="iconify tabler--folder"></i> Startup</a><span class="badge bg-light">6</span></li>
      </ul></div>
    <div class="mb-15"><h5 class="mb-5 font-bold uppercase">Popular Posts</h5>
      <ul class="*:py-3 *:flex *:items-center *:justify-between">
        <li class="border-b border-default-300"><a href="#" class="hover:text-primary flex items-center gap-3 font-medium"><i class="iconify tabler--article"></i> Unlocking the Secrets of Modern UI Design</a></li>
      </ul></div>
    <div class="mb-15"><h5 class="mb-5 font-bold uppercase">Popular Tags</h5>
      <div class="flex flex-wrap items-center gap-1.25"><a href="#" class="btn btn-sm bg-light hover:text-primary">Frontend</a><a href="#" class="btn btn-sm bg-light hover:text-primary">Tailwind CSS</a></div></div>
    <div class="bg-light/15 border-default-300 rounded border p-6 md:p-7.5">
      <h5 class="mb-5 font-bold uppercase">Subscribe to Newsletter</h5>
      <p class="text-default-400 mb-5 text-sm">Get the latest articles and updates directly to your inbox.</p>
      <form action="#"><div class="relative"><input type="email" class="form-input" placeholder="Your email address" />
        <button class="btn bg-dark absolute end-0 top-1/2 -translate-y-1/2 rounded-s-none py-3 text-white" type="submit"><i class="iconify tabler--send-2"></i></button></div></form>
    </div>
  </div>
</div></div></div>
```

**Gotchas.**
- `border-top` on the footer is not a template class (`border-t` is); the footer already has a top
  border from `.card-footer`.
- Category badge colour signals topic: `bg-dark` Development, `bg-primary` Design, etc.

## Blog grid (Masonry)

**What it is.** A `flex flex-wrap` container with `*:w-full md:*:w-1/2 xl:*:w-1/4 -mx-3` child
widths and `data-masonry='{"percentPosition": true }'`; each child is `px-3 mb-base` wrapping an
`article.card` (optional top image with category badge, body with badge/title/excerpt/tags/meta,
footer with author + Read more). Masonry packs the uneven cards.
**Use it when.**
- Card galleries with variable heights: articles, portfolio, testimonials, image notes.
- NOT when card heights are uniform — a plain `grid` is simpler and SSR-stable.
**Source.** `references/sources/pages/apps-blog-grid.html`, `assets/plugins/masonry/masonry.pkgd.min.js`,
`assets/js/pages/apps-blog-grid.js`.
**Markup.**

```html
<div class="container-fluid">
  <div class="flex flex-wrap *:w-full md:*:w-1/2 xl:*:w-1/4 -mx-3" data-masonry='{"percentPosition": true }'>
    <div class="px-3 mb-base"><!-- repeat per post -->
      <article class="card">
        <div class="relative h-full overflow-hidden rounded-t-md"><!-- optional image -->
          <div class="badge badge-label bg-dark text-white absolute start-6 top-6">Technology</div>
          <img src="assets/images/blog/blog-4.jpg" class="h-full w-full object-cover" alt="" /></div>
        <div class="card-body">
          <!-- text-only variant starts with: <span class="badge badge-label bg-dark text-white mb-5">Design</span> -->
          <h6 class="card-title mb-2.5"><a href="apps-blog-article.html" class="text-base hover:text-primary">The Future of Artificial Intelligence</a></h6>
          <p class="text-default-400 mb-5">Discover how AI is transforming industries…</p>
          <div><a href="#!" class="badge badge-label border border-default-300">AI</a><a href="#!" class="badge badge-label border border-default-300">Technology</a></div>
          <p class="text-default-400 text-sm mt-5 flex flex-wrap items-center gap-base"><span class="flex items-center gap-1.25"><i class="iconify tabler--calendar text-md"></i> May 28, 2025</span><span class="flex items-center gap-1.25"><i class="iconify tabler--message-circle text-md"></i><a href="#!" class="hover:text-primary">89</a></span><span class="flex items-center gap-1.25"><i class="iconify tabler--eye text-md"></i> 8,654</span></p>
        </div>
        <div class="card-footer items-center border-t-0 bg-transparent">
          <div class="flex items-center gap-2.5"><div><img src="assets/images/users/user-4.jpg" class="size-6 rounded-full" alt="" /></div><div><h5><a href="#!" class="text-sm hover:text-primary">Michael Turner</a></h5></div></div>
          <a class="text-primary flex items-center gap-1.25 font-semibold" href="apps-blog-article.html"> Read more <i class="iconify tabler--arrow-right"></i></a>
        </div>
      </article>
    </div>
  </div>
</div>
```

**Init / JS.** (`apps-blog-grid.js`, complete)

```js
setTimeout(() => {
  document.querySelectorAll("[data-masonry]").forEach((el) => new Masonry(el, JSON.parse(el.getAttribute("data-masonry"))));
}, 100);
```
**Gotchas.**
- The 100 ms delay lets images/fonts settle; for lazy images call `msnry.layout()` on `load` or use
  imagesLoaded. If items are appended later call `msnry.appended(elems)`.
- Masonry positions items absolutely — the `*:w-…` child widths define the columns and must be
  percentage-based (`percentPosition: true`). Don't add `gap-*`; use `px-3` on items + `-mx-3` on the
  container.

## Blog article

**What it is.** `container` → card `lg:p-15` → `grid 2xl:grid-cols-3`: the article (`2xl:col-span-2`)
with `h1.text-xl`, category badge + date/comments/views meta, hero image, prose with `mb-4`
paragraphs and an inline highlight `span.bg-warning/10`, a "Was this article helpful?" box with a
Yes/No radio-button group (`peer` + `peer-checked:`), an author box (dashed border), a Share row of
round social buttons; sidebar with Search, Related posts, Popular Tags, Newsletter.
**Use it when.**
- Help-centre article, documentation page, news post, changelog entry — anything long-form with
  feedback and related links.
**Source.** `references/sources/pages/apps-blog-article.html` (no JS).
**Markup.**

```html
<div class="2xl:col-span-2">
  <h1 class="text-xl">Mastering the Art of Focus: Tools & Strategies for Deep Work</h1>
  <div class="inline-flex items-center flex-wrap gap-base mt-5 text-sm">
    <span class="badge badge-label bg-dark text-white">Productivity</span>
    <span class="text-default-400 flex items-center gap-1.25"><i class="iconify tabler--calendar"></i> Mar 18, 2025</span>
    <span class="text-default-400 flex items-center gap-1.25"><i class="iconify tabler--message-circle"></i><a href="#!" class="hover:text-primary">42</a></span>
    <span class="text-default-400 flex items-center gap-1.25"><i class="iconify tabler--eye"></i> 982</span>
  </div>
  <img src="assets/images/blog/blog-post.jpg" class="mt-7.5 rounded" alt="" />
  <div class="text-md mt-7.5">
    <p class="mb-4">In a world full of constant notifications…</p>
    <p>By embracing stillness, <span class="bg-warning/10 p-0.75 dark:text-warning">you'll uncover a new level of clarity</span> …</p>
  </div>

  <div class="bg-light/15 border-light mt-12 flex flex-wrap items-center justify-center gap-3 rounded border p-5 text-center md:mt-15 md:justify-between md:gap-0">
    <h5>Was this article helpful?</h5>
    <p><b>41</b> out of <b>72</b> found this helpful</p>
    <div class="flex">
      <div><input type="radio" name="radiotoggle" id="radioYes" class="peer hidden" /><label for="radioYes" class="btn btn-sm rounded-e-none bg-success/15 text-success peer-checked:bg-success peer-checked:text-white"><i class="iconify tabler--thumb-up"></i> Yes</label></div>
      <div><input type="radio" name="radiotoggle" id="radioNo" class="peer hidden" /><label for="radioNo" class="btn btn-sm rounded-s-none bg-danger/15 text-danger peer-checked:bg-danger peer-checked:text-white"> No <i class="iconify tabler--thumb-down"></i></label></div>
    </div>
  </div>

  <div class="border-default-300 mt-7.5 mb-7.5 flex flex-wrap items-center gap-7.5 rounded border border-dashed p-6 md:flex-nowrap md:p-7.5">
    <div class="shrink-0 text-center"><div class="mb-3"><img src="assets/images/users/user-1.jpg" class="mx-auto size-12 rounded-full" alt="" /></div>
      <a href="#!" class="text-primary text-sm font-bold">Nathan Brooks</a><br /><span class="text-default-400 mt-1.5 text-xs font-semibold">Productivity Coach</span></div>
    <div><div class="text-default-400 mb-3 text-sm font-medium">Nathan is passionate about helping creators…</div><a href="#!" class="text-primary text-sm font-semibold">Author's Profile</a></div>
  </div>

  <div class="my-5 text-center md:my-7.5">
    <h5 class="mb-5 text-sm font-bold uppercase">Share This:</h5>
    <div class="mt-7.5 mb-2.5 flex flex-wrap items-center justify-start gap-2.5 md:justify-center">
      <a href="#" class="btn btn-icon bg-primary rounded-full hover:bg-primary-hover"><!-- brand svg --></a>
      <a href="#" class="btn btn-icon bg-info rounded-full hover:bg-info-hover"></a>
      <a href="#" class="btn btn-icon bg-danger rounded-full hover:bg-danger-hover"></a>
    </div>
  </div>
</div>
<!-- sidebar: Search / "Related post:" list (tabler--article) / Popular Tags / Newsletter — same markup as Blog list -->
```

**Gotchas.**
- The share buttons embed inline brand SVGs (no Tabler brand icons used); Tabler does ship
  `tabler--brand-facebook` etc. if you prefer the iconify route.
- The Yes/No group is pure CSS (`peer`); post the value on `change` if you need to record it.

## Blog add (CMS editor)

**What it is.** A single card form: title, slug, author, publish date-time (flatpickr with
`data-enable-time`), category, featured image file input, Quill `#snow-editor` (300 px, full
toolbar), excerpt, tags, then "SEO Settings" (meta title / description / keywords), "Visibility"
switches (featured, allow comments), Status radios (Draft / Published) and Reset / Save as Draft /
Publish buttons.
**Use it when.**
- Any CMS create/edit screen: blog posts, help articles, landing-page copy, product descriptions
  with SEO fields.
**Source.** `references/sources/pages/apps-blog-add.html`, `assets/plugins/quill/quill.js`,
`assets/js/pages/form-quilljs.js` (shared with the forms group's Quill page).
**Markup.**

```html
<div class="container"><div class="card">
  <div class="card-header"><h5 class="card-title">Create New Blog Post</h5><small class="text-default-400">Last saved: just now</small></div>
  <div class="card-body"><form class="space-y-5">
    <div><label for="title" class="form-label">Post Title</label><input type="text" class="form-input" id="title" placeholder="Enter your blog title" required /></div>
    <div><label for="slug" class="form-label">Slug</label><input type="text" class="form-input" id="slug" placeholder="e.g. how-to-build-a-blog" /></div>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-base">
      <div><label for="author" class="form-label">Author</label><input type="text" class="form-input" id="author" /></div>
      <div><label for="publishDate" class="form-label">Publish Date & Time</label><input type="text" data-provider="flatpickr" data-date-format="d M, Y" data-enable-time class="form-input" id="publishDate" /></div>
      <div><label for="category" class="form-label">Category</label><select id="category" class="form-select"><option selected disabled>Select category</option><option>Technology</option></select></div>
      <div><label for="profilephoto" class="form-label">Featured Image</label><input type="file" id="profilephoto" class="form-input" /><small class="text-default-400">Recommended size: 1200x600px</small></div>
    </div>
    <div><label class="form-label">Post Content</label>
      <div id="snow-editor" style="height: 300px"><h3>Create, manage, and publish engaging blog articles effortlessly.</h3><p>…</p></div></div>
    <div><label for="excerpt" class="form-label">Excerpt (Short Summary)</label><textarea class="form-textarea" id="excerpt" rows="2"></textarea></div>
    <div><label for="tags" class="form-label">Tags</label><input type="text" class="form-input" id="tags" placeholder="e.g. TailwindCSS, web design" /><small class="text-default-400">Separate tags with commas.</small></div>

    <div class="border-default-300 mt-7.5 space-y-5 border-t pt-5">
      <h5 class="text-default-400 text-sm font-bold uppercase">SEO Settings</h5>
      <div><label for="metaTitle" class="form-label">Meta Title</label><input type="text" class="form-input" id="metaTitle" /></div>
      <div><label for="metaDescription" class="form-label">Meta Description</label><textarea class="form-textarea" id="metaDescription" rows="2"></textarea></div>
      <div><label for="metaKeywords" class="form-label">Meta Keywords</label><input type="text" class="form-input" id="metaKeywords" /></div>
    </div>
    <div class="border-default-300 mt-7.5 space-y-5 border-t pt-5">
      <h5 class="text-default-400 text-sm font-bold uppercase">Visibility</h5>
      <div class="flex items-center gap-2"><input class="form-switch" type="checkbox" id="featured" /><label class="form-check-label" for="featured">Mark as Featured Post</label></div>
      <div class="flex items-center gap-2"><input class="form-switch" type="checkbox" id="commentsEnabled" checked /><label class="form-check-label" for="commentsEnabled">Allow Comments</label></div>
    </div>
    <div class="mt-7.5 mb-5 space-y-5">
      <label class="text-default-400 text-sm font-bold uppercase">Status</label>
      <div class="flex items-center gap-3">
        <div class="flex items-center gap-2"><input class="form-radio rounded-full!" type="radio" name="status" id="draft" value="draft" checked /><label class="form-check-label" for="draft">Draft</label></div>
        <div class="flex items-center gap-2"><input class="form-radio rounded-full!" type="radio" name="status" id="published" value="published" /><label class="form-check-label" for="published">Published</label></div>
      </div>
    </div>
    <div class="mt-5 flex flex-wrap justify-center gap-3">
      <button type="reset" class="btn border-secondary hover:bg-secondary text-secondary hover:text-white">Reset</button>
      <button type="submit" class="btn bg-success text-white hover:bg-success-hover">Save as Draft</button>
      <button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Publish Post</button>
    </div>
  </form></div>
</div></div>
```

**Init / JS.** (`form-quilljs.js`, trimmed) initialises `#snow-editor` (full toolbar) and
`#bubble-editor` if present:

```js
if (typeof Quill !== "undefined") {
  // …overrides Quill.import("ui/icons") with Tabler SVGs for bold/italic/underline/strike/lists/indent/link/image/video/code-block/clean/color/background/script/blockquote/align/header…
  const snow = document.getElementById("snow-editor");
  snow && new Quill(snow, { theme: "snow", modules: { toolbar: [
    [{ font: [] }], ["bold", "italic", "underline", "strike"], [{ color: [] }, { background: [] }],
    [{ script: "super" }, { script: "sub" }], [{ header: [false, 1, 2, 3, 4, 5, 6] }], ["blockquote", "code-block"],
    [{ list: "ordered" }, { list: "bullet" }, { indent: "-1" }, { indent: "+1" }], [{ align: [] }],
    ["link", "image", "video"], ["clean"] ] } });
  document.getElementById("bubble-editor") && new Quill("#bubble-editor", { theme: "bubble" });
}
```
**Gotchas.**
- Quill content is not part of the `<form>` submission — copy `quill.root.innerHTML` into a hidden
  input on submit.
- Two `type="submit"` buttons: distinguish Draft vs Publish by `name`/`value` or `formaction`.
- Flatpickr with `data-enable-time` uses `H:i` 24-hour time appended to `data-date-format`.

## Forum view

**What it is.** `container` → `grid lg:grid-cols-4`: `lg:col-span-3` stack (`space-y-1.25`) of thread
cards (category label, title link, excerpt, footer with author avatar + name + time, Answers, "Ends in",
Votes, status badge) and a sidebar card with Popular posts list and Popular Tags.
**Use it when.**
- Discussion board index, Q&A list, feature-request board, community threads.
**Source.** `references/sources/pages/apps-forum-view.html` (no JS).
**Markup.**

```html
<div class="container"><div class="grid grid-cols-1 lg:grid-cols-4 gap-base">
  <div class="lg:col-span-3"><div class="space-y-1.25">
    <div class="card"><!-- repeat per thread -->
      <div class="card-body">
        <p class="text-default-400 mb-2.5 text-sm font-semibold uppercase">Development Talk</p>
        <h4 class="mb-2.5 text-base"><a href="apps-forum-post.html" class="hover:text-primary">What's the best JavaScript framework in 2025?</a></h4>
        <p class="text-default-400">With so many frameworks available, developers often debate…</p>
      </div>
      <div class="card-footer block border-0">
        <div class="text-default-400 flex flex-wrap justify-between items-center gap-base">
          <div class="flex items-center gap-2.5"><img src="assets/images/users/user-5.jpg" class="size-8 rounded" alt="" /><div><a href="#!" class="text-dark font-semibold">James Milton</a><p class="text-xs">1 hour ago</p></div></div>
          <div class="flex items-center gap-1.25"><i class="iconify tabler--messages text-default-400"></i><a href="#!" class="hover:text-primary">Answers: 45</a></div>
          <div class="flex items-center gap-1.25"><i class="iconify tabler--clock text-default-400"></i><span class="font-semibold">Ends in: 3 days</span></div>
          <div class="flex items-center gap-1.25"><i class="iconify tabler--users text-default-400"></i><a href="#!" class="hover:text-primary">Votes: 732</a></div>
          <div class="flex items-center gap-1.25"><span class="badge bg-success text-white">New</span></div>  <!-- or bg-warning count badge -->
        </div>
      </div>
    </div>
  </div></div>
  <div><div class="card">
    <div class="card-body"><h5 class="mb-5 font-bold uppercase">Popular Posts:</h5>
      <ul><li class="border-default-300 border-b py-3"><a href="#" class="hover:text-primary transition-colors">How to Build a Portfolio with Tailwind CSS</a></li><li class="py-3"><a href="#" class="hover:text-primary transition-colors">Essential Tips for Clean and Maintainable Code</a></li></ul></div>
    <div class="card-body"><h5 class="mb-5 font-bold uppercase">Popular Tags:</h5>
      <div class="flex flex-wrap items-center gap-1.5"><a href="#" class="btn btn-sm bg-light hover:text-primary transition-colors">Web Design</a><a href="#" class="btn btn-sm bg-light hover:text-primary transition-colors">Frontend</a></div></div>
  </div></div>
</div></div>
```

**Gotchas.**
- `card-footer block border-0` removes the default footer flex + border so the meta row wraps freely.
- No "new thread" button in the demo; add one in `.page-title-head` or above the list.

## Forum post

**What it is.** Thread page: `lg:col-span-3` card with centred category + `h4.text-xl` title
(`<span data-current-year>` filled by app.js), body paragraphs, author/meta row, dashed divider, reply
textarea + Submit, "Replies(15)" and the same dashed comment boxes with nested replies used in Project
details; sidebar identical to Forum view.
**Use it when.**
- Thread detail, Q&A answer page, feature-request discussion, support community topic.
**Source.** `references/sources/pages/apps-forum-post.html` (no JS; `data-current-year` is an app.js helper).
**Markup.**

```html
<div class="lg:col-span-3"><div class="card"><div class="card-body">
  <p class="text-default-400 my-2.5 text-center font-semibold uppercase">#Development Talk</p>
  <h4 class="mb-5 text-center text-xl"> What's the best JavaScript framework in <span data-current-year></span> ? </h4>
  <p class="mb-4">With the ever-evolving front-end landscape…</p>
  <div class="mt-7.5 flex flex-wrap justify-between gap-2">
    <div class="flex items-center gap-2.5"><img src="assets/images/users/user-5.jpg" class="size-8 rounded" alt="" /><div><a href="#!" class="hover:text-primary block font-semibold">James Milton</a><span class="text-default-400 text-2xs">1 hour ago</span></div></div>
    <span class="text-default-400 flex items-center gap-1.25"><i class="iconify tabler--messages"></i><a href="#!" class="hover:text-primary">Answers: 45</a></span>
    <span class="text-default-400 flex items-center gap-1.25"><i class="iconify tabler--clock"></i> Ends in: 3 days</span>
    <span class="text-default-400 flex items-center gap-1.25"><i class="iconify tabler--users"></i> Votes: 732</span>
  </div>
  <div class="border-b border-dashed border-default-300 my-5"></div>
  <div class="mb-5"><textarea class="form-textarea bg-light/20" rows="4" placeholder="Enter your messages..."></textarea></div>
  <div class="text-end"><button type="submit" class="btn bg-secondary text-white hover:bg-secondary-hover"> Submit <i class="iconify tabler--send-2 text-white"></i></button></div>
  <h4 class="mb-2 text-lg">Replies(15)</h4>
  <div class="border-default-300 my-5 border-b border-dashed"></div>
  <div class="border-default-300 mb-2.5 rounded border border-dashed p-5"><!-- reply box -->
    <div class="flex gap-2.5"><div class="shrink-0"><img src="assets/images/users/user-8.jpg" class="size-8 rounded-full" alt="" /></div>
      <div><h5 class="mb-1.25"> Liam Carter <small class="text-default-400">15 Apr 2025 · 09:20AM</small></h5>
        <p class="mb-2.5">Customers are reporting that the checkout page freezes…</p>
        <a href="#" class="badge py-1 px-1.5 bg-light text-default-400"><i class="iconify tabler--corner-up-left text-base"></i> Reply</a>
        <div class="mt-7.5 flex gap-2.5"><!-- nested reply, same inner structure --></div>
      </div></div>
  </div>
</div></div></div>
```

**Gotchas.**
- app.js fills every `[data-current-year]` with the current year — handy for footers too.
- Nesting is done by placing the child's `flex gap-2.5` block inside the parent's text column, so
  indentation grows naturally; cap at 2–3 levels.

## Clients

**What it is.** CRM client table (`data-table`): search, round "+" opening `#addClientModal`, bulk
Delete, Country + Project Type filters, rows selector; columns Clients Name (avatar, name, email),
Phone, Country (flag + code), Enrolled, Type, Job Title, Status, Actions; pagination footer. The modal
(`md:max-w-2xl lg:max-w-3xl`, 2-col) has Client Name, Email, Phone, Country select and more.
**Use it when.**
- Customers, leads, suppliers, partners — any people-as-accounts table with a quick-add modal.
**Source.** `references/sources/pages/apps-clients.html` + `custom-table.js`.
**Markup.** (engine shell; distinctive bits)

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search clients..." class="form-input" /></div>
      <button class="btn bg-secondary btn-icon text-white" data-hs-overlay="#addClientModal"><i class="iconify tabler--plus text-base"></i></button>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button></div>
    <div class="flex flex-wrap items-center gap-2.5"><span class="me-2.5 font-semibold">Filter By:</span>
      <div class="input-icon-group"><i class="iconify tabler--world input-icon"></i><select data-table-filter="country" class="form-select"><option value="All">Country</option><option value="US">USA</option><option value="UK">UK</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--briefcase input-icon"></i><select data-table-filter="type" class="form-select"><option value="All">Project Type</option><option value="Project">Project</option><option value="Retainer">Retainer</option></select></div>
      <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="10">10</option></select></div>
  </div>
  <div class="table-wrapper"><table class="table table-hover table-custom">
    <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase"><th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th><th data-table-sort="name">Clients Name</th><th data-table-sort>Phone</th><th data-table-sort data-column="country">Country</th><th data-table-sort>Enrolled</th><th data-table-sort data-column="type">Type</th><th data-table-sort>Job Title</th><th data-table-sort>Status</th><th class="text-center">Actions</th></tr></thead>
    <tbody><tr>
      <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td>
      <td><div class="flex items-center gap-2.5"><img src="assets/images/users/user-7.jpg" class="size-8 rounded-full" alt="" /><div><h5><a data-sort="name" href="#!" class="hover:text-primary">Emily Parker</a></h5><p class="text-default-400 text-xs">emily@startupwave.io</p></div></div></td>
      <td>+1 (415) 992-3412</td>
      <td><div class="inline-flex items-center font-bold"><img src="assets/images/flags/us.svg" class="me-1.25 size-3 rounded-full" alt="" /> US</div></td>
      <td>Feb 2, 2024</td><td>Project</td><td>Frontend Developer</td>
      <td><span class="badge font-semibold badge-label bg-success/15 text-success">Active</span></td>
      <td><div class="flex justify-center gap-1.25"><!-- eye / edit / data-table-delete-row --></div></td>
    </tr></tbody></table></div>
  <div class="card-footer"><div data-table-pagination-info="clients"></div><div data-table-pagination></div></div>
</div>

<div id="addClientModal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" role="dialog" tabindex="-1">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 m-3 flex min-h-[calc(100%-56px)] max-w-sm scale-95 items-center opacity-0 transition-all duration-200 ease-in-out md:mx-auto md:w-full md:max-w-2xl lg:max-w-3xl">
    <div class="card pointer-events-auto flex w-full flex-col">
      <div class="card-header p-5"><h3 class="card-title uppercase font-bold text-sm">Add New Client</h3><button type="button" data-hs-overlay="#addClientModal"><i class="iconify tabler--x text-xl"></i></button></div>
      <div class="card-body overflow-y-auto"><div class="grid grid-cols-1 md:grid-cols-2 gap-base">
        <div><label for="clientName" class="form-label">Client Name</label><input type="text" class="form-input" id="clientName" placeholder="Enter full name" required /></div>
        <div><label for="clientEmail" class="form-label">Email</label><input type="email" class="form-input" id="clientEmail" required /></div>
        <div><label for="clientPhone" class="form-label">Phone</label><input type="tel" class="form-input" id="clientPhone" placeholder="+1 (000) 000-0000" /></div>
        <div><label for="clientCountry" class="form-label">Country</label><select class="form-input" id="clientCountry" required><option value="">Select country...</option><option value="US">United States</option></select></div>
      </div></div>
      <!-- standard border-t p-5 footer: Cancel (bg-light) + Save (bg-primary) -->
    </div>
  </div>
</div>
```

**Gotchas.**
- The Country filter compares the option value (`US`) with the cell text — the cell renders `US`
  next to the flag so it matches; keep the visible code equal to the option value.
- Status filter is not wired (no `data-column="status"` on that `th`); add it if you want one.

## Companies

**What it is.** Filter card (search, Location / Category / Rating selects, Apply, grid/list tabs) and a
3-column grid of horizontal company cards: 48 px logo, name + website, round "Follow" outline button,
location + category badges, description, Employees / Revenue KPIs and a 5-star rating row; pagination.
**Use it when.**
- Vendor / partner / account directory, competitor list, marketplace of organisations.
**Source.** `references/sources/pages/apps-companies.html` (no JS).
**Markup.**

```html
<div class="card border border-default-300 shadow-none mb-base"><div class="card-body"><!-- filter bar, same shape as Users contacts (icons tabler--map-pin / tabler--briefcase / tabler--star; tabs tabler--category / tabler--list-check) --></div></div>
<div class="grid xl:grid-cols-3 md:grid-cols-2 grid-cols-1 gap-base mb-5">
  <div class="card flex flex-row p-5"><!-- repeat per company -->
    <img src="assets/images/logos/amazon.svg" class="size-12 me-5" alt="" />
    <div class="grow">
      <div class="flex justify-between items-start">
        <div><h4 class="mb-1.25 font-bold text-lg">Amazon Inc.</h4><a href="https://www.amazon.com" class="text-default-400">www.amazon.com</a></div>
        <a href="#!" class="btn btn-sm border border-danger text-danger hover:bg-danger hover:text-white rounded-full"><i class="iconify tabler--heart me-1.25"></i> Follow</a>
      </div>
      <div class="mt-2.5 mb-5 flex flex-wrap gap-2.5"><span class="badge bg-light text-primary text-2xs"><i class="iconify tabler--map-pin me-1.25"></i> Seattle, WA</span><span class="badge bg-light text-success text-2xs">eCommerce</span></div>
      <p class="text-default-400 mb-5">Amazon.com, Inc. is an American multinational technology company…</p>
      <div class="flex justify-between flex-wrap mt-2.5 gap-5">
        <div><h6 class="text-default-400 mb-2 text-xs">Employees</h6><span class="font-semibold text-base">1.5M+</span></div>
        <div><h6 class="text-default-400 mb-2 text-xs">Revenue</h6><span class="font-semibold text-base">$514B</span></div>
        <div class="text-warning"><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star"></i></div>
      </div>
    </div>
  </div>
</div>
<!-- pagination: same round-button nav as Projects grid -->
```

**Gotchas.**
- Same dangling `#tabs-contact-1/2` tab targets as Users contacts (copied ids) — rename and add panels.
- `card flex flex-row p-5` bypasses `.card-body`; keep `p-5` or the content touches the edges.

## Outlook view

**What it is.** Two-pane reader: a `w-70` offcanvas/static column whose card is a vertical Preline tab
list (`nav[role=tablist][aria-orientation=vertical]` → `a.hs-tab-active:bg-light/45.p-5` per message:
sender, date, preview, location/badge) and a `flex-1` card whose body holds one `div[role=tabpanel]`
per message (timestamp, subject `h2`, tooltip action buttons "Plug it" / mark read / important / trash,
body paragraphs, a reply form). Clicking a list item swaps the pane — no JS beyond Preline.
**Use it when.**
- Notification centre, announcement reader, ticket queue with preview pane, document review list —
  anywhere "master list → detail pane" with pre-rendered details is acceptable.
- NOT for large mailboxes (every message body is in the DOM) — use Email inbox + details pages.
**Source.** `references/sources/pages/apps-outlook.html` (`custom-table.js` is loaded but there is no
`[data-table]` on the page, so it is inert).
**Markup.**

```html
<div class="container-fluid"><div class="flex lg:gap-1.25 h-[calc(100vh-200px)]">
  <div id="outlookSidebaroffcanvas" class="hs-overlay hs-overlay-open:translate-x-0 fixed start-0 top-0 bottom-0 z-70 h-full w-70 -translate-x-full transform transition-all duration-300 [--auto-close:lg] lg:static lg:end-auto lg:bottom-0 lg:block! lg:translate-x-0" role="dialog" tabindex="-1">
    <div class="card lg:h-[calc(100vh-200px)] h-full rounded-none" data-simplebar>
      <nav class="divide-default-300 flex flex-col divide-y" role="tablist" aria-orientation="vertical">
        <a href="#" class="hs-tab-active:bg-light/45 p-5" id="outlook-view-1" data-hs-tab="#outlook-tab-1" aria-controls="outlook-tab-1" role="tab"><!-- repeat per message -->
          <span class="flex items-center justify-between mb-1.25"><span class="text-sm font-semibold">Emily Carter</span><small class="text-default-400 text-2xs">12.04.2025</small></span>
          <span class="text-default-400 mb-2.5 block text-xs">Completed your project milestone and uploaded the final report.</span>
          <span class="flex justify-between"><span class="flex items-center gap-1"><i class="iconify tabler--map-pin"></i> New Haven, CT</span>
            <button class="badge badge-label font-semibold bg-primary text-white">Special</button></span>
        </a>
        <a href="#" class="hs-tab-active:bg-light/45 active p-5" id="outlook-view-2" data-hs-tab="#outlook-tab-2" aria-controls="outlook-tab-2" role="tab"><!-- initially selected --></a>
      </nav>
    </div>
  </div>
  <div class="card h-full min-w-0 flex-1">
    <div class="card-header lg:hidden"><button class="btn btn-sm btn-icon border-default-300" data-hs-overlay="#outlookSidebaroffcanvas"><i class="iconify tabler--menu-4 text-default-600 text-2xl"></i></button></div>
    <div class="card-body h-[calc(100vh-200px)]" data-simplebar>
      <div id="outlook-tab-1" role="tabpanel" class="hidden" aria-labelledby="outlook-view-1">
        <div class="mb-5 flex flex-wrap items-start justify-between md:mb-0">
          <div><div class="text-default-400 mb-2.5"><i class="iconify tabler--clock"></i> Tuesday, 16 April 2025, 11:48 AM</div><h2 class="mb-5 text-lg">Potential Partnership Opportunity</h2></div>
          <div class="flex items-center gap-1">
            <div class="hs-tooltip flex [--placement:left]"><button class="hs-tooltip-toggle"><div class="btn btn-sm border-default-300 text-default-800 hover:border-default-400 text-sm"><i class="iconify tabler--plug"></i> Plug it</div>
              <span class="hs-tooltip-content hs-tooltip-shown:visible hs-tooltip-shown:opacity-100 bg-default-800 text-default-50 invisible absolute z-10 rounded-md px-3 py-1.5 text-xs opacity-0">Plug this message</span></button></div>
            <div class="hs-tooltip flex [--placement:top]"><button class="hs-tooltip-toggle"><div class="btn btn-icon border-default-300 text-default-800 hover:border-default-400 size-7.75"><i class="iconify tabler--eye"></i></div>
              <span class="hs-tooltip-content hs-tooltip-shown:visible hs-tooltip-shown:opacity-100 bg-default-800 text-default-50 invisible absolute z-10 rounded-md px-3 py-1.5 text-xs opacity-0">Mark as read</span></button></div>
            <!-- tabler--alert-circle "Mark as important", tabler--trash "Move to trash" -->
          </div>
        </div>
        <p class="mb-4">Hello Maria,</p><p class="mb-4">…</p>
        <p class="italic"><strong> Best, <br /> David Lee </strong><br /> Business Development Lead</p>
        <form action="#" class="my-5">
          <div class="mb-5"><textarea class="form-textarea" rows="4" placeholder="Enter your reply..."></textarea></div>
          <div class="text-end"><button type="submit" class="btn bg-secondary text-white hover:bg-secondary-hover"> Submit <i class="iconify tabler--send-2"></i></button></div>
        </form>
      </div>
      <div id="outlook-tab-2" role="tabpanel" aria-labelledby="outlook-view-2"><!-- visible by default --></div>
    </div>
  </div>
</div></div>
```

**Gotchas.**
- The tab that should open first carries `active` on the `<a>` and NO `hidden` on its panel; every
  other panel needs `hidden`. The demo marks two items `aria-selected="true"` — only `active` counts.
- A `<button>` inside the tab `<a>` (the "Special" badge) is invalid nesting; use a `<span>`.
- To add a third "folders" pane, wrap this in the Email inbox's sidebar card.

## Vote list

**What it is.** One card: header with search, Sort By + Vote Status selects and an "Add New Topics"
button; `card-body p-0` with dashed-separated rows: a vertical up-count-down control
(`tabler--chevron-up` / bold number / `tabler--chevron-down`) beside the topic title, description and a
meta row (author avatar, posted date, tag badge, comments, "Ends in", votes, status).
**Use it when.**
- Feature voting boards, idea backlogs, community polls, "upvote this question" lists.
**Source.** `references/sources/pages/apps-vote-list.html` (no JS; the `data-table-search` input has
no `data-table` root so it is inert — add one or your own filter).
**Markup.**

```html
<div class="container"><div class="card">
  <div class="card-header">
    <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input type="search" placeholder="Search topics..." class="form-input" /></div>
    <div class="flex flex-wrap items-center gap-2.5"><span class="font-semibold me-2.5">Filter By:</span>
      <div class="input-icon-group"><i class="iconify tabler--filter-2 input-icon"></i><select class="form-select"><option selected>Sort By</option><option>Latest</option><option>Popular</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--circle-check input-icon"></i><select class="form-select"><option selected>Vote Status</option><option>Voted</option><option>Not Voted</option></select></div>
      <button type="submit" class="btn bg-success text-white hover:bg-success-hover">Add New Topics</button></div>
  </div>
  <div class="card-body p-0">
    <div class="border-b border-dashed border-default-300 px-7.5 py-5"><!-- repeat per topic -->
      <div class="flex items-center gap-7.5">
        <div class="flex flex-col items-stretch gap-1.5 text-center">
          <button type="button" class="btn p-0"><i class="iconify tabler--chevron-up text-primary text-xl"></i></button>
          <h5 class="text-base font-bold">35</h5>
          <button type="button" class="btn p-0"><i class="iconify tabler--chevron-down text-primary text-xl"></i></button>
        </div>
        <div class="grow">
          <h4 class="text-md mb-1.25"><a href="#!" class="hover:text-primary">Should remote work be a permanent option for all employees?</a></h4>
          <p class="text-default-400 mb-2.5 text-sm">Remote work has seen a massive rise in popularity since 2020…</p>
          <p class="text-default-400 mb-1.25 flex flex-wrap items-center gap-base">
            <span class="flex items-center gap-1.25"><img src="assets/images/users/user-7.jpg" class="size-6 rounded-full" alt="" /><a href="#!" class="hover:text-primary font-semibold">Emily Parker</a></span>
            <span class="flex items-center gap-1"><i class="iconify tabler--calendar"></i><span>Posted on: Jan 12, 2025</span></span>
            <span class="flex items-center gap-1"><i class="iconify tabler--tag"></i><span class="badge font-semibold bg-light text-primary">Workplace</span></span>
            <span class="flex items-center gap-1"><i class="iconify tabler--messages"></i><a href="#!" class="hover:text-primary text-sm">Comments: 89</a></span>
            <span class="flex items-center gap-1"><i class="iconify tabler--clock"></i> Ends in: 5 days</span>
            <span class="flex items-center gap-1"><i class="iconify tabler--users"></i> Votes: 1,284</span>
          </p>
        </div>
      </div>
    </div>
  </div>
</div></div>
```

**Gotchas.**
- Show the user's own vote by colouring the chevron (`text-danger` on the up arrow in the second demo
  row); there is no JS — increment the `h5` and post the vote yourself.
- The Sort By option values in the demo are copy-paste leftovers ("North America"…); set real values.

## Issue tracker

**What it is.** `data-table` card (search, "Add New Issues" button) whose headless table rows show:
status badge, ISSUE-ID link (opens `#taskDetailsModal`) + title, assignee avatar + name, Created / Due
lines, outline tag badges, progress bar + "60% Complete", comments count, files count, actions. The
modal is an "Issue Details" card: status pill + title, assignee, Created/Due/tags grid, description,
progress, comments/files counters, attachment list with Download buttons, Close / Edit / Delete footer.
**Use it when.**
- Bug tracker, support ticket board, task list with a quick-view drawer, QA defects log.
- The detail modal is a generic "record quick-view" you can reuse for orders, tasks, candidates.
**Source.** `references/sources/pages/apps-issue-tracker.html` + `custom-table.js`.
**Markup.**

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search issues..." class="form-input" /></div>
    <button class="btn bg-success text-white hover:bg-success-hover">Add New Issues</button>
  </div>
  <div class="card-body"><div class="table-wrapper"><table class="table table-hover"><tbody>
    <tr><!-- repeat per issue -->
      <td><span class="badge font-semibold badge-label text-2xs bg-warning text-white">In Progress</span></td>   <!-- bg-danger Open · bg-success Resolved -->
      <td><a href="#!" data-hs-overlay="#taskDetailsModal" class="hover:text-primary text-sm font-semibold uppercase">ISSUE-104</a><p class="text-default-400">User profile update not saving on mobile devices</p></td>
      <td><div class="flex items-center gap-2.5"><img src="assets/images/users/user-3.jpg" class="size-6 rounded-full" alt="" /><h5 class="text-default-800">Jason Lee</h5></div></td>
      <td><p class="flex items-center gap-1"><i class="iconify tabler--calendar"></i><span class="font-semibold">Created:</span> 10.02.2025</p><p class="flex items-center gap-1"><i class="iconify tabler--clock"></i><span class="font-semibold">Due:</span> 15.02.2025</p></td>
      <td><div class="flex items-center gap-0.75"><a href="#!" class="badge font-semibold badge-label border border-default-300">Mobile</a><a href="#!" class="badge font-semibold badge-label border border-default-300">Urgent</a></div></td>
      <td><div class="bg-default-100 h-1.5 w-full rounded-full"><div class="bg-warning h-1.5 rounded-s-full" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div></div><small class="text-default-400 text-xs">60% Complete</small></td>
      <td><div class="flex items-center gap-2"><i class="iconify tabler--message-circle text-default-400"></i> 12 comments</div></td>
      <td><div class="flex items-center gap-2"><i class="iconify tabler--paperclip text-default-400"></i> 3 files</div></td>
      <td><div class="flex justify-center gap-1.5"><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--eye text-base"></i></a><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--edit text-base"></i></a><a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a></div></td>
    </tr>
  </tbody></table></div></div>
  <div class="card-footer"><div data-table-pagination-info="issues"></div><div data-table-pagination></div></div>

  <!-- detail modal (inside <main> in the demo; works because nothing above it is transformed) -->
  <div id="taskDetailsModal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" role="dialog" tabindex="-1">
    <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 m-3 flex min-h-[calc(100%-56px)] scale-95 items-center opacity-0 transition-all duration-200 ease-in-out md:mx-auto md:w-full md:max-w-2xl lg:max-w-3xl">
      <div class="card pointer-events-auto flex w-full flex-col">
        <div class="card-header py-5"><h3 class="text-md">Issue Details</h3><button type="button" data-hs-overlay="#taskDetailsModal"><i class="iconify tabler--x text-xl"></i></button></div>
        <div class="card-body overflow-y-auto">
          <div class="flex flex-wrap items-center gap-3 mb-6"><span class="badge font-semibold bg-warning/10 text-warning rounded-full py-1.5 px-3 text-xs">In Progress</span><h5 class="font-semibold">ISSUE-104 — User profile update not saving on mobile devices</h5></div>
          <div class="flex items-center mb-6"><img src="assets/images/users/user-1.jpg" class="rounded-full me-3" width="40" height="40" alt="" /><div><h5>Jason Lee</h5><small class="text-default-400 text-2xs">Assigned User</small></div></div>
          <div class="grid md:grid-cols-3 mb-6"><div><strong>Created:</strong> 10 Feb 2025</div><div><strong>Due:</strong> 15 Feb 2025</div>
            <div><span class="badge font-semibold badge-label bg-light">Mobile</span><span class="badge font-semibold bg-light text-danger">Urgent</span></div></div>
          <p class="text-default-400 mb-4">User profile update is not saving correctly on mobile devices…</p>
          <div class="mb-6"><div class="flex justify-between"><small class="mb-3 uppercase text-2xs">Progress</small><small class="font-bold text-warning text-2xs">60% Complete</small></div>
            <div class="h-1.5 w-full rounded bg-default-200"><div class="h-full w-[60%] rounded bg-warning"></div></div></div>
          <div class="grid grid-cols-2 text-center mb-6"><div><i class="iconify tabler--message me-1.5"></i><strong>12 Comments</strong></div><div><i class="iconify tabler--paperclip me-1.5"></i><strong>3 Files Attached</strong></div></div>
          <ul class="mb-6 border border-default-300">
            <li class="py-3 px-5 border-b border-default-300 flex justify-between items-center"><span>profile-update-bug.txt</span><a href="#" class="btn btn-sm border border-primary text-primary">Download</a></li>
            <li class="py-3 px-5 flex justify-between items-center"><span>screenshot-mobile.png</span><a href="#" class="btn btn-sm border border-primary text-primary">Download</a></li>
          </ul>
        </div>
        <div class="border-default-300 flex items-center justify-end gap-x-2 border-t p-5">
          <button type="button" class="btn bg-default-200 hover:text-primary" data-hs-overlay="#taskDetailsModal">Close</button>
          <button type="button" class="btn bg-primary text-white hover:bg-primary-hover">Edit Issue</button>
          <button type="button" class="btn bg-danger text-white hover:bg-danger-hover">Delete Issue</button>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- One shared modal for all rows: fill it on click (`HSOverlay` fires `open.hs.overlay` on the element)
  or render per-row modals with unique ids.
- The table has no `<thead>`, so `custom-table.js` gives search + pagination only (no sort/filter).
  Add a `thead` with `data-column` if you want status filtering.

## API keys

**What it is.** `data-table` card: search, "+" opening `#addApiKeyModal`, bulk Delete, Status + Region
filters, rows selector; columns Name, Created By (avatar), API Key (readonly `form-input-sm` inside an
`.input-group` with a ClipboardJS copy button), Status badge, Usage `245 / 1000`, Created, Expires,
Region (flag), Actions; pagination. The modal has Client Name, Created By, API Key input with a
"Generate" button (random 27-char key), Status, Usage Limit, Region, Created On / Expires On (flatpickr).
**Use it when.**
- Developer settings: API tokens, webhook secrets, OAuth clients, license keys — any "secret with copy
  button + expiry" list.
- Copy-to-clipboard for any readonly value (order ids, share links).
**Source.** `references/sources/pages/apps-api-keys.html`, `custom-table.js`,
`assets/plugins/clipboard/clipboard.min.js`, `assets/plugins/apexcharts/apexcharts.min.js`,
`assets/js/pages/apps-api-keys.js`.
**Markup.**

```html
<td><div class="input-group">
  <input type="text" class="form-input form-input-sm" id="keyOne" readonly value="e4A7Fc98z120XYz776abc90MNZ" />
  <button class="btn btn-sm btn-icon border-default-300" type="button" data-clipboard-target="#keyOne"><i class="iconify tabler--copy text-lg"></i></button>
</div></td>
<td><span class="badge badge-label font-semibold bg-warning/15 text-warning">Pending</span></td>   <!-- bg-success/15 Active · bg-danger/15 Revoked -->
<td>245 / 1000</td><td>Jan 10, 2025</td><td>Nov 15, 2025</td>
<td><div class="inline-flex items-center gap-1.25 font-bold"><img src="assets/images/flags/de.svg" class="size-3.5 rounded-full" alt="" /> DE</div></td>

<!-- modal: note the top-right placement (items-start justify-end, no centring) -->
<div id="addApiKeyModal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" role="dialog" tabindex="-1">
  <div class="hs-overlay-animation-target flex items-start justify-end m-3 max-w-sm md:w-full md:max-w-2xl lg:max-w-3xl">
    <div class="card pointer-events-auto flex w-full flex-col">
      <div class="border-default-300 flex items-center justify-between border-b p-6"><h3 class="card-title">Add New API Key</h3><button type="button" data-hs-overlay="#addApiKeyModal"><i class="iconify tabler--x text-xl"></i></button></div>
      <div class="card-body overflow-y-auto"><div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div><label class="form-label">Client Name</label><input type="text" class="form-input" placeholder="Enter client name" /></div>
        <div><label class="form-label">Created By</label><select class="form-select"><option selected disabled>Select user</option><option>Mark Reynolds</option></select></div>
        <div><label class="form-label">API Key</label><div class="relative"><input type="text" id="apiKeyInput" class="form-input" placeholder="Enter or generate API key" />
          <button type="button" class="btn bg-secondary absolute end-0 top-0 rounded-s-none text-white" id="generateApiKey">Generate</button></div></div>
        <div><label class="form-label">Status</label><select class="form-select"><option value="Active">Active</option><option value="Pending">Pending</option><option value="Revoked">Revoked</option></select></div>
        <div><label class="form-label">Usage Limit</label><input type="text" class="form-input" placeholder="e.g. 1000" /></div>
        <div><label class="form-label">Region</label><select class="form-select"><option value="DE">🇩🇪 Germany</option><option value="US">🇺🇸 USA</option></select></div>
        <div><label class="form-label">Created On</label><input type="text" data-provider="flatpickr" data-date-format="d M, Y" class="form-input" readonly /></div>
        <div><label class="form-label">Expires On</label><input type="text" data-provider="flatpickr" data-date-format="d M, Y" class="form-input" readonly /></div>
      </div></div>
      <div class="p-4 flex items-center justify-end gap-x-2 border-t border-default-300">
        <button type="button" class="btn bg-light hover:text-primary" data-hs-overlay="#addApiKeyModal">Cancel</button>
        <button type="button" class="btn bg-primary text-white hover:bg-primary-hover">Add API Key</button>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** (`apps-api-keys.js`, trimmed)

```js
new ClipboardJS(document.querySelectorAll("[data-clipboard-target]"));   // copies the target input's value
function generateApiKey(len = 27) { const c = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"; let k = "";
  for (let i = 0; i < len; i++) k += c.charAt(Math.floor(Math.random() * c.length)); return k; }
document.getElementById("generateApiKey").addEventListener("click", (e) => { e.preventDefault(); document.getElementById("apiKeyInput").value = generateApiKey(); });
// The script also renders four ApexCharts sparklines into #chart-api-calls / #chart-successful-conversions /
// #chart-failed-requests / #chart-active-endpoints (type:"area", height:60, sparkline:{enabled:true}, colors from theme("chart-*"))
// — those elements are NOT in the demo page, so it only console.warns. Add stat tiles with those ids to get them.
```
**Gotchas.**
- `Math.random()` keys are demo-only; generate secrets server-side.
- ClipboardJS gives no feedback; listen for `clipboard.on("success")` and flip the icon/tooltip.
- The modal is anchored top-right (no `items-center`, `justify-end`) — copy the team-board modal
  wrapper if you want it centred.

## Manage apps (integrations)

**What it is.** Intro text ("You're using 3 of 3 free integrations…") and a 3-column grid of
integration cards: logo, name, description, a `form-switch` connect toggle, badges (plan / Connected /
sync interval), Connected Account + Last Sync, a quota progress bar, and Remove / Details buttons
(Details has a tooltip).
**Use it when.**
- Integrations / connected accounts / add-on marketplace / plugin manager / OAuth app list.
- Any card that pairs an on-off switch with usage and a danger action.
**Source.** `references/sources/pages/apps-manage.html` (no JS; the switch is a plain checkbox).
**Markup.**

```html
<div class="container">
  <div class="mb-4"><h5 class="mb-1.25 text-base">Authorized Apps</h5>
    <p class="text-default-400">You're currently using <strong>3 of 3</strong> free integrations. Upgrade to <a href="#" class="text-primary underline">PRO</a> to unlock more.</p></div>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-base mb-base">
    <div class="card"><div class="card-body"><!-- repeat per integration -->
      <div class="mb-5 flex items-start justify-between">
        <div class="flex items-center gap-base"><img src="assets/images/logos/google.svg" class="size-12 rounded" alt="" />
          <div><h5 class="card-title mb-1.25">Google Analytics</h5><p class="text-default-400 text-sm mb-0.5">Google Analytics is a free web analytics service…</p></div></div>
        <div><input type="checkbox" class="form-switch" checked /></div>
      </div>
      <div class="mb-5 flex flex-wrap items-center gap-2.5">
        <span class="badge font-semibold bg-light text-primary rounded-full px-2.5 py-1.25">Free Plan</span>
        <span class="badge font-semibold bg-success/15 text-success rounded-full px-2.5 py-1.25">Connected</span>
        <span class="badge font-semibold bg-info/15 text-info rounded-full px-2.5 py-1.25">Sync: Every 15 mins</span></div>
      <div class="mb-5 grid grid-cols-2 gap-base">
        <div><p class="text-2xs text-default-400 font-bold uppercase">Connected Account</p><span>analytics@domain.com</span></div>
        <div><p class="text-2xs text-default-400 font-bold uppercase">Last Sync</p><span>12:56 pm, 12 May</span></div></div>
      <div class="mb-5">
        <div class="flex justify-between mb-2.5"><span class="text-xs font-bold">Usage</span><small class="text-success font-bold">80% of quota</small></div>
        <div class="bg-default-200 flex h-1.5 w-full overflow-hidden rounded-full" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
          <div class="bg-success flex flex-col justify-center overflow-hidden rounded-full text-center text-xs whitespace-nowrap text-white transition duration-500" style="width: 80%"></div></div></div>
      <div class="grid grid-cols-2 gap-3">
        <button class="btn border-danger text-danger hover:bg-danger w-full hover:text-white">Remove</button>
        <div class="hs-tooltip inline-block [--placement:top]"><button type="button" class="hs-tooltip-toggle btn border-primary text-primary hover:bg-primary w-full hover:text-white"> Details
          <span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible bg-default-900 text-default-50 invisible absolute z-10 inline-block rounded-md px-2 py-1 text-sm font-medium opacity-0 shadow-2xs transition-opacity" role="tooltip">View integration details</span></button></div>
      </div>
    </div></div>
  </div>
</div>
```

**Gotchas.**
- The switch has no label/`id`; add `aria-label="Enable Google Analytics"` and a `change` handler
  that toggles the Connected badge.
- Logos come from `assets/images/logos/*.svg` (google, asana, slack, github, …) — all single-colour
  SVGs that look fine on dark `bg-card`.

## Pin board (sticky notes)

**What it is.** A transparent card holding a centred `flex flex-wrap gap-5` of square notes
(`size-52.5 p-3.5`, soft colour backgrounds `bg-<colour>/10`, hard shadow, `hover:scale-110`): a
timestamp line, title, text, and a trash link using Preline `data-hs-remove-element` to delete the note
(`hs-removing:hidden`). The last tile is a "+" button opening `#addNoteModal` (title, content, colour
select).
**Use it when.**
- Personal notes, quick reminders, brainstorming/retro boards, pinned announcements on a dashboard.
- For draggable/reorderable notes combine with SortableJS from the Kanban section.
**Source.** `references/sources/pages/apps-pin-board.html` (Preline `hs-remove-element`, no page script).
**Markup.**

```html
<div class="container-fluid"><div class="card bg-transparent! shadow-none"><div class="card-body"><div class="p-7.5">
  <div class="flex flex-wrap justify-center gap-5">
    <div class="hs-removing:hidden bg-primary/10 relative size-52.5 p-3.5 shadow-[4px_3px_7px_rgba(49,58,70,0.1)] transition-transform duration-300 hover:scale-110" id="pin-1"><!-- repeat per note -->
      <p class="mb-4 text-end text-2xs">14:22:07 08-04-2025</p>
      <h4 class="text-md mb-2">Client feedback summary</h4>
      <p class="mb-4">Positive response on UI, requested dark mode toggle and faster load times.</p>
      <a href="#" class="absolute end-3 bottom-3" data-hs-remove-element="#pin-1"><i class="iconify tabler--trash text-base"></i></a>
    </div>
    <!-- colours used: bg-primary/10 bg-danger/10 bg-warning/10 bg-info/10 bg-dark/10 bg-light/10 bg-secondary/10 bg-success/10 -->
    <div class="flex size-52.5 items-center justify-center p-3.5 transition-transform duration-300">
      <a href="#" class="btn btn-icon bg-primary btn-sm relative size-9.25 text-white transition-transform duration-300 hover:scale-110" data-hs-overlay="#addNoteModal"><i class="iconify tabler--plus text-base"></i></a>
    </div>
  </div>
</div></div></div></div>

<div id="addNoteModal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" role="dialog" tabindex="-1">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 m-3 flex min-h-[calc(100%-56px)] scale-95 items-center opacity-0 transition-all duration-200 ease-in-out md:mx-auto md:w-full md:max-w-lg">
    <div class="card pointer-events-auto flex w-full flex-col">
      <div class="card-header"><h3 class="text-sm font-bold">Add New Note</h3><button type="button" data-hs-overlay="#addNoteModal"><i class="iconify tabler--x text-xl"></i></button></div>
      <div class="card-body overflow-y-auto">
        <div class="mb-5"><label class="form-label">Title</label><input type="text" class="form-input" placeholder="Enter note title" /></div>
        <div class="mb-5"><label class="form-label">Note Content</label><textarea rows="3" class="form-textarea" placeholder="Write your note..."></textarea></div>
        <div class="mb-5"><label class="form-label">Color Theme</label><select class="form-select"><option value="bg-success/10" selected>Green (Success)</option><option value="bg-primary/10">Blue (Primary)</option><option value="bg-warning/10">Yellow (Warning)</option><option value="bg-danger/10">Red (Danger)</option></select></div>
      </div>
      <div class="border-default-300 flex items-center justify-end gap-x-2 border-t p-5">
        <button type="button" class="btn bg-secondary text-white hover:bg-secondary-hover" data-hs-overlay="#addNoteModal">Cancel</button>
        <button type="button" class="btn bg-primary text-white hover:bg-primary-hover">Save Note</button>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- `data-hs-remove-element` needs a unique `id` per note and `hs-removing:hidden` on the note (Preline
  adds `hs-removing` then removes the node). Nothing is persisted — hook `HSRemoveElement` or the
  click to your API.
- The demo modal's colour values are Bootstrap names (`bg-success-subtle`) that don't exist in this
  build; use the `bg-<colour>/10` tokens shown above and inject the new note with
  `window.HSStaticMethods.autoInit()` afterwards so its remove-link works.
- Notes are fixed-size squares (`size-52.5`); long text overflows — add `overflow-hidden` or
  `line-clamp-*`.

## Original sources

- `references/sources/MANIFEST-page-deps.txt`
- `references/sources/pages/apps-file-manager.html`
- `references/sources/pages/apps-email-inbox.html`
- `references/sources/pages/apps-email-details.html`
- `references/sources/pages/apps-email-compose.html`
- `references/sources/pages/apps-chat.html`
- `references/sources/pages/apps-calendar.html`
- `references/sources/pages/apps-social-feed.html`
- `references/sources/pages/apps-projects-grid.html`
- `references/sources/pages/apps-projects-list.html`
- `references/sources/pages/apps-projects-details.html`
- `references/sources/pages/apps-projects-kanban.html`
- `references/sources/pages/apps-projects-team-board.html`
- `references/sources/pages/apps-projects-activity.html`
- `references/sources/pages/apps-users-contacts.html`
- `references/sources/pages/apps-users-roles.html`
- `references/sources/pages/apps-users-role-details.html`
- `references/sources/pages/apps-users-permissions.html`
- `references/sources/pages/apps-invoice-list.html`
- `references/sources/pages/apps-invoice-details.html`
- `references/sources/pages/apps-invoice-create.html`
- `references/sources/pages/apps-blog-list.html`
- `references/sources/pages/apps-blog-grid.html`
- `references/sources/pages/apps-blog-article.html`
- `references/sources/pages/apps-blog-add.html`
- `references/sources/pages/apps-forum-view.html`
- `references/sources/pages/apps-forum-post.html`
- `references/sources/pages/apps-clients.html`
- `references/sources/pages/apps-companies.html`
- `references/sources/pages/apps-outlook.html`
- `references/sources/pages/apps-vote-list.html`
- `references/sources/pages/apps-issue-tracker.html`
- `references/sources/pages/apps-api-keys.html`
- `references/sources/pages/apps-manage.html`
- `references/sources/pages/apps-pin-board.html`
- `references/sources/assets/js/pages/custom-table.js`
- `references/sources/assets/js/pages/apps-email.js`
- `references/sources/assets/js/pages/apps-email-compose.js`
- `references/sources/assets/js/pages/apps-chat.js`
- `references/sources/assets/js/pages/apps-calendar.js`
- `references/sources/assets/js/pages/apps-kanban.js`
- `references/sources/assets/js/pages/apps-blog-grid.js`
- `references/sources/assets/js/pages/form-quilljs.js`
- `references/sources/assets/js/pages/apps-create-invoice.js`
- `references/sources/assets/js/pages/apps-api-keys.js`
- `references/sources/assets/js/app.js` (flatpickr `data-provider` handling, `data-current-year`)
- `references/sources/assets/css/app.min.css` (class existence checks: `.table-custom .thead-sm .mark-as-read .badge-label .input-icon-group .form-checkbox-light .form-input-sm .email-editor .table-wrapper .page-item .page-link .form-switch .ql-* .fc-* .sortable-item-ghost`)
