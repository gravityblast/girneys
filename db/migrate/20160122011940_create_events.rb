class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.json :data

      t.datetime :created_at
    end
  end
end
