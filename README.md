# further-reading
A customizable quarto extension that collects all external links from a presentation and lists them on the last slide (which is added automatically).

## Features

- This extension is done for and tested in quarto@revealjs documents (it may work in other cases, I don't know).
- During a presentation/lecture you normally use links to other resources in case the user/student wants material for _further reading_. The purpose of this extension is to provide, in a single slide, a list of all those links. This means that by design **only external links are listed** (specifically http, https, ftp; let me know if you need another ones).
  -  Internal links are ignored, such as:
    -  a link to a given slide within the current presentation (eg. `[Go to slide nr 4](#slide-id-4)`)
    -  a link to go to the begining (`[Go to the start](#)`)
    -  a link/button to go back (`[Go back](javascript:history.back())`)
- If a link appears multiple times during the presentation (in same or separate slides), it will be listed only once.
- The collected external links are listed in a single slide, that can be customized (see below). If the links are many and potentially too many for a single slide, the slide turns into a scrollable one so the list can be accessed in all cases.
-  The slide has the following structure:
    - Title of the slide (default: 'Further reading')
    - Subtitle of the slide (default: 'All the links to other sources are listed below')
    - Scrolling message (default: 'Scroll down to see all links')

  
## Installing
`quarto add rodrigo-j-goncalves/further-reading`
 
## Usage
 
Simply add the filter to your YAML header:
 
 ```
  filters:
    - further-reading

```

## Customizable options

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
