;; extends
;; Do not conceal backticks
;; Reverts https://github.com/nvim-treesitter/nvim-treesitter/pull/5414/files
(fenced_code_block
  (fenced_code_block_delimiter) @conceal
  (#set! conceal "?"))
(fenced_code_block
  (info_string (language) @conceal
  (#set! conceal "?" )))
