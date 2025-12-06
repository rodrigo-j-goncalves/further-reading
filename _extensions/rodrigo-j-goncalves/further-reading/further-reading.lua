-- =============================================================================
-- FILTER: Further Reading
-- GOAL:   Collect external (and only external) links found in the presentation, and list them
--                automatically on a final slide.
--                Custom slide title, subtitle and scroll message are allowed.
--
-- This filter is heavily inspired in an extension created by James Balamuta called 'linkate'
-- (https://github.com/coatless-quarto/linkate)
--
-- I needed a bit more customization because I teach in Spanish and English, and wanted
-- to use my own custom titles and subtitles.
-- The other feature I wanted is that the extension only lists the EXTERNAL links, and ignore
-- the internal links (e.g. go up, go back, go to a given slide within this presentation, etc.)
--
-- Rodrigo J. Gonçalves, 2025
-- =============================================================================

-- We create two tables (lists) to manage our data.
-- 'collected_links' stores the actual link objects to display later.
-- 'seen_links' acts as a checklist to ensure we don't list the same URL twice.
local collected_links = {}
local seen_links = {}

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Helper: Check if a text (str) starts with a specific sequence (prefix).
-- We use this to detect 'http' or 'https' links.
local function starts_with(str, prefix)
  return string.sub(str, 1, string.len(prefix)) == prefix
end

-- Helper: Process a single link found in the document.
-- If it is external and new, we add it to our collection.
local function add_link(link_elem)
  -- 1. Get the URL (target) safely. If nil, use empty string.
  local target = link_elem.target or ""

  -- 2. Determine if the link is external.
  -- We only want links starting with http, https, or ftp.
  -- We ignore relative links (like "images/graph.png") or internal slides ("#slide-1").
  local is_external = (starts_with(target, "http://") or
                       starts_with(target, "https://") or
                       starts_with(target, "ftp://"))

  if not is_external then
    return -- Stop here if it's not an external link.
  end

  -- 3. Create a unique "key" for this link to check for duplicates.
  -- We combine the text and the URL (e.g., "Google|https://google.com").
  local link_key = pandoc.utils.stringify(link_elem.content) .. "|" .. target

  -- 4. If we haven't seen this key before, add it to our list.
  if not seen_links[link_key] then
    seen_links[link_key] = true
    -- Store the link object.
    -- We recreate it nicely using pandoc.Link(content, target, title).
    table.insert(collected_links, pandoc.Link(link_elem.content, target, link_elem.title))
  end
end

-- =============================================================================
-- MAIN FILTER STEPS
-- =============================================================================

-- STEP 1: Scan the document.
-- This function runs on every "Link" element found in your content.
local function collect_links(el)
  add_link(el)
  return nil -- Returning nil tells Pandoc "Keep the link as is, don't delete it."
end

-- STEP 2: Create the final slide.
-- This function runs once, after the whole document has been processed.
local function add_links_section(doc)

  -- If we didn't find any links, we stop here. No extra slide needed.
  if #collected_links == 0 then
    return doc
  end

  -- A. CONFIGURATION ----------------------------------------------------------
  -- We look for settings in the YAML header under the key 'further-reading'.
  -- Note: In Lua, keys with hyphens must be accessed like ['key-name'].
  local config = doc.meta['further-reading'] or {}

  -- 1. TITLE SETUP
  -- Use YAML value if present, otherwise use the default string.
  local title_text = "Further reading"
  if config.title then
    title_text = pandoc.utils.stringify(config.title)
  end

  -- 2. SUBTITLE SETUP
  -- Use YAML value if present, otherwise use the default string.
  local subtitle_text = "All the links to other sources are listed below"
  local subtitle_block = nil

  if config.subtitle then
    -- If user provided a subtitle in YAML, we try to preserve formatting (bold/italic)
    if type(config.subtitle) == "table" and config.subtitle.t == "MetaInlines" then
       subtitle_block = pandoc.Para(config.subtitle)
    else
       -- If it's just a simple string
       subtitle_block = pandoc.Para(pandoc.utils.stringify(config.subtitle))
    end
  else
    -- If no YAML subtitle, use our default text
    subtitle_block = pandoc.Para(subtitle_text)
  end

  -- 3. SCROLL HINT SETUP
  -- Use YAML value if present, otherwise use the default string.
  local scroll_text = "Scroll down to see all links"
  if config.scroll_text then
    scroll_text = pandoc.utils.stringify(config.scroll_text)
  end

  -- B. FORMATTING LOGIC -------------------------------------------------------

  -- Detect if we are generating a RevealJS presentation.
  local is_revealjs = quarto and quarto.doc.is_format and quarto.doc.is_format("revealjs")

  -- If we have more than 6 links in RevealJS, the slide might overflow.
  -- We add logic to make the slide scrollable.
  local needs_scroll = is_revealjs and #collected_links > 6

  -- In RevealJS, level 2 header (##) creates a new slide.
  -- In standard HTML, we might prefer level 1 (#).
  local header_level = is_revealjs and 2 or 1

  -- If scrolling is needed, we add the "scrollable" class to the header.
  -- Quarto uses this class to enable overflow scrolling on that specific slide.
  local header_classes = needs_scroll and {"scrollable"} or {}
  local header_attr = pandoc.Attr("", header_classes, {})

  -- C. BUILD THE CONTENT ------------------------------------------------------

  -- Create a bullet list from our collected links.
  local links_list = {}
  for _, link in ipairs(collected_links) do
    table.insert(links_list, pandoc.Plain({link}))
  end

  -- Get the current list of blocks (paragraphs, headers, etc.) in the document.
  local blocks = doc.blocks

  -- Append our new Header (Title)
  table.insert(blocks, pandoc.Header(header_level, title_text, header_attr))

  -- Append our Subtitle
  if subtitle_block then
    table.insert(blocks, subtitle_block)
  end

  -- Append the Scroll Hint (only if needed)
  if needs_scroll then
    -- We wrap the text in Emph() to make it Italic.
    table.insert(blocks, pandoc.Para({pandoc.Emph({pandoc.Str(scroll_text)})}))
  end

  -- Append the actual list of links
  table.insert(blocks, pandoc.BulletList(links_list))

  -- Return the modified document to Quarto/Pandoc
  return pandoc.Pandoc(blocks, doc.meta)
end

-- =============================================================================
-- EXPORT
-- =============================================================================
-- Tell Pandoc which functions to run.
-- 1. Run 'collect_links' on every Link element.
-- 2. Run 'add_links_section' on the whole Document (Pandoc) at the end.
return {
  { Link = collect_links },
  { Pandoc = add_links_section }
}
