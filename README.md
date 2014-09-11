pandoc-sections.vim provides section motions [[ ]] [] and ][ and text objects
i]] i][ a]] a][ I][ and A][. These motions and text objects account for both
Setext (= and -) as well as ATX-style (#, ##, etc.) section headers. 

#Installation

##Using a plugin manager

I use NeoBundle:

		NeoBundle 'gbgar/pandoc-sections.vim', 

##Manually

Retrieve pandoc-sections.vim and copy it to ~/.vim/ftplugins/pandoc/pandoc-sections.vim.

##Set pandoc filetype association (Optional)
  
If you wish, add an autocommand to associate a filetype with pandoc in your vimrc 
or in $VIMFILES/ftdetect/pandoc.vim. For example:

		au BufNewFile,BufRead *.pdk set filetype=pandoc

#Mappings

##Motions

\]\]          Skip forward one primary section header.

\[\[          Skip backward one primary section header.

\]\[          Skip forward one section header in the second through sixth levels.

\[\]          Skip backward one section header in the second through sixth levels.

##Text Objects

Section text objects operate/select upon primary and secondary through
sixth-level sections. Two types of section objects are available: simple and
advanced.

Primary section objects work in any location, but with the addition of advanced
text objects, the lower-level objects only function within lower-level
headings.  This is to prevent odd jumping behavior when lower-level text objects were
used in an exclusively first-level heading.

###Simple Text Objects Simple text objects operate

Simple text objects operate strictly within or on the title of the current
subheading and without reference to hierarchy.

i\]\] 		Inner primary section header.

i\]\[ 		Inner secondary through sixth-level header.

a\]\]		All of primary header.

a\]\[		All of secondary through sixth-level header.

###Advanced Text-Objects

"Advanced" text objects operate with reference to header hierarchy. For
example, an advanced section text object will operate on a third-level heading
and any fourth-level through sixth-level headings beneath, until the bottom or
a first- through third-level heading is reached.

I\]\[ 		Hierarchy-aware inner secondary through sixth-level header.

A\]\[	    Hierarchy-aware all of secondary through sixth-level header.

#Credits 

This filetype plugin is based on Steve Losh's Learn Vimscript the Hard Way
"Potions section movement" chapter, found here:

http://learnvimscriptthehardway.stevelosh.com/chapters/51.html 

as well as

http://vim.wikia.com/wiki/Creating_new_text_objects

Pandoc is a document converter created by John MacFarlane:

http://johnmacfarlane.net/pandoc/index.html
