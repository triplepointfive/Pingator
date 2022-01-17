class CreateIpTrackingIntervals < ActiveRecord::Migration[6.0]
  def change
    create_table :ip_tracking_intervals do |t|
      t.inet :ip, null: false, index: true
      t.datetime :since, null: false
      t.datetime :till

      t.timestamps
    end
  end
end
