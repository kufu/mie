class AddSocialAccountsToSpeakers < ActiveRecord::Migration[6.1]
  def change
    change_table :speakers, bulk: true do |t|
      t.string :github
      t.string :twitter
    end
  end
end
