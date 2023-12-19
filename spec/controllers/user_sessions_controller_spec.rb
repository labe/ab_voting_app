require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  describe 'GET #new' do
    subject { get :new }

    it { should have_http_status(:success) }

    context 'when already signed in' do
      let(:user) { create(:user) }
      before { session[:user_id] = user.id }

      it { should redirect_to(:vote) }
    end
  end

  describe 'POST #create' do
    let(:params) do
      { email: "a@b.com", zip_code: "12345" }
    end
    subject { post :create, params: params }

    context 'when the user email is not in the database' do
      it 'creates a new user record' do
        expect { subject }.to change { User.count }.by(1)
        user = User.last
        expect(user.email).to eq(params[:email])
      end
    end

    context 'when the user email exists in the database' do
      let!(:user) { create(:user, params) }
      it 'does not create a new record' do
        expect { subject }.to_not change { User.count }
      end

      it 'updates the record if the zip code has changed' do
        new_zip = "54321"
        params[:zip_code] = new_zip
        expect_any_instance_of(User).to receive(:update!).and_call_original
        subject
        expect(user.reload.zip_code).to eq(new_zip)
      end

      it 'does not update the record if the zip code is the same' do
        expect_any_instance_of(User).to_not receive(:update!)
        subject
      end
    end

    it 'sets the session with the user id' do
      user = create(:user, params)
      subject
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe 'GET #destroy' do
    subject { get :destroy }

    it 'calls clear_session!' do
      expect(controller).to receive(:clear_session!)
      subject
    end

    it { should redirect_to(:login) }

    it 'sets a flash notice' do
      subject
      expect(flash[:notice]).to eq('You have successfully logged out.')
    end
  end
end
