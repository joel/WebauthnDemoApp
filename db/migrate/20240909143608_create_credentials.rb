class CreateCredentials < ActiveRecord::Migration[7.2]
  def change
    create_table :credentials, id: :uuid do |t|
      t.string :external_id
      t.string :public_key
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :nickname
      t.integer :sign_count

      t.timestamps
    end

    add_index :credentials, :external_id, unique: true
  end
end
