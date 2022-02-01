Trestle.resource(:pundit_resource, model: Administrator, register_model: false) do
  authorize_with pundit: AdministratorPolicy
end
