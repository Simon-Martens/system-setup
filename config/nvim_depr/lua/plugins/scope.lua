-- Scopes different tabpages into completely differen workspaces
return {
  'tiagovla/scope.nvim',
  config = function()
    require('scope').setup {}
  end,
}
