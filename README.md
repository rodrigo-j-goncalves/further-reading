# further-reading ![](docs/further-reading-logo.svg)
A customizable quarto extension that collects all external links from a presentation and lists them on the last slide (which is added automatically).

## Features

- This extension is done for and tested in quarto@revealjs documents (it may work in other cases, I don't know).
- During a presentation/lecture, you normally use links to other resources in case the user/student wants material for _further reading_. The purpose of this extension is to provide, in a single slide, a list of all those links. This means that by design, **only external links are listed** (specifically http, https, ftp; let me know if you need another ones).
  -  Internal links are ignored, such as:
    -  a link to a given slide within the current presentation (eg `[Go to slide nr 4](#slide-id-4)`)
    -  a link to go to the begining (`[Go to the start](#)`)
    -  a link/button to go back (`[Go back](javascript:history.back())`)
- If a link appears multiple times during the presentation (in the same or separate slides), it will be listed only once.
- The collected external links are listed in a single slide, let's call it the 'Further reading slide', which is automatically added at the end of the presentation every time you render your Qaurto document.
- If the links are potentially too many for a single slide, the slide automatically turns into a scrollable one, so the list can be accessed in all cases.
- The 'Further reading' slide can be customized (see below). 
-  The 'Further reading' slide has the following structure:
    - Title of the slide (default: 'Further reading'). This is applied as a `## header`
    - Subtitle of the slide (default: 'All the links to other sources are listed below'). This is added as 'normal slide text'.
    - Scrolling message (default: 'Scroll down to see all links'). This is added as 'normal slide text' but in italics. If the links are visible in a single slide, there is no scrolling, and this text is not shown.

## Who created this
This filter is heavily based on James Balamuta's [linkate](https://github.com/coatless-quarto/linkate).
I needed a bit more customization because I teach in Spanish and English, and wanted to use different languages, custom titles, and subtitles.
The other feature I wanted is that the extension only lists the EXTERNAL links and ignores the internal links (within the current presentation).
So the original creator is J. Balamuta; I just customized it for my needs and put it here in case anyone else finds it useful.
  
## Installing
`quarto add rodrigo-j-goncalves/further-reading`
 
## Usage

Simply add the filter to your YAML header:
 
 ```
  filters:
    - further-reading

```

Besides listing the filter in the YAML header, you don't need to do anything in your Quarto document.

## Customizable options

You can customize the text that will be shown on the 'Further reading' slide (added at the end of the presentation).

By customizing the collected links slide, you can also use different languages and expressions.

- Title of the slide (default: 'Further reading')
- Subtitle of the slide (default: 'All the links to other sources are listed below')
- Scrolling message (default: 'Scroll down to see all links')

To change any of these options, indicate them in the YAML header:

```
filters:
  - further-reading

further-reading:
  title: "Para seguir leyendo"
  subtitle: "Enlaces mencionados en esta clase"
  scroll_text: "Desliza hacia abajo para ver los links"

```
## Minimum example

Check the code for a [minimum example](docs/minimum_example.qmd).

This is the rendered [this revealjs presentation](https://rodrigo-j-goncalves.github.io/quarto-extensions/further-reading/docs/minimum_example.html)

## Customization example

- Too many links to fit in a single slide -> Sscroll functionality
- Customization of the **Further reading slide**
  - Slide title
  - Subtitle
  - Scrolling message

This is the quarto revealjs code for a [medium example](docs/medium_example.qmd) with the customizations.

This is the rendered [revealjs presentation](https://rodrigo-j-goncalves.github.io/quarto-extensions/further-reading/docs/medium_example.html)





.
