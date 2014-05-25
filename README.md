pandoc-sections.vim provides section motions \[\[ \]\] \[\] and \]\[ and text
objects i]] i][ a]] and a][. These motions and text objects account for both
Pandoc-markdown (= and -) as well as ATX-style (#, ##, etc.) section headers. 

This filetype plugin is based on Steve Losh's Learn Vimscript the Hard Way
"Potions section movement" chapter, found here:
http://learnvimscriptthehardway.stevelosh.com/chapters/51.html as well as
http://vim.wikia.com/wiki/Creating_new_text_objects.

#Installation

##Using a plugin manager

I use NeoBundle:

		NeoBundle 'gbgar/pandoc-sections.vim', 

##Manually

Retrieve pandoc-sections.vim and copy it to ~/.vim/ftplugins/pandoc/pandoc-sections.vim.

##Set pandoc filtype association (Optional)
  
If you wish to do so, add an autocommand to associate a filetype with pandoc in your vimrc 
or in $VIMFILES/ftdetect/pandoc.vim. For example:

		au BufNewFile,BufRead *.pdk set filetype=pandoc

Then, you may Lazy-load with NeoBundle:

        NeoBundle 'gbgar/pandoc-sections.vim', { 'autoload' : { 'filetypes' : 'pandoc' }}

#Mappings

## Motions

\]\]          Skip forward one primary section header.

\[\[          Skip backward one primary section header.

\]\[          Skip forward one section header in the second through sixth levels.

\[\]          Skip backward one section header in the second through sixth levels.

## Text Objects

i\]\] 		Inner primary section header.

i\]\[ 		Inner secondary through sixth-level header.

a\]\]		All of primary header.

a\]\[		All of secondary through sixth-level header.

Note: the secondary through sixth-level section
text objects are not yet sophisticated and only operate up to the next heading
(primary through sixth-level).
