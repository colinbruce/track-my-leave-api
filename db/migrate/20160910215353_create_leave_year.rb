class CreateLeaveYear < ActiveRecord::Migration[5.0]
  def change
    create_table :leave_years do |t|
      t.references :user
      t.date :starts_on
      t.integer :entitlement
      t.decimal :carried_forward

      t.timestamps null: false
    end
  end
end
