# DeCard64
DeCard project (Delphi)

Program allows to create set of the similar cards using template - rapid prototyping followed by improvement.

Template is SVG file with some expansions.
Result - png/svg/pdf/jpg

Each cards-project is stored in a separate directory and consists of:
- SVG-template;
- text table (delimited with tabs);
- subdirectory with pictures;
- subdirectory local fonts;
- can include an additional library of SVG-elements (clipart).

These names of files and directories are stored in XML-project file.

The basic principle: there are no "drag and drop" actions, only "text of this table cell is... ":
- wrapped text in this area
- filename of picture
- color, font size, scale (any SVG attribute)


Additional materials used:

SVG-rendering library (dll)
https://github.com/RazrFalcon/resvg

PDF-creation (Delphi package)
https://github.com/synopse/SynPDF

Text editor with syntax highlighting (Delphi package)
https://github.com/SynEdit/SynEdit
<br>Install this package into Delphi manually ([Tools]-[GetIt package manager...] turned out to be **incompatible with syntax checking**)

SynEdit interface to checking system **Hunspell** 
https://github.com/jrathlev/SynEdit-Spell-Checker

Icon pack
https://www.flaticon.com/
