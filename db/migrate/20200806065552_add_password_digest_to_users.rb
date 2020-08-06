class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :useers, :password_digest, :string
  end
end
