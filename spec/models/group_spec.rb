require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '値のバリデーション' do
    let(:group) { build(:group) }

    context '正常なデータの場合' do
      it '有効であること' do
        expect(group).to be_valid
      end
    end

    context 'グループ名が規定の文字数より大きい場合' do
      let(:group) { build(:group, :name_too_long) }

      it '無効であること' do
        expect(group).not_to be_valid
      end
    end

    context '参加人数を規定の値より大きい値を入力した場合' do
      let(:group) { build(:group, :participant_count_too_large) }

      it '無効であること' do
        expect(group).not_to be_valid
      end
    end

    context '参加人数を規定の値より小さい値を入力した場合' do
      let(:group) { build(:group, :participant_count_too_small) }

      it '無効であること' do
        expect(group).not_to be_valid
      end
    end

    context 'レシート金額を規定の値より大きい値を入力した場合' do
      let(:group) { build(:group, :total_amount_too_large) }

      it '無効であること' do
        expect(group).not_to be_valid
      end
    end

    context 'レシート金額を規定の値より小さい値を入力した場合' do
      let(:group) { build(:group, :total_amount_too_small) }

      it '無効であること' do
        expect(group).not_to be_valid
      end
    end
  end

  describe '#set_default_participant_count' do
    context '新しいレコードとして初期化された場合' do
      it "参加人数がデフォルト定数(#{Group::INIT_PARTICIPANT_COUNT})の値になること" do
        new_group = described_class.new
        expect(new_group.participant_count).to eq(Group::INIT_PARTICIPANT_COUNT)
      end
    end
  end

  describe 'created_by_session_scope' do
    context '指定したguest_tokenをscopeに渡した場合' do
      let(:target_name) { 'target_group' }
      let(:target_token) { 'session_token_to_find' }

      before do
        create_list(:group, 5)
        create(:group, name: target_name, guest_token: target_token)
      end

      it '正しいレコードが取得できること' do
        get_groups = described_class.created_by_session(target_token)

        expect(get_groups.count).to eq(1)
        expect(get_groups.first.name).to eq(target_name)
      end
    end
  end
end
