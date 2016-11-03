class AddIndexToUsersEmail < ActiveRecord::Migration
  #email uniqueness
  def change
  	add_index :users, :email, unique: true
  end
end
