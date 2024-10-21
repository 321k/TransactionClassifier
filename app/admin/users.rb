ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation
  # Add other fields you want to be editable or visible in the admin interface
end
