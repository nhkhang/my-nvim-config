return {
	-- General inline image support (Ghostty = kitty graphics protocol).
	-- Used as the rendering engine by diagram.nvim (see d2.lua) and also
	-- views plain image files directly via hijack_file_patterns.
	{
		"3rd/image.nvim",
		build = false, -- magick_cli needs no compilation
		lazy = false, -- eager: needed so image files (incl. `nvim foo.png`) are hijacked at open
		opts = {
			backend = "kitty",
			processor = "magick_cli", -- uses ImageMagick CLI, no luarocks
			-- Open a plain image file and render it directly in the buffer
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
			-- Render images larger (defaults are 50%); cap near the window so
			-- diagrams/screenshots are easier to read.
			max_width_window_percentage = 95,
			max_height_window_percentage = 95,
		},
	},
}
