Trestle.resource(:dsl_resource, model: Administrator, register_model: false) do
  authorize do
    access! { |instance| instance == current_user }
  end
end
