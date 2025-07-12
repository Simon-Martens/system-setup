return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    {
      'MattiasMTS/cmp-dbee',
      dependencies = {
        { 'kndndrj/nvim-dbee' },
      },
      ft = 'sql', -- optional but good to have
      opts = {}, -- needed
    },
  },
  opts = {
    sources = {
      { 'cmp-dbee' },
    },
  },
}
