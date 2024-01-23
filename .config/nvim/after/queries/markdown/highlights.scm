;; extends
;; Do not conceal backticks
;; DOES NOT YET WORK; I DO NOT KNOW HOW TO DISABLE THE CONCEAL
;; Is solved in /home/xi3k/.config/nvim/lua/simachri/plugins/treesitter.lua instead.
;; Reverts https://github.com/nvim-treesitter/nvim-treesitter/pull/5414/files
; (fenced_code_block
;   (fenced_code_block_delimiter) @conceal
;   (#set! conceal ""))
; (fenced_code_block
;   (info_string (language) @conceal
;   (#set! conceal "" )))
