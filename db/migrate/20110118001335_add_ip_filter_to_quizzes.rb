class AddIpFilterToQuizzes < ActiveRecord::Migration
  tag :predeploy

  def self.up
    add_column :quizzes, :ip_filter, :string
  end

  def self.down
    remove_column :quizzes, :ip_filter
  end
end
