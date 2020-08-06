class CreateUseers < ActiveRecord::Migration[6.0]
  def change
    create_table :useers do |t|
      t.string :name
      t.string :email
      t.string :password
      remove_column :useers, :password
      t.timestamps
    end
  end
end
