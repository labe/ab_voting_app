require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'clear_session!' do
    subject { controller.send(:clear_session!) }

    before do
      session[:user_id] = SecureRandom.uuid
      session[:expires_at] = Time.current
    end

    it 'clears the session user_id' do
      subject
      expect(session[:user_id]).to be_nil
    end

    it 'clears the session expires_at' do
      subject
      expect(session[:expires_at]).to be_nil
    end
  end
end
