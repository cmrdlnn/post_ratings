# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.numeric :value, precision: 3, scale: 2, null: false

      t.belongs_to :user,
                   foreign_key: true,
                   index: true,
                   null: false
      t.belongs_to :post,
                   foreign_key: true,
                   index: true,
                   null: false

      t.timestamps
    end

    add_index(:ratings, [:user_id, :post_id], unique: true)

    reversible do |direction|
      direction.up do
        execute <<~SQL
          ALTER TABLE ratings
            ADD CONSTRAINT rating_check
              CHECK (value >= 1 AND value <= 5);
        SQL
      end

      direction.down do
        execute <<~SQL
          ALTER TABLE ratings
            DROP CONSTRAINT rating_check
        SQL
      end
    end
  end
end
