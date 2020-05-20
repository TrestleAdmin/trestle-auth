Trestle.admin(:cancancan) do
  authorize_with cancancan: Ability
end
