{ config, pkgs, ... }:

let
  plugins = pkgs.vimPlugins;
  inherit (import ../../options.nix) theme;
in {
  programs.nixvim = {
    enable = true;

    colorschemes = {
      tokyonight = {
	enable = true;
	style = "storm";
	transparent = true;
      };
    };

    plugins = {
      telescope = {
	enable = true;
	extraOptions = {
	  pickers = {
	    find_files = {
	      theme = "dropdown";
	    };
	    live_grep = {
	      theme = "dropdown";
	    };
	  };
	};
      };
      neo-tree = {
	enable = true;
	window = {
	  position = "current";
	};
      };
      lualine = {
	enable = true;
	theme = "auto";
	sectionSeparators = {
	  left = "";
	  right = "";
	};
	componentSeparators = {
	  left = "|";
	  right = "|";
	};
      };
      auto-session = {
	enable = true;
	autoRestore.enabled = false;
	extraOptions = {
	  auto_session_use_git_branch = true;
	};
      };
      which-key.enable = true;
      fugitive.enable = true;
      copilot-lua = {
	enable = true;
	suggestion = {
	  autoTrigger = true;
	};
      };
      wilder.enable = true;
      luasnip.enable = true;
      gitsigns = {
	enable = true;
	onAttach = {
	  function = ''
	    function(bufnr)
	      local gs = package.loaded.gitsigns

	      local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	      end

	      -- Navigation
	      map('n', ']c', function()
		if vim.wo.diff then return ']c' end
		vim.schedule(function() gs.next_hunk() end)
		return '<Ignore>'
	      end, {expr=true})

	      map('n', '[c', function()
		if vim.wo.diff then return '[c' end
		vim.schedule(function() gs.prev_hunk() end)
		return '<Ignore>'
	      end, {expr=true})

	      -- Actions
	      map('n', '<leader>gs', gs.stage_hunk)
	      map('n', '<leader>gr', gs.reset_hunk)
	      map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
	      map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
	      map('n', '<leader>gS', gs.stage_buffer)
	      map('n', '<leader>gu', gs.undo_stage_hunk)
	      map('n', '<leader>gR', gs.reset_buffer)
	      map('n', '<leader>gp', function() gs.preview_hunk { border = 'rounded' } end)
	      map('n', '<leader>gl', function() gs.blame_line{full=true} end)
	      map('n', '<leader>gL', gs.toggle_current_line_blame)
	      map('n', '<leader>gd', gs.diffthis)
	      map('n', '<leader>gD', function() gs.diffthis('~') end)
	    end
	  '';
	};
      };
      nvim-ufo = {
	enable = true;
	foldVirtTextHandler = ''function(virtText, lnum, endLnum, width, truncate)
	  local newVirtText = {}
	  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
	  local sufWidth = vim.fn.strdisplaywidth(suffix)
	  local targetWidth = width - sufWidth
	  local curWidth = 0
	  for _, chunk in ipairs(virtText) do
	      local chunkText = chunk[1]
	      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
	      if targetWidth > curWidth + chunkWidth then
		  table.insert(newVirtText, chunk)
	      else
		  chunkText = truncate(chunkText, targetWidth - curWidth)
		  local hlGroup = chunk[2]
		  table.insert(newVirtText, {chunkText, hlGroup})
		  chunkWidth = vim.fn.strdisplaywidth(chunkText)
		  -- str width returned from truncate() may less than 2nd argument, need padding
		  if curWidth + chunkWidth < targetWidth then
		      suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
		  end
		  break
	      end
	      curWidth = curWidth + chunkWidth
	  end
	  table.insert(newVirtText, {suffix, 'MoreMsg'})
	  return newVirtText
	end'';
      };
      startup = { 
	enable = true;
	theme = "evil";
	userMappings = {
	  "<leader>ff" = "<cmd>Telescope find_files theme=dropdown<CR>";
	  "<leader>fw"  = "<cmd>Telescope live_grep theme=dropdown<CR>";
	  "<leader>e"  = "<cmd>Neotree toggle<CR>";
	};
      };
      comment-nvim.enable = true;
      lsp = {
	enable = true;
	servers = {
	  tsserver.enable = true;
	  volar.enable = true;
	  lua-ls.enable = true;
	  rust-analyzer = {
	    enable = true;
	    installRustc = true;
	    installCargo = true;
	  };
	  nixd.enable = true;
	  html.enable = true;
	  ccls.enable = true;
	  cmake.enable = true;
	  csharp-ls.enable = true;
	  cssls.enable = true;
	  gopls.enable = true;
	  jsonls.enable = true;
	  pyright.enable = true;
	  tailwindcss.enable = true;
	  eslint.enable = true;
	  prismals.enable = true;
	};
	keymaps = {
	  diagnostic = {
	    "<leader>dn" = "goto_next";
	    "<leader>dp" = "goto_prev";
	    "<leader>ld" = "open_float";
	  };
	  lspBuf = {
	    K = "hover";
	    gt = "type_definition";
	    "<leader>lr" = "rename";
	  };
	};
      };
      lsp-format = {
	enable = true;
      };
      treesitter.enable = true;
      #typescript-tools.enable = true;
      nvim-cmp = {
	enable = true;
	autoEnableSources = true;
	snippet.expand = "luasnip";
	sources = [
	  { name = "nvim_lsp"; }
	  { name = "path"; }
	  { name = "buffer"; }
	];
	mapping = {
	  "<CR>" = "cmp.mapping.confirm({ select = true })";
	  "<Tab>" = {
	    action = ''cmp.mapping.select_next_item()'';
	    modes = [ "i" "s" ];
	  };
	};
      };
      cmp_luasnip = {
	enable = true;
      };
    };

    extraPlugins = [
      plugins.nvim-lspconfig
      {
	config = ''
	  lua require('treesj').setup { max_join_length = 500 }
	'';
	plugin = plugins.treesj;
      }
    ];

    globals.mapleader = " "; # Sets the leader key to space

    extraConfigVim = ''
      autocmd FileType neo-tree highlight NeoTreeNormal guibg=NONE ctermbg=NONE
      autocmd FileType neo-tree highlight NeoTreeNormalNC guibg=NONE ctermbg=NONE
      highlight LineNr ctermfg=Grey guifg=Grey
      highlight CursorLineNr ctermfg=White guifg=White
      nnoremap <C-u> <C-u>zz
      nnoremap <C-d> <C-d>zz
    '';

    extraConfigLua = ''
      -- Define diagnostic signs
      vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
      vim.fn.sign_define("DiagnosticSignWarn", {text = "", texthl = "DiagnosticSignWarn"})
      vim.fn.sign_define("DiagnosticSignInfo", {text = "", texthl = "DiagnosticSignInfo"})
      vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

      -- Configure Neovim LSP diagnostic symbols
      vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = false,
	update_in_insert = false,
	severity_sort = true,
	float = {
	  border = "rounded",
	},
      })

      -- Setup language servers
      local lspformat = require("lsp-format")
      lspformat.setup {}
      local lspconfig = require('lspconfig')
      lspconfig.tsserver.setup {}
      lspconfig.volar.setup {}
      lspconfig.rust_analyzer.setup { on_attach = lspformat.on_attach }
      lspconfig.eslint.setup { on_attach = lspformat.on_attach }
      lspconfig.prismals.setup { on_attach = lspformat.on_attach }
      lspconfig.nixd.setup { on_attach = lspformat.on_attach }
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
	  border = "rounded"
	}
      )
      -- Eslint is not auto formatted on save
      vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', '*.vue' },
	command = 'silent! EslintFixAll',
	group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
      })
    '';

    keymaps = [
      {
	mode = "i";
	key = "<C-h>";
	action = "<C-w>";
	options.desc = "Delete previous word";
      }
      {
        mode = "n";
        key = "<leader>e";
        options.silent = false;
        action = "<cmd>Neotree toggle position=right reveal=true<CR>";
      }
      {
	mode = "n";
	key = "<leader>ff";
	action = "<cmd>Telescope find_files theme=dropdown<CR>";
	options = {
	  desc = "Find files";
	};
      }
      {
	mode = "n";
	key = "<leader>fF";
	action.__raw = "function() require'telescope.builtin'.find_files({ hidden = true, no_ignore = true }) end";
	options = {
	  desc = "Find all files";
	};
      }
      {
	mode = "n";
	key = "<leader>fw";
	action = "<cmd>Telescope live_grep theme=dropdown<CR>";
	options = {
	  desc = "Find words";
	};
      }
      {
	mode = "n";
	key = "<leader>fW";
	action.__raw = "function() require'telescope.builtin'.live_grep({ additional_args = function(opts) return {'--no-ignore'} end }) end";
	options = {
	  desc = "Find all words";
	};
      }
      {
	mode = "n";
	key = "<leader>fk";
	action = "<cmd>Telescope keymaps<CR>";
	options = {
	  desc = "Find keys";
	};
      }
      {
	mode = "n";
	key = "<leader>f<CR>";
	action = "<cmd>Telescope resume<CR>";
	options = {
	  desc = "Resume telescope window";
	};
      }
      {
	mode = "n";
	key = "<leader>gk";
	action = "<cmd>G push<CR>";
	options.desc = "Git push";
      }
      {
	mode = "n";
	key = "<leader>gK";
	action = "<cmd>G pull<CR>";
	options.desc = "Git pull";
      }
      {
	mode = "n";
	key = "<leader>gF";
	action = "<cmd>G push --force-with-lease<CR>";
	options.desc = "Git push force with lease";
      }
      {
	mode = "n";
	key = "<leader>zM";
	action.__raw = "function() require(\"ufo\").closeAllFolds() end";
	options.desc = "Close all folds";
      }
      {
	mode = "n";
	key = "<leader>zR";
	action.__raw = "function() require(\"ufo\").openAllFolds() end";
	options.desc = "Open all folds";
      }
      {
	mode = "n";
	key = "zr";
	action.__raw = "function() require(\"ufo\").openFoldsExceptKinds() end";
	options.desc = "Fold more";
      }
      {
	mode = "n";
	key = "zm";
	action.__raw = "function() require(\"ufo\").closeFoldsWith() end";
	options.desc = "Fold less";
      }
      {
	mode = "n";
	key = "zp";
	action.__raw = "function() require(\"ufo\").peekFoldedLinesUnderCursor() end";
	options.desc = "Peek fold";
      }
      {
	mode = "n";
	key = "<leader>la";
	action.__raw = "function() vim.lsp.buf.code_action() end";
	options.desc = "LSP Code Actions (under cursor)";
      }
      {
	mode = "v";
	key = "<leader>la";
	action.__raw = "function() vim.lsp.buf.code_action() end";
	options.desc = "LSP Code Actions (visual)";
      }
      {
	mode = "n";
	key = "gd";
	action.__raw = "function() require('telescope.builtin').lsp_definitions() end";
	options.desc = "LSP Definitions";
      }
      {
	mode = "n";
	key = "gD";
	action.__raw = "function() require('telescope.builtin').lsp_references() end";
	options.desc = "LSP References";
      }
      {
	mode = "n";
	key = "gi";
	action.__raw = "function() require('telescope.builtin').lsp_implementations() end";
	options.desc = "LSP Implementation";
      }
      {
	mode = "n";
	key = "gt";
	action.__raw = "function() require('telescope.builtin').lsp_type_definitions() end";
	options.desc = "LSP Type Definitions";
      }
      {
	mode = "n";
	key = "<leader>Sl";
	action = "<cmd>SessionRestore<CR>";
	options.desc = "Restore last session";
      }
      {
	mode = "n";
	key = "<leader>Ss";
	action = "<cmd>SessionSave<CR>";
	options.desc = "Save current session";
      }
      {
	mode = "n";
	key = "<leader>Sd";
	action = "<cmd>SessionDelete<CR>";
	options.desc = "Delete current session";
      }
      {
	mode = "n";
	key = "<leader>Sf";
	action.__raw = "function() require(\"auto-session.session-lens\").search_session() end";
	options.desc = "Search sessions";
      }
    ];

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      softtabstop = 2;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      updatetime = 50;
      numberwidth = 6;
      splitbelow = true;
      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
      fillchars = {
	eob = " ";
	fold = " ";
	foldopen = "";
	foldclose = "";
	foldsep = " ";
      };
      clipboard = "unnamedplus";
    };

  };
 } 
