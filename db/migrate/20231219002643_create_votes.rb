class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes, id: :uuid do |t|
      t.timestamps
    end

    add_reference :votes, :user, null: false, foreign_key: true, index: { unique: true }, type: :uuid
    add_reference :votes, :candidate, null: false, foreign_key: true, index: true, type: :uuid
  end
end
