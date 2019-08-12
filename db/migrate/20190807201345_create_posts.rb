# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      p t.respond_to?(:inet)
      t.text :title, null: false
      t.text :text,  null: false
      t.inet :ip_address

      t.belongs_to :user,
                   foreign_key: true,
                   index: true,
                   null: false

      t.timestamps
    end
  end
end
