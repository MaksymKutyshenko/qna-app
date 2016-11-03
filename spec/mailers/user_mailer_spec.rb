require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'confirmation_mail' do
    let(:email) { 'some@email.com' }
    let(:auth_token) { Digest::SHA1.hexdigest([Time.now, rand].join) }
    let(:mail) { described_class.confirmation_mail(email, auth_token).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Confirmaition email')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@qna.com'])
    end

    it 'assigns @auth_token' do
      expect(mail.body.encoded).to match(auth_token)
    end

    it 'assigns @email' do
      expect(mail.body.encoded).to match(ERB::Util.url_encode(email))
    end
  end
end
