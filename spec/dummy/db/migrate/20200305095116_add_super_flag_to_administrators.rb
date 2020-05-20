class AddSuperFlagToAdministrators < ActiveRecord::Migration[6.0]
  def change
    add_column :administrators, :super, :boolean, default: false
  end
end
