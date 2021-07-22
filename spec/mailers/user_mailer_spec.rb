require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'welcome_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it "sends a welcome email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the support email address' do
      expect(mail.from).to eq ['support@example.com']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq 'Welcome to Projects!'
    end

    it 'greets the user by first name' do
      expect(mail.body).to match(/Hello #{user.first_name},/)
    end

    it 'reminds the user of the registered email address' do
      expect(mail.body).to match user.email
    end
  end

  describe 'reset_password_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { Devise::Mailer.reset_password_instructions(user, user.authentication_token) }

    it "sends a reset password email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the support email address' do
      expect(mail.from).to eq ['please-change-me-at-config-initializers-devise@example.com']
    end

    it 'contains the change password link' do
      expect(mail.body).to match('Change my password')
    end
  end
end
