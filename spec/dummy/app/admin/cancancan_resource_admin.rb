Trestle.resource(:cancancan_resource, model: Administrator, register_model: false) do
  authorize_with cancancan: Ability
end
