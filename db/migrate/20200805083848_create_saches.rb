class CreateSaches < ActiveRecord::Migration[6.0]
  def change
    create_table :saches do |t|
      t.string :ten
      t.string :nxb
      t.string :namxb

      t.timestamps
    end
  end
end
