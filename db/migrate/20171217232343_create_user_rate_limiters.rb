class CreateUserRateLimiters < ActiveRecord::Migration[5.0]
  def change
    create_table :user_rate_limiters do |t|
      t.string :user_id, null: false
      t.datetime :threshold_limit
      t.timestamps
    end
  end
end
