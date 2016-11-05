require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do 

  sign_in_user
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:attachment) { create(:attachment, attachable: answer) }

  describe 'DELETE #destroy' do 
    context 'when current user is owner of attachable' do 
      before { answer.update(user: @user) }
      it 'assigns requested attachment to @attachment' do 
        delete :destroy, id: attachment, format: :js
        expect(assigns(:attachment)).to eq attachment
      end

      it 'deletes attachment' do 
        expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do 
        delete :destroy, id: attachment, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when current user is not owner of attachable' do 
      it 'does not delete attachment' do 
        expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(0)
      end
    end
  end
end