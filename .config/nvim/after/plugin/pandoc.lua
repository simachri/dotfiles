vim.cmd([[
    " Command to export a markdown file as docx to DebianShare/Export_docx
    " The file DebianShare/Export_docx/_Pandoc_reference_for_export.docx provides the styles.
    "
    " The current working directory is temporarily switched to the file's directory such that 
    " images are also exported.
    "
    " +task_lists interprets - [ ] as checkbox
    " +pipe_tables interpretes pipe tables
    " 
    " The redraw! is required to update Vim's screen after the command has been executed.
    function! PandocMdToDocx()
      " Change the working directory temporarily.
      lcd %:h
      
      let src_filename = fnameescape(expand('%:p'))
      let dst_filename = input('Enter filename: ' )
      if strlen(dst_filename) == 0
        " %:t:r - select the 'tail' of the path (filename) but without the file extension.
        let today = strftime('%y-%m-%d')
        let dst_filename = '~/VmHostShare/Export/'.fnameescape(expand('%:t:r')).'_'.today.'.docx'
      else
        let dst_filename = '~/VmHostShare/Export/'.dst_filename
      end
      silent execute
        "\ "!pandoc -f markdown+task_lists+pipe_tables
        \ "!pandoc -f gfm
        \ --reference-doc ~/VmHostShare/_Pandoc_reference_21-06-01.docx
        \ -s ".src_filename." -o ".dst_filename | redraw!
      echo dst_filename.' exported.'

      " Change the working directory back.
      lcd -
    endfunction

    command ToDocx call PandocMdToDocx()
]])
