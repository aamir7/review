class CreateNotifications < ActiveRecord::Migration
  def change
    create_table    :notifications do |t|
      t.references  :user,              index: true
      t.boolean     :is_read,           default: false
      t.integer     :sender_id
      t.string      :notification_type

      t.timestamps
    end
  end
end
