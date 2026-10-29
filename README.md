# UT Austin Swarm Lab website

Source of the [Swarm Lab website](https://utaustin-swarmlab.github.io/). Everything on the site is plain files in this repo: edit a file, open a pull request, and the site rebuilds itself.

## I want to... (quick start)

| I want to... | Edit this file | Details |
|---|---|---|
| Add a paper | `_bibliography/references.bib` | [Add a publication](#add-a-publication) |
| Announce a paper on the home page and News | the same bib entry: add `news = {YYYY-MM-DD}` | [Post news](#post-news) |
| Announce an award, talk, defense or anything else | `_data/news.yml` | [Post news](#post-news) |
| Add myself to the People page | new file `_people/<first>_<last>.md` + a photo in `images/people/` | [Add or update a person](#add-or-update-a-person) |
| Move someone to Alumni | their `_people/*.md`: `position: alumni`, `end_year`, `placement` | [Add or update a person](#add-or-update-a-person) |
| Write a blog post about a paper | new file `_posts/YYYY-MM-DD-title.md` | [Write a blog post](#write-a-blog-post) |
| Change a research theme's text | `_data/themes.yml` (and the theme list in the `lede:` of `research.md`) | [Research themes](#research-themes) |
| Add conference or trip photos | upload to `images/lab_pictures/<album>/` (optional captions: `_lab_pictures/<album>.md`) | [Lab life photos](#lab-life-photos) |
| Fix a typo on About / Join | `about.md` / `join.md` | |
| Swap the home figure, logo or tab icon | `images/key-visual/`, `images/logo/swarm-lab-mark.svg`, `favicon.svg` | [Brand assets](#brand-assets) |
| Preview my change | `bundle exec jekyll serve` | [Run locally](#run-locally) |

Not sure? Open a pull request anyway and ask in the Swarm Lab Slack.

## Contents

1. [Overview](#overview)
2. [Run locally](#run-locally)
3. [Add a publication](#add-a-publication)
4. [Post news](#post-news)
5. [Add or update a person](#add-or-update-a-person)
6. [Research themes](#research-themes)
7. [Write a blog post](#write-a-blog-post)
8. [Lab life photos](#lab-life-photos)
9. [Brand assets](#brand-assets)
10. [Design system](#design-system)
11. [Publish your change](#publish-your-change)

## Overview

- **Stack:** [Jekyll](https://jekyllrb.com/) 4.4 with [jekyll-scholar](https://github.com/inukshuk/jekyll-scholar) for the bibliography, Sass for styles, a little vanilla JavaScript. No Node, no Bootstrap, no jQuery.
- **Deploy:** every push to the `source` branch runs `.github/workflows/jekyll.yml`, which makes any missing WebP photo copies, builds the site (Ruby 3.2.3, on `ubuntu-24.04`) and publishes it to GitHub Pages. There is nothing to run by hand.
- **Single source of truth:** the bibliography feeds the Publications page, the Research page, the Home "Selected publications" list and (optionally) the news. You add a paper once.

| Path | What it is |
|---|---|
| `_bibliography/references.bib` | All papers (BibTeX + a few extra site fields) |
| `_data/news.yml` | Manual news items (awards, talks, defenses, ...) |
| `_data/themes.yml` | The five research themes (names, text, representative papers) |
| `_people/*.md` | One file per person (collection `people`) |
| `images/people/` | Original photos; `images/people/web/` holds the generated WebP copies the site shows |
| `_posts/` | Blog posts; their images are in `images/post/` |
| `images/lab_pictures/<album>/` | Lab life photos; each folder is an album (optional captions in `_lab_pictures/<album>.md`) |
| `index.html`, `research.md`, `publications.md`, `news.md`, `people.md`, `about.md`, `join.md`, `blog.md` | Page templates |
| `_plugins/bib_news.rb` | Merges bib news and `news.yml` into one list |
| `_plugins/lab_pictures.rb` | Turns the photo folders into albums and feeds the Home photo strip |
| `images/key-visual/`, `images/logo/`, `favicon.svg` | Home figure, header mark, tab icon, partner logos ([Brand assets](#brand-assets)) |
| `_sass/` | Styles; `_tokens.scss` holds colors, fonts, spacing |
| `scripts/optimize_images.py` | Makes web-sized WebP copies of photos (the deploy runs it too) |
| `people_template.md` | Template to copy for a new person (not published) |

## Run locally

You need Ruby 3.1.3 or newer (CI uses 3.2.3). The system Ruby on older Ubuntu (3.0) is too old.

```bash
git clone https://github.com/UTAustin-SwarmLab/UTAustin-SwarmLab.github.io.git
cd UTAustin-SwarmLab.github.io
git checkout source
bundle install
bundle exec jekyll serve        # open http://127.0.0.1:4000
```

`jekyll serve` rebuilds when you save a file (restart it after editing `_config.yml`). For a one-off build into `_site/`: `bundle exec jekyll build`.

**No suitable Ruby? Use conda:**

```bash
conda create -n swarmlab-site -c conda-forge ruby=3.2 compilers make
conda activate swarmlab-site
ruby -S bundle install          # inside conda, call bundler as `ruby -S bundle`
ruby -S bundle exec jekyll serve
```

**Photo script only:** `scripts/optimize_images.py` needs Python 3 with Pillow (`python3 -m pip install pillow`). It is not needed to run the site, and the deploy runs it for you; run it locally only to see new photos in a local preview.

## Add a publication

Open `_bibliography/references.bib` and paste your entry **after the first 4 lines** (the `---` header block), so newest papers stay near the top. Google Scholar's "BibTeX" button gives you a good start. Then fix it up:

- Use `@inproceedings` for conference papers, `@article` for journals, `@misc` for preprints, `@phdthesis` for theses.
- The **key** (the text after `{`) must be unique in the file. Convention: `lastname` + `year` + first word of the title, lowercase, e.g. `baser2026tensorcommitments`.
- Wrap acronyms and capitals you want to keep in extra braces: `title={{TensorCommitments}: A Lightweight ...}`. Escape `&` as `\&`.
- Authors are `Last, First and Last, First`. Lab members are bolded automatically (matched to `_people/*.md` by first initial + last name).
- `year` is required: it decides the year heading and whether the paper is on the Research page.

### Copy-paste example

```bibtex
@inproceedings{lastname2026keyword,
  title={{ShortName}: A Descriptive Title},
  author={Last, First and Chinchali, Sandeep P.},
  booktitle={Proceedings of the 40th Conference on Neural Information Processing Systems (NeurIPS 2026)},
  year={2026},
  url={https://arxiv.org/abs/XXXX.XXXXX},
  arxiv={https://arxiv.org/abs/XXXX.XXXXX},
  pdf={https://arxiv.org/pdf/XXXX.XXXXX},
  code={https://github.com/UTAustin-SwarmLab/your-repo},
  project={https://your-project-page.example},
  venue_short={NeurIPS 2026},
  themes={trust, edge},
  selected={true},
  award={Best Paper Nominee},
  news={2026-10-04}
}
```

### Optional site fields

All of these are optional and are hidden from the BibTeX that readers can copy. Leave out whatever you do not have.

| Field | Meaning |
|---|---|
| `themes` | Comma-separated theme slugs, **primary theme first** (table below). The Research page lists the paper under its primary theme only; the Publications filter uses all of them. Always set it, or the paper will not show on the Research page. |
| `venue_short` | Short venue badge, e.g. `NeurIPS 2026`. Without it the badge falls back to `journal`, `booktitle`, `school` or `publisher`. |
| `selected` | `{true}` puts the paper in Home "Selected publications". Use sparingly. |
| `award` | Orange award badge, e.g. `{Best Paper Nominee}`. |
| `arxiv` | arXiv abstract link. If missing but `url` points to arxiv.org, `url` is used. The PDF link is derived from it (`/abs/` becomes `/pdf/`). |
| `pdf` | Direct PDF link (overrides the derived one). |
| `url` | Landing page (OpenReview, publisher, proceedings). Shown as "OpenReview" or "Page" and used for the title link. |
| `code` | Code repository, shown as "Code". |
| `project` | Project page, shown as "Project". `website` does the same; if both exist `project` wins. For a lab blog post use a root-relative link, e.g. `website={/2026/10/04/TensorCommitments.html}`. |
| `video` | Video link, shown as "Video". |
| `news` | `YYYY-MM-DD`. Creates a news item (see [Post news](#post-news)). |
| `news_text` | HTML sentence that replaces the auto-generated news sentence. |

The title links to the first available of: `url` (if not arXiv), `arxiv`, `pdf`, `project`.

### Theme slugs

| Slug | Display name |
|---|---|
| `swarm` | Swarm Coordination & Fleet Learning |
| `edge` | Edge–Cloud Systems for Embodied AI |
| `neurosymbolic` | Neuro-Symbolic Video Understanding |
| `trust` | Trustworthy & Verifiable ML |
| `timeseries` | Time-Series Generation & Forecasting |
| `other` | Earlier & other work (does not fit the five themes) |

Example: `themes={swarm, neurosymbolic}` means the paper sits under Swarm Coordination on the Research page and also matches the Neuro-Symbolic filter on Publications.

## Post news

Home shows the 6 newest items; [/news/](https://utaustin-swarmlab.github.io/news/) shows all, grouped by year with type filters. Items from the last 30 days get a small "new" dot automatically.

### (a) Paper news: automatic from the bib

Add `news = {YYYY-MM-DD}` to the paper's bib entry. That is all. The generated text is:

> New paper **\<title\>** accepted to **\<venue_short\>**!

The title links to the first available of `website`, `project`, `url`, `pdf`. To write your own sentence (HTML is allowed), add `news_text`:

```bibtex
  news={2026-10-04},
  news_text={Oguzhan B.'s paper <a href="https://arxiv.org/abs/2602.12630">TensorCommitments</a> was accepted to NeurIPS 2026! <a href="/2026/10/04/TensorCommitments.html">Read the blog post</a>.}
```

An entry without `news` produces no news item. A date that is not `YYYY-MM-DD` is skipped with a `bib_news:` warning in the build log.

### (b) Anything else: `_data/news.yml`

Awards, talks, defenses, press. Add an item at the top (order in the file does not matter; items are sorted by date):

```yaml
- date: 2026-07-20
  type: award
  details: >-
    Jane Doe received the <a href="https://example.com">Example Award</a>!
```

| Field | Meaning |
|---|---|
| `date` | `YYYY-MM-DD` (required). |
| `type` | `award`, `paper`, `people`, `defense`, `talk` or `media`. These have filter buttons on /news/; `award` is highlighted; anything else works but gets no filter button. Default is `news`. |
| `details` | The sentence, as HTML (links as `<a href="...">`). Use `>-` as above so colons and quotes are safe. |
| `featured` | `true` shows the item in the orange "New" pill in the Home hero. If several items are featured, the newest one is used. Use for big news only; remove it when it gets old. |
| `pill` | Short text for that pill (about 40 characters). Defaults to the first 64 characters of `details`. |
| `key` | A bib key. If the bib entry has a `news` date, this manual item is dropped and the bib one is shown, so a paper is never listed twice. |

## Add or update a person

1. Copy `people_template.md` to `_people/<first>_<last>.md` (lowercase, underscores; the file name becomes the profile URL `/people/<first>_<last>/`).
2. Put your photo in `images/people/` (portrait, about 4:5, at least 480 px wide; any size is fine, the script shrinks it) and set `avatar:` to its file name.
3. The site shows a small WebP copy, `images/people/web/<name>.webp`. The deploy makes it automatically, so committing the original is enough. To see the photo in a local preview (or to commit the copy yourself), run:

   ```bash
   python3 scripts/optimize_images.py images/people --max-width 480 --target-kb 80
   ```

   The script skips files that are already up to date; run `python3 scripts/optimize_images.py --help` for options.
4. Fill in the front matter (below). Delete the instruction comment at the top and the bold instruction lines of the template body; keep **Office** if it applies to you. Anything below the front matter is your profile page text (Markdown).
5. Open a pull request.

### Front matter fields

Every field except `name` and `position` is optional. A field you leave out (or leave empty) is simply hidden. **Do not guess**: only list what you know to be true.

```yaml
---
name: Jane Doe
title: Jane Doe              # browser tab title; keep identical to name
position: gradstudent
avatar: jane_doe.jpg
degree: phd
start_year: 2026
interests: Fleet learning, verification
website: https://example.com
scholar: https://scholar.google.com/citations?user=XXXX
github: https://github.com/jane
linkedin: https://www.linkedin.com/in/jane/
fellowships:
  - name: Example Fellowship
    year: 2026
internships:
  - company: Example Corp
    year: 2026
industry:
  - company: Example Industries
    role: Software Engineer
    years: 2020-2023
---
```

| Field | Values and effect |
|---|---|
| `position` | Which section of /people/: `pi`, `postdoc`, `gradstudent`, `undergrad`, `researchstaff`, `visiting`, `others` (honorary members), `alumni`. |
| `degree` | `phd`, `ms`, `undergrad`, `postdoc`, `visiting`. Gives the label ("PhD student") and the row: current students share one "Students" section, with PhD students in the first row, MS (other `gradstudent`s) in the second and undergrads in the third. |
| `avatar` | File name in `images/people/`. No avatar shows an initials tile. |
| `start_year`, `end_year` | Shown as "since 2023" for current members, "2021-2025" for alumni (one year if they match). |
| `interests` | One line, shown on the card. |
| `website`, `scholar`, `github`, `linkedin` | Full URLs; each becomes an icon on the card and a button on the profile. |
| `email` | Optional; shows an email icon. Leave it out if you do not want it on the card. |
| `role` | Title line, used for the PI only. |
| `fellowships` | List of `name` + optional `year`. Orange badges. |
| `internships` | List of `company` + optional `year`. Outline badges ("Example Corp intern 2026"). List internships done during the PhD. `year` can be a range string ("2024-26"). |
| `industry` | List of `company`, `role`, `years`. Grey badges showing the company name only; `role` and `years` are for maintainers. For full-time industry experience, not internships. |
| `placement`, `placement_url` | Alumni only: where they went next, with an optional link. |

### Moving someone to Alumni

In their file change `position: alumni`, add `end_year: 2026` and `placement: Company or University` (plus `placement_url`, optional). Alumni are grouped PhD, MS, Undergraduate (by `degree`), newest `end_year` first within each group. Only add a placement you have verified.

## Research themes

The Research page is driven by two things: `_data/themes.yml` (the five themes, in display order) and the `themes` field in each bib entry.

```yaml
- slug: trust                      # matches the bib `themes` field
  name: Trustworthy & Verifiable ML
  headline: Formal and cryptographic guarantees for deployed models.   # one line, also on Home
  blurb: >-                        # the paragraph under the title
    Deployed models face adversaries, ...
  representative: [baser2026tensorcommitments, cheng2022task, agarwal2022synthesizing]   # 3 bib keys shown as "Selected papers"; the rest are collapsed
```

- Papers from **2021 on** are listed under the **primary** (first) theme.
- Papers before 2021 go into the "Before Swarm Lab" block, grouped by theme; `themes={other}` goes into "Earlier & other work".
- `representative` takes bib keys that must exist in `references.bib`. Pick the most relevant papers from the strongest venues, from 2021 on, whose **primary** theme is this theme (otherwise the "Show N more" count is off).
- Slugs must match exactly. Adding a sixth theme is a design decision: also check `research.md`, where each theme has its own small illustration, and ask first.
- The intro sentence at the top of the Research page lists the theme names by hand (`lede:` in `research.md`). Update it when you rename, add or remove a theme.

## Write a blog post

Create `_posts/YYYY-MM-DD-title.md` (no spaces in the file name; use `-`). The date and file name set the URL: `_posts/2026-10-04-TensorCommitments.md` becomes `/2026/10/04/TensorCommitments.html`. You can create it directly on GitHub (`Add file > Create new file`) and preview there.

```markdown
---
title: "Your Paper Title"
description: NeurIPS 2026 paper
categories: blog
---

*By Your Name*

# A plain-language headline

Body in Markdown. Use **TL;DR** and a figure:

![Pipeline overview]({{site.baseurl}}/images/post/yourpaper/pipeline.png)

Inline math works: $a^2 + b^2 = c^2$, and display math with $$ ... $$.
```

- `categories: blog` is **required**; the Blog page only lists posts in that category.
- `description` appears next to the date and in the Blog list. Keep it short.
- Put images in `images/post/` (a subfolder per post is tidy: `images/post/yourpaper/`) and keep them reasonably small. Reference them with `{{site.baseurl}}/images/post/...`.
- Math (MathJax) is loaded on every post automatically. On a regular page add `math: true` to its front matter.
- Link the post from the paper: `website={/2026/10/04/TensorCommitments.html}` in the bib entry.

Look at a recent post in `_posts/` for a full example.

## Lab life photos

Albums are listed at `/lab_pictures/` (linked from the footer and the People page). **Each folder in `images/lab_pictures/` is an album, and every photo in it is shown automatically** (`_plugins/lab_pictures.rb`).

1. **Add photos:** upload them to `images/lab_pictures/<album>/` (for example `images/lab_pictures/corl2022/`), on GitHub or locally, and push. That's all. They appear at the end of that album, and the album's photo count updates.
   - A **new folder** becomes a new album at `/lab_pictures/<folder>/`, titled from the folder name (`neurips_2025` → "Neurips 2025").
   - Files ending in `-tn` (thumbnails) are skipped.
   - The deploy workflow creates the small WebP copies (`images/lab_pictures/web/...`). Until a copy exists, the page shows the original. To make them locally as well: `python3 scripts/optimize_images.py images/lab_pictures --max-width 1600 --target-kb 120`.
2. **Optional: captions, a proper title, location and cover.** Create `_lab_pictures/<album>.md` (copy `_lab_pictures/corl_22.md`):
   - The front matter is `title`, `name`, `location`, `folder` (the image folder) and `avatar` (the cover, relative to `images/lab_pictures/`).
   - The body lists captioned figures; each shows the `web/...webp` file and links to the original. Give every `<img>` its real `width` and `height` and a short `alt`.
   - Photos in the folder that the body does not list are still shown after them, without captions.
3. **Home photo strip:** every album photo appears there automatically, captioned "<album>, <city>". To give a photo its own caption (or a fixed place in the strip), add a line to the `ticker:` list in the front matter of `index.html` (`src` is relative to `images/lab_pictures/`, e.g. `web/corl2022/DSC03166.webp`, plus `w`, `h`, `alt`, `cap`). Sponsor logos are the `sponsors:` list in the same place (files in `images/logo/`).

## Brand assets

| What | File | Notes |
|---|---|---|
| Home figure (hero) | `images/key-visual/swarm-lab-key-visual-animated.svg` | Animated SVG (CSS only). Visitors with reduced motion get the still copy `swarm-lab-key-visual.svg`; keep the two in sync. Its text is the page's `<h1>` (alt "Swarm Lab"). |
| Header mark | `images/logo/swarm-lab-mark.svg` | Shown next to "Swarm Lab" in the header. |
| Browser tab icon | `favicon.svg`, `favicon-32.png`, `apple-touch-icon.png` | Linked in `_includes/head.html`. Regenerate the PNGs if you change the SVG. |
| Link-preview image | `images/logo/og.png` | 1200×630, used for social and chat previews. |
| Partner logos | `images/logo/*.png` | Listed in the `sponsors:` front matter of `index.html`. |

## Design system

- All colors, fonts, spacing and radii are CSS custom properties in `_sass/_tokens.scss`. Use the tokens; do not hard-code colors. Do color math in CSS (`color-mix`), not with Sass `darken()`.
- `style.scss` pulls in one partial per area: `_base`, `_layout`, `_header`, `_footer`, `_prose`, `_home`, `_publications`, `_people`, `_research`, `_news`, `_pages`. Put page-specific styles in that page's partial.
- Brand: UT burnt orange `--accent` (#BF5700) as a restrained accent. For **small text and links use `--accent-text`** (#A84C00), because #BF5700 does not have enough contrast on white at small sizes.
- No Bootstrap, no jQuery, no CDN script frameworks (MathJax on posts is the one exception). Pages must work without JavaScript, and animation must respect `prefers-reduced-motion`.
- Fonts (Inter, Instrument Serif, JetBrains Mono) are self-hosted in `fonts/`.
- Icons are an SVG sprite in `_includes/icons.svg`; use `<svg class="icon"><use href="#i-name"/></svg>`.

## Publish your change

1. Fork or branch from `source`, make your change, and check it with `bundle exec jekyll serve`.
2. Commit and open a **pull request to the `source` branch**. Ask someone in the lab to review.
3. When it is merged, GitHub Actions builds and deploys to <https://utaustin-swarmlab.github.io>; allow a few minutes. Watch progress under the repo's **Actions** tab.

Never push straight to a branch other than `source`; there is no separate `master` build step and `rake publish` is no longer needed.

Changing `.github/workflows/` needs a GitHub token with the `workflow` scope. If a push is rejected with "refusing to allow an OAuth App to create or update workflow", run `gh auth refresh -h github.com -s workflow` and push again.

**Something broke?** Open the failed run in the Actions tab and read the "Build with Jekyll" log. Typical causes: a duplicate BibTeX key, an unbalanced `{` in a bib entry, bad YAML in `news.yml` or a front matter block (check indentation and quotes), or a post without a `YYYY-MM-DD-` prefix.

**Help:** message Oguzhan Baser in the Swarm Lab Slack or email oguzhanbaser@utexas.edu.
