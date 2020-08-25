Trestle.admin(:dsl) do
  authorize do
    access! { current_user.super? }
  end
end
