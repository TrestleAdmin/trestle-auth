Trestle.admin(:pundit) do
  authorize_with pundit: TestPolicy
end
