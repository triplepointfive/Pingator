class CreatePings < ActiveRecord::Migration[6.0]
  def change
    create_table :pings do |t|
      t.inet :ip, index: true, null: false
      t.float :rtt

      t.timestamps
    end
  end
end
