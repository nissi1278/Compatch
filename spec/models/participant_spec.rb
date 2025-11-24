require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe '関係' do
    context '親グループがない場合' do
      let(:participant) { build(:participant, group: nil) }

      it '作成できないこと' do
        expect(participant).not_to be_valid

        # エラー情報はバリデーションを実行しないと格納されないため、valid後に取得
        error_messages = participant.errors.messages[:group]
        expect(error_messages.count).to eq 1
        expect(error_messages).to include('を入力してください')
      end
    end
  end

  describe '値のバリデーション'  do
    let(:participant) { build(:participant) }

    context '正常なデータの場合' do
      it '有効であること' do
        expect(participant).to be_valid
      end
    end

    context '名前が規定の文字数より多い場合' do
      let(:participant) { build(:participant, :name_too_long) }

      it '無効であること' do
        expect(participant).not_to be_valid
      end
    end

    context '支払金額が規定の数値より小さい場合' do
      let(:participant) { build(:participant, :payment_amount_too_small) }

      it '無効であること' do
        expect(participant).not_to be_valid
      end
    end

    context '金額固定有無がboolean以外の場合' do
      let(:participant) { build(:participant, :is_manual_fixed_other_value) }

      it '無効であること' do
        expect(participant).not_to be_valid
      end
    end
  end
end
