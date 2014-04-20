pandoc-sections provides vim section movements [[ ]] [] and ][ for normal and
visual modes. Section movements account for both Pandoc (= and -) as well as
ATX-style (#, ##, etc.) section headers.  This filetype plugin is based on
Steve Losh's Learn Vimscript the Hard Way "Potions section movement" chapter,
found here: http://learnvimscriptthehardway.stevelosh.com/chapters/51.html .

=== CONTENTS ===

-INSTALLATION |pandoc-sections-installation|
-KEYBINDINGS |pandoc-sections-keybindings|

=== INSTALLATION ===		 											*pandoc-sections-installation*

- Using a plugin manager

	I use NeoBundle:

		NeoBundle 'gbgar/pandoc-sections.vim', 

- Manually

	Retrieve pandoc-sections.vim and copy it to 
	~/.vim/ftplugins/pandoc/pandoc-sections.vim.

- Set pandoc filtype association (Optional)
  
	If you wish to do so, add an autocommand to associate a filetype with 
	pandoc in your vimrc or in $VIMFILES/ftdetect/pandoc.vim. For example:

		au BufNewFile,BufRead *.pdk set filetype=pandoc

	Then, you may Lazy-load with NeoBundle:

		NeoBundleLazy 'gbgar/pandoc-sections.vim', 
                    \{ 'autoload' : { 'filetype' : 'pandoc' } }

=== Mappings ===															*pandoc-sections-keybindings*

]]
Skip forward one primary section header.
[[
Skip backward one primary section header.

][
Skip forward one section header in the second through sixth levels.

[]
Skip backward one section header in the second through sixth levels.
